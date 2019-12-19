//
//  MainGlobalHomeViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/21.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "MainGlobalHomeViewController.h"

@interface MainGlobalHomeViewController ()

@end

@implementation MainGlobalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}


@end
