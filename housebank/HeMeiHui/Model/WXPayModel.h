//
//  WXPayModel.h
//  HeMeiHui
//
//  Created by 任为 on 2017/2/20.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 appid = wxfe7ed681f8323282;
 noncestr = e324f4746d684dcf9e40f4c6d4864b78;
 optional =     {
 id = 99477;
 type = 5;
 userId = 99477;
 };
 package = "Sign=WXPay";
 partnerid = 1436251302;
 payChannel = WX;
 payMode = "P_MODE_WECHAT";
 payPlatform = "PAY_PLATFORM_WECHAT";
 prepayid = wx201702201540316d7c14bfe20282815255;
 sign = D1D59AA1931BF584819ECF319D809771;
 timestamp = 1487576431;
 }
 */

@interface WXPayModel : NSObject
@property (nonatomic, strong)NSString *package;
@property (nonatomic, strong)NSString *payPlatform;
@property (nonatomic, strong)NSString *appid;
@property (nonatomic, strong)NSString *noncestr;
@property (nonatomic, strong)NSString *partnerid;
@property (nonatomic, strong)NSString *payChannel;
@property (nonatomic, strong)NSString *prepayid;
@property (nonatomic, strong)NSString *sign;
@property (nonatomic, assign)UInt32 timestamp;

@end
