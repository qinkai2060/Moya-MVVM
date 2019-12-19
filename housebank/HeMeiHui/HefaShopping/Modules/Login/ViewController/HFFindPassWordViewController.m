//
//  HFFindPassWordViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFindPassWordViewController.h"
#import "HFFindPassWordView.h"
#import "HFLoginViewModel.h"
#import "HFCountryViewController.h"
#import "HFLoginRegModel.h"
#import "HFLoginH5WebViewController.h"
#import "WRNavigationBar.h"
@interface HFFindPassWordViewController ()

@property(nonatomic,strong)HFFindPassWordView *findPwdView;
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@end

@implementation HFFindPassWordViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.findPwdView];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.openCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFCountryViewController *vc = [[HFCountryViewController alloc] initWithViewModel:self.viewModel];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [self.viewModel.findsendCodeSubject subscribeNext:^(id  _Nullable x) {
        
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
    [self.viewModel.findSubject subscribeNext:^(id  _Nullable x) {
        if (![x isKindOfClass:[NSString class]] && ![[NSString stringWithFormat:@"%@",x] isEqualToString:@"成功"]) {
            [MBProgressHUD showAutoMessage:@"请求失败"];
        }else {
            [MBProgressHUD showAutoMessage:@"找回成功"];
            [self.viewModel.findSuccessPhoneSubject sendNext:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD showAutoMessage:@"请求失败"];
    }];
    [self.viewModel.findprivacySubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/html/common/privicy-policies.html?hideTitle=1",fyMainHomeUrl];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.findmemberSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/html/common/agreement-app2.html?hideTitle=1",fyMainHomeUrl];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];

}
- (HFFindPassWordView *)findPwdView {
    if (!_findPwdView) {
        CGFloat navH = IS_iPhoneX ? (64+24):64;
        _findPwdView = [[HFFindPassWordView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) WithViewModel:self.viewModel];
    }
    return _findPwdView;
}

@end
