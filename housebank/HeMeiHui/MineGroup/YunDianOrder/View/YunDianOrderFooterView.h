//
//  YunDianOrderFooterView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianOrderListModel.h"
#import "YunDianOrderProductsModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YunDianOrderFooterViewTypeClick) {
    YunDianOrderFooterViewTypeRefun,//退款
    YunDianOrderFooterViewTypeVerifyCode,//核销码
    YunDianOrderFooterViewTypeReason,//查看原因
    YunDianOrderFooterViewTypeDispatchGoods,//发货
    YunDianOrderFooterViewTypeViewLogistics//查看物流
};

typedef void(^YunDianOrderFooterViewTypeClickBlcok)(YunDianOrderFooterViewTypeClick clickType, NSInteger section);

@interface YunDianOrderFooterView : UIView

@property (nonatomic, copy) YunDianOrderFooterViewTypeClickBlcok clickBlock;

@property (nonatomic, strong) YunDianOrderListModel *orderListModel;
@property (nonatomic, assign) NSInteger state;//大与等于四为退款s售后
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
 查看物流
 */
@property (nonatomic, strong) UIButton *btnViewLogistics;

/**
 退款 ZUO  ZHONG
 */
@property (nonatomic, strong) UIButton *btnRefun_R;



/**
 核销码
 */
@property (nonatomic, strong) UIButton *btnVerifyCode;



/**
 发货
 */
@property (nonatomic, strong) UIButton *btnDispatchGoods;



/**
 查看原因
 */
@property (nonatomic, strong) UIButton *btnReason_M;

/**
 查看原因
 */
@property (nonatomic, strong) UIButton *btnReason_R;

@end

NS_ASSUME_NONNULL_END
