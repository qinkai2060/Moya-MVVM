//
//  MBProgressHUD+WARExtension.h
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (WARExtension)

// -------------TipMessage----------------
+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;

+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer;
+ (void)showActiveMessage:(NSString *)message view:(UIView*)view timer:(int)aTimer;

/**
 * TipMessage不自动消失
 */
+ (void)showMessageToWindow:(NSString *)message;

/**
 * TipMessage自动消失
 */
+ (void)showAutoMessage:(NSString *)message;

// -------------ActivityMessage---------------
+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer;

+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer;

/**
 *  LoadingView不自动消息
 */
+ (void)showLoad;


/**
 *  隐藏
 */
+ (void)hideHUD;

+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view;

+ (void)showCustomIconImage:(UIImage *)iconImage Title:(NSString *)title ToView:(UIView *)view;

+ (void)showActivityInWindowWithoutWordTimer:(int)aTimer;
@end
