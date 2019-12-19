//
//  HFAlertView.m
//  housebank
//
//  Created by usermac on 2018/12/18.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAlertView.h"
#import "UIView+addGradientLayer.h"
#import "UIButton+CustomButton.h"
@interface HFAlertView ()
@property(nonatomic,strong)UIView *cornerView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *detailLb;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *payVipBtn;

@end
@implementation HFAlertView
+ (void)showAlertViewType:(HFAlertViewType)type title:(NSString*)title detailString:(NSString*)detail cancelTitle:(NSString*)cancelText  cancelBlock:(cancelBBlock)cancel sureTitle:(NSString*)sureText sureBlock:(sureBBlock)sure  {
    HFAlertView *alertView = [[HFAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.currentTitle = title;
    if (type == HFAlertViewTypeNone ) {
          alertView.titleLb.text = title;
        alertView.titleLb.font = [UIFont boldSystemFontOfSize:16];
        CGSize size = [alertView.titleLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.titleLb.frame = CGRectMake(25, 43, alertView.cornerView.width-50, size.height);

        alertView.payVipBtn.hidden = YES;
    }else if (type == HFAlertViewTypeVip){
        alertView.titleLb.text = title;
        alertView.titleLb.font = [UIFont boldSystemFontOfSize:12];
        CGSize size = [alertView.titleLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.titleLb.frame = CGRectMake(25, 20, alertView.cornerView.width-50, size.height);
        alertView.payVipBtn.frame = CGRectMake(alertView.cornerView.width-25-100, alertView.titleLb.bottom+10, 100, 20);
        alertView.titleLb.textAlignment = NSTextAlignmentLeft;
        alertView.payVipBtn.hidden = NO;
    }else {
        alertView.payVipBtn.hidden = YES;
        alertView.titleLb.text = title;
        CGSize size = [alertView.titleLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.titleLb.frame = CGRectMake(25, 25, alertView.cornerView.width-50, size.height);
        
        alertView.detailLb.text = detail;
        alertView.titleLb.font = [UIFont boldSystemFontOfSize:16];
        CGSize sizedetail = [alertView.detailLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.detailLb.frame = CGRectMake(25, alertView.titleLb.bottom+10, alertView.cornerView.width-50, sizedetail.height);
        
    }

    if (cancelText.length == 0 ) {
        alertView.cancelBtn.hidden = YES;
        alertView.sureBtn.hidden = YES;
        alertView.backBtn.hidden =  NO;
        [alertView.backBtn setTitle:sureText forState:UIControlStateNormal];
    }
    if (sureText.length == 0) {
        alertView.cancelBtn.hidden = NO;
        alertView.sureBtn.hidden = YES;
        alertView.backBtn.hidden =  YES;
        alertView.cancelBtn.frame = CGRectMake(0, alertView.cornerView.height-45, ScreenW-48*2, 45);
    }
 
    [alertView.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
    [alertView.sureBtn setTitle:sureText forState:UIControlStateNormal];

    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
    alertView.sureblock = sure;
    alertView.cancelblock = cancel;
    [HFAlertView exChangeOut:alertView.cornerView dur:0.3];
    
}
+ (void)showAlertViewType:(HFAlertViewType)type title:(NSString*)title detailString:(NSString*)detail cancelTitle:(NSString*)cancelText  vipBlock:(vipBlock)vipBlock sureTitle:(NSString*)sureText sureBlock:(sureBBlock)sure {
    HFAlertView *alertView = [[HFAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.currentTitle = title;
    if (type == HFAlertViewTypeNone ) {
        alertView.titleLb.text = title;
        alertView.titleLb.font = [UIFont boldSystemFontOfSize:16];
        CGSize size = [alertView.titleLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.titleLb.frame = CGRectMake(25, 43, alertView.cornerView.width-50, size.height);
        
        alertView.payVipBtn.hidden = YES;
    }else if (type == HFAlertViewTypeVip){
        alertView.titleLb.text = title;
        alertView.titleLb.font = [UIFont boldSystemFontOfSize:12];
        CGSize size = [alertView.titleLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.titleLb.frame = CGRectMake(25, 20, alertView.cornerView.width-50, size.height);
        alertView.payVipBtn.frame = CGRectMake(alertView.cornerView.width-25-100, alertView.titleLb.bottom+10, 100, 20);
        alertView.titleLb.textAlignment = NSTextAlignmentLeft;
        alertView.payVipBtn.hidden = NO;
    }else {
        alertView.payVipBtn.hidden = YES;
        alertView.titleLb.text = title;
        CGSize size = [alertView.titleLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.titleLb.frame = CGRectMake(25, 25, alertView.cornerView.width-50, size.height);
        
        alertView.detailLb.text = detail;
        alertView.titleLb.font = [UIFont boldSystemFontOfSize:16];
        CGSize sizedetail = [alertView.detailLb sizeThatFits:CGSizeMake(alertView.cornerView.width-50, 60)];
        alertView.detailLb.frame = CGRectMake(25, alertView.titleLb.bottom+10, alertView.cornerView.width-50, sizedetail.height);
        
    }
    
    if (cancelText.length == 0 ) {
        alertView.cancelBtn.hidden = YES;
        alertView.sureBtn.hidden = YES;
        alertView.backBtn.hidden =  NO;
        [alertView.backBtn setTitle:sureText forState:UIControlStateNormal];
    }
    if (sureText.length == 0) {
        alertView.cancelBtn.hidden = NO;
        alertView.sureBtn.hidden = YES;
        alertView.backBtn.hidden =  YES;
        alertView.cancelBtn.frame = CGRectMake(0, alertView.cornerView.height-45, ScreenW-48*2, 45);
    }
    
    [alertView.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
    [alertView.sureBtn setTitle:sureText forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
    alertView.sureblock = sure;
    alertView.vipblock = vipBlock;
    [HFAlertView exChangeOut:alertView.cornerView dur:0.3];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        [self hh_setupSubViews];
    }
    return self;
}
- (void)hh_setupSubViews {
    [self addSubview:self.cornerView];
    [self.cornerView addSubview:self.cancelBtn];
    [self.cornerView addSubview:self.sureBtn];
    [self.cornerView addSubview:self.backBtn];
    [self.cornerView addSubview:self.lineView];
    [self.cornerView addSubview:self.titleLb];
    [self.cornerView addSubview:self.detailLb];
    [self.cornerView addSubview:self.payVipBtn];
   
}
- (void)sureClickEvent:(UIButton*)btn {
 
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    statusBar.backgroundColor = [UIColor whiteColor];
    [HFAlertView exChangeDisappear:self.cornerView dur:0.3];
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.sureblock) {
            self.sureblock(self);
        }
        UIView *v = self;
        [v removeFromSuperview];
    }];
    
   int(^block)(int num) =  [self num:1];
   int num = block(1);
    NSLog(@"%d",num);
}
- (int(^)(int))num:(int)x {
    return ^int(int y) {
        return x+y;
    };
}
- (void)vipPayMentClick {
    if (self.vipblock) {
        self.vipblock(self);
    }
}
- (void)cancelClickEvent:(UIButton*)btn {


//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    statusBar.backgroundColor = [UIColor whiteColor];
    [HFAlertView exChangeDisappear:self.cornerView dur:0.3];
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.cancelblock) {
            self.cancelblock(self);
        }
        UIView *v = self;
      [v removeFromSuperview];
   
    }];
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.cornerView.height-45, self.cornerView.width*0.5, 45)];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
         [_cancelBtn addTarget:self action:@selector(cancelClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)payVipBtn {
    if(!_payVipBtn) {
        _payVipBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cornerView.width-25-80, self.titleLb.bottom+10, 80, 20)];
        [_payVipBtn setTitle:@"成为VIP会员" forState:UIControlStateNormal];
        [_payVipBtn setTitleColor:[UIColor colorWithHexString:@"F3344A"] forState:UIControlStateNormal];
        _payVipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_payVipBtn setImage:[UIImage imageNamed:@"vip_icon-arrow"] forState:UIControlStateNormal];
        [_payVipBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_payVipBtn addTarget:self action:@selector(cancelClickEvent:) forControlEvents:UIControlEventTouchUpInside]; //cancelClickEvent vipPayMentClick
    }
    return _payVipBtn;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cornerView.width*0.5, self.cornerView.height-45, self.cornerView.width*0.5, 45)];
         [_sureBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn addTarget:self action:@selector(sureClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.cornerView.height-45, self.cornerView.width, 45)];
        [_backBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_backBtn addTarget:self action:@selector(sureClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden =YES;
    }
    return _backBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cornerView.height-45-0.5, self.cornerView.width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textAlignment = NSTextAlignmentCenter;
         _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}
- (UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [[UILabel alloc] init];
        _detailLb.textColor = [UIColor colorWithHexString:@"666666"];
        _detailLb.font = [UIFont systemFontOfSize:14];
        _detailLb.textAlignment = NSTextAlignmentCenter;
        _detailLb.numberOfLines = 0;
    }
    return _detailLb;
}
- (UIView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-48*2, 150)];
        _cornerView.center = CGPointMake(ScreenW*0.5, ScreenH*0.5);
        _cornerView.layer.cornerRadius = 10;
        _cornerView.layer.masksToBounds = YES;
        _cornerView.backgroundColor = [UIColor whiteColor];
    }
    return _cornerView;
}
+ (void)exChangeOut:(UIView*)changeOutView dur:(CFTimeInterval)dur
{
    
    CAKeyframeAnimation* animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray* values = [NSMutableArray array];
    
    for (int m = 0; m<10; m++)
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale((m+1)*0.1,(m+1)*0.1,(m+1)*0.1)]];
    }
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1,1.1,1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,1.2,1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3,1.3,1.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,1.2,1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1,1.1,1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
}
+ (void)exChangeDisappear:(UIView*)disappearView dur:(CFTimeInterval)time
{
    
    CAKeyframeAnimation* animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = time;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray* values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 0.4)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0.2)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [disappearView.layer addAnimation:animation forKey:nil];
    
}
@end
