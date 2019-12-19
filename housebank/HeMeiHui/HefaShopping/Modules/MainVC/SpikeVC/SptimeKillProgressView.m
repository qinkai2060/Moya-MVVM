//
//  SptimeKillProgressView.m
//  HeMeiHui
//
//  Created by usermac on 2019/5/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SptimeKillProgressView.h"

@implementation SptimeKillProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"FFCCC8"];
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.percentageLb];
        [self addSubview:self.stateLb];
        self.stateLb.frame = CGRectMake(5, 0, self.width-10, self.height);
        self.gradientLayer.frame = CGRectMake(0, 0, 0, self.height);
        self.percentageLb.frame = CGRectMake(5, 0, self.width-10, self.height);;
        
    }
    return self;
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (progress == 1.0) {
//        self.stateLb.text = @"已抢光";
        self.stateLb.textAlignment = NSTextAlignmentCenter;
        self.percentageLb.hidden = YES;
       
    }else {
        self.stateLb.textAlignment = NSTextAlignmentLeft;
        self.percentageLb.hidden = NO;
    }
    [self anmation];
}

- (void)anmation {
    CABasicAnimation *anm = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    anm.fromValue =0;
    anm.toValue = [NSNumber numberWithFloat:(self.width*2)*self.progress];
    anm.removedOnCompletion = NO;
    anm.duration = 2;
    anm.fillMode = kCAFillModeForwards;
    anm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.gradientLayer addAnimation:anm forKey:@""];
}
- (UILabel *)percentageLb {
    if (!_percentageLb) {
        _percentageLb = [[UILabel alloc] init];
        _percentageLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _percentageLb.font = [UIFont systemFontOfSize:9];
        _percentageLb.textAlignment = NSTextAlignmentRight;
    }
    return _percentageLb;
}
- (UILabel *)stateLb {
    if (!_stateLb) {
        _stateLb = [[UILabel alloc] init];
        _stateLb.textColor = [UIColor whiteColor];
        _stateLb.font = [UIFont systemFontOfSize:9];
    }
    return _stateLb;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

@end
