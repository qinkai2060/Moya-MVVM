//
//  HFGlobalFamilayHomeStarPriceView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HFFilterPriceModel.h"
@class HFGlobalFamilayHomeStarPriceView;
NS_ASSUME_NONNULL_BEGIN
@protocol HFGlobalFamilayHomeStarPriceViewDelegate <NSObject>

- (void)popupView:(HFGlobalFamilayHomeStarPriceView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index ;

@end
@interface HFGlobalFamilayHomeStarPriceView : UIView
@property(nonatomic,weak)id<HFGlobalFamilayHomeStarPriceViewDelegate> delegate;
@property(nonatomic,strong)HFFilterPriceModel *model;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *resetBtn;
@property(nonatomic,strong)UIButton *sureBtn;
- (instancetype)initWithFrame:(CGRect)frame WithFilter:(HFFilterPriceModel *)model;
- (void)dissMiss;
- (void)show;
@end

NS_ASSUME_NONNULL_END
