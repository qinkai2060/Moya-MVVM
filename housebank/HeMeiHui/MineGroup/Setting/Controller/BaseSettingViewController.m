//
//  BaseSettingViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface BaseSettingViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    self.lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lButton setImage:[UIImage imageNamed:@"HMH_back_light"] forState:UIControlStateNormal];
    self.lButton.frame = CGRectMake(0, 0, 44, 44);
    self.lButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [self.lButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.lButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rButton setImage:[UIImage imageNamed:@"icon_orderMore"] forState:UIControlStateNormal];
    self.rButton.frame = CGRectMake(0, 0, 44, 44);
    [self.rButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.rButton.hidden = YES;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rButton];
    self.view.backgroundColor = HEXCOLOR(0xF5F5F5);
    
    self.navigationItem.rightBarButtonItem = rightItem;
    

    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if(self.navigationController.viewControllers.count > 1) {
        
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = color;
        }
}


- (void)rightBarButtonItemAction{
    
    
}
- (void)downLoad
{
    self.loading = [[MBProgressHUD alloc] initWithView:[self lastWindow]];
    [[self lastWindow] addSubview:self.loading];
    [self.loading show:YES];
}
- (UIWindow *)lastWindow
{
    return [UIApplication sharedApplication].keyWindow;
}
- (void)leftBarButtonItemAction{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showSVProgressHUDSuccessWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}
@end
