//
//  NSObject+VC.h
//  WeChatFloat
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSObject (VC)
- (UIViewController *)war_currentViewController;
- (UITabBarController *)war_currentTabBarController;
- (UINavigationController *)war_currentNavigationController;
@end
