//
//  MBProgressHUD+QYExtension.h
//  HeMeiHui
//
//  Created by Tracy on 2019/8/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (QYExtension)
+ (void)qy_showWithText:(NSString *)text icon:(NSString *)icon toView:(UIView *)view;

+ (void)qy_showProgressView;

+ (void)qy_hideProgressView ;

+ (void)qy_showInfoWithStatus:(NSString *)text;

+ (void)qy_showSuccessWithStatus:(NSString *)text ;

+ (void)qy_showFailureWithStatus:(NSString *)text ;
@end

NS_ASSUME_NONNULL_END
