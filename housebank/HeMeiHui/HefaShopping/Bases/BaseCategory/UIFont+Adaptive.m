//
//  UIFont+Adaptive.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/10/16.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "UIFont+Adaptive.h"
#define FONT_SCALE [[UIScreen mainScreen] bounds].size.width/375.0f
@implementation UIFont (Adaptive)
+(UIFont *)adaptFontSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize*FONT_SCALE];
}

+(UIFont *)adaptBoldFontSize:(CGFloat)fontSize
{
    return [UIFont boldSystemFontOfSize:fontSize*FONT_SCALE];
}

+(UIFont *)adaptFontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    return [UIFont fontWithName:fontName size:fontSize];
}
@end
