//
//  WARFriendCommentVoiceView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARFriendCommentVoiceView.h"
#import "WARCategory.h"
#import "WARMacros.h"
#import "WARCAVAudioPlayer.h"
#import "ReactiveObjC.h"
#import "WARCommentLayout.h"
#import "WARCommentsTool.h"
#import "WARMomentVoice.h"

@interface WARFriendVoiceProgressView()
@property (nonatomic, assign) CGFloat progress;
@end
@implementation WARFriendVoiceProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGSize size = rect.size;
    
    // 1. 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2. 描述路径, 矩形路径
    // 圆角矩形
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _progress, size.height) cornerRadius:size.height*0.5];
    
    [RGB(111,255,243) set];
    
    // 3 把路径保存到上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    // 4 把内容渲染到View上
    CGContextFillPath(ctx);
}

- (void)drawProgress:(CGFloat )progress{
    _progress = progress;
    [self setNeedsDisplay];
}

@end


@interface WARFriendCommentVoiceView()
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIImageView* voiceProgress;
@property (nonatomic, strong) WARFriendVoiceProgressView* progressView;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSTimer* countDownTimer;
@property (nonatomic, assign) CGFloat currentSecond;
@end

@implementation WARFriendCommentVoiceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _progress = 0;
        
        //self.backgroundColor = RGB(0,216,183);
        WARFriendVoiceProgressView* progressView = [[WARFriendVoiceProgressView alloc] init];
        //progressView.backgroundColor = RGB(0,216,183);
        [self addSubview:progressView];
        self.progressView = progressView;
        
        UIImageView* voiceProgress = [[UIImageView alloc] init];
        voiceProgress.image = [WARCommentsTool commentsGetImg:@"voice_progress"];
        [self addSubview:voiceProgress];
        self.voiceProgress = voiceProgress;
        
        UIButton* playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        [playBtn setImage:[WARCommentsTool commentsGetImg:@"voice_play"] forState:UIControlStateNormal];
        [playBtn setImage:[WARCommentsTool commentsGetImg:@"voice_stop"] forState:UIControlStateSelected];
        playBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        playBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        [self addSubview:playBtn];
        self.playBtn = playBtn;
        
        UILabel* timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:8];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        @weakify(self)
        [RACObserve([WARCAVAudioPlayer sharePlayer], audioPlayerState) subscribeNext:^(NSNumber*  _Nullable audioPlayerState) {
            @strongify(self)
            //NSLog(@"audioPlayerState = %@", audioPlayerState);
            if (audioPlayerState.integerValue == 0){// || (audioPlayerState.integerValue == 3)) {
                self.playBtn.selected = NO;
                [self.progressView drawProgress:0];
                [self timerInvalidate];
            }
        }];
    }
    return self;
}

- (void)setVoice:(WARMomentVoice *)voice{
    _voice = voice;
    self.timeLabel.text = [NSString stringWithFormat:@"%.f''", voice.duration.floatValue];
    self.currentSecond = voice.duration.floatValue;
}


- (void)playVoice:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(audioPlay:sender:voiceView:)]) {
        [self.delegate audioPlay:self.voice sender:sender voiceView:self];
    }
    
    if (self.audioPlayBlock) {
        self.audioPlayBlock(self.voice, sender, self);
    }
    
    if (sender.selected) {
        [self timer];
        [self countDownTimer];
    }
}

- (void)timeStart {
    self.progress += (self.progressView.width/(self.voice.duration.floatValue*10));
    if (self.progress >= self.progressView.width) { // 60s 时间到了，录音自动停止
        [self timerInvalidate];
    }
    [self.progressView drawProgress:self.progress];
}

- (void)timerInvalidate{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
    self.progress = 0.0f;
    self.currentSecond = self.voice.duration.floatValue;
    self.timeLabel.text = [NSString stringWithFormat:@"%.f''", self.voice.duration.floatValue];
}

- (void)countDownStart{
    self.currentSecond -= 1;
    if (self.currentSecond <= 0) {
        [self timerInvalidate];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%.f''", self.currentSecond];
}

#pragma mark - Timer
- (NSTimer *)timer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeStart) userInfo:nil repeats:YES];
    return _timer;
}

- (NSTimer *)countDownTimer{
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownStart) userInfo:nil repeats:YES];
    return _countDownTimer;
}

- (void)pauseVoicePlay{
    
    [self.progressView drawProgress:0];
    [self timerInvalidate];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.height * 0.5;
    
    self.progressView.frame = self.bounds;
    self.progressView.x = 15;
    self.progressView.width = self.width - 15 - 22;
    
    self.voiceProgress.frame = self.bounds;
    self.playBtn.frame = self.bounds;
    self.timeLabel.frame = CGRectFlatMake(self.width - 20, 0, 20, self.height);
}

+ (CGSize)voiceViewSize{
    UIImage *img = [WARCommentsTool commentsGetImg:@"voice_progress"];
    return img.size;
}


@end
