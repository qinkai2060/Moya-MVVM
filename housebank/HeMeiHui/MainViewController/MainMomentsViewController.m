//
//  MainMomentsViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/21.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "MainMomentsViewController.h"

@interface MainMomentsViewController ()

@end

@implementation MainMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
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
