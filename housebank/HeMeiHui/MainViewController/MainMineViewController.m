//
//  MainMineViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/21.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "MainMineViewController.h"

@interface MainMineViewController ()
@property(nonatomic,assign)BOOL isShouldLoad;
@end

@implementation MainMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *sid=  [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    if (sid.length>3) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mainUrlStr]]];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    NSString *sid=  [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    if (!self.isShouldLoad&&sid.length>3) {
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mainUrlStr]]];
        self.isShouldLoad = YES;
    }
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
