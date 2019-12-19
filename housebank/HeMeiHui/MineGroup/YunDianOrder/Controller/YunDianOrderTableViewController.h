//
//  YunDianOrderTableViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "UserOrderCell.h"
#import "BaseSettingViewController.h"
#import "YunDianShopListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^YunDianOrderNumReturnBlock)(NSNumber *num);//待发货

@interface YunDianOrderTableViewController : BaseSettingViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UserOrderCellClickType orderState;
@property (nonatomic, strong) YunDianShopListModel *shopModel;
@property (nonatomic, weak) UINavigationController *nvController;
@property (nonatomic, copy) YunDianOrderNumReturnBlock ydOrderNumBlock;

- (void)refreshBeEmptyView;//清空view
- (void)refreshDate;//刷新接口
- (void)refreshDateNoMJ;//刷新接口

@end

NS_ASSUME_NONNULL_END
