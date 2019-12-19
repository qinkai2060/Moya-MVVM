//
//  NavigationBarTitleView.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "NavigationBarTitleView.h"
#import "UIButton+CustomButton.h"
@interface NavigationBarTitleView()

@end

@implementation NavigationBarTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setui];
    }
    return self;
}
- (void)setui{
    _btnmMyOrder = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _btnmMyOrder.frame = CGRectMake(0, 0, 200, 30);
    [_btnmMyOrder setTitle:@"我的订单" forState:(UIControlStateNormal)];
    [_btnmMyOrder setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
    _btnmMyOrder.titleLabel.font = PFR17Font;
    [_btnmMyOrder addTarget:self action:@selector(btnTypeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnmMyOrder setImage:[UIImage imageNamed:@"icon_sanjiao_bottom"] forState:(UIControlStateNormal)];
    [_btnmMyOrder setImage:[UIImage imageNamed:@"icon_sanjiao_top"] forState:(UIControlStateSelected)];
    [_btnmMyOrder setSelected:NO];
    _btnmMyOrder.adjustsImageWhenHighlighted =  NO;
    [self addSubview:_btnmMyOrder];
    [_btnmMyOrder layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:5];
}

/**
 点击按钮

 @param btn 上下三角
 */
- (void)btnTypeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.clickBlock) {
        self.clickBlock(btn.selected);
    }
}

/**
 改变btn样式

 @param title btn标题
 */
- (void)changeBtnTitle:(NSString *)title{
    if ([title isEqualToString:@""]) {
         _btnmMyOrder.selected = NO;
        return;
    }
    _btnmMyOrder.selected = NO;
    if ([title isEqualToString:@"全部"]) {
        title = @"我的订单";
    }
    [_btnmMyOrder setTitle:title forState:(UIControlStateNormal)];
    [_btnmMyOrder layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:5];
}
@end
