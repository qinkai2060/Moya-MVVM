//
//  NSObject+VC.m
//  WeChatFloat
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import "NSObject+VC.h"

@implementation NSObject (VC)

- (UIViewController *)war_currentViewController {
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1){
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else{
            break;
        }
    }
    return vc;
}

- (UINavigationController *)war_currentNavigationController {
    return [self war_currentViewController].navigationController;
}

- (UITabBarController *)war_currentTabBarController {
    return [self war_currentViewController].tabBarController;
}

@end
