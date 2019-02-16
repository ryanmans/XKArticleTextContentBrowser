//
//  XKHttpNetworkHelper+Reachability.m
//  XKHttpNetworkHelper_Example
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 RyanMans. All rights reserved.
//

#import "XKHttpNetworkHelper+Reachability.h"
#import "Reachability.h"

@implementation XKHttpNetworkHelper (Reachability)

//获取网络状态
+ (XKNetworkStatusType)networkReachabilityStatus{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    return [self xk_ReachabilityStatus:status];
}

+ (XKNetworkStatusType)xk_ReachabilityStatus:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"NetworkStatus: 未知网络");
            return XKNetworkStatusUnknown;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"NetworkStatus: 无网络");
            return XKNetworkStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"NetworkStatus: 手机自带网络");
            return XKNetworkStatusReachableViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"NetworkStatus: WIFI");
            return XKNetworkStatusReachableViaWiFi;
            break;
    }
}

//3G网络
+ (BOOL)xk_IsEnable3G{
    return  ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

//wifi网络
+ (BOOL)xk_IsEnableWifi{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 网络状态
+ (BOOL)xk_IsNetworkOK{
    return ([self xk_IsEnable3G] || [self xk_IsEnableWifi]);
}

//时刻监听网络状态的改变
+ (void)xk_ReachabilityStatusChangeBlock:(void (^)(XKNetworkStatusType networkStatus))block{
    
    //监听网络状态的改变
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        XKNetworkStatusType statusType = [XKHttpNetworkHelper xk_ReachabilityStatus:status];
        block ? block(statusType) : nil;
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
@end

