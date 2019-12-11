//
//  HKFloatBall.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/4.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKFloatBall;
@protocol HKFloatBallDelegate <NSObject>
@optional
- (void)floatBallDidClick:(HKFloatBall *)floatBall;
- (void)floatBallClose:(HKFloatBall *)floatBall;
- (void)floatBallFullScreen:(HKFloatBall *)floatBall;
- (void)floatBallPlay:(HKFloatBall *)floatBall stop:(BOOL)stop;
@end

@interface HKFloatBall : UIView
@property (nonatomic, weak) id<HKFloatBallDelegate>delegate;
@property (nonatomic, strong) UIImageView *iconImageView;
@end
