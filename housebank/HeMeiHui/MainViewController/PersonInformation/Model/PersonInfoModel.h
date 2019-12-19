//
//  PersonInfoModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PersonInfoModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString * brokerId;    // 经纪人id
@property (nonatomic, copy) NSString * name;        // 姓名
@property (nonatomic, copy) NSString * mobilephone; // 手机号
@property (nonatomic, copy) NSString * region;      // 区域
@property (nonatomic, copy) NSString * regionId;    // 区域id
@property (nonatomic, copy) NSString * blockId;     // 块id
@property (nonatomic, copy) NSString * company;     // 公司名称
@property (nonatomic, copy) NSString * companyId;   // 公司id
@property (nonatomic, copy) NSString * storeId;     // 门店id
@property (nonatomic, copy) NSString * store;       // 门店名称
@property (nonatomic, copy) NSString * brokerHeadImg;   // 经纪人头像
@property (nonatomic, copy) NSString * authStatus;   // 认证状态
@property (nonatomic, copy) NSString * resume;   // 自我介绍
@property (nonatomic, copy) NSString * cityId;   // 城市id
@property (nonatomic, copy) NSString * chainId;   // 门店角色
@property (nonatomic, copy) NSString * familiarBlock;   // 熟悉板块
@property (nonatomic, copy) NSString * familiarCommunity;   // 主营小区
@property (nonatomic, copy) NSString * workYear;   // 从业年限
@property (nonatomic, copy) NSString * roleTitle;   // 角色名
@property (nonatomic, copy) NSString * createTime;   // 注册时间
@property (nonatomic, copy) NSString * agentCity;   // 代理城市
@property (nonatomic, copy) NSString * agentRegion;   // 代理区域
@property (nonatomic, copy) NSString * identityVerifyStatus;   // 实名认证状态
@end

NS_ASSUME_NONNULL_END
