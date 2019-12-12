//
//  WARChangePhoneNumViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/28.
//

#import "WARChangePhoneNumViewController.h"
#import "WARChangePhoneNumCell.h"
#import "WARSettingDataManager.h"
#import "WARMacros.h"
#import "NSString+RegexCategory.h"
#import "UIButton+CountDown.h"
#import "MBProgressHUD+WARExtension.h"

@interface WARChangePhoneNumViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARSettingDataManager *dataManager;

@end

@implementation WARChangePhoneNumViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WARLocalizedString(@"修改手机号");
    
    [self.view addSubview:self.tableView];
    
    self.dataManager = [[WARSettingDataManager alloc] init];
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
    [button setTitle:WARLocalizedString(@"确认修改") forState:UIControlStateNormal];
    [button.titleLabel setFont:kFont(17)];
    [button setTintColor:UIColorWhite];
    [button addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:button];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.view.frame.size.height - 44 * 2 - 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARChangePhoneNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARChangePhoneNumCell"];
    if (indexPath.row == 0) {
        cell.cellTitleLabel.text = @"+86";
        cell.textField.placeholder = WARLocalizedString(@"请输入需绑定的手机号");
    }
    else if (indexPath.row == 1) {
        cell.cellTitleLabel.text = @"验证码";
        cell.textField.placeholder = WARLocalizedString(@"请输入验证码");
        [cell.rightButton setTitle:WARLocalizedString(@"获取验证码") forState:UIControlStateNormal];
        WS(weakSelf);
        cell.rightButtonBlock = ^ {
            [weakSelf clickRightButtonAction];
        };
    }
    return cell;
}

#pragma mark - Private

- (void)clickRightButtonAction {
    WARChangePhoneNumCell *phoneNumberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WARChangePhoneNumCell *codeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *phoneNumber = phoneNumberCell.textField.text;
    if (![phoneNumber isMobileNumber]) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"请输入正确的手机号")];
        return;
    }
    
    [self.dataManager getCodeForChangePhone:phoneNumber success:^(id successData) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"发送成功")];
        [codeCell.rightButton startTime:59 title:WARLocalizedString(@"重新获取")  titleColor:ThemeColor waitTittle:WARLocalizedString(@"s可重发") waitColor:[UIColor grayColor]];
    } failed:^(id failedData) {
        NSInteger status = [[failedData objectForKey:@"state"] integerValue];
        if (AccountSettingPhoneSameAsOrigin == status) {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"新手机号和原手机号相同")];
        }
    }];
}

- (void)clickButtonAction {
    WARChangePhoneNumCell *phoneNumberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WARChangePhoneNumCell *codeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [phoneNumberCell.textField resignFirstResponder];
    [codeCell.textField resignFirstResponder];
    
    NSString *phoneNumber = phoneNumberCell.textField.text;
    NSString *code = codeCell.textField.text;
    
    if (![phoneNumber isMobileNumber] || phoneNumber.length == 0) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"手机号码不正确")];
        return;
    }
    
    if (!code.length || 0 == code.length) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"验证码不能为空")];
        return;
    }
    
    [self.dataManager changePhoneNumber:phoneNumber code:code success:^(id successData) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"修改成功，请重新登录")];
        
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:showLoginViewNotification object:nil];
        });
    } failed:^(id failedData) {
        if (failedData) {
            NSInteger status = [[failedData objectForKey:@"state"] integerValue];
            if(status == AccountSettingCodeError) {
                [MBProgressHUD showAutoMessage:WARLocalizedString(@"验证码错误")];
            }else if (status == AccountSettingPhoneAlreadyExist) {
                [MBProgressHUD showAutoMessage:WARLocalizedString(@"新的手机号已经存在")];
            }
        }else {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"返回值错误")];
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
        [_tableView registerClass:[WARChangePhoneNumCell class] forCellReuseIdentifier:@"WARChangePhoneNumCell"];
    }
    return _tableView;
}

@end
