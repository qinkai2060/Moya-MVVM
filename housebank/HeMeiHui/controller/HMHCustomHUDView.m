//
//  CustomHUDView.m
//  VideoDownLoade
//
//  Created by Qianhong Li on 2018/3/1.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHCustomHUDView.h"


@interface HMHCustomHUDView ()

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation HMHCustomHUDView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIView];
    }
    return self;
}

- (void)createUIView{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self];
    self.HUD.userInteractionEnabled = YES;
    [self showMBProgressHUD];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 20, 50, 50);
    [_backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _backBtn.hidden = YES;
}
- (void)backBtnClick:(UIButton *)btn{
    [self hideMBProgressHUD];
    if (self.hubBtnClick) {
        self.hubBtnClick();
    }
}

- (void)showMBProgressHUD
{
//    [self setUserInteractionEnabled:NO];
    
    if (self.HUD.superview) {
        [self.HUD removeFromSuperview];
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    [self addSubview:self.HUD];
    self.HUD.userInteractionEnabled = YES;

    [self.HUD showAnimated:YES];
    
    [self addSubview:_backBtn];

    
//    [self performSelector:@selector(doTime) withObject:nil afterDelay:2];
}

//- (void)doTime{
//    _backBtn.hidden = NO;
////    [self hideMBProgressHUD];
//}

- (void)hideMBProgressHUD
{
    [self setUserInteractionEnabled:YES];
    [self.HUD hideAnimated:YES];
    
    if (self.HUD.superview) {
        [self.HUD removeFromSuperview];
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

}


@end
