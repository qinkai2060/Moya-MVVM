//
//  BaseSettingViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseSettingViewController : UIViewController
@property (nonatomic, strong) UIButton * lButton;
@property (nonatomic, strong) UIButton * rButton;
@property (nonatomic, strong)MBProgressHUD *loading;
- (void)downLoad;
- (void)setStatusBarBackgroundColor:(UIColor *)color;
- (void)showSVProgressHUDSuccessWithStatus:(NSString *)str;
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
