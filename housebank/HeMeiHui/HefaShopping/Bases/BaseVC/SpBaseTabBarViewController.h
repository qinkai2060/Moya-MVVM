//
//  BaseTabBarViewController.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHPopAppointViewController.h"
@interface SpBaseTabBarViewController : UITabBarController
@property (nonatomic, strong) HMHPopAppointViewController *HMH_loginVC;
// 单纯的判断是否登录
- (BOOL)isJudgeLogin;
// 判断是否登录 如果没有登录 就跳登录页面
- (BOOL)isLogin;
// 直接跳登录页面
- (void)gotoLogin;
@end
