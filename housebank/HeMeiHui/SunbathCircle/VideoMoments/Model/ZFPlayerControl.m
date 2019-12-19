//
//  ZFPlayerControl.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ZFPlayerControl.h"
#import "HFSliderView.h"

#import <UIImageView+YYWebImage.h>
@interface ZFPlayerControl ()<HFSliderViewDelegate>
@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UIImageView *bottomImageView;
@property(nonatomic,strong)UIButton *playbtn;
@property(nonatomic,strong)HFSliderView *slider;
@property (nonatomic,strong)UIImageView *bgImgView;
@property (nonatomic,strong) UILabel *currentDurationLb;
@property (nonatomic,strong) UILabel *totalDurationLb;

@property (nonatomic, strong)UIView *effectView;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) dispatch_block_t afterBlock;

@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

@property (nonatomic, assign) BOOL controlViewAppeared;

@property (nonatomic) CGFloat zf_lastOffsetY;

/// prepare时候是否显示loading,默认 NO.
@property (nonatomic, assign) BOOL prepareShowLoading;

@end
@implementation ZFPlayerControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isShowControl = YES;
        [self addSubview:self.bgImgView];
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self addSubview:self.playbtn];
        [self.bottomImageView addSubview:self.currentDurationLb];
        [self.bottomImageView addSubview:self.slider];
        [self.bottomImageView addSubview:self.totalDurationLb];
        self.autoHiddenTimeInterval = 2.5;
        self.prepareShowLoading = YES;

    }
    return self;
}
- (void)showCoverViewWithUrl:(NSString *)coverUrl withImageMode:(UIViewContentMode)contentMode {
    self.coverImageView.contentMode = contentMode;
    [self.coverImageView setImageURL:[NSURL URLWithString:coverUrl]];
    [self.bgImgView setImageURL:[NSURL URLWithString:coverUrl]];

}
- (void)resetControlView {
    self.playbtn.hidden = YES;
    self.slider.value = 0;
    self.slider.bufferValue = 0;
    self.currentDurationLb.text = @"00:00";
    self.totalDurationLb.text = @"00:00";
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

- (void)truncent {
      [self.videManager.view insertSubview:self.coverImageView atIndex:0];
      [self.coverImageView addSubview:self.effectView];
      [self.videManager.view insertSubview:self.coverImageView atIndex:1];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat navH = IS_IPHONE_X() ? 88:64;
     self.bgImgView.frame = self.bounds;
     self.topImageView.frame = CGRectMake(0, 0, kScreenWidth, navH);
     self.playbtn.center = self.center;
    [self hideControlViewWithAnimated:YES];
     self.bottomImageView.frame = CGRectMake(0, kScreenHeight-250, kScreenWidth, 250);
     self.currentDurationLb.frame = CGRectMake(13, (self.bottomImageView.height-16)*0.5, 35, 16);
     self.totalDurationLb.frame = CGRectMake(kScreenWidth-13-35,(self.bottomImageView.height-16)*0.5, 35, 16);
     self.slider.frame = CGRectMake(self.currentDurationLb.right+8, 0, self.totalDurationLb.left-8-(self.currentDurationLb.right+8), 20);
     self.slider.centerY = self.totalDurationLb.centerY;
     self.bgImgView.frame = self.bounds;
     self.effectView.frame = self.bgImgView.bounds;
     self.coverImageView.frame = self.videManager.view.bounds;
}

- (void)playAndPauseClick:(UIButton*)btn {
    
}
- (void)tapShowControl:(UITapGestureRecognizer*)tap {

    if (self.controlViewAppeared) {
        [self hideControlViewWithAnimated:YES];
    } else {
        /// 显示之前先把控制层复位，先隐藏后显示
        [self hideControlViewWithAnimated:NO];
        [self showControlViewWithAnimated:YES];
    }
}
/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    [self autoFadeOutControlView];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomImageView.hidden = NO;
        self.topImageView.hidden =  NO;
        self.playbtn.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

/// 隐藏控制层showControlViewWithAnimated
- (void)hideControlViewWithAnimated:(BOOL)animated {
     
    self.controlViewAppeared = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomImageView.hidden = YES;
        self.topImageView.hidden = YES;
        self.playbtn.hidden = YES;
    } completion:^(BOOL finished) {

    }];
}
- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    @weakify(self)
    self.afterBlock = dispatch_block_create(0, ^{
        @strongify(self)
        [self hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoHiddenTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [HFUntilTool convertTimeSecond:currentTime];
        self.currentDurationLb.text = currentTimeString;
        NSString *totalTimeString = [HFUntilTool convertTimeSecond:totalTime];
        self.totalDurationLb.text = totalTimeString;
        self.slider.value = videoPlayer.currentTime / videoPlayer.totalTime;
    }
}
- (void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state {
    if (state == ZFPlayerPlayStatePlaying) {
        self.playbtn.selected = NO;
//        self.failBtn.hidden = YES;
        /// 开始播放时候判断是否显示loading
        if (videoPlayer.loadState == ZFPlayerLoadStateStalled && !self.prepareShowLoading) {
//            [self.activity startAnimating];
        } else if ((videoPlayer.loadState == ZFPlayerLoadStateStalled || videoPlayer.loadState == ZFPlayerLoadStatePrepare) && self.prepareShowLoading) {
//            [self.activity startAnimating];
        }
    } else if (state == ZFPlayerPlayStatePaused) {
        self.playbtn.selected = YES;
        /// 暂停的时候隐藏loading
//        [self.activity stopAnimating];
//        self.failBtn.hidden = YES;
    } else if (state == ZFPlayerPlayStatePlayFailed) {
//        self.failBtn.hidden = NO;
//        [self.activity stopAnimating];
    }
}
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
        self.playbtn.selected = !videoPlayer.shouldAutoPlay;
    } else if (state == ZFPlayerLoadStatePlaythroughOK || state == ZFPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
        self.effectView.hidden = YES;
        videoPlayer.view.backgroundColor = [UIColor blackColor];
    
    }
    if (state == ZFPlayerLoadStateStalled && videoPlayer.isPlaying && !self.prepareShowLoading) {
//        [self.activity startAnimating];
    } else if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.isPlaying && self.prepareShowLoading) {
//        [self.activity startAnimating];
    } else {
//        [self.activity stopAnimating];
    }
}
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferTime / videoPlayer.totalTime;
}
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];

    }
    return _bgImgView;
}
- (UILabel *)currentDurationLb {
    if (!_currentDurationLb) {
        _currentDurationLb = [[UILabel alloc] init];
        _currentDurationLb.textColor = [UIColor whiteColor];
        _currentDurationLb.font = [UIFont systemFontOfSize:11];
        _currentDurationLb.text = @"02:00";
    }
    return _currentDurationLb;
}
- (UILabel *)totalDurationLb {
    if (!_totalDurationLb) {
        _totalDurationLb = [[UILabel alloc] init];
        _totalDurationLb.textColor = [UIColor whiteColor];
        _totalDurationLb.font = [UIFont systemFontOfSize:11];
        _totalDurationLb.text = @"02:00";
    }
    return _totalDurationLb;
}
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _topImageView;
}
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _bottomImageView;
}
- (HFSliderView *)slider {
    if (!_slider) {
        _slider = [[HFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[UIImage imageNamed:@"circle_slider"] forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}
- (UIButton *)playbtn {
    if (!_playbtn) {
        _playbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
        [_playbtn setImage:[UIImage imageNamed:@"circleplay"] forState:UIControlStateNormal];
        [_playbtn setImage:[UIImage imageNamed:@"pause_circle"] forState:UIControlStateSelected];
        [_playbtn addTarget:self action:@selector(playAndPauseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playbtn;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowControl:)];
        [_coverImageView addGestureRecognizer:tap];
    }
    return _coverImageView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

@end
