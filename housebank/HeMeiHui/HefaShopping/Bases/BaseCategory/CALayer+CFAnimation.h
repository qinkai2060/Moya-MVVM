//
//  CALayer+CFAnimation.h
//  housebank
//
//  Created by zhuchaoji on 2018/10/26.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CFAnimation)
//动画
- (void)startAnimationWithKeyPath:(NSString *)keyPath andValues:(NSArray *)values andDuration:(CFTimeInterval)duration;

@end
