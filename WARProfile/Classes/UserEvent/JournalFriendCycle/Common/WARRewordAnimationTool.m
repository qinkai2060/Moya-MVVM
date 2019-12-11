//
//  PurchaseCarAnimationTool.m
//  PruchaseCarAnimation
//
//  Created by zhenyong on 16/8/17.
//  Copyright © 2016年 com.demo. All rights reserved.
//

#import "WARRewordAnimationTool.h"
@interface WARRewordAnimationTool()<CAAnimationDelegate>

@end

@implementation WARRewordAnimationTool
#pragma mark - instancetype
+ (instancetype)shareTool
{
    return [[WARRewordAnimationTool alloc]init];
}
#pragma public function
- (void)startAnimationandView:(UIView *)view
                         rect:(CGRect)rect
                  finisnPoint:(CGPoint)finishPoint
                  finishBlock:(animationFinisnBlock)completion
{
    //图层
    _layer = [CALayer layer];
    _layer.contents = view.layer.contents;
    _layer.contentsGravity = kCAGravityResizeAspectFill;
    rect.size.width  = view.bounds.size.width;
    rect.size.height = view.bounds.size.height;   //重置图层尺寸
    _layer.bounds = rect; 
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.layer addSublayer:_layer];
    _layer.position = CGPointMake(rect.origin.x+view.frame.size.width/2, CGRectGetMidY(rect)); //a 点
    /// 路径
    [self createAnimationwithRect:rect finishPoint:finishPoint];
    /// 回调
    if (completion) {
        _animationFinisnBlock = completion;
    }
}
+ (void)shakeAnimation:(UIView *)shakeView
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
    shakeAnimation.autoreverses = YES;
    [shakeView.layer addAnimation:shakeAnimation forKey:nil];
}
#pragma mark - private function
/// 创建动画
- (void)createAnimationwithRect:(CGRect)rect
                    finishPoint:(CGPoint)finishPoint {
    /// 路径动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_layer.position];
    [path addQuadCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y - 50) controlPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y - 50)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
//    /// 旋转动画
    CABasicAnimation *scaleAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation.toValue   = [NSNumber numberWithFloat:1.5];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //透明度变化
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    
    /// 添加动画动画组合
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,scaleAnimation,opacityAnimation];
    groups.duration = 1.2f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_layer animationForKey:@"group"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
        if (_animationFinisnBlock) {
            _animationFinisnBlock(YES);
        }
    }
}
@end
