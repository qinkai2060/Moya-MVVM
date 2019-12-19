//
//  UILabel+RichTextLable.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/19.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "UILabel+RichTextLable.h"

@implementation UILabel (RichTextLable)
#pragma mark - 创建UILabel
//创建lable
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor*)color font:(UIFont*)font textColor:(UIColor*)textColor

{
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    lable.text=title;
    lable.font=font;
    [lable setBackgroundColor:color];
    lable.textColor=textColor;
    return lable;
}
//创建h行首缩进标签
+ (UILabel*)setLableIndentation:(NSString *)typeStr frame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor*)color font:(UIFont*)font textColor:(UIColor*)textColor
{
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    lable.text=title;
    lable.font=font;
    [lable setBackgroundColor:color];
    lable.textColor=textColor;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    paraStyle01.firstLineHeadIndent = 38;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    lable.text = lable.text ? lable.text : @"";
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:lable.text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    lable.attributedText = attrText;
    [lable sizeToFit];
    return lable;
  
}

@end
