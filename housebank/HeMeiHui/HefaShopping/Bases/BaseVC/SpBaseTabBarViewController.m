//
//  BaseTabBarViewController.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "SpBaseTabBarViewController.h"

@interface SpBaseTabBarViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SpBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 单纯的判断是否登录
- (BOOL)isJudgeLogin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    if (sidStr.length > 6 && ![sidStr isEqualToString:@"(null)"]) { //已经登录
        return YES;
    }
    return NO;
}

#pragma mark 判断是否登录 如果没有登录 就跳登录页面
- (BOOL)isLogin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    if (sidStr.length > 6 && ![sidStr isEqualToString:@"(null)"]) { //已经登录
        return YES;
    }
    [self gotoLogin];
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)gotoLogin{
    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if (tools.pageUrlConfigArrary.count) {
        
        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
            
            if([model.pageTag isEqualToString:@"fy_login"]) {
                _HMH_loginVC = [[HMHPopAppointViewController alloc]init];
                _HMH_loginVC.urlStr = model.url;
                _HMH_loginVC.isNavigationBarshow = NO;
                _HMH_loginVC.hidesBottomBarWhenPushed = YES;
                //                __weak  typeof (self)weakSelf = self;
                //                                _loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
                //                    weakSelf.sidStr = sidStr;
                //                                };
                
                [self.navigationController pushViewController:_HMH_loginVC animated:YES];
                
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
