//
//  AliWMPlayerView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/7/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "AliWMPlayerView.h"
#import "WMLightView.h"
#define iOS8 [UIDevice currentDevice].systemVersion.floatValue >= 8.0

#define BUTTON_TAT_PLAY 8000
#define BUTTON_TAT_STOP BUTTON_TAT_PLAY+1
#define BUTTON_TAT_PAUSE BUTTON_TAT_STOP+1
#define BUTTON_TAT_RESUME BUTTON_TAT_PAUSE+1
#define BUTTON_TAT_REPLAY BUTTON_TAT_RESUME+1
#define BUTTON_TAT_TOOL BUTTON_TAT_REPLAY+1

#define WMPlayerSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMPlayerFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMPlayerImage(file)      [UIImage imageNamed:WMPlayerSrcName(file)] ? :[UIImage imageNamed:WMPlayerFrameworkSrcName(file)]

//整个屏幕代表的时间
#define TotalScreenTime 90
#define LeastDistance 15

static void *PlayViewCMTimeValue = &PlayViewCMTimeValue;
static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface AliWMPlayerView ()<UIGestureRecognizerDelegate,AliyunVodPlayerDelegate>{
    //用来判断手势是否移动过
    BOOL _hasMoved;
    //记录触摸开始时的视频播放的时间
    float _touchBeginValue;
    //记录触摸开始亮度
    float _touchBeginLightValue;
    //记录触摸开始的音量
    float _touchBeginVoiceValue;
    
    //总时间
    CGFloat totalTime;
}
@property (nonatomic, assign) BOOL isLock; // 是否显示锁
/** 是否初始化了播放器 */
@property (nonatomic, assign) BOOL isInitPlayer;
///记录touch开始的点
@property (nonatomic,assign) CGPoint touchBeginPoint;

///手势控制的类型
///判断当前手势是在控制进度?声音?亮度?
@property (nonatomic, assign) VodPlayerControlType controlType;
// 判断当滑动快进后退时 确保声音和亮度不被调用
@property (nonatomic, assign) BOOL controlJudge;
// 判断当声音和亮度被调用的时候 确保快进和后退不被调用
@property (nonatomic, assign) BOOL isLightJudge;
// 判断当前的手势是否是声音
@property (nonatomic, assign) BOOL isVolmControl;

@property (nonatomic, assign) BOOL isUpVolume;

@property (nonatomic, assign) BOOL isVideoPrepareDone;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

//视频进度条的单击事件
@property (nonatomic, strong) UITapGestureRecognizer *tap;
//@property (nonatomic, assign) BOOL isDragingSlider;//是否点击了按钮的响应事件
// 显示播放时间的UILabel
@property (nonatomic,strong) UILabel        *leftTimeLabel;
@property (nonatomic,strong) UILabel        *rightTimeLabel;

///进度滑块
@property (nonatomic,strong) UISlider       *progressSlider;
///声音滑块
@property (nonatomic,strong) UISlider       *volumeSlider;
//显示缓冲进度
@property (nonatomic,strong) UIProgressView *loadingProgress;

@end

@implementation AliWMPlayerView{
    UITapGestureRecognizer* singleTap;
}

/**
 *  storyboard、xib的初始化方法
 */
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initWMPlayer];
}
/**
 *  initWithFrame的初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWMPlayer];
    }
    return self;
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark - timerRun
- (void)timerRun:(NSTimer *)sender{
    if (!self.vodPlayer.duration){
        self.progressSlider.minimumValue = 0.0;
        return;
    }
    if (self.vodPlayer) {
        self.leftTimeLabel.text = [self convertTime:self.vodPlayer.currentTime];
        
        [self.progressSlider setValue:self.vodPlayer.currentTime animated:YES];
        if (self.vodPlayer.playerState == AliyunVodPlayerStateFinish) { // 当播放完之后 做的处理
            [self.progressSlider setValue:0.0 animated:YES];
            self.leftTimeLabel.text = [self convertTime:0.0];
        }
        [self.loadingProgress setProgress:self.vodPlayer.loadedTime];
    }
}

//快进⏩和快退的view
-(void)creatFF_View{
    self.FF_View = [[NSBundle mainBundle] loadNibNamed:@"FastForwardView" owner:self options:nil].lastObject;
    self.FF_View.hidden = YES;
    self.FF_View.layer.cornerRadius = 10.0;
    [self.vodContentView addSubview:self.FF_View];
    
    [self.FF_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(120));
        make.height.equalTo(@60);
    }];
}

/**
 *  初始化WMPlayer的控件，添加手势，添加通知，添加kvo等
 */
