//
//  CommonServicesCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckShopsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, CommonServicesViewClickType) {
//    @"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"销售线索",@"邀请RM",@"代理商品",@"福利商品",@"升级RM"
    CommonServicesViewTypeMyCollection, //我的收藏
    CommonServicesViewTypeInviteFriends, //邀请好友
    CommonServicesViewTypeMailList, //通讯邀约
    CommonServicesViewTypeBankCard,//银行卡管理
    CommonServicesViewTypeAddressManagement,//地址管理
    CommonServicesViewTypeGroupBuy,//我的团购
     CommonServicesViewTypeBuyTickets,//购买门票
    CommonServicesViewTypeSalesLeads,//销售线索
     CommonServicesViewTypeInviteRM,//邀请RM
     CommonServicesViewTypeAgencyGoods,//代理商品
     CommonServicesViewTypeWelfareGoods,//福利商品
     CommonServicesViewTypeUpgradeRM//升级RM
};
typedef void(^CommonServicesClickViewBlock)(CommonServicesViewClickType flag);
@interface CommonServicesCell : UITableViewCell
@property(nonatomic,strong)NSArray * nameArray;
@property(nonatomic,strong)NSArray * imageArray;
@property (nonatomic, copy) CommonServicesClickViewBlock clickBlock;
- (void)refreshCellWithModel:(CheckShopsModel*)model;
@end

NS_ASSUME_NONNULL_END
