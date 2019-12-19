//
//  MBProgressHUD+QYExtension.m
//  HeMeiHui
//
//  Created by Tracy on 2019/8/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MBProgressHUD+QYExtension.h"

@implementation MBProgressHUD (QYExtension)
+ (void)qy_showWithText:(NSString *)text icon:(NSString *)icon toView:(UIView *)view {
    if (!text.length && !icon.length) {
        return;
    }
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    if (icon) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: icon]];
    } else {
        hud.mode = MBProgressHUDModeText;
    }
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.label.text = text;
    [view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
}


+ (void)qy_showProgressView {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:NO];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
}

+ (void)qy_hideProgressView {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
}



+ (void)qy_showInfoWithStatus:(NSString *)text {
    [MBProgressHUD qy_showWithText:text icon:nil toView:[UIApplication sharedApplication].delegate.window];
}

+ (void)qy_showSuccessWithStatus:(NSString *)text {
    [MBProgressHUD qy_showWithText:text icon:@"MBProgressHud_success" toView:[UIApplication sharedApplication].delegate.window];
}

+ (void)qy_showFailureWithStatus:(NSString *)text {
    [MBProgressHUD qy_showWithText:text icon:@"MBProgressHud_failure" toView:[UIApplication sharedApplication].delegate.window];
}
@end
