//
//  appIDModel.h
//  HeMeiHui
//
//  Created by 任为 on 2017/3/30.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface appIDModel : NSObject
@property (nonatomic, strong)NSString *appId;
@property (nonatomic, strong)NSString *appSecret;
@property (nonatomic, strong)NSNumber *masterSecret;
@property (nonatomic, strong)NSNumber *mchId;
@property (nonatomic, strong)NSString *notifyUrl;
@property (nonatomic, strong)NSString *totalfee;
@property (nonatomic, strong)NSString *payPrecision;
@property (nonatomic, strong)NSString *returnUrl;
@property (nonatomic, strong)NSString *testSecret;
@property (nonatomic, strong)NSString *weChatAppId;
@end
