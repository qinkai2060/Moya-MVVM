//
//  HFProgressHUD.m
//  Pods
//
//  Created by usermac on 2019/1/16.
//
//

#import "HFProgressHUD.h"
//#import "UIImage+WARBundleImage.h"

@implementation HFProgressHUD
+ (void)showSuccessMessage:(NSString *)message {
    [self showCustomIconName:@"MBHUD_Success" Title:message ToView:nil];
}

+ (void)showErrorMessage:(NSString *)message {
    [self showCustomIconName:@"MBHUD_Error" Title:message ToView:nil];
}

+ (void)showInfoMessage:(NSString *)message {
    [self showCustomIconName:@"MBHUD_Info" Title:message ToView:nil];
}

+ (void)showWarnMessage:(NSString *)message {
    [self showCustomIconName:@"MBHUD_Warn" Title:message ToView:nil];
}

+ (void)showErrorMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIconName:@"MBHUD_Error" Title:message ToView:nil];
}

+ (void)showSuccessMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIconName:@"MBHUD_Success" Title:message ToView:nil];
}

+ (void)showInfoMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIconName:@"MBHUD_Info" Title:message ToView:nil];
}

+ (void)showWarnMessage:(NSString *)message ToView:(UIView *)view {
    [self showCustomIconName:@"MBHUD_Warn" Title:message ToView:nil];
}


// -------------TipMessage----------------
+ (void)showTipMessageInWindow:(NSString*)message {
    [MBProgressHUD showTipMessageInWindow:message];
}
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer {
    [MBProgressHUD showTipMessageInWindow:message timer:aTimer];
}

+ (void)showTipMessageInView:(NSString*)message {
    [MBProgressHUD showTipMessageInView:message];

}

+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer {
    [MBProgressHUD showTipMessageInView:message timer:aTimer];

}

/**
 * TipMessage不自动消失
 */
+ (void)showMessageToWindow:(NSString *)message {
    [MBProgressHUD showMessageToWindow:message];
}

/**
 * TipMessage自动消失
 */
+ (void)showAutoMessage:(NSString *)message {
    [MBProgressHUD showAutoMessage:message];
}

// -------------ActivityMessage---------------
+ (void)showActivityMessageInWindow:(NSString*)message {
    [MBProgressHUD showActivityMessageInWindow:message];
}

+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer {
    [MBProgressHUD showActivityMessageInWindow:message timer:aTimer];
}

+ (void)showActivityMessageInView:(NSString*)message {
    [MBProgressHUD showActivityMessageInView:message];
}

+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer {
    [MBProgressHUD showActivityMessageInView:message timer:aTimer];
}

+ (void)showActivityInWindowWithoutWord {
    [MBProgressHUD showActivityInWindowWithoutWordTimer:99];
}
    
+ (void)showActivityInWindowWithoutWordTimer:(int)aTimer {
    [MBProgressHUD showActivityInWindowWithoutWordTimer:aTimer];
}
    
/**
 *  LoadingView不自动消息
 */
+ (void)showLoad {
    [MBProgressHUD showLoad];
}

/**
 *  隐藏
 */
+ (void)hideHUD {
    [MBProgressHUD hideHUD];
}

+ (void)showCustomIconName:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view {
    [MBProgressHUD showCustomIconImage:[self getImageWithImageName:iconName] Title:title ToView:view];
}


+ (UIImage *)getImageWithImageName:(NSString*)imageName {
    return [UIImage imageNamed:imageName];
}
@end
