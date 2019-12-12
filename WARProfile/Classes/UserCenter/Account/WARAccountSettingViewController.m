//
//  WARAccountSettingViewController.m
//  Pods
//
//  Created by huange on 2017/8/4.
//
//

#import "WARAccountSettingViewController.h"

//#import "WARChangePhoneNumberViewController.h"
//#import "WARChangePasswordViewController.h"
#import "WARChangePhoneNumViewController.h"
#import "WARChangePasswordNewViewController.h"

#import "WARAlertView.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, AccountCellIndex) {
    AccountChangePhoneNumberCellIndex = 0,
    AccountChangeChangePasswordCellIndex = 1,
} ;

@interface WARAccountSettingViewController ()

@end

@implementation WARAccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WARLocalizedString(@"账号安全");
}

- (void)initData {
    [super initData];
    
    self.settinsItemArray = [NSMutableArray new];

    for (int i = 0; i < 2; i++) {
        WARSettingCellItem *item = [WARSettingCellItem new];
        
        switch (i) {
            case 0:{
                item.titleString =  WARLocalizedString(@"修改手机号");
            }
                break;
            case 1:{
                item.titleString =  WARLocalizedString(@"修改密码");
            }
                break;
            default:
                break;
        }
        
        [self.settinsItemArray addObject:item];
    }
}

#pragma mark - init UI
- (void)initUI {
    [super initUI];
    self.tableView.rowHeight = commonCellHeight;
}

#pragma mark - tableView delegete
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCellID"];
    if (!cell) {
        cell = [[WARSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCellID"];
    }
    WARSettingCellItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
    
    cell.showAccessoryView = YES;
    cell.descriptionText = item.titleString;
    if (AccountChangePhoneNumberCellIndex == indexPath.row) {
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
        
        
        cell.rightText = [NSString stringWithFormat:@"%@****%@",prefixString,suffixString];
        cell.rightTextColor = DisabledTextColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (AccountChangePhoneNumberCellIndex == indexPath.row) {
        [self inputPassword];
    }else {
        WARChangePasswordNewViewController *changePasswordVC = [[WARChangePasswordNewViewController alloc] init];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }
}

- (void)inputPassword {
    // WARChangePhoneNumberViewController.h

    @weakify(self);
//    [[[WARAlertView alloc] initWithTextFieldsAndTitle:WARLocalizedString(@"修改绑定手机")
//                                              message:nil
//                                   numberOfTextFields:1
//                                          placeholder:WARLocalizedString(@"输入你的密码")
//                               textFieldsSetupHandler:^(UITextField * _Nonnull textField, NSUInteger index) {
//                                                  textField.secureTextEntry = YES;
//                                              }
//                                         buttonTitles:@[@"确定"] cancelButtonTitle:WARLocalizedString(@"取消")destructiveButtonTitle:nil
//                                        actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
//                                            @strongify(self);
//                                            UITextField *texField = [[alertView textFieldsArray] objectAtIndex:index];
//                                            NSString *password = texField.text;
//                                            
//                                            [self confirmPassword:password];
//                                        }
//                                        cancelHandler:^(LGAlertView * _Nonnull alertView) {}
//                                   destructiveHandler:^(LGAlertView * _Nonnull alertView) {}]
//     showAnimated:YES
//     completionHandler:nil];
}


- (void)confirmPassword:(NSString *)password {
    
    if (!password || password.length == 0) {
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"请输入正确的密码")];
        return;
    }
    
    [MBProgressHUD showLoad];
    [self.dataManager confirmPassword:password successBlock:^(id successData) {
        [MBProgressHUD hideHUD];
        
        WARChangePhoneNumViewController *changePhoneNumber = [[WARChangePhoneNumViewController alloc] init];
        [self.navigationController pushViewController:changePhoneNumber animated:YES];
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"密码错误")];
    }];
    
    
//    WARChangePhoneNumberViewController *changePhoneNumber = [[WARChangePhoneNumberViewController alloc] init];
//    [self.navigationController pushViewController:changePhoneNumber animated:YES];
}

@end
