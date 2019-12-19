//
//  CALayer+CFAnimation.m
//  housebank
//
//  Created by zhuchaoji on 2018/10/26.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "CALayer+CFAnimation.h"

@implementation CALayer (CFAnimation)

- (void)startAnimationWithKeyPath:(NSString *)keyPath andValues:(NSArray *)values andDuration:(CFTimeInterval)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = keyPath;
    animation.values = values;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.calculationMode = kCAAnimationCubic;
    animation.fillMode = kCAFillModeForwards;
    [self addAnimation:animation forKey:nil];
}

@end