-(void)initWMPlayer{
    // 当视频播放失败时用
    self.isVideoPlayFail = NO;
    
    self.isVideoPrepareDone = NO;

    if (!_vodPlayer) {
        _vodPlayer = [[AliyunVodPlayer alloc] init];
        _vodPlayer.delegate = self;
        [_vodPlayer setAutoPlay:NO];
        _vodPlayer.quality=  0;
        _vodPlayer.circlePlay = NO;
    }
    
    //wmplayer内部的一个view，用来管理子视图
    self.vodContentView = [[UIView alloc]init];
    self.vodContentView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.vodContentView];
    [self.vodContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

//     playerView
    self.playerView = [[UIView alloc] init];
    self.playerView.frame = CGRectMake(0, 0, self.vodContentView.frame.size.width, self.vodContentView.frame.size.height);
    self.playerView = self.vodPlayer.playerView;
    [self.vodContentView addSubview:self.playerView];

    // ==========================
//    self.vodContentView = [[UIView alloc] init];
////    self.vodContentView.frame = CGRectMake(0, 0, self.vodContentView.frame.size.width, self.vodContentView.frame.size.height);
//    self.vodContentView = self.vodPlayer.playerView;
//    [self addSubview:self.vodContentView];
//    //autoLayout contentView
//    [self.vodContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
    //创建fastForwardView
    [self creatFF_View];
    
    //设置默认值
    self.seekTime = 0.00;
    self.enableVolumeGesture = YES;
    
    //小菊花
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //    UIActivityIndicatorViewStyleWhiteLarge 的尺寸是（37，37）
    //    UIActivityIndicatorViewStyleWhite 的尺寸是（22，22）
    [self.vodContentView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vodContentView);
    }];
    [self.loadingView startAnimating];
    
    //topView
    self.topView = [[UIImageView alloc]init];
    self.topView.image = WMPlayerImage(@"top_shadow");
    self.topView.userInteractionEnabled = YES;
    //    self.topView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
    [self.vodContentView addSubview:self.topView];
    //autoLayout topView
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vodContentView).with.offset(0);
        make.right.equalTo(self.vodContentView).with.offset(0);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.vodContentView).with.offset(0);
    }];
    
    //bottomView
    self.bottomView = [[UIImageView alloc]init];
    self.bottomView.image = WMPlayerImage(@"bottom_shadow");
    self.bottomView.userInteractionEnabled = YES;
    //    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
    // 默认底部的view为隐藏的
    self.bottomView.alpha = 0.0;
    [self.vodContentView addSubview:self.bottomView];
    
    //autoLayout bottomView
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vodContentView).with.offset(0);
        make.right.equalTo(self.vodContentView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.vodContentView).with.offset(0);
        
    }];
    [self setAutoresizesSubviews:NO];
    
    //_fullScreenBtn
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenBtn.showsTouchWhenHighlighted = YES;
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn setImage:WMPlayerImage(@"fullscreen") forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:WMPlayerImage(@"nonfullscreen") forState:UIControlStateSelected];
    [self.bottomView addSubview:self.fullScreenBtn];
    //autoLayout fullScreenBtn
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(50);
        
    }];
    
    //leftTimeLabel显示左边的时间进度
    self.leftTimeLabel = [[UILabel alloc]init];
    self.leftTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.leftTimeLabel.textColor = [UIColor whiteColor];
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:11];
    [self.bottomView addSubview:self.leftTimeLabel];
    //autoLayout timeLabel
    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.bottomView).with.offset(0);
    }];
    self.leftTimeLabel.text = [self convertTime:0.0];//设置默认值
    
    //rightTimeLabel显示右边的总时间
    self.rightTimeLabel = [[UILabel alloc]init];
    self.rightTimeLabel.textAlignment = NSTextAlignmentRight;
    self.rightTimeLabel.textColor = [UIColor whiteColor];
    self.rightTimeLabel.backgroundColor = [UIColor clearColor];
    self.rightTimeLabel.font = [UIFont systemFontOfSize:11];
    [self.bottomView addSubview:self.rightTimeLabel];
    //autoLayout timeLabel
    [self.rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.bottomView).with.offset(0);
    }];
    self.rightTimeLabel.text = [self convertTime:0.0];//设置默认值
    
    //_closeBtn  返回按钮
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.showsTouchWhenHighlighted = YES;
    [_closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setImage:WMPlayerImage(@"play_back.png") forState:UIControlStateNormal];
    [_closeBtn setImage:WMPlayerImage(@"play_back.png") forState:UIControlStateSelected];
    [self.topView addSubview:_closeBtn];
    //autoLayout _closeBtn
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.topView).with.offset(20);
    }];
    
    //_shareBtn
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.showsTouchWhenHighlighted = YES;
    [_shareBtn addTarget:self action:@selector(shareTheVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setImage:[UIImage imageNamed:@"VL_ShareImage"] forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"VL_ShareImage"] forState:UIControlStateSelected];
    [self.topView addSubview:_shareBtn];
    
    //    autoLayout _shareBtn
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).with.offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.topView).with.offset(20);
    }];
    
    //titleLabel
    self.titleLabel = [[UILabel alloc]init];
    //    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.topView addSubview:self.titleLabel];
    //autoLayout titleLabel
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(45);
        make.right.equalTo(self.topView).with.offset(-45);
        make.center.equalTo(self.topView);
        make.top.equalTo(self.topView).with.offset(0);
    }];
    
    //_playOrPauseBtn
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playOrPauseBtn setImage:WMPlayerImage(@"pause") forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:WMPlayerImage(@"play") forState:UIControlStateSelected];
    
    [self.bottomView addSubview:self.playOrPauseBtn];
    //autoLayout _playOrPauseBtn
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(50);
        
    }];
    self.playOrPauseBtn.selected = YES;//默认状态，即默认是不自动播放
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[UISlider class]]) {
            self.volumeSlider = (UISlider *)view;
        }
    }
    [[UIApplication sharedApplication].keyWindow addSubview:[WMLightView sharedLightView]];
    
    //slider
    self.progressSlider = [[UISlider alloc]init];
    self.progressSlider.minimumValue = 0.0;
    [self.progressSlider setThumbImage:WMPlayerImage(@"dot")  forState:UIControlStateNormal];
    self.progressSlider.minimumTrackTintColor = [UIColor greenColor];
    self.progressSlider.maximumTrackTintColor = [UIColor clearColor];
    self.progressSlider.value = 0.0;//指定初始值
    //进度条的拖拽事件
    [self.progressSlider addTarget:self action:@selector(stratDragSlide:)  forControlEvents:UIControlEventValueChanged];
    //进度条的点击事件
    [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventTouchUpInside];
    
    //给进度条添加单击手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.tap.delegate = self;
    [self.progressSlider addGestureRecognizer:self.tap];
    [self.bottomView addSubview:self.progressSlider];
    self.progressSlider.backgroundColor = [UIColor clearColor];
    
    //autoLayout slider
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        make.center.equalTo(self.bottomView);
    }];
    
    self.loadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.loadingProgress.progressTintColor = [UIColor clearColor];
    self.loadingProgress.trackTintColor    = [UIColor lightGrayColor];
    [self.bottomView addSubview:self.loadingProgress];
    [self.loadingProgress setProgress:0.0 animated:NO];
    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressSlider);
        make.right.equalTo(self.progressSlider);
        make.center.equalTo(self.progressSlider);
        make.height.mas_equalTo(1.5);
    }];
    
    [self.bottomView sendSubviewToBack:self.loadingProgress];
    
    // 添加锁屏按钮
    self.lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lockBtn.frame = CGRectMake(10, self.vodContentView.frame.size.height / 2 - 25, 50, 50);
    self.lockBtn.showsTouchWhenHighlighted = YES;
    [self.lockBtn addTarget:self action:@selector(lockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn setImage:[UIImage imageNamed:@"Video_unlockImage"] forState:UIControlStateNormal];
    [self.lockBtn setImage:[UIImage imageNamed:@"Video_lockImage"] forState:UIControlStateSelected];
    self.lockBtn.hidden = YES;
    self.isLock = NO; // 默认不显示锁
    [self.vodContentView addSubview:self.lockBtn];
    
//    // 单击的 Recognizer
//    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    singleTap.numberOfTapsRequired = 1; // 单击
//    singleTap.numberOfTouchesRequired = 1;
//    [self.vodContentView addGestureRecognizer:singleTap];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTouchesRequired = 1; //手指数
    doubleTap.numberOfTapsRequired = 2; // 双击
    // 解决点击当前view时候响应其他控件事件
    [singleTap setDelaysTouchesBegan:YES];
    [doubleTap setDelaysTouchesBegan:YES];
    [singleTap requireGestureRecognizerToFail:doubleTap];//如果双击成立，则取消单击手势（双击的时候不回走单击事件）
    [self.vodContentView addGestureRecognizer:doubleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark 分享按钮的点击事件
- (void)shareTheVideo:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(videoPlayerDoShare)]) {
        [self.delegate videoPlayerDoShare];
    }
}

