//
//  UIButton+Base.m
//  zzw
//
//  Created by weixing on 14-11-20.
//  Copyright (c) 2014年 weixing. All rights reserved.
//

#import "UIButton+Base.h"

@implementation UIButton (Base)

@dynamic underlineNone;

-(void)selectImageWithNoSelectImage:(NSString *)selectImage noSelectImage:(NSString *)noSelectImage{
    [self normalImage:noSelectImage];
    [self setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
}

-(void)ischeckImageWithCheckImage:(NSString *)isCheckImage checkImage:(NSString *)checkImage{
    [self normalImage:checkImage];
    [self setBackgroundImage:[UIImage imageNamed:isCheckImage] forState:UIControlStateSelected];
}
-(void)normalImage:(NSString *)imageName{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
-(void)setUnderlineNone:(BOOL)flag {
    if (flag) {
        NSString *text = self.titleLabel.text;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text] ;
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0,text.length)];
        [self setAttributedTitle:str forState:UIControlStateNormal];
    }
}
@end
