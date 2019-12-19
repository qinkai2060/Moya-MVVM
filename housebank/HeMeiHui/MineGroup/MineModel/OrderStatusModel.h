//
//  OrderStatusModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/30.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface OrderStatusData :NSObject<NSCoding>
@property (nonatomic , strong) NSString              * P_BIZ_PROXY_REG_ORDER;//11111; //代注册（邀请）
@property (nonatomic , strong) NSString              * P_BIZ_REGISTRATION_ORDER;//2222;//自己注册
@property (nonatomic , strong) NSString              * P_BIZ_UPREGISTRATION_ORDER;//33333;//升级

@end
@interface OrderStatusModel : SetBaseModel
@property (nonatomic , strong) OrderStatusData              * data;
@end

NS_ASSUME_NONNULL_END
