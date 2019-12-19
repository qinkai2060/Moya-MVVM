//
//  HMHMessageViewController.m
//  housebank
//
//  Created by Qianhong Li on 2017/9/25.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHMessageViewController.h"

@interface HMHMessageViewController ()

@end

@implementation HMHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
