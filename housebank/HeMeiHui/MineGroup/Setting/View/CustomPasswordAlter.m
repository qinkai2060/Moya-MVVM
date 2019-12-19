//
//  CustomPasswordAlter.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "CustomPasswordAlter.h"
#import "UIView+addGradientLayer.h"
#define FitiPhone6Scale(x) ((x) * ScreenW / 375.0f)
@interface CustomPasswordAlter()
{
    UIView * view;
    UILabel * labelTitle;
}
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSString *suret;
@property (nonatomic, assign) NSString *closet;

@end


@implementation CustomPasswordAlter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

+(instancetype)showCustomPasswordAlterViewViewIn:(UIView *)view title:(NSString *)title suret:(NSString *)suret closet:(NSString *)closet sureblock:(void(^)())sureblock closeblock:(void(^)())closeblock{
    CustomPasswordAlter *cus = [[CustomPasswordAlter alloc] initWithFrame:view.bounds];
    cus.sureblock = sureblock;
    cus.closeblock = closeblock;
    cus.title = title;
    cus.suret = suret;
    cus.closet = closet;
    [view addSubview:cus];
    [cus createBtn];
    return cus;
}

/**
 通过字段判断创建创建按钮的个数
 */
- (void)createBtn{
    if (self.closet.length && self.suret.length) {
        [self doublebtn];
    } else {
        [self onebtn];
    }
}
- (void)btnCloseUpInsideAction{
    
    
    if (self.closeblock) {
        self.closeblock();
        [self removeFromSuperview];
    }
}
- (void)btnSureUpInsideAction{
    if (self.sureblock) {
        self.sureblock();
        [self removeFromSuperview];
    }
}

/**
 两个按钮的提示框
 */
- (void)doublebtn{
    
    UIButton * btnclose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnclose setTitle:self.closet forState:(UIControlStateNormal)];
    btnclose.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnclose setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
    [btnclose addTarget:self action:@selector(btnCloseUpInsideAction) forControlEvents:(UIControlEventTouchUpInside)];
    btnclose.backgroundColor = [UIColor whiteColor];
    [view addSubview:btnclose];
    btnclose.frame = CGRectMake(0, FitiPhone6Scale(105), FitiPhone6Scale(140), FitiPhone6Scale(45));
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, FitiPhone6Scale(105), FitiPhone6Scale(140), 0.8)];
    line.backgroundColor = HEXCOLOR(0xE5E5E5);
    [view addSubview:line];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btnclose.bounds byRoundingCorners:UIRectCornerBottomLeft  cornerRadii:CGSizeMake(FitiPhone6Scale(10), FitiPhone6Scale(10))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btnclose.bounds;
    maskLayer.path = maskPath.CGPath;
    btnclose.layer.mask = maskLayer;
    
    
    UIButton * btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSure setTitle:self.suret forState:(UIControlStateNormal)];
    btnSure.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnSure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnSure addTarget:self action:@selector(btnSureUpInsideAction) forControlEvents:(UIControlEventTouchUpInside)];
    btnSure.backgroundColor = HEXCOLOR(0xFF2E5D);
    [view addSubview:btnSure];
    btnSure.frame = CGRectMake(FitiPhone6Scale(140), FitiPhone6Scale(105), FitiPhone6Scale(140), FitiPhone6Scale(45));
    [btnSure addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSure bringSubviewToFront:btnSure.titleLabel];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:btnSure.bounds byRoundingCorners: UIRectCornerBottomRight cornerRadii:CGSizeMake(FitiPhone6Scale(10), FitiPhone6Scale(10))];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = btnSure.bounds;
    maskLayer2.path = maskPath2.CGPath;
    btnSure.layer.mask = maskLayer2;
    
}

/**
 一个按钮的提示框
 */
- (void)onebtn{
    UIButton * btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSure setTitle:self.suret forState:(UIControlStateNormal)];
    btnSure.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnSure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnSure addTarget:self action:@selector(btnSureUpInsideAction) forControlEvents:(UIControlEventTouchUpInside)];
    btnSure.backgroundColor = HEXCOLOR(0xFF2E5D);
    [view addSubview:btnSure];
    btnSure.frame = CGRectMake(0, FitiPhone6Scale(105), FitiPhone6Scale(280), FitiPhone6Scale(45));
    [btnSure addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSure bringSubviewToFront:btnSure.titleLabel];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:btnSure.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(FitiPhone6Scale(10), FitiPhone6Scale(10))];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = btnSure.bounds;
    maskLayer2.path = maskPath2.CGPath;
    btnSure.layer.mask = maskLayer2;
}
- (void)createView{
    UIView * viewB = [[UIView alloc] initWithFrame:self.bounds];
    viewB.backgroundColor = [UIColor blackColor];
    viewB.alpha = 0.4;
    [self addSubview:viewB];
    
    view = [[UIView alloc] init];
    view.backgroundColor =  [UIColor whiteColor];
    view.layer.cornerRadius = FitiPhone6Scale(10);
    view.frame = CGRectMake(0, 0, FitiPhone6Scale(280), FitiPhone6Scale(150));
    view.center = self.center;
    
    labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = HEXCOLOR(0x333333);
    labelTitle.numberOfLines = 0;
    labelTitle.font = [UIFont boldSystemFontOfSize:FitiPhone6Scale(16)];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labelTitle];
    labelTitle.frame = CGRectMake(FitiPhone6Scale(15), FitiPhone6Scale(13), FitiPhone6Scale(250), FitiPhone6Scale(80));
    
    [self addSubview:view];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    labelTitle.text = title;
}
@end
