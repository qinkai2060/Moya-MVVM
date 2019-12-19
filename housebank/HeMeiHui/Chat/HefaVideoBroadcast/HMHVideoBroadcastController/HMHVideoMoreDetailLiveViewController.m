//
//  HMHVideoMoreDetailLiveViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/22.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoMoreDetailLiveViewController.h"

@interface HMHVideoMoreDetailLiveViewController ()

@end

@implementation HMHVideoMoreDetailLiveViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.vodPlayer stop];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
