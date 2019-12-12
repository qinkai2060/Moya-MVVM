//
//  WARTestViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARTestViewController.h"
#import "WARFavriteGenarlView.h"
#import "WARFavriteNetWorkTool.h"
#import "WARFavoriteModel.h"
#import "YYModel.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "UIColor+WARCategory.h"
#import "WARConfigurationMacros.h"
#import "WARAvatarsAnmationV.h"
#define DEGREES_TO_RADIANS(degrees) ((degrees)*M_PI)/180
static const CGFloat kAnimationTime = 2.f;
@interface WARTestViewController ()<CAAnimationDelegate>
{
    ///起点
    CGFloat _startAngle;
    ///终点
    CGFloat _endAngle;

}
/** btn */
@property (nonatomic, strong) UIImageView *iconbtn;
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) CAShapeLayer *leftShaplayer;
@property (nonatomic, strong) CAShapeLayer *rightShaplayer;
@property (nonatomic, assign) CGFloat progress; // 当前传入所占等级进度
@property (nonatomic, assign) CGFloat lastprogress;// 之前所停留的进度

@property (nonatomic, assign) CGFloat currentLevel;// 当前等级

@property (nonatomic, assign)    NSInteger total;// 总的经验
@property (nonatomic, assign)    NSInteger currentEXP;
@property (nonatomic, assign)    NSInteger i;
@property (nonatomic, assign)    NSInteger currentLevelSurplusEXP;
@property (nonatomic, assign)    NSInteger currentLevelOverEXP;
@property (nonatomic, assign)    BOOL isOVER;
@property (nonatomic, assign)    CGFloat overEXPProgress;
@property (nonatomic, strong)    WARAvatarsAnmationV *avatars;
@end

@implementation WARTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"303036"];
    
    WS(weakself);
    [self.view addSubview:self.bg];
    [self.bg addSubview:self.iconbtn];
//    [self.view addSubview:self.avatars];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.avatars];
    self.navigationItem.rightBarButtonItem = right;
}

- (WARAvatarsAnmationV *)avatars {
    if (!_avatars) {
        //CGRectMake(0, 0,34, 34)
        _avatars = [[WARAvatarsAnmationV alloc] initWithFrame:CGRectMake((kScreenWidth - 34)*0.5, 150,34, 34)];
    }
    return _avatars;
}
- (void)setMaskModel:(WARProfileMasksModel *)maskModel {
    _maskModel = maskModel;
    self.avatars.avatarsImgStr = maskModel.faceImg;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [self.avatars goldAnmation];
    
}
- (void)jianbian {
    [WARTestViewController exChangeOut:self.iconbtn dur:0.5 type:@"2" disappearView:self.iconbtn];
}
+ (void)exChangeOut:(UIView*)changeOutView dur:(CFTimeInterval)dur type:(NSString*)str disappearView:(UIView*)disView
{
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    // 1秒后执行
    animation2.beginTime = CACurrentMediaTime();
    // 持续时间
    animation2.duration = 0.5;
    // 重复次数
    animation2.repeatCount = 1;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    // 起始位置
    animation2.fromValue = @(45);
    // 终止位置
    animation2.toValue =@(10);
    // 添加动画
    [changeOutView.layer addAnimation:animation2 forKey:@"move"];
    
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.beginTime = CACurrentMediaTime();
    animation.duration = dur;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray* values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];

    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values=@[@(1),@(0.8),@(0.5),@(0.1)];
    opacityAnimation.duration =0.5f;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
  
    [disView.layer addAnimation:opacityAnimation forKey:nil];

    [self performSelector:@selector(removeThisView:) withObject:disView afterDelay:dur];

}

