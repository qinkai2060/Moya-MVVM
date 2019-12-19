//
//  YunDianOrderHeaderView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YunDianOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^YunDianOrderHeaderViewClickBlock)(NSInteger section);

@interface YunDianOrderHeaderView : UIView

@property (nonatomic, copy) YunDianOrderHeaderViewClickBlock clickHeaderBlock;
@property (nonatomic, assign) NSInteger state;//大与等于四为退款s售后
/**
 背景图
 */
@property (nonatomic, strong) UIView *bgView;
/**
 类型图
 */
@property (nonatomic, strong) UIImageView *imgLogo;
/**
 类型
 */
@property (nonatomic, strong) UILabel *typeLabel;
/**
 竖线
 */
@property (nonatomic, strong) UIView *line;
/**
 店铺名
 */
@property (nonatomic, strong) UILabel *storeNamelL;
/**
 右箭头
 */
@property (nonatomic, strong) UIImageView *imgNext;

/**
 状态
 */
@property (nonatomic, strong) UILabel *stateLabel;

/**
 结算
 */
@property (nonatomic, strong) UILabel *settleLabel;


@property (nonatomic, strong) YunDianOrderListModel *orderListModel;
@end

NS_ASSUME_NONNULL_END

