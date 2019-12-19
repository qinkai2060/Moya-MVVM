//
//  YunDianOrderDetailFooterView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianOrderListDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderDetailFooterView : UIView
@property (nonatomic, strong) YunDianOrderListDetailModel *detailFooterModel;

/**
 订单信息view
 */
@property (nonatomic, strong) UIView *orderInfoView;

/**
 订单编号
 */
@property (nonatomic, strong) UILabel *orderNoLabel;

/**
 复制
 */
@property (nonatomic, strong) UILabel *orderNoCopyLabel;

/**
 下单时间
 */
@property (nonatomic, strong) UILabel *orderTimeLabel;
/**
 付款时间
 */
@property (nonatomic, strong) UILabel *payTimeLabel;
/**
 发货时间
 */
@property (nonatomic, strong) UILabel *dispatchGoodsTLabel;
/**
 买家留言
*/
@property (nonatomic, strong) UILabel *buyerRemark;

/**
 账单view
 */
@property (nonatomic, strong) UIView *billView;

/**
 商品总金额
 */
@property (nonatomic, strong) UILabel *goodsTotalMoneyLa;

/**
 平台佣金
 */
@property (nonatomic, strong) UILabel * platformCommission;

/**
 运费
 */
@property (nonatomic, strong) UILabel *freightLabel;

/**
 抵扣券
 */
@property (nonatomic, strong) UILabel *voucherLabel;

/**
 注册券
 */
@property (nonatomic, strong) UILabel *registrationVouchersLabel;


/**
 现金
 */
@property (nonatomic, strong) UILabel *cashLabel;

/**
 注册券下
 */
@property (nonatomic, strong) UILabel *registrationVoucherBottomLabel;

/**
 商家应收现金
 */
@property (nonatomic, strong) UILabel * merchantCash;

@end

NS_ASSUME_NONNULL_END
