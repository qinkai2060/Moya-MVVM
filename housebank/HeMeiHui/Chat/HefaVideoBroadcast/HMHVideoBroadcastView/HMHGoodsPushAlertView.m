//
//  HMHGoodsPushAlertView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHGoodsPushAlertView.h"

@interface HMHGoodsPushAlertView ()

@property (nonatomic, strong) UIImageView *HMH_bgImageView;
@property (nonatomic, strong) UIImageView *HMH_iconImageView;
@property (nonatomic, strong) UILabel *HMH_contentLab;
@property (nonatomic, assign) NSInteger showTime; // 默认为3秒

// 定时器
@property (nonatomic, retain) NSTimer  *autoDismissTimer;

@end

@implementation HMHGoodsPushAlertView

- (instancetype)initWithFrame:(CGRect)frame userIconUrl:(NSString *)iconUrl  contentStr:(NSString *)contentStr isShowTime:(NSInteger)showTime{
    self = [super initWithFrame:frame];
    if (self) {
        if (showTime) {
            _showTime = showTime;
        }
        [self createUIWithUserIconUrl:iconUrl contentStr:contentStr];
    }
    return self;
}

- (void)createUIWithUserIconUrl:(NSString *)iconUrl  contentStr:(NSString *)contentStr{
    //
    _HMH_bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width - 10,0, self.frame.size.width, self.frame.size.height)];
    _HMH_bgImageView.backgroundColor =HEXCOLOR(0xF3344A);
    _HMH_bgImageView.userInteractionEnabled = YES;
    _HMH_bgImageView.layer.masksToBounds = YES;
    _HMH_bgImageView.layer.cornerRadius = 4;
    _HMH_bgImageView.alpha = 0.8;
    [self addSubview:_HMH_bgImageView];
    
    //
    self.HMH_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, _HMH_bgImageView.frame.size.height - 5, _HMH_bgImageView.frame.size.height - 5)];
    self.HMH_iconImageView.userInteractionEnabled = YES;
    self.HMH_iconImageView.layer.masksToBounds = YES;
    self.HMH_iconImageView.layer.cornerRadius = self.HMH_iconImageView.frame.size.height / 2;
    [_HMH_bgImageView addSubview:self.HMH_iconImageView];
    
    if (iconUrl.length > 6) {
        self.HMH_iconImageView.hidden = NO;
        
        [self.HMH_iconImageView sd_setImageWithURL:[iconUrl get_Image]];
        
       
    } else {
        self.HMH_iconImageView.hidden = YES;
    }

    //
    self.HMH_contentLab = [[UILabel alloc]init];
    
    if (iconUrl.length > 6) {
        self.HMH_contentLab.frame = CGRectMake(CGRectGetMaxX(self.HMH_iconImageView.frame) + 5, 0, _HMH_bgImageView.frame.size.width - CGRectGetMaxX(self.HMH_iconImageView.frame) - 10, _HMH_bgImageView.frame.size.height);
    } else {
        self.HMH_contentLab.frame = CGRectMake(5, 0, _HMH_bgImageView.frame.size.width - 10, _HMH_bgImageView.frame.size.height);

    }
    self.HMH_contentLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_contentLab.text = contentStr;
    self.HMH_contentLab.textColor = [UIColor whiteColor];
    [_HMH_bgImageView addSubview:self.HMH_contentLab];
    
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, _HMH_bgImageView.frame.size.width, _HMH_bgImageView.frame.size.height);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_bgImageView addSubview:btn];
    
}

- (void)btnClick:(UIButton *)btn{
    if (self.goodsClickBlock) {
        self.goodsClickBlock();
    }
    [self hide];
}

- (void)show{
    // dismiss bottomView
    if (self.autoDismissTimer==nil) {
        self.autoDismissTimer = [NSTimer timerWithTimeInterval:_showTime target:self selector:@selector(autoHidView:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHidView:) object:nil];
        
        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
        self.autoDismissTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(autoHidView:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];

    }
    [UIView animateWithDuration:0.6 animations:^{
        _HMH_bgImageView.frame = CGRectMake(10, 0, self.frame.size.width, self.frame.size.height);
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }];
}
// showTime时间后自动隐藏
- (void)autoHidView:(NSTimer *)timer{
    
    [self hide];
}

- (void)hide{
    if (self) {
        // 隐藏是 透明度淡化 变透明之后就移除
        [UIView animateWithDuration:0.6 animations:^{
//            CGRect rect = _HMH_bgImageView.frame;
//            rect.origin.x =  - self.frame.size.width - 10;
//            _HMH_bgImageView.frame = rect;
//            _HMH_bgImageView.backgroundColor =HEXCOLOR(0xF3344A);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];

        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
    }
}

@end
