//
//  SpTypesSearchMainView.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypesSearchFooterView.h"
#import "SpTypesSearchView.h"
typedef NS_ENUM(NSInteger , SearchViewTypes) {
    
    //普通搜索
    OrdinarySearchViewType= 0,
    //全球家首页搜索
    GlobalHomeSearchViewType,
    
};
NS_ASSUME_NONNULL_BEGIN
@protocol SearchTextViewDelegate <NSObject>

/**
 tableViewCell 的点击事件 indexRow为所属的row  searchText 历史搜索列表的内容
 */
- (void)tableViewDidSelectedWithIndexRow:(NSInteger)indexRow searchText:(NSString *)searchText;

- (void)lianXiangSearchCancelBtnClick:(UIButton *)btn;

@end

@interface SpTypesSearchMainView : UIView
@property (nonatomic, assign) SearchViewTypes searchViewType;
@property (nonatomic, strong) SpTypesSearchFooterView *footView;
@property (nonatomic, strong) SpTypesSearchView *searchView;

@property (nonatomic, weak) id<SearchTextViewDelegate> delegate;

// 历史数据的数据刷新
- (void)refreshViewWithArr:(NSMutableArray *)muArr;

// 联想搜索的数据刷新
- (void)refreshTableViewWithDataSource:(NSMutableArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
