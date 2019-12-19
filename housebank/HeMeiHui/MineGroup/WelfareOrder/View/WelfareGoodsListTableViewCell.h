//
//  WelfareGoodsListTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelfareGoodsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WelfareGoodsListTableViewCell : UITableViewCell

/**
 背景
 */
@property (nonatomic, strong) UIView *bgView;
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
 优惠券标签
 */

@property (nonatomic, strong) UILabel *couponLabel;
/**
 立即购买
 */
@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) UIView *line;


@property (nonatomic, strong) WelfareGoodsListModel *model;
@end

NS_ASSUME_NONNULL_END
