//
//  XKHttpNetworkHelper+Reachability.h
//  XKHttpNetworkHelper_Example
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 RyanMans. All rights reserved.
//

#import <XKHttpNetworkHelper/XKHttpNetworkHelper.h>

NS_ASSUME_NONNULL_BEGIN

#define  xk_IsEnable3G()    [XKHttpNetworkHelper   xk_IsEnable3G]
#define  xk_IsEnableWifi()  [XKHttpNetworkHelper xk_IsEnableWifi]
#define  xk_IsNetworkOK()   [XKHttpNetworkHelper  xk_IsNetworkOK]

typedef NS_ENUM(NSUInteger, XKNetworkStatusType) {
    /** 未知网络*/
    XKNetworkStatusUnknown,
    /** 无网络*/
    XKNetworkStatusNotReachable,
    /** 手机网络*/
    XKNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    XKNetworkStatusReachableViaWiFi
};

@interface XKHttpNetworkHelper (Reachability)

/**
 获取网络状态
 
 @return XKNetworkStatusType
 */
+ (XKNetworkStatusType)networkReachabilityStatus;

/**
 3G网络
 
 @return yes/no
 */
+ (BOOL)xk_IsEnable3G;

/**
 Wi-Fi
 
 @return yes/no
 */
+ (BOOL)xk_IsEnableWifi;

/**
 网络状态
 
 @return yes/no
 */
+ (BOOL)xk_IsNetworkOK;

/**
 实时获取网络状态,通过Block回调实时获取
 
 @param block 网络状态
 */
+ (void)xk_ReachabilityStatusChangeBlock:(void (^)(XKNetworkStatusType networkStatus))block;


@end

NS_ASSUME_NONNULL_END
