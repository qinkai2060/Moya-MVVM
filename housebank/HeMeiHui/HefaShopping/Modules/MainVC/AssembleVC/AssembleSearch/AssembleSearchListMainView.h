//
//  AssembleSearchListMainView.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssembleSearchView.h"
#import "SpTypesSearchTopView.h"
#import "SpTypesSearchListTableViewCell.h"
#import "AssembleSearchListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SpTypeSearchListDelegate <NSObject>
// cell上 进店按钮的点击事件
- (void)searchListToShopBtnClickWithModel:(SearchListModel *)model;
// cell的点击事件
- (void)searchListCellDidSelectRowAtIndexWithModel:(SearchListModel *)model;
@end


@interface AssembleSearchListMainView : UIView
@property (nonatomic, weak) id<SpTypeSearchListDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AssembleSearchView *searchView;
@property (nonatomic, strong) SpTypesSearchTopView *topView;

- (instancetype)initWithFrame:(CGRect)frame withSearchStr:(NSString *)searchStr;

- (void)refreshViewWithData:(NSMutableArray *)dataSource;
@end

NS_ASSUME_NONNULL_END
