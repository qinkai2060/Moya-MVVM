//
//  WARProgressHUD.h
//  Pods
//
//  Created by shenfangwei on 2017/8/8.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+WARExtension.h"

@interface HFProgressHUD : NSObject

+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;

+ (void)showSuccessMessage:(NSString *)message ToView:(UIView *)view;
+ (void)showErrorMessage:(NSString *)message ToView:(UIView *)view;
+ (void)showWarnMessage:(NSString *)message ToView:(UIView *)view;


// -------------TipMessage----------------
+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;

+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer;

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

+ (void)showActivityInWindowWithoutWord;
+ (void)showActivityInWindowWithoutWordTimer:(int)aTimer;
/**
 *  LoadingView不自动消息
 */
+ (void)showLoad;

/**
 *  隐藏
 */
+ (void)hideHUD;
@end
