//
//  NSObject+MP.m
//  MobileProject
//
//  Created by wujunyang on 16/7/9.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MBProgressHUD+WARExtension.h"
//#import "WARLocalizedHelper.h"
//#import "WARPopOverMenu.h"

#define CHINESE_MBProgressHUD_SYSTEM(x) [UIFont fontWithName:@"Heiti SC" size:x]

@implementation MBProgressHUD (MP)

#pragma mark - 显示成功/错误/信息/警告

+ (void)showSuccessMessage:(NSString *)message {
    [self showCustomIcon:@"MBHUD_Success" Title:message ToView:nil];
}

+ (void)showErrorMessage:(NSString *)message {
    [self showCustomIcon:@"MBHUD_Error" Title:message ToView:nil];
}

+ (void)showInfoMessage:(NSString *)message {
    [self showCustomIcon:@"MBHUD_Info" Title:message ToView:nil];
}

+ (void)showWarnMessage:(NSString *)message {
    [self showCustomIcon:@"MBHUD_Warn" Title:message ToView:nil];
}

+ (void)showErrorMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIcon:@"MBHUD_Error" Title:message ToView:view];
}

+ (void)showSuccessMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIcon:@"MBHUD_Success" Title:message ToView:view];
}

+ (void)showInfoMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIcon:@"MBHUD_Info" Title:message ToView:view];
}

+ (void)showWarnMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIcon:@"MBHUD_Warn" Title:message ToView:view];
}

#pragma mark - ActivityMessage
+ (void)showActivityMessageInWindow:(NSString*)message {
    [self showActivityMessage:message ToView:nil timer:1];
}

+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer {
    [self showActivityMessage:message ToView:nil timer:aTimer];
}

+ (void)showActivityMessageInView:(NSString*)message {
    [self showActivityMessage:message ToView:[self getCurrentUIVC].view timer:1];
}

+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer {
    [self showActivityMessage:message ToView:[self getCurrentUIVC].view timer:aTimer];
}

+ (void)showLoad {
    [self showActivityMessageInWindow:@"加载中..." timer:99];
}

#pragma mark - TipMessage
+ (void)showMessageToWindow:(NSString *)message {
    [self showTipMessageInWindow:message timer:99];
}

+ (void)showTipMessageInWindow:(NSString*)message {
    [self showTipMessage:message ToView:nil timer:1];
}

+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer {
    [self showTipMessage:message ToView:nil timer:aTimer];
}

+ (void)showTipMessageInView:(NSString*)message {
    [self showTipMessage:message ToView:[self getCurrentUIVC].view timer:1];
}

+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer {
    [self showTipMessage:message ToView:[self getCurrentUIVC].view timer:aTimer];
}

//快速显示一条提示信息
+ (void)showAutoMessage:(NSString *)message {
    [self showTipMessage:message ToView:nil timer:1];
}
+ (void)showActiveMessage:(NSString *)message view:(UIView*)view timer:(int)aTimer{
    MBProgressHUD *hud  =  [self createMBProgressHUDViewWithMessage:message ToView:view Mode:MBProgressHUDModeIndeterminate];
    if (aTimer > 0 && aTimer < 50) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}
#pragma mark - Private
+ (void)showTipMessage:(NSString*)message ToView:(UIView *)view timer:(int)aTimer
{
    if(!message.length) return;
    MBProgressHUD *hud = [self createMBProgressHUDViewWithMessage:message ToView:view Mode:MBProgressHUDModeText];
    if (aTimer > 0 && aTimer < 50) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}

+ (void)initialize {
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
}

+ (void)showActivityMessage:(NSString*)message ToView:(UIView *)view timer:(int)aTimer
{
    if(!message.length) return;
    MBProgressHUD *hud  =  [self createMBProgressHUDViewWithMessage:message ToView:view Mode:MBProgressHUDModeIndeterminate];
    if (aTimer > 0 && aTimer < 50) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}
    
+ (void)showActivityInWindowWithoutWordTimer:(int)aTimer{
    MBProgressHUD *hud  =  [self createMBProgressHUDViewWithMessage:nil ToView:nil Mode:MBProgressHUDModeIndeterminate];
    if (aTimer > 0 && aTimer < 50) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}

+ (void)showCustomIconImage:(UIImage *)iconImage Title:(NSString *)title ToView:(UIView *)view {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [self createMBProgressHUDViewWithMessage:title ToView:view Mode:MBProgressHUDModeCustomView];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:iconImage];
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}

+ (MBProgressHUD *)createMBProgressHUDViewWithMessage:(NSString*)message ToView:(UIView *)view Mode:(MBProgressHUDMode)mode
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = mode;
    
    hud.label.text = message;
    hud.label.font = CHINESE_MBProgressHUD_SYSTEM(15);
    hud.label.numberOfLines = 0;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    hud.contentColor = [UIColor whiteColor];
    
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
    [self hideHUDForView:[self getCurrentUIVC].view animated:YES];
}

#pragma mark - 辅助
//获取当前屏幕显示的viewcontroller
+(UIViewController *)getCurrentWindowVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    return  result;
}

+(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [[self class]  getCurrentWindowVC ];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end
