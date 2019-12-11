//
//  WARSettingsBaseViewController.h
//  Pods
//
//  Created by huange on 2017/8/4.
//
//

#import <UIKit/UIKit.h>
#import "WARBaseViewController.h"
#import "WARSettingCellItem.h"
#import "WARSettingsCell.h"

#import "WARSettingDataManager.h"
#import "MBProgressHUD+WARExtension.h"
#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "ReactiveObjC.h"

@interface WARSettingsBaseViewController : WARBaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settinsItemArray;
@property (nonatomic, strong) WARSettingDataManager *dataManager;

- (void)initData;
- (void)initUI;

@end
