//
//  UIImage+Color.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/**
 根据颜色绘制图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage*) imageWithUIView:(UIView*) view;
+ (UIImage *)imageWithSolidColor:(UIColor *)color size:(CGSize)size;
@end
