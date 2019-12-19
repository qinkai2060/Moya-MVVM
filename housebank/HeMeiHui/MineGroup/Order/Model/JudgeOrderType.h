//
//  JudgeOrderType.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfoListModel.h"
#import "YunDianOrderListModel.h"

#import "YunDianOrderListDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JudgeOrderType : NSObject

/**
 是否为商城订单

 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judgeStoreOrderType:(NSString *)orderType;
/**
 是否为云店(新零售)
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judgeOTOOrderType:(NSString *)orderType;
/**
 是否为云店
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judgeCloudOrderType:(NSString *)orderType;
/**
 是否为全球家
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judgeGlobalHomeOrderType:(NSString *)orderType;
/**
 是否为代理订单
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judgeDelegateOrderType:(NSString *)orderType;
/**
 是否为福利订单
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judgeWelfareOrderType:(NSString *)orderType;
/**
 是否为注册rm
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judge_ZC_RM_OrderType:(NSString *)orderType;
/**
 是否为代注册rm订单
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judge_D_ZC_RM_OrderType:(NSString *)orderType;
/**
 是否为升级rm订单
 
 @param orderType 传入类型
 @return yes 是
 */
+ (BOOL)judge_S_ZC_RM_OrderType:(NSString *)orderType;

+ (NSString *)timeStr:(NSString *)timeStr;
+ (NSString *)timeStrNYR:(NSString *)timeStr;

//时间戳 转时间
+ (NSString *)timeStr:(NSString *)timeStr formatterType:(NSString *)type;
+ (NSString *)timeStr1000:(NSString *)timeStr formatterType:(NSString *)type;
/**
 金额转换

 @param text 199968.89
 @return 199,968.80
 */
+ (NSString *)positiveFormat:(NSString *)text;
//我的订单
+ (float)returnTableViewFooter:(OrderInfoListModel *)infoListModel;
//云店 销售订单
+ (float)returnYunDianTableViewFooter:(YunDianOrderListModel *)orderListModel;
//是否显示云店详情下面按钮
+ (BOOL)returnYunDianDetailTableViewFooter:(YunDianOrderListDetailModel *)orderListModel;
//云店是否显示结算
+ (BOOL)yunDianTableViewIsShowJS:(YunDianOrderListModel *)orderListModel;
+ (NSString *)getSystemTimeString13;
//云店 销售订单详情 返回header高度
+ (float)returnYunDianDetailTableViewHeaderHeight:(YunDianOrderListDetailModel *)detailModel;

@end

NS_ASSUME_NONNULL_END
