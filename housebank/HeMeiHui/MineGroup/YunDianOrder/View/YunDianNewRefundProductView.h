//
//  YunDianNewRefundProductView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianNewRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundProductView : UIView
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundDetailModel;
@property (nonatomic, assign) BOOL isRefuseRefund;//是否是拒绝退款
@property (nonatomic, strong) UIView * hearderView;

@property (nonatomic, strong) UIView *productView;
/**
 商品图
 */
@property (nonatomic, strong) UIImageView *imgLogo;
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleL;
/**
 钱
 */
@property (nonatomic, strong) UILabel *moneyLabel;
/**
 数量
 */
@property (nonatomic, strong) UILabel *numLabel;
/**
 规格
 */
@property (nonatomic, strong) UILabel *rankLabel;
/**
 类型标签
 */
@property (nonatomic, strong) UILabel *typeLabel;
/**
 促销标签
 */
@property (nonatomic, strong) UILabel *salesLabel;
/**
 拼团标签
 */
@property (nonatomic, strong) UILabel *groupPurchaseLabel;

/**
 订单信息view
 */
@property (nonatomic, strong) UIView *orderInfoView;

/**
 退款编号
 */
@property (nonatomic, strong) UILabel *refundNoLabel;
/**
 申请时间
 */
@property (nonatomic, strong) UILabel *applyForTimeLabel;

/**
 退款现金
 */
@property (nonatomic, strong) UILabel *refundMoneyLabel;

@property (nonatomic, strong) UILabel *orderNoCopyLabel;//复制
///**
// 退款状态
// */
//@property (nonatomic, strong) UILabel *refundStateLabel;
///**
// 退款运费
// */
//@property (nonatomic, strong) UILabel *refundFreightLabel;
//
///**
// 退款抵扣券
// */
//@property (nonatomic, strong) UILabel *refundVoucherLabel;
//
///**
// 退款注册券
// */
//@property (nonatomic, strong) UILabel *refundRegistrationVouchersLabel;


@end

NS_ASSUME_NONNULL_END
