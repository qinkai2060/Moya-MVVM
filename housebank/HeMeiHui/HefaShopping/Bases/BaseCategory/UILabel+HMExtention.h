//
//  UILabel+HMExtention.h
//  02-支付宝生活圈
//
//  Created by teacher on 16/8/26.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HMExtention)
+ (instancetype)hm_labelWithText:(NSString *)text font:(UIFont *)font;
+ (instancetype)hm_labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
+ (instancetype)hm_labelWithText:(NSString *)text font:(UIFont *)font hexColor:(uint32_t)hexColor;
+ (instancetype)wd_labelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color;
+ (instancetype)wd_labelWithText:(NSString *)text font:(CGFloat)font textColorStr:(NSString *)colorStr;
+ (instancetype)wd_labelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color typeFace:(NSString *)typeFaceName textAlignment:(NSTextAlignment)textAlignment;

/**
 * 顶部对齐
 */
- (void)wd_alignTop;

/**
 * 底部对齐
 */
- (void)wd_alignBottom;

@end
