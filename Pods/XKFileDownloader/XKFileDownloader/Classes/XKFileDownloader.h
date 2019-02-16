//
//  XKFileDownloader.h
//  XKFileDownloader_Example
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 RyanMans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XKHttpNetworkHelper/XKHttpNetworkHelper.h>

NS_ASSUME_NONNULL_BEGIN

//文件下载(包含缓存功能)
@interface XKFileDownloader : NSObject

#pragma mark -文件操作

/**
 根据链接,文件类型创建文件名
 
 @param URL 下载链接
 @param fileType 文件类型
 @return filename
 */
+ (NSString*)createFileNameWithURL:(NSString*)URL fileType:(NSString*)fileType;

/**
 判断文件是否存在
 
 @param fileName 文件名
 @return yes / no
 */
+ (BOOL)fileCacheExist:(NSString*)fileName;

/**
 获取已下载文件存储路径
 
 @param fileName 文件名
 @return 文件存储路径
 */
+ (NSString*)fileCacheDirPath:(NSString*)fileName;

/**
 删除已下载文件
 
 @param fileName 文件名
 @return yes / no
 */
+ (BOOL)deleteCachefile:(NSString*)fileName;

/**
 清空缓存文件
 
 @return yes / no
 */
+ (BOOL)cleanCachefile;

/**
 清空下载目录
 
 @return yes / no
 */
+ (BOOL)cleanRootDir;

#pragma mark -网络操作

/**
 文件下载
 
 @param URL 下载链接
 @param fileName 文件名
 @param progress 进度
 @param success 成功，返回文件存储路径
 @param failure 失败error
 @return 返回的对象可取消请求,调用xk_CancelDownloaderTask方法
 */
+ (__kindof NSURLSessionTask *)Download:(NSString *)URL
                               fileName:(NSString*)fileName
                               progress:(XKHttpProgress _Nullable)progress
                                success:(void(^)(NSString * _Nullable filePath))success
                                failure:(XKHttpRequestFailed _Nullable)failure;


/**
 文件恢复下载()
 
 @param URL 下载链接
 @param fileName 文件名
 @param progress 进度
 @param success 成功，返回文件存储路径
 @param failure 失败error
 @return 返回的对象可取消请求,调用xk_CancelDownloaderTask方法
 */
+ (__kindof NSURLSessionTask *)ResumeDownload:(NSString *)URL
                                     fileName:(NSString*)fileName
                                     progress:(XKHttpProgress _Nullable)progress
                                      success:(void(^)(NSString * _Nullable filePath))success
                                      failure:(XKHttpRequestFailed _Nullable)failure;
/**
 暂停下载任务
 
 @param URL 下载的链接
 */
+ (void)suspendDownloaderTask:(NSString *)URL;

@end

NS_ASSUME_NONNULL_END
