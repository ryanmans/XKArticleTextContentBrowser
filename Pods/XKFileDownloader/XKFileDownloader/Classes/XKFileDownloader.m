//
//  XKFileDownloader.m
//  XKFileDownloader_Example
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 RyanMans. All rights reserved.
//

#import "XKFileDownloader.h"
#import "XKFileManager.h"
#import <CommonCrypto/CommonCrypto.h>

//根目录
static NSString * _fileRootDir;

//缓存目录
static NSString * _fileCacheDir;

//暂停缓冲区
static NSString * _fileBufferDir;

@implementation XKFileDownloader

+ (void)initialize
{
    //文件下载的根目录文件
    _fileRootDir = [XKFileManager xk_AppendingCachesDirectory:@"fileDownManager"];
    
    //文件下载的目录文件
    _fileCacheDir = [_fileRootDir stringByAppendingPathComponent:@"fileCache"];
    
    [XKFileManager xk_CreateDirectoryAtPath:_fileCacheDir];
    
    //文件下载缓冲区
    _fileBufferDir = [_fileRootDir stringByAppendingPathComponent:@"fileBuffer"];
    
    [XKFileManager xk_CreateDirectoryAtPath:_fileBufferDir];
}

//确保字符串为安全字符串
NSString * IsSafeString(NSString * str){
    return (str != nil && str.length != 0) ? str : @"";
}

//MD5加密
NSString * MD5Encoding(NSString * str){
    const char * utfString = str.UTF8String;
    unsigned char  result [16] = {0};
    CC_MD5(utfString, (CC_LONG)strlen(utfString), result);
    char szOutput[33] = { 0 };
    for (int index = 0; index < 16; index++){
        unsigned char src = result[index];
        sprintf(szOutput, "%s%02x",szOutput,src);
    }
    return [NSString stringWithUTF8String:szOutput];
}

// 判断是否是包含有中文(中文代码范围0x4E00~0x9FA5， )
BOOL  isContainChinese(NSString * str){
    for (NSInteger index = 0; index < [str length]; index ++) {
        int indexValue = [str characterAtIndex:index];
        if (indexValue > 0x4e00 && indexValue < 0x9fff) return YES;
    }
    return NO;
}

// 根据链接,文件类型创建文件名
+ (NSString*)createFileNameWithURL:(NSString*)URL fileType:(NSString*)fileType{
    return [NSString stringWithFormat:@"%@.%@",MD5Encoding(IsSafeString(URL)),IsSafeString(fileType)];
}

//判断文件是否存在
+ (BOOL)fileCacheExist:(NSString *)fileName{
    if (!fileName) return NO;
    NSString * fileCachePath = [NSString stringWithFormat:@"%@/%@",_fileCacheDir,fileName];
    return [XKFileManager xk_FileExistsAtPath:fileCachePath];
}

// 获取已下载文件存储路径
+ (NSString *)fileCacheDirPath:(NSString *)fileName{
    return fileName ? [_fileCacheDir stringByAppendingPathComponent:fileName] : nil;
}

//删除已下载文件
+ (BOOL)deleteCachefile:(NSString *)fileName{
    NSString * fileCachePath = [NSString stringWithFormat:@"%@/%@",_fileCacheDir,fileName];
    return [XKFileManager xk_RemoveItemAtPath:fileCachePath];
}

//清空缓存文件
+ (BOOL)cleanCachefile{
    return [XKFileManager xk_RemoveItemAtPath:_fileCacheDir];
}

//清空下载目录
+ (BOOL)cleanRootDir{
    return [XKFileManager xk_RemoveItemAtPath:_fileRootDir];
}

//获取缓冲区配置数据
+ (NSData*)fileBufferData:(NSString*)URL{
    NSString * bufferCfg = [NSString stringWithFormat:@"%@%@",MD5Encoding(URL) ,@".psCfg"];
    NSString * fileBufferPath = [NSString stringWithFormat:@"%@/%@",_fileBufferDir,bufferCfg];;
    if (![XKFileManager xk_FileExistsAtPath:fileBufferPath]) return nil;
    return [NSData dataWithContentsOfFile:fileBufferPath];
}

#pragma mark - 下载文件
//文件下载
+ (__kindof NSURLSessionTask *)Download:(NSString *)URL
                               fileName:(NSString*)fileName
                               progress:(XKHttpProgress _Nullable)progress
                                success:(void(^)(NSString * _Nullable filePath))success
                                failure:(XKHttpRequestFailed _Nullable)failure{
    
    //如果包含中文，需要编码
    URL = isContainChinese(URL) ?  [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : URL;
    
    //拼接文件路径
    NSString *filePath = [self fileCacheDirPath:IsSafeString(fileName)];
    
    return [XKHttpNetworkHelper Download:URL filePath:filePath progress:progress success:success failure:failure];
}

// 文件恢复下载
+ (__kindof NSURLSessionTask *)ResumeDownload:(NSString *)URL
                                     fileName:(NSString*)fileName
                                     progress:(XKHttpProgress _Nullable)progress
                                      success:(void(^)(NSString * _Nullable filePath))success
                                      failure:(XKHttpRequestFailed _Nullable)failure{
    
    //如果包含中文，需要编码
    URL = isContainChinese(URL) ?  [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : URL;

    NSData * fileBufferData = [self fileBufferData:URL];
    
    //拼接文件路径
    NSString *filePath = [self fileCacheDirPath:IsSafeString(fileName)];
    
    return [XKHttpNetworkHelper ResumeDownload:URL filePath:filePath fileBufferData:fileBufferData progress:progress success:success failure:failure];
}

//暂停任务
+ (void)suspendDownloaderTask:(NSString *)URL{
    [XKHttpNetworkHelper suspendDownloadTaskWithURL:URL resume:^(NSData * _Nullable resumeData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resumeData.length) {
                NSString * bufferCfg = [NSString stringWithFormat:@"%@%@",MD5Encoding(URL) ,@".psCfg"];
                NSString * fileBufferPath = [_fileBufferDir stringByAppendingPathComponent:bufferCfg];
                [resumeData writeToFile:fileBufferPath atomically:YES];
            }
        });
    }];
}
@end
