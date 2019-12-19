//
//  UILable+addSetWidthAndheight.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/16.
//  Copyright © 2019年 hefa. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UILabel (addSetWidthAndheight)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font; 
@end

NS_ASSUME_NONNULL_END
