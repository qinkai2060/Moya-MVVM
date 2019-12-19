//
//  UIViewController+YS.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "UIViewController+YS.h"

@implementation UIViewController (YS)
+ (UIViewController *)visibleViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [UIViewController getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom: (UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)viewController;
        return [UIViewController getVisibleViewControllerFrom:tabController.selectedViewController];
    }
    else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)viewController;
        return [UIViewController getVisibleViewControllerFrom:navController.visibleViewController];
    }
    if (viewController.presentedViewController) {
        UIViewController *presentedController = viewController.presentedViewController;
        return [UIViewController getVisibleViewControllerFrom: presentedController];
    }
    return viewController;
}
@end
