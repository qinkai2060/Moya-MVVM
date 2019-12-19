//
//  SpTypesSearchListMainView.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypesSearchView.h"
#import "SpTypesSearchTopView.h"
#import "SpTypesSearchListTableViewCell.h"
#import "GetProductListByConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SpTypeSearchListDelegate <NSObject>
// cell上 进店按钮的点击事件
- (void)searchListToShopBtnClickWithModel:(GetProductListByConditionModel *)model;
// cell的点击事件
- (void)searchListCellDidSelectRowAtIndexWithModel:(GetProductListByConditionModel *)model;
@end

@interface SpTypesSearchListMainView : UIView

@property (nonatomic, weak) id<SpTypeSearchListDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SpTypesSearchView *searchView;
@property (nonatomic, strong) SpTypesSearchTopView *topView;

- (instancetype)initWithFrame:(CGRect)frame withSearchStr:(NSString *)searchStr;

- (void)refreshViewWithData:(NSMutableArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