+ (void)removeThisView:(UIView*)view
{
    [view removeFromSuperview];
//    HZSorceObj* hzsonj = [HZSorceObj sharedManager];
//    [hzsonj End];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//
//    self.i =10;//
//
//    CGFloat progress = 0;
//
//    if (self.i != 0) {
//        if (self.i + self.currentEXP >= self.total) {
//               NSLog(@"走了");
//            self.currentLevelSurplusEXP = self.total - self.currentEXP;
//            self.currentLevelOverEXP = self.i + self.currentEXP-self.total;//超出
//            self.isOVER = YES;
//            progress = ((self.currentLevelSurplusEXP+self.currentEXP)/(self.total*1.0));
//
//        }else{
//            progress = ((self.i + self.currentEXP) /(self.total*1.0));
//        }
//        self.progress = progress;
//    }
//
//
//}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSString *name                         = [anim valueForKey:@"name"];
//    if ([name isEqualToString:@"strokeEnd"]) {
//
//        if (self.isOVER) {
//            self.total = self.total*2;
//            self.overEXPProgress =  self.currentLevelOverEXP /(self.total*1.0);
//
//            _lastprogress = 0;
//            self.currentEXP = self.currentLevelOverEXP;
//            self.progress =  self.overEXPProgress ;
//            self.isOVER = NO;
//        }
//    }
//}
//- (void)setMaskModel:(WARProfileMasksModel *)maskModel {
//    _maskModel = maskModel;
//    [self.iconbtn sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(28, 28),maskModel.faceImg)];
//}
//- (void)setArcCircle {
//        float radius = 32/2.0;
//     UIBezierPath *rightPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bg.center.x, self.bg.center.y) radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(-90) clockwise:NO];
//    CAShapeLayer *rightBgLayer = [CAShapeLayer layer];
//    rightBgLayer.frame = self.bg.bounds;
//    rightBgLayer.fillColor =  [[UIColor clearColor] CGColor];
//    rightBgLayer.strokeColor  = [UIColor colorWithHexString:@"FFFFFF" opacity:0.2].CGColor;
//    rightBgLayer.lineWidth = 2;
//    rightBgLayer.path = [rightPath CGPath];
//    rightBgLayer.strokeEnd = 1;
//    [self.bg.layer addSublayer:rightBgLayer];
//
//    UIBezierPath *leftPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bg.center.x, self.bg.center.y) radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(-90) clockwise:YES];
//    CAShapeLayer *leftBgLayer = [CAShapeLayer layer];
//    leftBgLayer.frame = self.bg.bounds;
//    leftBgLayer.fillColor =  [[UIColor clearColor] CGColor];
//    leftBgLayer.strokeColor  = [UIColor colorWithHexString:@"FFFFFF" opacity:0.2].CGColor;
//    leftBgLayer.lineWidth = 2;
//    leftBgLayer.path = [leftPath CGPath];
//    leftBgLayer.strokeEnd = 1;
//    [self.bg.layer addSublayer:leftBgLayer];
//
//    self.leftShaplayer = [CAShapeLayer layer];
//    self.leftShaplayer.frame = self.bg.bounds;
//    self.leftShaplayer.fillColor =  [UIColor clearColor].CGColor;
//    self.leftShaplayer.strokeColor  = [[UIColor colorWithHexString:@"31A6C4"] CGColor];
//    self.leftShaplayer.lineCap = kCALineCapRound;
//
//    self.leftShaplayer.lineWidth = 2;
//    self.leftShaplayer.path = [leftPath CGPath];
//    self.leftShaplayer.strokeEnd = 0;
//    [self.bg.layer addSublayer:self.leftShaplayer];
//
//    self.rightShaplayer = [CAShapeLayer layer];
//    self.rightShaplayer.frame = self.bg.bounds;
//    self.rightShaplayer.fillColor =  [UIColor clearColor].CGColor;
//    self.rightShaplayer.strokeColor  = [ThemeColor CGColor];
//    self.rightShaplayer.lineCap = kCALineCapRound;
//
//    self.rightShaplayer.lineWidth = 2;
//    self.rightShaplayer.path = [rightPath CGPath];
//    self.rightShaplayer.strokeEnd = 0;
//    [self.bg.layer addSublayer:self.rightShaplayer];
//
//}
//- (void)circleAnimation {
//
//    //开启事务
//    [CATransaction begin];
//    //关闭动画
//    [CATransaction setDisableActions:YES];
//    self.leftShaplayer.strokeEnd = _lastprogress;
//    //self.rightShaplayer.strokeEnd = _lastprogress;
//    [CATransaction commit];
//
//
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    [animation setValue:@"strokeEnd" forKey:@"name"];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.duration = kAnimationTime;
//    animation.beginTime = CACurrentMediaTime();
//    animation.repeatCount = 1;
//    animation.fromValue = @(_lastprogress);
//    animation.toValue = @(self.progress);
//    animation.fillMode = kCAFillModeForwards;
//    animation.delegate = self;
//    animation.removedOnCompletion = NO;
//    [self.leftShaplayer addAnimation:animation forKey:@"strokeEnd"];
////    [self.rightShaplayer addAnimation:animation forKey:@"strokeEndAni"];
//    _lastprogress = _progress;
//    if (self.isOVER) {
//
//        self.currentEXP = self.currentLevelOverEXP;
//    }else{
//
//         self.currentEXP += self.i;
//    }
//
//}
//- (void)setOverEXPProgress:(CGFloat)overEXPProgress {
//    _overEXPProgress = overEXPProgress;
//
//}
//
//- (void)setProgress:(CGFloat)progress {
//    _progress = progress;
//    [self circleAnimation];
//
//}
- (UIImageView *)iconbtn {
    if (!_iconbtn) {
        _iconbtn = [[UIImageView   alloc] initWithFrame:CGRectMake(0, 48, 34, 14)];
//        _iconbtn.center = self.bg.center;
        _iconbtn.layer.cornerRadius = 4;
        _iconbtn.layer.masksToBounds = YES;
        _iconbtn.layer.opacity = 0;
        _iconbtn.backgroundColor = [UIColor redColor];
    }
    return _iconbtn;
}
- (UIView *)bg {
    if (!_bg) {
        _bg = [[UIView   alloc] initWithFrame:CGRectMake(0, 0,34, 34)];
        _bg.center = self.view.center;
        _bg.backgroundColor = [UIColor orangeColor];
    }
    return _bg;
}
//-(NSInteger) newProgress {
//    return arc4random()%self.total;
//}
@end
