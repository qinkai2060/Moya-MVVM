//
//  NSMutableAttributedString+MutableAttributestr.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/19.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (MutableAttributestr)
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color;
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text textColor:(UIColor *)color setImage:(UIImage *)image;
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)titleText indentationText:(NSString *)singleText1 indentationText:(NSString *)singleText2;
+ (NSMutableAttributedString *)setupAttributeLine:(NSString *)text lineColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
