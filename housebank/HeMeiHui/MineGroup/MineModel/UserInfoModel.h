//
//  UserInfoModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/29.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UserCenterInfo :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger             userId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger              regionId;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * regionName;
@property (nonatomic , assign) NSInteger              authStatus;
@property (nonatomic , copy) NSString              * authStatusName;
@property (nonatomic , copy) NSString              * mobilephone;
@property (nonatomic , assign) NSInteger              applyChainId;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , assign) NSInteger              agentId;
@property (nonatomic , assign) NSInteger              agentType;
@property (nonatomic , assign) NSInteger              agentCityId;
@property (nonatomic , assign) NSInteger              agentRegionId;
@property (nonatomic , copy) NSString              * agentCityName;
@property (nonatomic , copy) NSString              * agentRegionName;
@property (nonatomic , assign) CGFloat              agentRestMoney;
@property (nonatomic , assign) NSInteger              chainRole;
@property (nonatomic , copy) NSString              * chainRoleName;//高级门店。s初级门店。   中级门店
@property (nonatomic , assign) NSInteger              chainRestMoney;
@property (nonatomic , assign) NSInteger              totalGjj;
@property (nonatomic , assign) NSInteger              haveGetHouse;
@property (nonatomic , assign) NSInteger              chainMoney;
@property (nonatomic , assign) NSInteger              oldZeroChainUser;
@property (nonatomic , assign) NSInteger              restTransfer;
@property (nonatomic , assign) NSInteger              restIntegral;
@property (nonatomic , assign) NSInteger              memberLevel;//=6时为企业会员
@property (nonatomic , assign) NSInteger              state;
@property (nonatomic , assign) NSInteger              identityVerifyStatus;
@property (nonatomic , copy) NSString              * identity;
@property (nonatomic , assign) NSInteger              unConfirmGoodsCount;
@property (nonatomic , assign) NSInteger              stockRightSpecial;
@property (nonatomic , assign) NSInteger              marketPerformance;//MLS业绩
@property (nonatomic , assign) NSInteger              marketPerformanceProfit;//商城业绩
@property (nonatomic , assign) NSInteger              banLevel;
@property (nonatomic , assign) NSInteger              banLevelDateTime;
@property (nonatomic , assign) NSInteger              banLevelStartTime;
@property (nonatomic , assign) NSInteger              offlineShopsId;
@property (nonatomic , assign) NSInteger              hfgShopsId;
@property (nonatomic , assign) NSInteger              isCellQualificationShow;
@property (nonatomic , assign) NSInteger              isRedPacketShow;
@property (nonatomic , copy) NSString              *companyName;
@property (nonatomic , copy) NSString              *companyPeople;
@property (nonatomic , copy) NSString              *companyAddress;
@property (nonatomic , copy) NSString              *imagePath;
@property (nonatomic , copy) NSString              *agentTypeName;
@property (nonatomic , copy) NSString              *vipLevel;//vip会员等级(1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员)
@property (nonatomic , copy) NSString              *hasRmGiftPack;//是否有RM礼包可领取，true-有，false-没有

@end


@interface UserData :NSObject<NSCoding>
@property (nonatomic , strong) UserCenterInfo              * userCenterInfo;

@end


@interface UserInfoModel :SetBaseModel
@property (nonatomic , strong) UserData              * data;
@end


NS_ASSUME_NONNULL_END
