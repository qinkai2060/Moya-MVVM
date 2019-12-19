//
//  HFLoginViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLoginViewController.h"
#import "HFLoginViewModel.h"
#import "HFLoginView.h"
#import "BaseNavgationViewController.h"
#import "HFRegsiterViewController.h"
#import "HFFindPassWordViewController.h"
#import "HFCountryViewController.h"
#import "HFLoginRegModel.h"
#import "HFAlertView.h"
#import "ResetLoginPasswodViewController.h"
#import "HFLoginH5WebViewController.h"
#import "WRNavigationBar.h"

@interface HFLoginViewController ()
@property(nonatomic,strong)HFLoginView *loginView;
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@end

@implementation HFLoginViewController

- (void)hh_addSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:self.loginView];
}

- (void)hh_layoutNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_close"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(goRegClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     self.navigationController.navigationBar.translucent = NO;
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.findPassWordSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFFindPassWordViewController *vc = [[HFFindPassWordViewController alloc] initWithViewModel:self.viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.openCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFCountryViewController *vc = [[HFCountryViewController alloc] initWithViewModel:self.viewModel];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    [self.viewModel.passWordLoginSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        [SVProgressHUD dismiss];
        if ([x isKindOfClass:[HFLoginRegModel class]]) {
            HFLoginRegModel *logRegModel = (HFLoginRegModel*)x;
            if (logRegModel.state != 1) {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }else {
                [MBProgressHUD showTipMessageInWindow:@"登录成功" timer:1];
                [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.userName forKey:USERNAME];
                 [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.countryCode forKey:@"loginAreacode"];
                [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.countryStr forKey:@"codeValue"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                if ([[HFUntilTool judgePasswordStrength:self.viewModel.passWord] isEqualToString:@"0"]) {
                    [HFAlertView showAlertViewType:HFAlertViewTypeNone title:@"你的密码口令太弱了\n强烈建议您更换" detailString:@"" cancelTitle:@"继续使用" cancelBlock:^(HFAlertView *view){
                        [HFUserDataTools login:[HFUserDataTools loginData:logRegModel.data]];

                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginout_refrensh" object:nil];


                        if ([self.delegate respondsToSelector:@selector(loginViewController:loginFinsh:)]) {
                            [self.delegate loginViewController:self loginFinsh:logRegModel.data];
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } sureTitle:@"去修改" sureBlock:^(HFAlertView *view){
                        ResetLoginPasswodViewController *vc = [[ResetLoginPasswodViewController alloc] init];
                        vc.ntitle = @"修改登录密码";
                        vc.sid = CHECK_STRING([logRegModel.data valueForKey:@"sid"]);
                        vc.successBlock = ^{
                            [self.loginView editingEndSuccess];
                        };

                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                }else {
                    // 存值
                   
                    [HFUserDataTools login:[HFUserDataTools loginData:logRegModel.data]];
                    if ([self.delegate respondsToSelector:@selector(loginViewController:loginFinsh:)]) {
                        [self.delegate loginViewController:self loginFinsh:logRegModel.data];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginout_refrensh" object:nil];

                    [self dismissViewControllerAnimated:YES completion:nil];
                }
               
            }
        }
        
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD showAutoMessage:@"请求失败"];
    }];
    [self.viewModel.quickLoginSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if ([x isKindOfClass:[HFLoginRegModel class]]) {
            HFLoginRegModel *logRegModel = (HFLoginRegModel*)x;
            if (logRegModel.state != 1) {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }else {
                [MBProgressHUD showTipMessageInWindow:@"登录成功" timer:1];
                [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.userName forKey:USERNAME];
                 [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.countryCode forKey:@"loginAreacode"];
                  [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.countryStr forKey:@"codeValue"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                    // 存值
                    [HFUserDataTools login:[HFUserDataTools loginData:logRegModel.data]];
                    if ([self.delegate respondsToSelector:@selector(loginViewController:loginFinsh:)]) {
                        [self.delegate loginViewController:self loginFinsh:logRegModel.data];
                    }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginout_refrensh" object:nil];

                    [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD showAutoMessage:@"请求失败"];
    }];
    [self.viewModel.privacySubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/html/common/privicy-policies.html?hideTitle=1",fyMainHomeUrl];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.memberSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/html/common/agreement-app2.html?hideTitle=1",fyMainHomeUrl];
//        vc.url = [NSString stringWithFormat:@"%@/html/home/#/pageDecorated/home?specialId=2&bkcolor=",fyMainHomeUrl];
        vc.view.backgroundColor = [UIColor whiteColor];//
        [self.navigationController pushViewController:vc animated:YES];
    }];

}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(closeController)]) {
            [self.delegate closeController];
        }
    }];
}
- (void)goRegClick {
    HFRegsiterViewController *regVC = [[HFRegsiterViewController alloc] initWithViewModel:self.viewModel];
    [self.navigationController pushViewController:regVC animated:YES];
}
+ (void)showViewController:(UIViewController*)viewcontroller {
    HFLoginViewController *vc  = [[HFLoginViewController alloc] init];
    vc.delegate = viewcontroller;
    BaseNavgationViewController *nav = [[BaseNavgationViewController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewcontroller presentViewController:nav animated:YES completion:^{
        
    }];
}
- (HFLoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFLoginViewModel alloc] init];
        
    }
    return _viewModel;
}
- (HFLoginView *)loginView {
    if (!_loginView) {
        CGFloat navH = IS_iPhoneX ? (64+24):64;
        _loginView = [[HFLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) WithViewModel:self.viewModel];
    }
    return _loginView;
}
@end
