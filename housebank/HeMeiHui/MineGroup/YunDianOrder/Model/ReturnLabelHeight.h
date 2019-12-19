//
//  ReturnLabelHeight.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReturnLabelHeight : NSObject
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