#pragma mark - lockBtnClick 锁屏按钮的点击事件
- (void)lockBtnClick:(UIButton *)btn{
    if (self.isLock) { // 锁屏
        btn.selected = NO;
        self.isLock = NO;
        [self showControlView];
    } else {
        btn.selected = YES;
        self.isLock = YES;
        [self hiddenControlView];
        btn.hidden = NO;
    }
}

#pragma mark
#pragma mark lazy 加载失败的label
-(UILabel *)loadFailedLabel{
    if (_loadFailedLabel==nil) {
        _loadFailedLabel = [[UILabel alloc]init];
        _loadFailedLabel.backgroundColor = [UIColor clearColor];
        _loadFailedLabel.textColor = [UIColor whiteColor];
        _loadFailedLabel.textAlignment = NSTextAlignmentCenter;
        _loadFailedLabel.text = @"视频加载失败";
        _loadFailedLabel.hidden = YES;
        [self.vodContentView addSubview:_loadFailedLabel];
        
        [_loadFailedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.vodContentView);
            make.width.equalTo(self.vodContentView);
            make.height.equalTo(@30);
        }];
    }
    return _loadFailedLabel;
}
#pragma mark
#pragma mark 进入后台
- (void)appDidEnterBackground:(NSNotification*)note{
    //    if (self.state !=AliyunVodPlayerStatePause) {
    //        [self.player pause];
    //        self.playOrPauseBtn.selected = NO;
    //    }
    if (self.playOrPauseBtn.isSelected==NO) {//如果是播放中，则暂停播放
        //        NSArray *tracks = [self.currentItem tracks];
        //        for (AVPlayerItemTrack *playerItemTrack in tracks) {
        //            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
        //                playerItemTrack.enabled = YES;
        //            }
        //        }
        //        self.playerLayer.player = nil;
        //        [self.player play];
        //
        //        self.state = WMPlayerStatePlaying;
        
        self.playOrPauseBtn.selected = YES;
        
        [self.vodPlayer pause];
        self.state = VodWMPlayerStateStopped;
    }else{
        self.playOrPauseBtn.selected = YES;
        self.state = VodWMPlayerStateStopped;
    }
}
#pragma mark
#pragma mark 进入前台
- (void)appWillEnterForeground:(NSNotification*)note
{
    if (self.playOrPauseBtn.isSelected==NO) {//如果是播放中，则继续播放
        //        NSArray *tracks = [self.currentItem tracks];
        //        for (AVPlayerItemTrack *playerItemTrack in tracks) {
        //            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
        //                playerItemTrack.enabled = YES;
        //            }
        //        }
        //        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        //        self.playerLayer.frame = self.contentView.bounds;
        //        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        //        [self.contentView.layer insertSublayer:_playerLayer atIndex:0];
        //        [self.player play];
        //        self.state = WMPlayerStatePlaying;
        //        NSLog(@"3333333%s WMPlayerStatePlaying",__FUNCTION__);
        
        self.playOrPauseBtn.selected = YES;
        [self.vodPlayer pause];
        self.state = VodWMPlayerStateStopped;
        
    }else{
        self.playOrPauseBtn.selected = YES;
        self.state = VodWMPlayerStateStopped;
    }
}
#pragma mark
#pragma mark appwillResignActive
- (void)appwillResignActive:(NSNotification *)note{
    //    NSLog(@"appwillResignActive");
}
- (void)appBecomeActive:(NSNotification *)note{
    //    NSLog(@"appBecomeActive");
}

