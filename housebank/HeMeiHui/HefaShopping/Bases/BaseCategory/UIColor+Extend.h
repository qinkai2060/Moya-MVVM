//
//  UIColor+Extend.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor ()
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  从十六进制字符串获取颜色
 *
 *  @param color NSString : 支持@"#123456"、@"0X123456"、@"123456"三种格式
 *  @param alpha CGFloat : 支持 0.1 - 1.0
 *
 *  @return UIColor
 *
 *  @exception color不空 alpha(0.1-1.0)
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
//根据颜色值获取颜色
+ (UIColor *)colorOfHex:(int)value;

@end
