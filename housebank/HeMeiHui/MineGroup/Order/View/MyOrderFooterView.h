//
//  MyOrderFooterView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MyOrderFooterViewTypeClick) {
    MyOrderFooterViewTypeGoPay, //付款
    MyOrderFooterViewTypeCanceloOrder, //取消订单
    MyOrderFooterViewTypeUrgeOrder, //催单
    MyOrderFooterViewTypeSure, //确认订单
    MyOrderFooterViewTypeViewLogistics,//查看物流
    MyOrderFooterViewTypeEvaluate,//评价
    MyOrderFooterViewTypeGoBugAgain,//再次预定
    MyOrderFooterViewTypeBackOut,//退订
    MyOrderFooterViewTypeRefun,//退款
    MyOrderFooterViewTypeVerifyCode,//核销码
    MyOrderFooterViewTypeDelete,//删除
    MyOrderFooterViewTypeSurePS, //确认订单(配送)

};
typedef NS_ENUM(NSUInteger, MyOrderCellType) {
    MyOrderCellTypeFinsh, //已完成
    MyOrderCellTypeFinshNoEvaluate, //已完成未评价
    MyOrderCellTypeCancel, //已取消
    MyOrderCellTypePendingPayment, //待付款
    MyOrderCellTypeToBeShipped, //待发货
    MyOrderCellTypeTypeGoodsReceived, //待收货
};

typedef void(^MyOrderFooterViewTypeClickBlcok)(MyOrderFooterViewTypeClick clickType, NSInteger section);

@interface MyOrderFooterView : UIView


@property (nonatomic, copy) MyOrderFooterViewTypeClickBlcok clickBlock;

@property (nonatomic, strong) OrderInfoListModel *infoListModel;

/**
 背景图
 */
@property (nonatomic, strong) UIView *bgView;
/**
 商品数
 */
@property (nonatomic, strong) UILabel *numLabel;
/**
 金额
 */
@property (nonatomic, strong) UILabel *moneyLabel;
/**
 付款
 */
@property (nonatomic, strong) UIButton *btnGoPay;
/**
 左 取消订单
 */
@property (nonatomic, strong) UIButton *btnCanceloOrder;

/**
 催单
 */
@property (nonatomic, strong) UIButton *btnuUrgeOrder;

/**
 确认收货
 */
@property (nonatomic, strong) UIButton *btnSure;
/**
 确认收货 配送
 */
@property (nonatomic, strong) UIButton *btnSurePS;
/**
 查看物流
 */
@property (nonatomic, strong) UIButton *btnViewLogistics_M;

@property (nonatomic, strong) UIButton *btnViewLogistics_R;
/**
 评价
 */
@property (nonatomic, strong) UIButton *btnEvaluate;
/**
 再次预定左
 */
@property (nonatomic, strong) UIButton *btnBuyAgainL;
/**
 再次预定右
 */
@property (nonatomic, strong) UIButton *btnBuyAgainrR;
/**
 去点评
 */
@property (nonatomic, strong) UIButton *btnGoEvaluate;
/**
 右取消订单
 */
@property (nonatomic, strong) UIButton *btnCanceloOrderR;


/**
 退订
 */
@property (nonatomic, strong) UIButton *btnBackOut;


/**
 退款 右
 */
@property (nonatomic, strong) UIButton *btnRefun_R;
/**
 退款 中
 */
@property (nonatomic, strong) UIButton *btnRefun_M;
/**
 退款 左
 */
@property (nonatomic, strong) UIButton *btnRefun_L;
/**
 核销码
 */
@property (nonatomic, strong) UIButton *btnVerifyCode;
/**
 核销码中间
 */
@property (nonatomic, strong) UIButton *btnVerifyCode_M;

/**
 删除
 */
@property (nonatomic, strong) UIButton *btnDelete;

@property (nonatomic, strong) UILabel *remainingMarginLable;//本月额度剩余 (福利订单显示)
@end

NS_ASSUME_NONNULL_END
