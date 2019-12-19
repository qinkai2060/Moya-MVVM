//
//  UIView+addGradientLayer.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/12.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "UIView+addGradientLayer.h"

CGFloat DEGREES(CGFloat degress) { return degress * M_PI/180 ;};
@implementation UIView (addGradientLayer)
-(void)addGradualLayerWithColores:(NSArray *)colorArray
{
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradientLayer setColors:colorArray];//渐变数组
    [self.layer addSublayer:gradientLayer];
    
}
//这里只是做了个定时器对locations进行定增操作
-(void)addGradientLayer
{    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame = (CGRect){CGPointZero,CGSizeMake(200, 200)};
    colorLayer.position = self.center;
    [self.layer addSublayer:colorLayer];
    //颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor blueColor].CGColor];
    colorLayer.locations = @[@(0.25),@(0.5),@(0.75)];
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(1, 0);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer){
        static CGFloat length = -0.1f;
        if (length >= 1.1) {
        length = - 0.1f;
        [CATransaction setDisableActions:YES];
        colorLayer.locations = @[@(length),@(length + 0.1),@(length + 0.15)];
    }else{
        [CATransaction setDisableActions:NO];
        colorLayer.locations = colorLayer.locations = @[@(length),@(length + 0.1),@(length + 0.15)];
    }
        length += 0.1f;
    }];
    [self.timer fire];
    
    
}

-(void)addCircleGradientLayer
{    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.backgroundColor = [UIColor orangeColor].CGColor;
    colorLayer.frame = CGRectMake(0, 120, 200, 200);
    colorLayer.position = CGPointMake(self.center.x, colorLayer.frame.origin.y);
    [self.layer addSublayer:colorLayer];
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor whiteColor].CGColor,
                          (__bridge id)[UIColor redColor].CGColor];
    colorLayer.locations  = @[@(-0.2), @(-0.1), @(0)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0);
    CAShapeLayer *circle = [self createCircleWithCenter:CGPointMake(100, 110) radius:90 startAngle:DEGREES(0) endAngle:DEGREES(360) clockwise:YES lineDashPattern:nil];
    circle.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:circle];
    
    circle.strokeEnd = 1.0f;
    colorLayer.mask = circle;
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer){        static NSInteger index = 1;        if (index ++ % 2 == 0) {            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.fromValue = @[@(-0.1), @(-0.15), @(0)];
        animation.toValue   = @[@(1.0), @(1.1), @(1.15)];
        animation.duration  = 1.0;
        [colorLayer addAnimation:animation forKey:nil];
    }
        
    }];
    [self.timer1 fire];
}
//这里其实是两个特效，只是很类似所以放在了一起。第一个是加了一个圆形的遮罩然后对locations进行动画操作。第二个只是简单的对locations
-(CAShapeLayer *)createCircleWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise lineDashPattern:(NSArray *)lineDashPattern
{    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapRound;    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:clockwise];    // 获取path
    layer.path = path.CGPath;
    layer.position = center;    // 设置填充颜色为透明
    layer.fillColor = [UIColor clearColor].CGColor;    // 获取曲线分段的方式
    if (lineDashPattern)
    {
        layer.lineDashPattern = lineDashPattern;
    }
    return layer;
    
}


-(void)addRectangleGradientLayer
{    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.backgroundColor = [UIColor orangeColor].CGColor;
    colorLayer.frame = CGRectMake(0, 300, 300, 100);
    colorLayer.position = CGPointMake(self.center.x, colorLayer.frame.origin.y);
    [self.layer addSublayer:colorLayer];
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor whiteColor].CGColor,
                          (__bridge id)[UIColor redColor].CGColor];
    colorLayer.locations  = @[@(-0.2), @(-0.1), @(0)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0);
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer){        static NSInteger index = 1;        if (index ++ % 2 == 0) {            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.fromValue = @[@(-0.1), @(-0.15), @(0)];
        animation.toValue   = @[@(1.0), @(1.1), @(1.15)];
        animation.duration  = 1.0;
        [colorLayer addAnimation:animation forKey:nil];
    }
        
    }];
    [self.timer2 fire];
}

@end
