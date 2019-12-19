//
//  MyOrderTableViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>
#import "UserOrderCell.h"
#import "BaseSettingViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^OrderNumReturnBlock)(NSNumber *num);

@interface MyOrderTableViewController : BaseSettingViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UserOrderCellClickType orderState;
@property (nonatomic, copy) NSString *strType;
@property (nonatomic,weak) UINavigationController *nvController;
@property (nonatomic, copy) OrderNumReturnBlock orderNumBlock;
@end

NS_ASSUME_NONNULL_END
