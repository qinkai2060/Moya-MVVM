//
//  UIViewController+YS.h
//  JXFuture
//
//  Created by wr on 2017/7/27.
//  Copyright © 2017年 Elephants Financial Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YS)

/**
 *  当当前页面存在UIAlertView弹窗时。这时使用此方法取到的Controller将不能支持页面
 *  跳转。因为这时取得的实际上是UIAlertController
 */
+ (UIViewController *)visibleViewController;

/**
 *  使用此方法取到的Controller，总是支持跳转，不论当前页面是否存在弹窗及警告。
 *  要注意的是，当当前页面存在AlertView弹窗时，新页面会被被弹窗遮盖。
 */
+ (UIViewController *)presentingViewController;

/**
 *  回到rootViewController根控制器。
 */
- (void)backToRootViewController;

@end


@interface UIViewController (FillNavigationBar)

- (void)setupFillingViewUnderNavigationBar;

@end

@protocol UIViewControllerPopViewControllerDelegate <NSObject>

@optional;
- (BOOL)shouldPopViewController;

@end

@interface UIViewController (PopViewController)<UIViewControllerPopViewControllerDelegate>

@end

@interface UIViewController (StatusBarStyle)

/*
 使用 runtime 需要注意：
 对应的 UIViewController 子类不需要重写 preferredStatusBarStyle 方法的，否则不会调用方法替换后的自定义方法。
 */
@end

@interface UIViewController (GPCWLateralSlide)

/**
 * 用于侧滑控制器中的推送弹框
 * completion 收起后执行的操作
 * onlyDismiss YES: 只将弹框本身收起，不需要执行其他跳转控制器操作。NO:除将弹框收起外，还需要执行去看看操作，即跳转别的控制器
 */
- (void)JX_dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion onlyDismiss:(BOOL)onlyDismiss;

@end
