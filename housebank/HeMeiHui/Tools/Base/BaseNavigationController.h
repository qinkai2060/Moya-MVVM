//
//  BaseNavigationController.h
//  MCF2
//
//  Created by Qianhong Li on 15/6/3.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseNavigationController : UINavigationController<UIGestureRecognizerDelegate>

//@property(nonatomic) int colorType;  //不同模块进去，是不同的色系

- (void)deleteCurrentContrllerPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewControllerAndBackRootController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewControllerWithFromController:(UIViewController *)fVC toController:(UIViewController *)tVC animated:(BOOL)animated;

//- (void)changeBackgroundColor:(UIColor *)color;

@end