#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.playerLayer.frame = self.bounds;
    
}
#pragma mark - 全屏按钮点击func
-(void)fullScreenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:clickedFullScreenButton:)]) {
        [self.delegate wmplayer:self clickedFullScreenButton:sender];
    }
}
#pragma mark - 关闭按钮点击func
-(void)colseTheVideo:(UIButton *)sender{
    if (!_isFullscreen) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:clickedCloseButton:)]) {
        [self.delegate wmplayer:self clickedCloseButton:sender];
    }
}

///获取视频当前播放的时间
- (double)currentTime{
    if (self.vodPlayer) {
        return self.vodPlayer.currentTime;
    }else{
        return 0.0;
    }
}

- (void)setCurrentTime:(double)time{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vodPlayer seekToTime:time];
    });
}
#pragma mark  PlayOrPause
- (void)PlayOrPause:(UIButton *)sender{
    if (sender.selected) {
        if (sender.tag == BUTTON_TAT_PAUSE) { // 如果是暂停的话 就掉继续播放
            sender.tag = BUTTON_TAT_RESUME;
        } else { // 如果不是暂停状态的话 就播放
            sender.tag = BUTTON_TAT_PLAY;
        }
    } else {
        sender.tag = BUTTON_TAT_PAUSE;
    }
    
    if ([self.delegate respondsToSelector:@selector(wmplayer:clickedPlayOrPauseButton:)]) {
        [self.delegate wmplayer:self clickedPlayOrPauseButton:sender];
    }
    switch (sender.tag) {
        case BUTTON_TAT_PLAY:{
            if (self.vodPlayer.playerState == AliyunVodPlayerStateIdle || self.vodPlayer.playerState == AliyunVodPlayerStateStop) {
                self.vodPlayer.autoPlay = YES;
                
//                [self.vodPlayer prepareWithLiveTimeUrl:[NSURL URLWithString:self.URLString]];
                [self.vodPlayer prepareWithURL:[NSURL URLWithString:self.URLString]];

            } else if (self.vodPlayer.playerState == AliyunVodPlayerStateFinish){
                [self.vodPlayer replay];
            } else {
                [self.vodPlayer start];
            }
            [self.timer fireDate];
        }
            break;
            
        case BUTTON_TAT_PAUSE:{
            [self.vodPlayer pause];
        }
            break;
            
        case BUTTON_TAT_RESUME:{
            [self.vodPlayer resume];
        }
            break;
        case BUTTON_TAT_STOP:{
            [self.vodPlayer stop];
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
            break;
        default:
            break;
    }
    sender.selected = !sender.selected;
}

///播放
-(void)play{
    if (self.isInitPlayer == NO) {
        self.isInitPlayer = YES;
        [self creatWMPlayerAndReadyToPlay];
//        [self.vodPlayer start];
        self.playOrPauseBtn.selected = NO;
    }else{
        if (self.state==VodWMPlayerStateStopped||self.state ==VodWMPlayerStatePause) {
            self.state = VodWMPlayerStatePlaying;
            [self.vodPlayer start];
            self.playOrPauseBtn.selected = NO;
        }else if(self.state ==VodWMPlayerStateFinished){
            if (_isPreviewPlayAgain) { // 只和观看预告片有关
                self.state = VodWMPlayerStatePlaying;

                [self.vodPlayer replay];
                self.playOrPauseBtn.selected = NO;
            }
        }
    }
}
///暂停
-(void)pause{
    if (self.state==VodWMPlayerStatePlaying || self.state == VodWMPlayerStateBuffering) {
        self.state = VodWMPlayerStateStopped;
    }
    [self.vodPlayer pause];
    self.playOrPauseBtn.selected = YES;
}

#pragma mark
#pragma mark - 单击手势方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissBottomView:) object:nil];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:singleTaped:)]) {
        [self.delegate wmplayer:self singleTaped:sender];
    }
    
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    self.autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
    
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isLock) { // 锁屏
            if (self.lockBtn.hidden) {
                [self showControlView];
            } else {
                [self hiddenControlView];
            }
        } else {
            if (self.bottomView.alpha == 1.0) {
                [self hiddenControlView];
            }else{
                [self showControlView];
            }
        }
    } completion:^(BOOL finish){
    }];
}
#pragma mark - 双击手势方法
- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap{
    //    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:doubleTaped:)]) {
    //        [self.delegate wmplayer:self doubleTaped:doubleTap];
    //    }
    //    [self PlayOrPause:self.playOrPauseBtn];
    //
    //    [self showControlView];
}
/**
 *  重写placeholderImage的setter方法，处理自己的逻辑
 */
- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    if (placeholderImage) {
        self.vodContentView.layer.contents = (id) self.placeholderImage.CGImage;
    } else {
        UIImage *image = WMPlayerImage(@"");
        self.vodContentView.layer.contents = (id) image.CGImage;
    }
}

