//
//  HFUserAnnotationView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFUserAnnotationView.h"
@interface HFUserAnnotationView ()
@property (nonatomic, strong) CALayer *circleView;
@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation HFUserAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10  , 10)];
        self.imageView.backgroundColor = [UIColor colorWithHexString:@"ED0505"];
        self.imageView.layer.cornerRadius =5;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                            -CGRectGetHeight(self.imageView.bounds) / 2.f + self.calloutOffset.y);
        [self addSubview:self.imageView];
        self.circleView.position = self.imageView.center;
        [self.layer insertSublayer:self.circleView below:self.imageView.layer];
    }
    return self;
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    if (self.selected == selected) {
//
//      return;
//    }
//
//    if (selected) {
//        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10  , 10)];
//        self.imageView.backgroundColor = [UIColor colorWithHexString:@"ED0505"];
//        self.imageView.layer.cornerRadius =5;
//        self.imageView.layer.masksToBounds = YES;
//        self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                            -CGRectGetHeight(self.imageView.bounds) / 2.f + self.calloutOffset.y);
//        [self addSubview:self.imageView];
//        self.circleView.position = self.imageView.center;
//        [self.layer insertSublayer:self.circleView below:self.imageView.layer];
//
//    }else {
//        [self.imageView removeFromSuperview];
//    }
//    [super setSelected:selected animated:animated];
//}

- (CALayer *)circleView
{
    if (!_circleView) {
        _circleView = [CALayer layer];
        _circleView.frame = CGRectMake(0, 0, 44, 44);
        
        _circleView.backgroundColor = [UIColor colorWithHexString:@"ED0505"].CGColor;
        _circleView.opacity = 0.2;
        _circleView.cornerRadius = _circleView.frame.size.width / 2;
    }
    return _circleView;
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self startAnimate];
}
- (void)startAnimate
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:2.2f];
    animation.autoreverses = YES;
    animation.duration = 1.f;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circleView addAnimation:animation forKey:nil];
}
@end
