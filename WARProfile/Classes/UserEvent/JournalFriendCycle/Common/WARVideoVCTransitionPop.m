//
//  WARVideoVCTransitionPop.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/5.
//

#import "WARVideoVCTransitionPop.h" 
#import "WARMacros.h"
#import "WARFloatWindowManager.h"

#define kAuration 0.25
@interface WARVideoVCTransitionPop()<CAAnimationDelegate>
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIView *coverView;
@end
@implementation WARVideoVCTransitionPop

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kAuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext=transitionContext;
    
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contView = [transitionContext containerView];
    [contView addSubview:toVC.view];
    [contView addSubview:fromVC.view];
    
    CGRect floatBallRect = [WARFloatWindowManager shared].floatView.frame;
    [toVC.view addSubview:self.coverView];
    
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(floatBallRect.origin.x, floatBallRect.origin.y,floatBallRect.size.width , floatBallRect.size.height) cornerRadius:0];
    
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,kScreenWidth, kScreenHeight) cornerRadius:0];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskStartBP.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.toValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.fromValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = kAuration;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
    [UIView animateWithDuration:kAuration animations:^{
        self.coverView.alpha = 0;
    }];
    [UIView animateWithDuration:kAuration animations:^{
        [WARFloatWindowManager shared].floatView.alpha = 1;
    }];
    
}
#pragma mark - CABasicAnimation的Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:YES];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    [self.coverView removeFromSuperview];
}

-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.5;
    };
    return _coverView;
}

@end