-(void)creatWMPlayerAndReadyToPlay{
    //设置player的参数
    
    [self.vodPlayer prepareWithURL:[NSURL URLWithString:self.URLString]];
    
//    self.player = [AVPlayer playerWithPlayerItem:_currentItem];
//    self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    //AVPlayerLayer
//    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    self.playerLayer.frame = self.contentView.layer.bounds;
//    //WMPlayer视频的默认填充模式，AVLayerVideoGravityResizeAspect
//    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
//    [self.contentView.layer insertSublayer:_playerLayer atIndex:0];
    self.state = VodWMPlayerStateBuffering;
}
/**
 *  重写URLString的setter方法，处理自己的逻辑，
 */
- (void)setURLString:(NSString *)URLString{
    if (_URLString==URLString) {
        return;
    }
    _URLString = URLString;
    
    if (self.isInitPlayer) {
        self.state = VodWMPlayerStateBuffering;
    }else{
        self.state = VodWMPlayerStateStopped;
        //here
        [self.loadingView stopAnimating];
    }
    
    if (!self.placeholderImage) {//开发者可以在此处设置背景图片
        UIImage *image = WMPlayerImage(@"");
        self.vodContentView.layer.contents = (id) image.CGImage;
    }
}

/**
 *  设置播放的状态
 *  @param state WMPlayerState
 */
- (void)setState:(CustomWMPlayerState)state{
    _state = state;
    // 控制菊花显示、隐藏
    if (state == VodWMPlayerStateBuffering) {
        [self.loadingView startAnimating];
    }else if(state == VodWMPlayerStatePlaying){
        //here
        [self.loadingView stopAnimating];//
    }else if(state == VodWMPlayerStatePause){
        //here
        [self.loadingView stopAnimating];//
    }
    else{
        //here
        [self.loadingView stopAnimating];//
    }
}

#pragma mark - AliyunVodPlayer代理方法
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
        {
            self.isVideoPlayFail = NO;
            self.isVideoPrepareDone = YES;
            
            [self.loadingView stopAnimating];//
            // 单击的 Recognizer
            singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTap.numberOfTapsRequired = 1; // 单击
            singleTap.numberOfTouchesRequired = 1;
            [self.vodContentView addGestureRecognizer:singleTap];

            // 当视频加载完之后 显示底部的view
            self.bottomView.alpha = 1.0;

            //5s dismiss bottomView
            if (self.autoDismissTimer==nil) {
                self.autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
            }

            if (self.vodPlayer.duration) {
                totalTime = self.vodPlayer.duration;
                if (!isnan(totalTime)) {
                    self.progressSlider.maximumValue = totalTime;
                }
            }
            //监听播放状态
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
            AliyunVodPlayerVideo *videoModel = [self.vodPlayer getAliyunMediaInfo];
            if (videoModel) {
                self.rightTimeLabel.text = [self convertTime:videoModel.duration];
            }else{
                self.rightTimeLabel.text = [self convertTime:self.vodPlayer.duration];
            }
            
            if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerReadyToPlay:WMPlayerStatus:)]) {
                [self.delegate wmplayerReadyToPlay:self WMPlayerStatus:VodWMPlayerStatePlaying];
            }
        }
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发
            self.isVideoPlayFail = NO;
            [self.loadingView stopAnimating];//

            break;
        case AliyunVodPlayerEventFirstFrame:
            //播放视频首帧显示出来时触发
            self.isVideoPlayFail = NO;
            [self.loadingView stopAnimating];//

            break;
        case AliyunVodPlayerEventPause:
            //视频暂停时触发
            self.isVideoPlayFail = NO;
            [self.loadingView stopAnimating];//

            break;
        case AliyunVodPlayerEventStop:
            //主动使用stop接口时触发
            self.isVideoPlayFail = NO;
            [self.loadingView stopAnimating];//

            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
        {
            self.isVideoPlayFail = NO;

            [self.loadingView stopAnimating];//

            if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerFinishedPlay:)]) {
                [self.delegate wmplayerFinishedPlay:self];
            }
            
            [self seekToTimeToPlay:self.vodPlayer.duration];
            
            // 视频播放完成后 调replay方法 加载视频首针 为了解决进度条播放完之后不能滑动的问题(暂未用)
//            [self.vodPlayer replay];
            
            [self showControlView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.state = VodWMPlayerStateFinished;
                self.playOrPauseBtn.selected = YES;
//                [self.vodPlayer pause];
            });
        }
            break;
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            [self.loadingView startAnimating];//
            
            break;
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            self.isVideoPlayFail = NO;

            [self.loadingView stopAnimating];//
            
            if (self.playOrPauseBtn.selected) {
                [self.vodPlayer pause];
            }
            break;
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
        {
            self.isVideoPlayFail = NO;

            [self.loadingView stopAnimating];//

            // 当SeekToTime方法执行完成之后 重新开启定时器
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
            break;
        default:
            [self.loadingView stopAnimating];//
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    [self.loadingView stopAnimating];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:errorModel.errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//    [alert show];
    
    self.isVideoPlayFail = YES;
    if (errorModel.errorMsg) {
        self.loadFailedLabel.hidden = NO;
        [self bringSubviewToFront:self.loadFailedLabel];
        //here
        [self.loadingView stopAnimating];
    }

    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerFailedPlay:WMPlayerStatus:)]) {
        [self.delegate wmplayerFailedPlay:self WMPlayerStatus:VodWMPlayerStateFailed];
    }
}
- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer *)vodPlayer{
}

- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer {
    
}


