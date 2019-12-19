//
//  PayReq.h
//  HeMeiHui
//
//  Created by usermac on 2019/9/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayReq : BaseReq
/** 商家向财付通申请的商家id */
@property (nonatomic, retain) NSString *partnerId;
/** 预支付订单 */
@property (nonatomic, retain) NSString *prepayId;
/** 随机串，防重发 */
@property (nonatomic, retain) NSString *nonceStr;
/** 时间戳，防重发 */
@property (nonatomic, assign) UInt32 timeStamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, retain) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, retain) NSString *sign;
@end
/*! @brief 微信终端返回给第三方的关于支付结果的结构体
 *
 *  微信终端返回给第三方的关于支付结果的结构体
 */
@interface PayResp : BaseResp

/** 财付通返回给商家的信息 */
@property (nonatomic, retain) NSString *returnKey;

@end
NS_ASSUME_NONNULL_END
