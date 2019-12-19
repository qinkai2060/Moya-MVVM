//
//  HFRegsiterViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFRegsiterViewController.h"
#import "HFNewRegsiterView.h"
#import "HFLoginViewModel.h"
#import "HFLoginRegModel.h"
#import "HFCountryViewController.h"
#import "HFLoginH5WebViewController.h"
#import "WRNavigationBar.h"
#import "HFUserLoginAlertView.h"
#import "HFIMMessageController.h"
#import "HFAlertViewController.h"
@interface HFRegsiterViewController ()
@property(nonatomic,strong)HFNewRegsiterView *regView;
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@end

@implementation HFRegsiterViewController
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFLoginViewModel*)viewModel;
    if (self = [super initWithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_layoutNavigation {
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)hh_addSubviews {
        [HFUserLoginAlertView showAlertViewType:HFUserLoginAlertViewTypeRegsiterProtocol title:@"注册协议及隐私政策" contextTX:[NSString stringWithFormat:@"%@/html/common/agreement-app2.html?hideTitle=1",fyMainHomeUrl] bottomTX:@"点击同意即表示那您已阅读并同意《合美惠用户注册协议》与《合美惠隐私政策》并将您的订单信息共享给为您完成此订单所必须的第三方合作方。" bottomRangeList:@[@"《合美惠用户注册协议》",@"《合美惠隐私政策》"] cancelTitle:@"不同意" cancelBlock:^(HFUserLoginAlertView *view) {
            [self.navigationController popViewControllerAnimated:YES];
        } sureTitle:@"同意" sureBlock:^(HFUserLoginAlertView *view) {
            [self.regView agreePrivateProtocol];
        } didTextView:^(NSString *string) {
            if ([string isEqualToString:@"clickRegProtocol"]) {
         
                HFAlertViewController *vc = [[HFAlertViewController alloc] init];
                vc.url = [NSString stringWithFormat:@"%@/html/common/agreement-app2.html?hideTitle=1",fyMainHomeUrl];
                vc.titleStr = @"合美惠用户注册协议";
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:vc animated:YES completion:nil];
            }else if([string isEqualToString:@"clickPrivate"]){
                HFAlertViewController *vc = [[HFAlertViewController alloc] init];
                vc.url = [NSString stringWithFormat:@"%@/html/common/privicy-policies.html?hideTitle=1",fyMainHomeUrl];
                vc.titleStr = @"合美惠隐私政策";
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:vc animated:YES completion:nil];
            }else {
                HFAlertViewController *vc = [[HFAlertViewController alloc] init];
                vc.url = [NSString stringWithFormat:@"%@/html/common/agreement-app2.html?hideTitle=1",fyMainHomeUrl];
                vc.titleStr = @"订单共享与安全";
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:vc animated:YES completion:nil];
            }
            NSLog(@"");
        }];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.regView];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.passWordLoginSubject subscribeNext:^(id  _Nullable x) {
 
        if ([x isKindOfClass:[HFLoginRegModel class]]) {
            HFLoginRegModel *logRegModel = (HFLoginRegModel*)x;
            if (logRegModel.state != 1) {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }else {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }
        }
        
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD showAutoMessage:@"请求失败"];
    }];
    [self.viewModel.regsendCodeSubject subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[HFLoginRegModel class]]) {
            HFLoginRegModel *logRegModel = (HFLoginRegModel*)x;
            if (logRegModel.state != 1) {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }else {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }
        }
        
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD showAutoMessage:@"请求失败"];
    }];
    [self.viewModel.regSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFLoginRegModel class]]) {
            HFLoginRegModel *logRegModel = (HFLoginRegModel*)x;
            if (logRegModel.state != 1) {
                [MBProgressHUD showAutoMessage:logRegModel.msg];
            }else {
                [MBProgressHUD showTipMessageInWindow:@"注册成功" timer:1];
                [self.viewModel.regSuccessPassWordSubject sendNext:self.viewModel.regPassWord];
                [self.viewModel.regSuccessPhoneSubject sendNext:self.viewModel.regPhone];
                [MBProgressHUD showAutoMessage:logRegModel.msg];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD showAutoMessage:@"请求失败"];
    }];
    [self.viewModel.openCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFCountryViewController *vc = [[HFCountryViewController alloc] initWithViewModel:self.viewModel];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [self.viewModel.regprivacySubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/html/common/privicy-policies.html?hideTitle=1",fyMainHomeUrl];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.regmemberSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/html/common/agreement-app2.html?hideTitle=1",fyMainHomeUrl];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (HFNewRegsiterView *)regView {
    if (!_regView) {
        CGFloat navH = IS_iPhoneX ? (64+24):64;
        _regView = [[HFNewRegsiterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) WithViewModel:self.viewModel];
    }
    return _regView;
}

@end
