//
//  WARChangePasswordNewViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/28.
//

#import "WARChangePasswordNewViewController.h"
#import "WARSettingDataManager.h"
#import "WARSettingsCell.h"
#import "WARSettingInputCell.h"
#import "MBProgressHUD+WARExtension.h"

@interface WARChangePasswordNewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARSettingDataManager *dataManager;

@property (nonatomic, copy) NSString *bindString;

@end

@implementation WARChangePasswordNewViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WARLocalizedString(@"修改密码");
    
    [self.view addSubview:self.tableView];
    
    self.dataManager = [[WARSettingDataManager alloc] init];
    
    NSString *phoneNumber = self.dataManager.userInfo.phoneNum;
    NSString *prefixString = @"";
    NSString *suffixString = @"";
    if (phoneNumber.length > 3) {
        prefixString = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
    }
    
    NSInteger suffixLocal = phoneNumber.length - 4;
    if (suffixLocal > 0 ) {
        suffixString = [phoneNumber substringFromIndex:suffixLocal];
    }
    self.bindString = [NSString stringWithFormat:@"已绑定手机：%@",[NSString stringWithFormat:@"%@****%@",prefixString,suffixString]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.frame;
}

#pragma mark - Event Response

#pragma mark - Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = BackgroundDefaultColor;
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = BackgroundDefaultColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 27, kScreenWidth - 30, 44);
    button.backgroundColor = ThemeColor;
    button.layer.cornerRadius = 5;
    [button setTitle:WARLocalizedString(@"确定") forState:UIControlStateNormal];
    [button.titleLabel setFont:kFont(17)];
    [button setTintColor:UIColorWhite];
    [button addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:button];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.view.frame.size.height - 44 * 4 - 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        cell.descriptionText = self.bindString;
        return cell;
    }
    else {
        WARSettingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingInputCell"];
        cell.inputTextFeild.secureTextEntry = YES;
        if (1 == indexPath.row) {
            cell.inputTextFeild.placeholder = WARLocalizedString(@"请输入原密码");
        }else if (2 == indexPath.row) {
            cell.inputTextFeild.placeholder = WARLocalizedString(@"请输入6-16位新密码");
        }else if (3 == indexPath.row) {
            cell.inputTextFeild.placeholder = WARLocalizedString(@"请再次输入确认密码");
        }
        return cell;
    }
}

#pragma mark - Private

-(void)clickButtonAction {
    WARSettingInputCell *oldPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    WARSettingInputCell *newPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    WARSettingInputCell *confirmPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [oldPasswordCell.inputTextFeild resignFirstResponder];
    [newPasswordCell.inputTextFeild resignFirstResponder];
    [confirmPasswordCell.inputTextFeild resignFirstResponder];
    
    
    NSString *newPassword = newPasswordCell.inputTextFeild.text;
    NSString *oldPassword = oldPasswordCell.inputTextFeild.text;
    NSString *confirmPassword = confirmPasswordCell.inputTextFeild.text;
    
    if (!oldPassword || oldPassword.length == 0) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"请输入原密码")];
        return;
    }
    
    if (!newPassword || newPassword.length == 0) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"请输入新密码")];
        return;
    }
    
    if (!confirmPassword || confirmPassword.length == 0) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"请输入确认密码")];
        return;
    }
    
    if (newPassword.length < 6 || newPassword.length > 16) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"请设置6-16位新密码")];
        return;
    }
    
    if (![newPassword isEqualToString:confirmPassword]) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"确认新密码错误")];
        return;
    }
    
    [self.dataManager changePasswordByOldPassword:oldPassword newPassword:newPassword success:^(id successData) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"修改成功，请重新登录")];
        
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:showLoginViewNotification object:nil];
        });
        
    } failed:^(id failedData) {
        NSInteger status = [[failedData objectForKey:@"state"] integerValue];
        if (AccountSettingOldPasswordError == status) {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"原密码错误")];
        }
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
        [_tableView registerClass:[WARSettingInputCell class] forCellReuseIdentifier:@"WARSettingInputCell"];
    }
    return _tableView;
}

@end
