//
//  XKHttpNetworkHelper.m
//  XKHttpNetworkHelper_Example
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 RyanMans. All rights reserved.
//

#import "XKHttpNetworkHelper.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

@implementation XKHttpNetworkHelper

+ (void)initialize{
    _sessionManager = [AFHTTPSessionManager manager];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

// 开始监测网络状态
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//存储着所有的请求task数组
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 网络请求
//MARK:GET请求
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id _Nullable)parameters
                           success:(XKHttpRequestSuccess)success
                           failure:(XKHttpRequestFailed)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

//MARK:POST请求
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id _Nullable)parameters
                            success:(XKHttpRequestSuccess _Nullable)success
                            failure:(XKHttpRequestFailed _Nullable)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

//MARK:POST请求-表单提交
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id _Nullable)parameters
          constructingBodyWithBlock:(XKMultipartFormData _Nullable)block
                           progress:(XKHttpProgress _Nullable)progress
                            success:(XKHttpRequestSuccess _Nullable)success
                            failure:(XKHttpRequestFailed _Nullable)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

//MARK:PUT请求
+ (__kindof NSURLSessionTask *)PUT:(NSString *)URL
                        parameters:(id _Nullable)parameters
                           success:(XKHttpRequestSuccess _Nullable)success
                           failure:(XKHttpRequestFailed _Nullable)failure{
    
    
    NSURLSessionTask *sessionTask = [_sessionManager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

//MARK:PATCH请求
+ (__kindof NSURLSessionTask *)PATCH:(NSString *)URL
                          parameters:(id _Nullable)parameters
                             success:(XKHttpRequestSuccess _Nullable)success
                             failure:(XKHttpRequestFailed _Nullable)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager PATCH:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

//MARK:DELETE请求
+ (__kindof NSURLSessionTask *)DELETE:(NSString *)URL
                           parameters:(id _Nullable)parameters
                              success:(XKHttpRequestSuccess _Nullable)success
                              failure:(XKHttpRequestFailed _Nullable)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

//MARK:REQUEST请求
+ (__kindof NSURLSessionTask *)REQUEST:(NSURLRequest *)request
                               success:(XKHttpRequestSuccess _Nullable)success
                               failure:(XKHttpRequestFailed _Nullable)failure{
    
    __block NSURLSessionTask *sessionTask = nil;
    sessionTask = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:sessionTask];
        if (responseObject && success) success(responseObject);
        if (error && failure) failure(error);
    }];
    
    [sessionTask resume];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载请求
//MARK:文件下载请求
+ (__kindof NSURLSessionTask *)Download:(NSString *)URL
                               filePath:(NSString *)filePath
                               progress:(XKHttpProgress _Nullable)progress
                                success:(nullable void(^)(NSString *filePath))success
                                failure:(XKHttpRequestFailed _Nullable)failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    __block NSURLSessionTask *sessionTask = nil;
    
    sessionTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        progress ? progress(downloadProgress) : nil;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (filePath.absoluteString.length && success) success(filePath.absoluteString /** NSURL->NSString*/);
        if (error && failure) failure(error);
        [[self allSessionTask] removeObject:sessionTask];
        
    }];
    
    [sessionTask resume];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

//MARK:文件恢复下载
+ (__kindof NSURLSessionTask *)ResumeDownload:(NSString *)URL
                                     filePath:(NSString *)filePath
                               fileBufferData:(NSData * _Nullable)fileBufferData
                                     progress:(XKHttpProgress _Nullable)progress
                                      success:(nullable void(^)(NSString *filePath))success
                                      failure:(XKHttpRequestFailed _Nullable)failure{
    
    if (!fileBufferData) return [self Download:URL filePath:filePath progress:progress success:success failure:failure];
    
    __block NSURLSessionTask *sessionTask = nil;
    
    sessionTask = [_sessionManager downloadTaskWithResumeData:fileBufferData progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        progress ? progress(downloadProgress) : nil;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (filePath.absoluteString.length && success) success(filePath.absoluteString /** NSURL->NSString*/);
        if (error && failure) failure(error);
        [[self allSessionTask] removeObject:sessionTask];
    }];
    
    [sessionTask resume];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 取消/暂停网络请求操作
//取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL{
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

//取消所有HTTP请求
+ (void)cancelAllRequest{
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

//暂停下载任务
+ (void)suspendDownloadTaskWithURL:(NSString *)URL
                            resume:(void (^)(NSData * _Nullable resumeData))resume{
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL] && [task isKindOfClass:[NSURLSessionDownloadTask class]]) {
                
                NSURLSessionDownloadTask * downloadTask = (NSURLSessionDownloadTask*)task;
                
                [downloadTask cancelByProducingResumeData:resume];
                
                [[self allSessionTask] removeObject:task];
                
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 设置AFHTTPSessionManager相关属性

// 设置AFHTTPSessionManager的实例
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager{
    sessionManager ? sessionManager(_sessionManager): nil;
}

//设置网络请求参数的格式:AFHTTPRequestSerializer
+ (void)setRequestSerializer:(XKRequestSerializer)requestSerializer{
    _sessionManager.requestSerializer = requestSerializer == XKRequestSerializerJSON ? [AFJSONRequestSerializer serializer] : [AFHTTPRequestSerializer serializer];
}

//设置服务器响应数据格式: AFJSONResponseSerializer
+ (void)setResponseSerializer:(XKResponseSerializer)responseSerializer{
    _sessionManager.responseSerializer = responseSerializer == XKResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

//是否打开网络状态转圈菊花
+ (void)openNetworkActivityIndicator:(BOOL)open{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

// 设置请求超时时间:默认为30S
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time{
    _sessionManager.requestSerializer.timeoutInterval = time;
}

//设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}
@end
