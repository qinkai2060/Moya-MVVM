//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"
#import <NIMSDK/NIMSDK.h>

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
//        _appKey = @"44ec9c8c5db77eea8d3f2d04ca2841de";//生产appkey
//        _appKey = @"3ac6ee77676a8456748589fe98b10bcb";  //测试APPKey
        
        _appKey = NIMAppKey;
        _apiURL = @"https://app.netease.im/api";
        _apnsCername = NIMSDKCertificateName;
        _pkCername = @"testPush";
        _redPacketConfig = [[NTESRedPacketConfig alloc] init];
    }
    return self;
}

- (NSString *)apiURL
{
    NSAssert([[NIMSDK sharedSDK] isUsingDemoAppKey], @"只有 demo appKey 才能够使用这个API接口");
    return _apiURL;
}



@end



@implementation NTESRedPacketConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _useOnlineEnv = YES;
        _aliPaySchemeUrl = @"alipay052969";
        _weChatSchemeUrl = @"wx2a5538052969956e";
    }
    return self;
}

@end
