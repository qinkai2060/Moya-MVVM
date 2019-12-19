//
//  YunDianOrderListTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianOrderProductsModel.h"
#import "YunDianOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderListTableViewCell : UITableViewCell
@property (nonatomic, strong) YunDianOrderProductsModel *productsModel;
@property (nonatomic, strong) YunDianOrderListModel *orderListModel;

@property (nonatomic, assign) NSInteger state;//大与等于四为退款s售后
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

@property (nonatomic, strong) UILabel *refundLabel;

@end

NS_ASSUME_NONNULL_END
