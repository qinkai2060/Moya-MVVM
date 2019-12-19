//
//  VipInformationModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipInformationModel : NSObject
@property (nonatomic, strong) NSNumber * vipLevel;;//用户当前角色，1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员
@property (nonatomic, strong)  NSNumber *unGetVipLevel;//待领取角色，0-没有待领取角色，1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员
@property (nonatomic, copy) NSString * name;//姓名
@property (nonatomic, copy) NSString *headImagePath;//头像地址
@property (nonatomic, copy) NSString * vipRecommendFlag; // vip推荐人页面显示标识，1-不显示，0-显示
@end

NS_ASSUME_NONNULL_END
