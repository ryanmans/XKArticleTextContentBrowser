//
//  XKHttpNetworkHelper.h
//  XKHttpNetworkHelper_Example
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 RyanMans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XKRequestSerializer) {
    XKRequestSerializerJSON,   // 设置请求数据为JSON格式
    XKRequestSerializerHTTP,   // 设置请求数据为二进制格式
};

typedef NS_ENUM(NSUInteger, XKResponseSerializer) {
    XKResponseSerializerJSON,  // 设置响应数据为JSON格式
    XKResponseSerializerHTTP,  // 设置响应数据为二进制格式
};

//请求数据成功
typedef void(^XKHttpRequestSuccess)(id _Nullable responseObject);

//请求数据失败
typedef void(^XKHttpRequestFailed)(NSError * _Nullable error);

//请求数据进度
typedef void (^XKHttpProgress)(NSProgress * _Nullable progress);

//表单
typedef void (^XKMultipartFormData)(id <AFMultipartFormData> _Nullable formData);

//网络请求框架对象(基于AFN)
@interface XKHttpNetworkHelper : NSObject

/**
 *  GET请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id _Nullable)parameters
                           success:(XKHttpRequestSuccess)success
                           failure:(XKHttpRequestFailed)failure;

/**
 *  POST请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id _Nullable)parameters
                            success:(XKHttpRequestSuccess _Nullable)success
                            failure:(XKHttpRequestFailed _Nullable)failure;

/**
 *  POST请求-FormData
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param block      表单的回调
 *  @param progress   网络进度的回调
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id _Nullable)parameters
          constructingBodyWithBlock:(XKMultipartFormData _Nullable)block
                           progress:(XKHttpProgress _Nullable)progress
                            success:(XKHttpRequestSuccess _Nullable)success
                            failure:(XKHttpRequestFailed _Nullable)failure;

/**
 *  PUT请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)PUT:(NSString *)URL
                        parameters:(id _Nullable)parameters
                           success:(XKHttpRequestSuccess _Nullable)success
                           failure:(XKHttpRequestFailed _Nullable)failure;
/**
 *  PATCH请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)PATCH:(NSString *)URL
                          parameters:(id _Nullable)parameters
                             success:(XKHttpRequestSuccess _Nullable)success
                             failure:(XKHttpRequestFailed _Nullable)failure;

/**
 *  DELETE请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)DELETE:(NSString *)URL
                           parameters:(id _Nullable)parameters
                              success:(XKHttpRequestSuccess _Nullable)success
                              failure:(XKHttpRequestFailed _Nullable)failure;
/**
 *  REQUEST请求
 *
 *  @param request    请求request
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)REQUEST:(NSURLRequest *)request
                               success:(XKHttpRequestSuccess _Nullable)success
                               failure:(XKHttpRequestFailed _Nullable)failure;

#pragma mark - 文件下载请求

/**
 *  下载文件
 *
 *  @param URL       请求地址
 *  @param filePath  文件存储路径
 *  @param progress  文件下载的进度信息
 *  @param success   下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure   下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)Download:(NSString *)URL
                               filePath:(NSString *)filePath
                               progress:(XKHttpProgress _Nullable)progress
                                success:(nullable void(^)(NSString *filePath))success
                                failure:(XKHttpRequestFailed _Nullable)failure;

/**
 *  恢复下载文件（可直接下载）
 *
 *  @param URL             请求地址
 *  @param filePath        文件存储路径
 *  @param fileBufferData  文件缓存数据（空则重新下载）
 *  @param progress        文件下载的进度信息
 *  @param success         下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure         下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)ResumeDownload:(NSString *)URL
                                     filePath:(NSString *)filePath
                               fileBufferData:(NSData * _Nullable)fileBufferData
                                     progress:(XKHttpProgress _Nullable)progress
                                      success:(nullable void(^)(NSString *filePath))success
                                      failure:(XKHttpRequestFailed _Nullable)failure;

#pragma mark - 取消/暂停网络请求操作

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 *  暂停下载任务（会从网络队列中移除，恢复，则重新调用文件恢复下载）
 *
 *  @param URL     请求地址
 *  @param resume  文件已下载的数据
 *
 */
+ (void)suspendDownloadTaskWithURL:(NSString *)URL
                            resume:(void (^)(NSData * _Nullable resumeData))resume;


#pragma mark - 设置AFHTTPSessionManager相关属性

/**
 在开发中,如果以下的设置方式不满足项目的需求,就调用此方法获取AFHTTPSessionManager实例进行自定义设置
 @param sessionManager AFHTTPSessionManager的实例
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer XKRequestSerializerJSON(JSON格式),XKRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(XKRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer XKResponseSerializerJSON(JSON格式),XKResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(XKResponseSerializer)responseSerializer;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
@end

NS_ASSUME_NONNULL_END
