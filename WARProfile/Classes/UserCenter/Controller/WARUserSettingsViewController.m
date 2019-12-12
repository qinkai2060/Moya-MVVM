//
//  WARUserSettingsViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/28.
//

#import "WARUserSettingsViewController.h"
#import "WARAccountSettingViewController.h"
#import "WARPrivateSettingsViewController.h"
#import "WARCommonViewController.h"
#import "WARMessageSettingViewController.h"
#import "WARFeedbackViewController.h"
#import "WARVersionIntroduceController.h"
#import "WARSettingsCell.h"
#import "WARDeleteUserCell.h"

#import "WARAlertView.h"
#import "WARSettingDataManager.h"

@interface WARUserSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitleArray;

@property (nonatomic, strong) WARSettingDataManager *dataManager;

@end

@implementation WARUserSettingsViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WARLocalizedString(@"设置");
    
    self.cellTitleArray = @[@[WARLocalizedString(@"账号安全"),WARLocalizedString(@"通知设置"),WARLocalizedString(@"隐私"),WARLocalizedString(@"通用"),WARLocalizedString(@"意见反馈"),WARLocalizedString(@"版本介绍")],@[WARLocalizedString(@"退出登录")]];
    
    [self.view addSubview:self.tableView];
    
    self.dataManager = [[WARSettingDataManager alloc] init];
    
    [WARSettingDataManager getUserSettingsInfo];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.frame;
}

#pragma mark - Event Response

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitleArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = BackgroundDefaultColor;
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    NSString *cellTitle = array[0];
    if ([cellTitle isEqualToString:WARLocalizedString(@"退出登录")]) {
        return 35;
    }
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"退出登录")]) {
        return 50;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"退出登录")]) {
        WARDeleteUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARDeleteUserCell"];
        cell.nameLabel.text = cellTitle;
        return cell;
    }
    else {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        cell.descriptionText = cellTitle;
        cell.showAccessoryView = YES;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"退出登录")]) {
        WS(weakSelf);
        [WARAlertView showWithTitle:WARLocalizedString(@"退出登录") Message:WARLocalizedString(@"退出后不会删除任何历史数据，下次登录仍可以使用本账号") cancelTitle:WARLocalizedString(@"取消") actionTitle:WARLocalizedString(@"确认退出") cancelHandler:nil actionHandler:^(LGAlertView * _Nonnull alertView) {
            [weakSelf logOut];
        }];
    }
    else {
        UIViewController *VC = nil;
        if ([cellTitle isEqualToString:WARLocalizedString(@"账号安全")]) {
            VC = [WARAccountSettingViewController new];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"通知设置")]) {
            VC = [WARMessageSettingViewController new];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"隐私")]) {
            VC = [WARPrivateSettingsViewController new];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"通用")]) {
            VC = [WARCommonViewController new];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"意见反馈")]) {
            VC = [WARFeedbackViewController new];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"版本介绍")]) {
            VC = [WARVersionIntroduceController new];
        }
        [self.navigationController pushViewController:VC animated:YES];
    } 
}

#pragma mark - Private

- (void)logOut {
    //去除绑定
    [MBProgressHUD showLoad];
    [self.dataManager logoutWithSuccess:^(id successData) {
        [MBProgressHUD hideHUD];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:userLogoutSuccessNotification object:nil];
    } failed:^(id failedData) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"error")];
    }];
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = BackgroundDefaultColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:@"WARSettingsCell"];
        [_tableView registerClass:[WARDeleteUserCell class] forCellReuseIdentifier:@"WARDeleteUserCell"];
        
    }
    return _tableView;
}

@end
