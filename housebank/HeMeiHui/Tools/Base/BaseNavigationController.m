//
//  BaseNavigationController.m
//  MCF2
//
//  Created by Qianhong Li on 15/6/3.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //[self changeBackgroundColor:RGBACOLOR(255, 97, 5, 1.0)];
//        [self changeBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

- (void)deleteCurrentContrllerPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self popViewControllerAnimated:NO];
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewControllerAndBackRootController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self popToRootViewControllerAnimated:NO];
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewControllerWithFromController:(UIViewController *)fVC toController:(UIViewController *)tVC animated:(BOOL)animated
{
    [self popToViewController:fVC animated:NO];
    [self pushViewController:tVC animated:animated];
}


//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//右滑返回上一页面
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        //self.interactivePopGestureRecognizer.delegate = self;  //添加右滑返回
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
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
