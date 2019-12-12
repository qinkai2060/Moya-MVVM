//
//  HKFloatBall.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/4.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKFloatBall.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARLayoutButton.h"

#define margin 10

@interface HKFloatBall()

/** playButton */
@property (nonatomic, strong) WARLayoutButton *playButton;

/** closeButton */
@property (nonatomic, strong) WARLayoutButton *closeButton;
/** fullScreenButton */
@property (nonatomic, strong) WARLayoutButton *fullScreenButton;

@end

@implementation HKFloatBall

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.closeButton];
//        [self addSubview:self.fullScreenButton];
//        [self addSubview:self.playButton];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}

- (WARLayoutButton *)playButton {
    if (!_playButton) {
        UIImage *image = [UIImage war_imageName:@"release_home_vide_play" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *stopImage = [UIImage war_imageName:@"stop" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _playButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake((self.bounds.size.width - 22) * 0.5, (self.bounds.size.height - 22) * 0.5, 22, 22);
        _playButton.imageSize = CGSizeMake(22, 22);
        _playButton.hidden = YES;
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton setImage:stopImage forState:UIControlStateSelected];
    }
    return _playButton;
}

- (WARLayoutButton *)closeButton {
    if (!_closeButton) {
        UIImage *image = [UIImage war_imageName:@"person_delete1" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _closeButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.bounds.size.width - 22, 0, 22, 22);
        _closeButton.imageSize = CGSizeMake(22, 22);
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:image forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (WARLayoutButton *)fullScreenButton {
    if (!_fullScreenButton) {
        UIImage *image = [UIImage war_imageName:@"bigbig" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _fullScreenButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.frame = CGRectMake(self.bounds.size.width - 22, self.bounds.size.height - 22, 22, 22);
        _fullScreenButton.imageSize = CGSizeMake(16, 16);
        [_fullScreenButton addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreenButton setImage:image forState:UIControlStateNormal];
    }
    return _fullScreenButton;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _iconImageView.backgroundColor = [UIColor blackColor];
        _iconImageView.userInteractionEnabled = NO;
        _iconImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _iconImageView.layer.masksToBounds = YES;
    };
    return _iconImageView;
}

- (void)playAction:(UIButton *)button {
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(floatBallPlay:stop:)]) {
        [self.delegate floatBallPlay:self stop:button.selected];
    }
}

- (void)closeAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(floatBallClose:)]) {
        [self.delegate floatBallClose:self];
    }
}

- (void)fullScreenAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(floatBallFullScreen:)]) {
        [self.delegate floatBallFullScreen:self];
    }
}

- (void)tap:(UIGestureRecognizer *)tap{
    
    if (self.playButton.hidden) {
        self.playButton.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(floatBallDidClick:)]) {
        [self.delegate floatBallDidClick:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.center = [touches.anyObject locationInView:[UIApplication sharedApplication].keyWindow];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endTouch:[touches.anyObject locationInView:[UIApplication sharedApplication].keyWindow]];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endTouch:[touches.anyObject locationInView:[UIApplication sharedApplication].keyWindow]];
}

- (void)endTouch:(CGPoint)point{
    CGRect frame = self.frame;
    if (point.x > kScreenWidth / 2) {
        frame.origin.x = kScreenWidth - frame.size.width -margin;
    }else{
        frame.origin.x = margin;
    }
    if (frame.origin.y > kScreenHeight - 64) {
        frame.origin.y = kScreenHeight -64;
    }else  if (frame.origin.y < 20) {
        frame.origin.y =  20;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
        
    }];
}


@end
