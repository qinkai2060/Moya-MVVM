//
//  AssembleSearchMainView.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypesSearchFooterView.h"
#import "AssembleSearchView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SearchTextViewDelegate <NSObject>

/**
 tableViewCell 的点击事件 indexRow为所属的row  searchText 历史搜索列表的内容
 */
- (void)tableViewDidSelectedWithIndexRow:(NSInteger)indexRow searchText:(NSString *)searchText;

- (void)lianXiangSearchCancelBtnClick:(UIButton *)btn;

@end

@interface AssembleSearchMainView : UIView
@property (nonatomic, strong) SpTypesSearchFooterView *footView;
@property (nonatomic, strong) AssembleSearchView *searchView;

@property (nonatomic, weak) id<SearchTextViewDelegate> delegate;

// 历史数据的数据刷新
- (void)refreshViewWithArr:(NSMutableArray *)muArr;

// 联想搜索的数据刷新
- (void)refreshTableViewWithDataSource:(NSMutableArray *)dataArr;
@end

NS_ASSUME_NONNULL_END
