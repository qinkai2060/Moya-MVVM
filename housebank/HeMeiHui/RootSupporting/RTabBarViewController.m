//
//  RTabBarViewController.m
//  HeMeiHui
//
//  Created by 任为 on 2017/11/1.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "RTabBarViewController.h"
#import "RootViewController.h"
#import "HMHViewController.h"

@interface RTabBarViewController ()

@end

@implementation RTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HMHViewController*VC = [[HMHViewController alloc]init];
    RootViewController *rootViewController = [[RootViewController alloc]initWithRootViewController:VC];
    self.viewControllers = @[rootViewController];
    self.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