///显示操作栏view
-(void)showControlView{
    [UIView animateWithDuration:0.5 animations:^{
        //        self.bottomView.alpha = 1.0;
        //        self.topView.alpha = 1.0;        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:isHiddenTopAndBottomView:withBottomView:topView:lockBtn:isLock:)]) {
            [self.delegate wmplayer:self isHiddenTopAndBottomView:NO withBottomView:_bottomView topView:_topView lockBtn:_lockBtn isLock:_isLock];
        }
    } completion:^(BOOL finish){
        
    }];
}

///隐藏操作栏view
-(void)hiddenControlView{
    [UIView animateWithDuration:0.5 animations:^{
        //        self.bottomView.alpha = 0.0;
        //        self.topView.alpha = 0.0;
        self.lockBtn.hidden = YES;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:isHiddenTopAndBottomView:withBottomView:topView:lockBtn:isLock:)]) {
            [self.delegate wmplayer:self isHiddenTopAndBottomView:YES withBottomView:_bottomView topView:_topView lockBtn:_lockBtn isLock:_isLock];
        }
    } completion:^(BOOL finish){
        
    }];
}
#pragma mark--开始拖曳sidle
- (void)stratDragSlide:(UISlider *)slider{
//    self.isDragingSlider = YES;
    if (self.isVideoPlayFail) {
        return;
    }
    // 是为了防止在拖拽进度条时 出现进度条的抖动
    if (self.timer) {
        [self.timer invalidate];
    }
    if (self.vodPlayer && (self.vodPlayer.playerState == AliyunVodPlayerStateLoading || self.vodPlayer.playerState == AliyunVodPlayerStatePause ||
                           self.vodPlayer.playerState == AliyunVodPlayerStatePlay)) {
        
        //        self.mProgressCanUpdate = NO;
//        [self.vodPlayer seekToTime:slider.value];
        [self seekToTimeToPlay:slider.value];
        self.leftTimeLabel.text = [self convertTime:slider.value];

    }else{
        slider.value = 0.0;
    }
}
#pragma mark - 更新播放进度
- (void)updateProgress:(UISlider *)slider{
//    self.isDragingSlider = NO;
    if (self.isVideoPlayFail) {
        return;
    }
//    [self.vodPlayer seekToTime:slider.value];
    [self seekToTimeToPlay:slider.value];
}
#pragma mark 给进度条添加单击手势
- (void)actionTapGesture:(UITapGestureRecognizer *)sender{
    if (self.isVideoPlayFail) {
        return;
    }
    CGPoint touchLocation = [sender locationInView:self.progressSlider];
    CGFloat value = (self.progressSlider.maximumValue - self.progressSlider.minimumValue) * (touchLocation.x/self.progressSlider.frame.size.width);
    [self.progressSlider setValue:value animated:YES];
    
    [self seekToTimeToPlay:self.progressSlider.value];
}

#pragma mark autoDismissBottomView
/*
 AliyunVodPlayerStateIdle = 0,           //空转，闲时，静态
 AliyunVodPlayerStateError,              //错误
 AliyunVodPlayerStatePrepared,           //已准备好
 AliyunVodPlayerStatePlay,               //播放
 AliyunVodPlayerStatePause,              //暂停
 AliyunVodPlayerStateStop,               //停止
 AliyunVodPlayerStateFinish,             //播放完成
 AliyunVodPlayerStateLoading             //加载中
 */
-(void)autoDismissBottomView:(NSTimer *)timer{
    if (self.vodPlayer.playerState==AliyunVodPlayerStatePlay) {
        if (self.bottomView.alpha==1.0) {
            [self hiddenControlView];//隐藏操作栏
        }
    }
}
/**
 *  跳到time处播放
 *  @param seekTime这个时刻，这个时间点
 */
