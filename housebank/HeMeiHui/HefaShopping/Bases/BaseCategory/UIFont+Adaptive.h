//
//  UIFont+Adaptive.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/10/16.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Adaptive)
+(UIFont *)adaptFontSize:(CGFloat)fontSize;
+(UIFont *)adaptBoldFontSize:(CGFloat)fontSize;

+(UIFont *)adaptFontWithName:(NSString*)fontName size:(CGFloat)fontSize;
@end
