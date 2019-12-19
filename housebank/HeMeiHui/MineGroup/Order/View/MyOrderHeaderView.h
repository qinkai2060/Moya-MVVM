//
//  MyOrderHeaderView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderFooterView.h"

#import "OrderInfoListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^MyOrderHeaderViewClickBlock)(NSInteger section);

@interface MyOrderHeaderView : UIView

@property (nonatomic, copy) MyOrderHeaderViewClickBlock clickBlock;
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

@property (nonatomic, strong) OrderInfoListModel *infoListModel;
@end

NS_ASSUME_NONNULL_END
