//
//  NetStatTool.m
//  HeMeiHui
//
//  Created by 任为 on 2016/12/27.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "NetStatTool.h"

@implementation NetStatTool

- (void)NetWorkReachablity
{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi://2
            {
                //NSLog(@"WiFi");
                [self.delegete NetStateChanged:2];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://1
            {
                [self.delegete NetStateChanged:1];
                // NSLog(@"手机网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable://0
            {
                //  NSLog(@"没有网络");
                [self.delegete NetStateChanged:0];
            }
                break;
            case AFNetworkReachabilityStatusUnknown://-1
                // NSLog(@"未知网络");
                [self.delegete NetStateChanged:-1];
                break;
                
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

@end
