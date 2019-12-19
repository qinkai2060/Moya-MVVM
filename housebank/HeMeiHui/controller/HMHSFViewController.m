//
//  SFViewController.m
//  HeMeiHui
//
//  Created by 任为 on 2016/12/19.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "HMHSFViewController.h"


@interface HMHSFViewController ()
{

    AppDelegate *app;

}
@end

@implementation HMHSFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app =(AppDelegate*) [UIApplication sharedApplication].delegate;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    app.isFull = YES;
    

}
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    app.isFull = NO;

}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return  UIInterfaceOrientationMaskAllButUpsideDown;

}
- (BOOL)shouldAutorotate{
    
    return YES;

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
@end
