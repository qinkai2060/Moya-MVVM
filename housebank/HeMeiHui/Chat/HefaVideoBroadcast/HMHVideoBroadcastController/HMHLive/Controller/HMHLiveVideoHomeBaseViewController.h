//
//  HMHLiveVideoHomeBaseViewController.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveVideoHomeBaseViewController : HMHBasePrimaryViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) UITableViewStyle tableViewStyle;  //选择tableViewStyle 和下面对应

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,weak)UINavigationController *nvController;

/**
 *  Overwrite to setup titleView, contentView etc.
 */
- (void)setSubviews;

- (void)initNotification;

- (void)removeNotification;


///**
// 加载数据
// */
- (void)loadData;



/**
 加载更多数据
 */
- (void)loadMoreData;

- (void)addFooterRefresh;

@end

NS_ASSUME_NONNULL_END
