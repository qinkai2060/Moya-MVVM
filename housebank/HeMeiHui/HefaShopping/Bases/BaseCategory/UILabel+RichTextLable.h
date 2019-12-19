//
//  UILabel+RichTextLable.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/19.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (RichTextLable)
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor*)color font:(UIFont*)font textColor:(UIColor*)textColor;
+ (UILabel*)setLableIndentation:(NSString *)typeStr frame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor*)color font:(UIFont*)font textColor:(UIColor*)textColor;
@end

NS_ASSUME_NONNULL_END
