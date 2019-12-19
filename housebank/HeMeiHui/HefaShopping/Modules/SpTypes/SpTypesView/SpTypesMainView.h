//
//  CategoryMainView.h
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypesSearchView.h"
#import "SpTypesLeftTableViewCell.h"
#import "SpTypesHeaderCollectionView.h"
#import "SpTypesRightCollectionViewCell.h"
#import "SpTypeFirstLevelModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol RightCollectionViewDelegate <NSObject>

/**
  collectitonCell 的点击事件 section为所属的分区  indexRow为所属的row
 */
- (void)collectionViewCellSelectedWithIndexSection:(NSInteger)section indexRow:(NSInteger)indexRow dataSourceArr:(NSArray *)modelArr;

/**
  分区中 更多按钮的点击事件 section为所属的分区
 */
- (void)collectionViewSectionMoreBtnClickWithSection:(NSInteger)section dataSourceModel:(SpTypeFirstLevelModel *)model;

@end

@interface SpTypesMainView : UIView

@property (nonatomic, strong) SpTypesSearchView *searchView;

@property (nonatomic, weak) id<RightCollectionViewDelegate> delegate;

@property (nonatomic, assign) NSInteger type;//1 一级界面 2 二级界面

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

// 当无数据时 在主页面刷新UI
- (void)refreshMainUI;
@end

NS_ASSUME_NONNULL_END
