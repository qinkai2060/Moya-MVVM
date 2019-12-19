//
//  BeeModel.h
//  HeMeiHui
//
//  Created by 任为 on 16/9/26.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BeeModel : NSObject

@property (nonatomic, strong)NSString *billno;
@property (nonatomic, strong)NSString *channel;
@property (nonatomic, strong)NSNumber *id;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSNumber *totalfee;
@property (nonatomic, strong)NSNumber *payType;
@property (nonatomic, strong)NSNumber *appId;
@property (nonatomic, strong)NSNumber *appSecret;
@property (nonatomic, strong)NSString *weChatAppId;


@end