- (void)seekToTimeToPlay:(double)time{
    if (self.vodPlayer && self.vodPlayer.playerState != AliyunVodPlayerStateError) {
        if (time>=totalTime) {
            time = 0.0;
        }
        if (time<0) {
            time=0.0;
        }
        //        int32_t timeScale = self.player.currentItem.asset.duration.timescale;
        //currentItem.asset.duration.timescale计算的时候严重堵塞主线程，慎用
        /* A timescale of 1 means you can only specify whole seconds to seek to. The timescale is the number of parts per second. Use 600 for video, as Apple recommends, since it is a product of the common video frame rates like 50, 60, 25 and 24 frames per second*/
        
        [self.vodPlayer seekToTime:time];
        
        if (time == 0.0) {
            [self showControlView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.state = VodWMPlayerStateFinished;
                self.playOrPauseBtn.selected = YES;
                [self.vodPlayer pause];
            });
        }
    }
}
- (NSString *)convertTime:(float)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    return [[self dateFormatter] stringFromDate:d];
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    }
    return _dateFormatter;
}
#pragma mark - touches   手势
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 判断视频是否已经准备好播放
    if (!self.isVideoPrepareDone) {
        return;
    }
    // 如果视频加载失败 就return
    if (self.isVideoPlayFail) {
        return;
    }
    //这个是用来判断, 如果有多个手指点击则不做出响应
    UITouch * touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1 || event.allTouches.count > 1) {
        return;
    }
    //    这个是用来判断, 手指点击的是不是本视图, 如果不是则不做出响应
    if (![[(UITouch *)touches.anyObject view] isEqual:self.vodContentView] &&  ![[(UITouch *)touches.anyObject view] isEqual:self]) {
//        return;
    }
    [super touchesBegan:touches withEvent:event];
    
    //触摸开始, 初始化一些值
    _hasMoved = NO;
    // 控制滑块
    _controlJudge = NO;
    // 控制声音和亮度
    _isLightJudge = NO;
    // 控制声音
    _isVolmControl = NO;
    
    _isUpVolume = NO;
    
    _touchBeginValue = self.progressSlider.value;
    //位置
    _touchBeginPoint = [touches.anyObject locationInView:self];
    //亮度
    _touchBeginLightValue = [UIScreen mainScreen].brightness;
    //声音
    _touchBeginVoiceValue = _volumeSlider.value;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 判断视频是否已经准备好播放
    if (!self.isVideoPrepareDone) {
        return;
    }
    // 如果视频加载失败 就return
    if (self.isVideoPlayFail) {
        return;
    }
    
    if (self.isLock) { // 如果是锁屏 则不操作
        return;
    }
    UITouch * touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1  || event.allTouches.count > 1) {
        return;
    }
    if (![[(UITouch *)touches.anyObject view] isEqual:self.vodContentView] && ![[(UITouch *)touches.anyObject view] isEqual:self]) {
//        return;
    }
    [super touchesMoved:touches withEvent:event];
    
    if (self.timer) {
        [self.timer invalidate];
    }

    //如果移动的距离过于小, 就判断为没有移动
    CGPoint tempPoint = [touches.anyObject locationInView:self];
    if (fabs(tempPoint.x - _touchBeginPoint.x) < LeastDistance && fabs(tempPoint.y - _touchBeginPoint.y) < LeastDistance) {
        return;
    }
    _hasMoved = YES;
    //如果还没有判断出使什么控制手势, 就进行判断
    //滑动角度的tan值
    float tan = fabs(tempPoint.y - _touchBeginPoint.y)/fabs(tempPoint.x - _touchBeginPoint.x);
    // if (tan < 1/sqrt(3))  // 当滑动角度小于30度的时候, 进度手势
    if (tan < sqrt(3)) {    //当滑动角度小于60度的时候, 进度手势
        if (!_isLightJudge && !_isVolmControl) { // 如果不是声音和亮度
            _controlType = VodprogressControl;
            _controlJudge = YES;
            if (_isUpVolume) {
                _isUpVolume = NO;
            }
            
            float value = [self moveProgressControllWithTempPoint:tempPoint];
            [self timeValueChangingWithValue:value];
            
            return;
        }
    } else if (!_controlJudge) { // 如果不是快进
        if(tan > sqrt(3)){  //当滑动角度大于60度的时候, 声音和亮度
            //判断是在屏幕的左半边还是右半边滑动, 左侧控制为亮度, 右侧控制音量
            if (_touchBeginPoint.x < self.bounds.size.width/2) {
                _controlType = VodlightControl;
                _isLightJudge = YES;
                
            }else{
                _controlType = VodvoiceControl;
                _isVolmControl = YES;
                _isUpVolume = YES;
            }
        }
    }else{     //如果是其他角度则不是任何控制
        _controlType = VodnoneControl;
        return;
    }
    
    if (_controlType == VodprogressControl && _controlJudge) {     //如果是进度手势
        float value = [self moveProgressControllWithTempPoint:tempPoint];
        [self timeValueChangingWithValue:value];
        
        return;
        
    } else if(_controlType == VodvoiceControl && _isVolmControl){    //如果是音量手势
        if (self.isFullscreen) {//全屏的时候才开启音量的手势调节
            
            if (self.enableVolumeGesture) {
                //根据触摸开始时的音量和触摸开始时的点去计算出现在滑动到的音量
                float voiceValue = _touchBeginVoiceValue - ((tempPoint.y - _touchBeginPoint.y)/self.bounds.size.height);
                //判断控制一下, 不能超出 0~1
                if (voiceValue < 0) {
                    _volumeSlider.value = 0;
                }else if(voiceValue > 1){
                    _volumeSlider.value = 1;
                }else{
                    _volumeSlider.value = voiceValue;
                }
            }
        }else{
            return;
        }
    }else if(_controlType == VodlightControl && _isLightJudge){   //如果是亮度手势
        [self hideTheLightViewWithHidden:NO];
        if (self.isFullscreen) {
            //根据触摸开始时的亮度, 和触摸开始时的点来计算出现在的亮度
            float tempLightValue = _touchBeginLightValue - ((tempPoint.y - _touchBeginPoint.y)/self.bounds.size.height);
            if (tempLightValue < 0) {
                tempLightValue = 0;
            }else if(tempLightValue > 1){
                tempLightValue = 1;
            }
            //        控制亮度的方法
            [self.vodPlayer setBrightness:tempLightValue];
//            [UIScreen mainScreen].brightness = tempLightValue;
            //        实时改变现实亮度进度的view
        }else{
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    // 判断视频是否已经准备好播放
    if (!self.isVideoPrepareDone) {
        return;
    }
    // 如果视频加载失败 就return
    if (self.isVideoPlayFail) {
        return;
    }
    if (self.isLock) { // 如果是锁屏 则不操作
        return;
    }
    if (_controlJudge) {
        _controlJudge = NO;
    }
    if (_isLightJudge) {
        _isLightJudge = NO;
    }
    
    //判断是否移动过,
    if (_hasMoved) {
        if (_controlType == VodprogressControl) { //进度控制就跳到响应的进度
            CGPoint tempPoint = [touches.anyObject locationInView:self];
            float value = [self moveProgressControllWithTempPoint:tempPoint];
            [self seekToTimeToPlay:value];
            
            self.FF_View.hidden = YES;
        }else if (_controlType == VodlightControl){//如果是亮度控制, 控制完亮度还要隐藏显示亮度的view
            [self hideTheLightViewWithHidden:YES];
        } else if (_controlType == VodvoiceControl){
        }
    }else{
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // 判断视频是否已经准备好播放
    if (!self.isVideoPrepareDone) {
        return;
    }
    // 如果视频加载失败 就return
    if (self.isVideoPlayFail) {
        return;
    }
    if (self.isLock) { // 如果是锁屏 则不操作
        return;
    }
    self.FF_View.hidden = YES;
    [self hideTheLightViewWithHidden:YES];
    [super touchesEnded:touches withEvent:event];
    
    if (_controlJudge) {
        _controlJudge = NO;
    }
    if (_isLightJudge) {
        _isLightJudge = NO;
    }
    
    //判断是否移动过,
    if (_hasMoved) {
        if (_controlType == VodprogressControl) { //进度控制就跳到响应的进度
            CGPoint tempPoint = [touches.anyObject locationInView:self];
            //            if ([self.delegate respondsToSelector:@selector(seekToTheTimeValue:)]) {
            float value = [self moveProgressControllWithTempPoint:tempPoint];
            //                [self.delegate seekToTheTimeValue:value];
            
            [self seekToTimeToPlay:value];
            
            self.FF_View.hidden = YES;
        }else if (_controlType == VodlightControl){//如果是亮度控制, 控制完亮度还要隐藏显示亮度的view
            [self hideTheLightViewWithHidden:YES];
        } else if (_controlType == VodvoiceControl){
        }
    }else{
    }
}
#pragma mark - 用来控制移动过程中计算手指划过的时间
-(float)moveProgressControllWithTempPoint:(CGPoint)tempPoint{
    //90代表整个屏幕代表的时间
    //    float tempValue = _touchBeginValue + TotalScreenTime * ((tempPoint.x - _touchBeginPoint.x)/([UIScreen mainScreen].bounds.size.width));
    // 此处的3600 是为了调节快进时 快进的太慢的问题
    CGFloat timeF = 0.0;
//    if (self.vodPlayer.duration / 60 > 20) {
//        timeF = 3000;
//    } else {
        timeF = 400;
//    }
    float tempValue = _touchBeginValue + timeF * ((tempPoint.x - _touchBeginPoint.x)/([UIScreen mainScreen].bounds.size.width));
    
    if (tempValue > self.vodPlayer.duration) {
        tempValue = self.vodPlayer.duration;
    }else if (tempValue < 0){
        tempValue = 0.0f;
    }
    return tempValue;
}

#pragma mark - 用来显示时间的view在时间发生变化时所作的操作
-(void)timeValueChangingWithValue:(float)value{
    if (value > _touchBeginValue) {
        self.FF_View.sheetStateImageView.image = WMPlayerImage(@"progress_icon_r");
    }else if(value < _touchBeginValue){
        self.FF_View.sheetStateImageView.image = WMPlayerImage(@"progress_icon_l");
    }
    self.FF_View.hidden = NO;
    
    self.FF_View.sheetTimeLabel.text = [NSString stringWithFormat:@"%@/%@", [self convertTime:value], [self convertTime:totalTime]];
    self.leftTimeLabel.text = [self convertTime:value];
    [self showControlView];
    [self.progressSlider setValue:value animated:YES];
}

#pragma mark -
#pragma mark - 用来控制显示亮度的view, 以及毛玻璃效果的view
-(void)hideTheLightViewWithHidden:(BOOL)hidden{
    if (self.isFullscreen) {//全屏才出亮度调节的view
        if (hidden) {
            [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                if (iOS8) {
                    self.effectView.alpha = 0.0;
                }
            } completion:nil];
        }else{
            if (iOS8) {
                self.effectView.alpha = 1.0;
            }
        }
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            self.effectView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.height)/2-155/2, ([UIScreen mainScreen].bounds.size.width)/2-155/2, 155, 155);
        }
    }else{
        return;
    }
}
//重置播放器
//-(void )resetWMPlayer{
//    self.seekTime = 0;
//    // 移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    // 关闭定时器
//    [self.autoDismissTimer invalidate];
//    self.autoDismissTimer = nil;
//    // 暂停
//    [self.vodPlayer pause];
//    // 移除原来的layer
////    [self.playerLayer removeFromSuperlayer];
//    // 把player置为nil
//    self.vodPlayer = nil;
//}
-(void)dealloc{
    for (UIView *aLightView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([aLightView isKindOfClass:[WMLightView class]]) {
            [aLightView removeFromSuperview];
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.vodPlayer pause];
    [self.vodPlayer releasePlayer];
    self.vodPlayer = nil;

    [self.effectView removeFromSuperview];
    self.effectView = nil;
    self.playOrPauseBtn = nil;
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
}

-(void)destroyPlayer{
    for (UIView *aLightView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([aLightView isKindOfClass:[WMLightView class]]) {
            [aLightView removeFromSuperview];
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.vodPlayer pause];
    
    [self.effectView removeFromSuperview];
    self.effectView = nil;
//    [self.playerLayer removeFromSuperlayer];
//    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.playOrPauseBtn = nil;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.autoDismissTimer) {
        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
    }

    [self.vodPlayer releasePlayer];
    self.vodPlayer = nil;
}

//获取当前的旋转状态
+(CGAffineTransform)getCurrentDeviceOrientation{
    //状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    //根据要进行旋转的方向来计算旋转的角度
    if (orientation ==UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    }else if (orientation ==UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    }else if(orientation ==UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

@end
