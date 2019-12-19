//
//  HMHVideoMoreDetailInfoViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/21.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoMoreDetailInfoViewController.h"

@interface HMHVideoMoreDetailInfoViewController ()

@end

@implementation HMHVideoMoreDetailInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.player pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
