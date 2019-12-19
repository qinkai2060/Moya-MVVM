//
//  MyOrderTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderProductListModel.h"
#import "OrderInfoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyOrderTableViewCell : UITableViewCell


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
/**
 促销标签
 */
@property (nonatomic, strong) UILabel *salesLabel;
/**
 拼团标签
 */
@property (nonatomic, strong) UILabel *groupPurchaseLabel;
/**
 全家购有早无早标签
 */
@property (nonatomic, strong) UILabel *mornLabel;
/**
 退款状态
 */
@property (nonatomic, strong) UILabel *refundLabel;

@property (nonatomic, strong) MyOrderProductListModel *productModel;
//全球家走这个model
@property (nonatomic, strong) OrderInfoListModel *infoListModel;
@end

NS_ASSUME_NONNULL_END
