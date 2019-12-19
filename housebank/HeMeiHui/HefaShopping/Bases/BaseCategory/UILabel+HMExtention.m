//
//  UILabel+HMExtention.m
//  02-支付宝生活圈
//
//  Created by teacher on 16/8/26.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIColor+ZFBAddition.h"

@implementation UILabel (HMExtention)
+ (instancetype)hm_labelWithText:(NSString *)text font:(UIFont *)font{
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = font;
    return label;
}

+ (instancetype)hm_labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color{
    UILabel *label = [self hm_labelWithText:text font:font];
    label.textColor = color;
    return label;
}

+ (instancetype)hm_labelWithText:(NSString *)text font:(UIFont *)font hexColor:(uint32_t)hexColor{
    UIColor *color = [UIColor hm_colorWithHex:hexColor];
    return [self hm_labelWithText:text font:font textColor:color];
}

+ (instancetype)wd_labelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color {
  //  UIFont *tempFont = [UIFont systemFontOfSize:font];
    return  [self wd_labelWithText:text font:font textColor:color typeFace:@"PingFangSC-Regular" textAlignment:NSTextAlignmentLeft];
}
+ (instancetype)wd_labelWithText:(NSString *)text font:(CGFloat)font textColorStr:(NSString *)colorStr {

    UIColor *color = [UIColor colorWithHexString:colorStr];
    return [self wd_labelWithText:text font:font textColor:color];
}

+ (instancetype)wd_labelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color typeFace:(NSString *)typeFaceName textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [UILabel hm_labelWithText:text font:[UIFont systemFontOfSize:font] textColor:color];
    
    if (typeFaceName) {
        [label setFont:[UIFont fontWithName:typeFaceName size:font]];
    } else {
        [label setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:font]]; //兰亭雅黑
    }
    
    if (textAlignment) {
        label.textAlignment = textAlignment;
    } else {
        label.textAlignment = NSTextAlignmentCenter;
    }
    return label;
}

- (void)wd_alignTop {
    
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
    
    
}

- (void)wd_alignBottom {
    
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    
}

@end
