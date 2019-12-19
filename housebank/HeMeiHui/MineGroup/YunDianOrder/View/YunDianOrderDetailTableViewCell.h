//
//  YunDianOrderDetailTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianorderDetailProductListModel.h"
#import "YunDianOrderListDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) YunDianOrderListDetailModel *detailModel;

@property (nonatomic, strong) YunDianorderDetailProductListModel *productModel;
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
 退款状态
 */
@property (nonatomic, strong) UILabel *refundLabel;
@end

NS_ASSUME_NONNULL_END
