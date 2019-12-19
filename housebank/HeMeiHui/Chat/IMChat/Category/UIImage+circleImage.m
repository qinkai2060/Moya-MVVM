//
//  UIImage+circleImage.m
//  loanPro
//
//  Created by 任为 on 2017/5/29.
//  Copyright © 2017年 Reeve. All rights reserved.
//

#import "UIImage+circleImage.h"

@implementation UIImage (circleImage)
+(UIImage *)drawCircleImage:(UIImage *)image {

    
    // borderWidth 表示边框的宽度
    CGFloat borderWidth = 0;
    CGFloat imageW = image.size.width + 2 * borderWidth;
    CGFloat imageH = imageW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // borderColor表示边框的颜色
    UIColor *borderColor = [[UIColor yellowColor]colorWithAlphaComponent:1];
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    [image drawInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
