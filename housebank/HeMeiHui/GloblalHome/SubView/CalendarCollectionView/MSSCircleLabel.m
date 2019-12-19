//
//  MSSCircleLabel.m
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//
#import "MSSCircleLabel.h"
#import "MSSCalendarDefine.h"

@implementation MSSCircleLabel

- (void)drawRect:(CGRect)rect
{
    if(_isSelected)
    {
        [self.textColor setFill];
        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.height / 2 startAngle:0.0 endAngle:180.0 clockwise:YES];
//        [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.height startAngle:0.0 endAngle:180.0 clockwise:YES];

        [path fill];
    }
    [super drawRect:rect];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    [self setNeedsDisplay];
}

@end
