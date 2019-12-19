//
//  WelfareOrderListViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef NS_ENUM(NSInteger, WelfareOrderListType){
    WelfareOrderListTypeAll,//全部订单
    WelfareOrderListTypePendingPayment, //代付款
    WelfareOrderListTypeToBeShipped, //待发货
    WelfareOrderListTypeGoodsReceived, //待收货
    WelfareOrderListTypeCancle,//取消订单
    WelfareOrderListTypeFinsh//完成
};

typedef void(^WelfareOrderListNumReturnBlock)(NSNumber * _Nullable num);

NS_ASSUME_NONNULL_BEGIN

@interface WelfareOrderListViewController : BaseSettingViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) WelfareOrderListType orderState;//订单类型
@property (nonatomic,weak) UINavigationController *nvController;
@property (nonatomic, copy) WelfareOrderListNumReturnBlock orderNumBlock;//待发货数量回调
@end

NS_ASSUME_NONNULL_END
