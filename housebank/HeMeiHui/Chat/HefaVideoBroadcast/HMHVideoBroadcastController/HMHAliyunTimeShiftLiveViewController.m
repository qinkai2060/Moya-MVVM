//
//  AliyunTimeShiftLiveViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/12/28.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "HMHAliyunTimeShiftLiveViewController.h"
#import "HMHVideoEveryoneSaidViewController.h"
#import "HMHVideoMorewonderfulViewController.h"
#import "HMHVideoPlayBottomView.h"
#import "HMHVideoDescribeViewController.h"
#import "HMHVideoCoursewareViewController.h"
#import "HMHCoursewareAndRedpacketView.h"
#import "WMLightView.h"
#import "HFLoginViewController.h"

#define BUTTON_TAT_PLAY 8000
#define BUTTON_TAT_STOP BUTTON_TAT_PLAY+1
#define BUTTON_TAT_PAUSE BUTTON_TAT_STOP+1
#define BUTTON_TAT_RESUME BUTTON_TAT_PAUSE+1
#define BUTTON_TAT_REPLAY BUTTON_TAT_RESUME+1
#define BUTTON_TAT_TOOL BUTTON_TAT_REPLAY+1

//
#define WMPlayerSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMPlayerFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]

#define WMPlayerImage(file)      [UIImage imageNamed:WMPlayerSrcName(file)] ? :[UIImage imageNamed:WMPlayerFrameworkSrcName(file)]

@interface HMHAliyunTimeShiftLiveViewController ()<AliyunVodPlayerDelegate,UIAlertViewDelegate,ShareToolDelegete,CoursewareAndRedpacketDelegate,UIGestureRecognizerDelegate,HFLoginViewControllerDelegate>{
    NSArray*HMH_titleArr;
    
    UIPageViewController *HMH_pageView;
    NSInteger HMH_index;
    NSMutableArray *HMH_vcAr;
    UIButton *HMH_weakBtn;
    
    UIView*HMH_moveLine;
    HMHVideoEveryoneSaidViewController *HMH_first;
    HMHVideoDescribeViewController *HMH_second;
    HMHVideoMorewonderfulViewController *HMH_third;
    
    //用来判断手势是否移动过
    BOOL HMH_hasMoved;
    //记录触摸开始时的视频播放的时间
//    float _touchBeginValue;
    //记录触摸开始亮度
    float HMH_touchBeginLightValue;
    //记录触摸开始的音量
    float HMH_touchBeginVoiceValue;
}

@property (nonatomic, strong) UIView *HMH_playerView;
@property (nonatomic, strong) UIView *HMH_vodContentView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) double HMH_tempTotalTime;

@property (nonatomic, strong) Reachability *reachability;

///记录touch开始的点
@property (nonatomic,assign)CGPoint HMH_touchBeginPoint;
///手势控制的类型
///判断当前手势是在控制进度?声音?亮度?
@property (nonatomic, assign) TimeShiftControlType controlType;
//是否使用手势控制音量
@property (nonatomic,assign) BOOL  HMH_enableVolumeGesture;
//给显示亮度的view添加毛玻璃效果
@property (nonatomic, strong) UIVisualEffectView * HMH_effectView;

//  底部操作工具栏
@property (nonatomic,retain ) UIImageView   *HMH_bottomView;
//  顶部操作工具栏
@property (nonatomic,retain ) UIImageView    *HMH_topView;
//  控制全屏的按钮
@property (nonatomic,retain ) UIButton  *HMH_fullScreenBtn;
// 记录是否是全屏状态
@property (nonatomic, assign) BOOL HMH_isFullScreen;
// 返回按钮
@property (nonatomic,retain ) UIButton  *HMH_closeBtn;
// 分享按钮
@property (nonatomic, strong) UIButton *HMH_shareBtn;
//
@property (nonatomic, strong) UILabel *HMH_titleLab;
// 播放暂停按钮
@property (nonatomic,retain ) UIButton  *HMH_playOrPauseBtn;
// 单击手势
@property (nonatomic, strong)  UITapGestureRecognizer* HMH_singleTap;
// 定时器
@property (nonatomic, retain) NSTimer  *HMH_autoDismissTimer;
// 红包定时器
@property (nonatomic, retain) NSTimer  *HMH_redPacketTimer;

@property (nonatomic, strong) HMHVideoRedPacketModel *HMH_redModel;
// 显示或隐藏状态栏
@property (nonatomic, assign) BOOL HMH_navigationBarHidden;

@property (nonatomic, strong) UIButton *HMH_lockBtn;

@property (nonatomic, assign) BOOL HMH_isLock; // 是否显示锁

@property (nonatomic, strong) UIView *HMH_bgView; //pageView的HMH_bgView

@property (nonatomic, strong) HMHVideoPlayBottomView *HMH_videoBottomView;

@property (nonatomic, strong) HMHVideoListModel *HMH_videoModel;

@property (nonatomic, strong) ShareTools *HMH_shareTool;
// 课件 红包
@property (nonatomic, strong) HMHCoursewareAndRedpacketView *HMH_courseView;
@property (nonatomic, strong) NSMutableArray *HMH_coursewareUrlArr;
@property (nonatomic, strong) NSMutableArray *HMH_coursewareTitleArr;
// 是否是红包跳转出去
@property (nonatomic, assign) BOOL HMH_isRedLeave;

@property (nonatomic,assign)NSUInteger shouchangState;

@end

@implementation HMHAliyunTimeShiftLiveViewController

static BOOL s_autoPlay = NO;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isFull = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isFull = NO;
    if (self.vodPlayer.playerState != AliyunVodPlayerStatePause) {
        [self.vodPlayer pause];
        // 改变播放暂停的状态
        self.HMH_playOrPauseBtn.selected = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

// 插入观看历史
-(void)HMH_watchHistoryRequest{
    NSTimeInterval currentTime = self.vodPlayer.currentTime;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-watchhistory/watchhistory/save"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }
    
    // {vno:视屏编号,episode:集数（默认0）,seekTime:播放时间（默认0）}
    NSString *currentTimeStr = [NSString stringWithFormat:@"%f",currentTime];
    // 因为是直播的观看历史 所以播放时间传0
    NSDictionary *dic = @{@"vno":self.videoNum,@"episode":@1,@"seekTime":@0};
    
    [self requestData:dic withUrl:getUrlStr withRequestName:@"history" withRequestType:@"put"];
}
// 更新视频观看次数
-(void)HMH_videoHitsRequest{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
//   NSString *uuidStr = [VersionTools UUIDString];
//    NSDictionary *dic = @{@"watcherId":uuidStr};

    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-hits/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNum,sidStr];
    }

    [self requestData:nil withUrl:getUrlStr withRequestName:@"hits" withRequestType:@"post"];
}

#pragma  mark - viewDidload
- (void)viewDidLoad {
    [super viewDidLoad];
    _HMH_navigationBarHidden = NO; // 默认显示
    _HMH_coursewareUrlArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_coursewareTitleArr = [NSMutableArray arrayWithCapacity:1];
    
    _HMH_isRedLeave = NO;
    _HMH_shareTool = [[ShareTools alloc]init];
    _HMH_shareTool.delegete = self;

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appVodDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appVodWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    [self HMH_initView];
    // 获取视频信息
    [self HMH_loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    // 红包接口
    [self HMH_redPacketRequestData];
    
    [self HMH_createPageController];
    // 更新观看次数
    [self HMH_videoHitsRequest];
}

- (void)HMH_loadData{
    if (self.videoNum.length > 0) {
        NSString *sidStr = [self getUserSidStr];
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-info/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNum,sidStr];
        }
        [self requestData:nil withUrl:getUrlStr withRequestName:@"" withRequestType:@"get"];
    }
}
// 红包接口请求
- (void)HMH_redPacketRequestData{
    if (self.videoNum.length > 0) {
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-red/packet/redpacket/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?vno=%@&sid=%@",getUrlStr,self.videoNum,[self getUserSidStr]];
        }

        [self requestData:nil withUrl:getUrlStr withRequestName:@"redPacket" withRequestType:@"post"];
    }

}

-(void)HMH_createPageController{
    HMH_titleArr=@[@"大家说",@"内容简介",@"更多精彩"];
    HMH_vcAr=[[NSMutableArray alloc]init];
    HMH_index=100;
    [self HMH_createUI];
    [self HMH_createPageView];
}

-(void)HMH_createUI{
    _HMH_bgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame), ScreenW, 44)];
    _HMH_bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_HMH_bgView];
    
    CGFloat width=ScreenW/HMH_titleArr.count;
    for (NSInteger i=0; i<HMH_titleArr.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(width*i,0, width - 10, 43)];
        [btn setTitle:HMH_titleArr[i] forState:UIControlStateNormal];
        [_HMH_bgView addSubview:btn];
        [btn setTitleColor:RGBACOLOR(57,58,59,1) forState:UIControlStateNormal];
        [btn setTitleColor:RGBACOLOR(181,148,89,1) forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:13.0];
        [_HMH_bgView addSubview:btn];
        
        btn.tag=100+i;
        if (i==[self.indexSelected intValue]) {
            btn.selected = YES;
            HMH_weakBtn=btn;
        }
        [btn addTarget:self action:@selector(headerSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 43,width, 1)];
        lineLab.backgroundColor = RGBACOLOR(240, 241, 242, 1);
        [_HMH_bgView addSubview:lineLab];
    }
}

-(void)HMH_createPageView{
    __weak  typeof( self)weakSelf=self;
    HMH_first=[[HMHVideoEveryoneSaidViewController alloc]init];
    HMH_first.videoNum = self.videoNum;
    [HMH_first setMyBlock:^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
//        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    [HMH_vcAr addObject:HMH_first];

    HMH_second=[[HMHVideoDescribeViewController alloc]init];
    HMH_second.isFromVodPlay = NO;
    HMH_second.videoNum = self.videoNum;
   
    [HMH_second setMyBlock:^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [HMH_second setMyPopBlock:^(UIViewController *vc) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [HMH_vcAr addObject:HMH_second];
    
    HMH_third=[[HMHVideoMorewonderfulViewController alloc]init];
    HMH_third.videoNum=self.videoNum;
    [HMH_third setMyBlock:^(UIViewController *vc) {
        if (self.vodPlayer.playerState != AliyunVodPlayerStatePause) {

            [weakSelf.vodPlayer pause];
            // 改变播放暂停的状态
            weakSelf.HMH_playOrPauseBtn.selected = !weakSelf.HMH_playOrPauseBtn.selected;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [HMH_vcAr addObject:HMH_third];
    
    HMH_pageView=[[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame)) ;
    
    [HMH_pageView setViewControllers:@[HMH_vcAr[[self.indexSelected intValue]]] direction:0 animated:YES completion:nil];
    [self.view addSubview:HMH_pageView.view ];
    
    UIScrollView *sc=(UIScrollView *)HMH_pageView.view.subviews[0];
    sc.scrollEnabled=NO;
    CGFloat width=ScreenW/3.0;
    HMH_moveLine=[[UIView alloc]initWithFrame:CGRectMake(width*[self.indexSelected intValue],  CGRectGetMaxY(_HMH_bgView.frame)-1, width, 2)];
    HMH_moveLine.backgroundColor= RGBACOLOR(181,148,89,1);
    [self.view addSubview:HMH_moveLine];
    
    // 课件 和 红包
    _HMH_courseView = [[HMHCoursewareAndRedpacketView alloc] initWithFrame:CGRectMake(ScreenW - 60, ScreenH - 60 - 200, 60, 200)];
    _HMH_courseView.userInteractionEnabled = YES;
    _HMH_courseView.delegate = self;
    [self.view addSubview:_HMH_courseView];
}

// 课件按钮的点击事件
- (void)pptBtnClickWithBtn:(UIButton *)pptBtn{
    if (self.vodPlayer.playerState != AliyunVodPlayerStatePause) {
        [self.vodPlayer pause];
        // 改变播放暂停的状态
        self.HMH_playOrPauseBtn.selected = !self.HMH_playOrPauseBtn.selected;
    }
    
    self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext; //半透明
    HMHVideoCoursewareViewController *vc = [[HMHVideoCoursewareViewController alloc] init];
    vc.urlArr = self.HMH_coursewareUrlArr;
    vc.titleArr = self.HMH_coursewareTitleArr;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}

// 红包按钮的点击事件
- (void)redPacketBtnClickWithBtn:(UIButton *)redPacketBtn{
    if (self.vodPlayer.playerState != AliyunVodPlayerStatePause) {
        [self.vodPlayer pause];
        // 改变播放暂停的状态
        self.HMH_playOrPauseBtn.selected = YES;
    }
    _HMH_isRedLeave = YES;
    
    if (self.isLogin) {
        [self HMH_redPacketPushVC];
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
//        [weakSelf HMH_redPacketPushVC];
    };
}
// 红包跳转
- (void)HMH_redPacketPushVC{
    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if (tools.pageUrlConfigArrary.count) {
        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
            NSString *pageStr;
            if (_HMH_redModel.pageTag.length > 0) {
                pageStr = _HMH_redModel.pageTag;
            } else {
                pageStr = @"fy_hongbao_openBalance";
            }

            if([model.pageTag isEqualToString:pageStr]) {
                NSString *redUrl;
                if (_HMH_redModel) {
                    redUrl = [NSString stringWithFormat:@"%@?id=%@",model.url,_HMH_redModel.rpId];
                }
                [self HMH_redPacketWithUrl:redUrl];
            }
        }
    }
}

- (void)HMH_redPacketWithUrl:(NSString *)url{
    PopAppointViewControllerModel *model = [NavigationContrl getModelFrom:url];
    
    HMHPopAppointViewController*business = [[HMHPopAppointViewController alloc]init];
    business.title = model.title;
    business.urlStr = url;
    if (model) {
        business.title = model.title;
        business.naviBg = model.naviBg;
        business.isNavigationBarshow = model.showNavi;
        business.naviMask = model.naviMask;
        business.naviMaskHeight = model.naviMaskHeight;
        business.pageTag = model.pageTag;
    }
    business.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:business animated:YES];
}

-(void)headerSwitchBtnClick:(UIButton *)sender{
    HMH_weakBtn.selected=NO;
    sender.selected=YES;
    
    HMH_weakBtn=sender;
    [HMH_pageView setViewControllers:@[HMH_vcAr[sender.tag-100]] direction:(sender.tag<HMH_index) animated:YES completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=  HMH_moveLine.frame;
        rect.origin.x=sender.frame.origin.x;
        HMH_moveLine.frame=rect;
    }];
    HMH_index=sender.tag;
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition {
    
    NSLog(@"");
}
#pragma  mark - 懒加载 播放器部分
-(AliyunVodPlayer *)vodPlayer{
    if (!_vodPlayer) {
        _vodPlayer = [[AliyunVodPlayer alloc] init];
        _vodPlayer.delegate = self;
        [_vodPlayer setAutoPlay:s_autoPlay];
        _vodPlayer.quality=  0;
        _vodPlayer.circlePlay = NO;
    }
    return _vodPlayer;
}

-(void)muteSwitchChanged:(UISwitch*)sender{
    if (self.vodPlayer) {
        [self.vodPlayer setMuteMode:sender.isOn];
    }
}
-(void)volumeSliderChanged:(UISlider*)sender{
    self.vodPlayer.volume = sender.value;
}

-(void)brightnessSliderChanged:(UISlider*)sender{
    self.vodPlayer.brightness = sender.value;
}

- (void)displaySegmentedControlChanged:(UISegmentedControl*)sender{
    self.vodPlayer.displayMode = (int)sender.selectedSegmentIndex;
}
#pragma  mark - HMH_initView
- (void)HMH_initView{
    /***********播放器界面搭建**************/
    self.HMH_vodContentView = [[UIView alloc] init];
    self.HMH_vodContentView.frame = CGRectMake(0, self.HMH_statusHeghit, self.view.frame.size.width, self.view.frame.size.width*9/16);
    
    self.HMH_playerView = [[UIView alloc] init];
    self.HMH_playerView.frame = CGRectMake(0, 0, self.HMH_vodContentView.frame.size.width, self.HMH_vodContentView.frame.size.height);
    
    self.HMH_playerView = self.vodPlayer.playerView;
    [self.HMH_vodContentView addSubview:self.HMH_playerView];
    
    self.HMH_vodContentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.HMH_vodContentView];
    
    //HMH_topView
    self.HMH_topView = [[UIImageView alloc]init];
    self.HMH_topView.image = WMPlayerImage(@"top_shadow");
    self.HMH_topView.userInteractionEnabled = YES;
    [self.HMH_vodContentView addSubview:self.HMH_topView];
    //autoLayout HMH_topView
    [self.HMH_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HMH_vodContentView).with.offset(0);
        make.right.equalTo(self.HMH_vodContentView).with.offset(0);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.HMH_vodContentView).with.offset(0);
    }];
    
    //bottomView
    self.HMH_bottomView = [[UIImageView alloc]init];
    self.HMH_bottomView.image = WMPlayerImage(@"bottom_shadow");
    self.HMH_bottomView.userInteractionEnabled = YES;
    [self.HMH_vodContentView addSubview:self.HMH_bottomView];
    //autoLayout HMH_bottomView
    [self.HMH_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HMH_vodContentView).with.offset(0);
        make.right.equalTo(self.HMH_vodContentView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.HMH_vodContentView).with.offset(0);
    }];

    //_HMH_fullScreenBtn
    self.HMH_fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_fullScreenBtn.showsTouchWhenHighlighted = YES;
    [self.HMH_fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_fullScreenBtn setImage:WMPlayerImage(@"fullscreen") forState:UIControlStateNormal];
    [self.HMH_fullScreenBtn setImage:WMPlayerImage(@"nonfullscreen") forState:UIControlStateSelected];
    [self.HMH_bottomView addSubview:self.HMH_fullScreenBtn];
    //autoLayout HMH_fullScreenBtn
    [self.HMH_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.HMH_bottomView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.HMH_bottomView).with.offset(0);
        make.width.mas_equalTo(50);
    }];
    
    //_HMH_closeBtn
    _HMH_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_closeBtn.showsTouchWhenHighlighted = YES;
    [_HMH_closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_closeBtn setImage:WMPlayerImage(@"play_back.png") forState:UIControlStateNormal];
    [_HMH_closeBtn setImage:WMPlayerImage(@"play_back.png") forState:UIControlStateSelected]; // VP_whiteBackImage@2x
    [self.HMH_topView addSubview:_HMH_closeBtn];
    
    //autoLayout _HMH_closeBtn
    [self.HMH_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HMH_topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.HMH_topView).with.offset(18);
    }];
    
    //
    _HMH_titleLab = [[UILabel alloc] init];
    _HMH_titleLab.textColor = [UIColor whiteColor];
    _HMH_titleLab.font = [UIFont systemFontOfSize:16.0];
    [self.HMH_topView addSubview:_HMH_titleLab];
    //autoLayout _HMH_closeBtn
    [self.HMH_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HMH_closeBtn).with.offset(40);
        make.right.equalTo(self.HMH_topView).with.offset(-50);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.HMH_topView).with.offset(18);
    }];

    //_HMH_shareBtn
    _HMH_shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_shareBtn.showsTouchWhenHighlighted = YES;
    [_HMH_shareBtn addTarget:self action:@selector(shareTheVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_shareBtn setImage:[UIImage imageNamed:@"VL_ShareImage"] forState:UIControlStateNormal];
    [_HMH_shareBtn setImage:[UIImage imageNamed:@"VL_ShareImage"] forState:UIControlStateSelected];
    [self.HMH_topView addSubview:_HMH_shareBtn];
    
//    autoLayout HMH_shareBtn
    [self.HMH_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.HMH_topView).with.offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.HMH_topView).with.offset(15);
    }];

    
    //_HMH_playOrPauseBtn
    self.HMH_playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.HMH_playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
     // ||
    [self.HMH_playOrPauseBtn setImage:WMPlayerImage(@"pause") forState:UIControlStateNormal];
    [self.HMH_playOrPauseBtn setImage:WMPlayerImage(@"play") forState:UIControlStateSelected];
    self.HMH_playOrPauseBtn.selected = NO;
    [self.HMH_bottomView addSubview:self.HMH_playOrPauseBtn];
    //autoLayout _HMH_playOrPauseBtn
    [self.HMH_playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HMH_bottomView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.HMH_bottomView).with.offset(0);
        make.width.mas_equalTo(50);
        
    }];
//    self.HMH_playOrPauseBtn.selected = YES;//默认状态，即默认是不自动播放
    //
    self.HMH_lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_lockBtn.frame = CGRectMake(10, self.HMH_vodContentView.frame.size.height / 2 - 25, 50, 50);
    self.HMH_lockBtn.showsTouchWhenHighlighted = YES;
    [self.HMH_lockBtn addTarget:self action:@selector(lockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.HMH_lockBtn setImage:[UIImage imageNamed:@"Video_unlockImage"] forState:UIControlStateNormal];
    [self.HMH_lockBtn setImage:[UIImage imageNamed:@"Video_lockImage"] forState:UIControlStateSelected];

    self.HMH_lockBtn.hidden = YES;
    self.HMH_isLock = NO; // 默认不显示锁
    [self.HMH_vodContentView addSubview:self.HMH_lockBtn];
    
    
    // 视频底部的view
    _HMH_videoBottomView = [[HMHVideoPlayBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_HMH_vodContentView.frame), _HMH_vodContentView.frame.size.width, 30)];
    
    __weak typeof(self)weakSelf = self;
    _HMH_videoBottomView.shouCangBtnClick = ^(NSInteger state) {
        // state  2 收藏    1 取消收藏
        [weakSelf isJudgeLoginFavoriteWithState:state];
    };
    [self.view addSubview:_HMH_videoBottomView];
    
    // 单击的 Recognizer
    _HMH_singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _HMH_singleTap.numberOfTapsRequired = 1; // 单击
    _HMH_singleTap.numberOfTouchesRequired = 1;
    // 解决点击当前view时候响应其他控件事件
    [_HMH_singleTap setDelaysTouchesBegan:YES];

    [self.HMH_vodContentView addGestureRecognizer:_HMH_singleTap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:[WMLightView sharedLightView]];

    self.HMH_enableVolumeGesture = YES;

    //5s dismiss bottomView
    if (self.HMH_autoDismissTimer==nil) {
        self.HMH_autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.HMH_autoDismissTimer forMode:NSDefaultRunLoopMode];
    }
}
// 点击收藏时 判断登录
- (void)isJudgeLoginFavoriteWithState:(NSInteger)state{

    self.shouchangState = state;
    if (self.isJudgeLogin) {
        [self HMH_videoBottomViewFavoriteWithState:state];
        return;
    }
    //这里就是没有登录成功
    [HFLoginViewController showViewController:self];
//    if (self.isLogin) {
//        [self HMH_videoBottomViewFavoriteWithState:state];
//        return;
//    }
//    __weak typeof(self)weakSelf = self;
//    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
//        [weakSelf HMH_videoBottomViewFavoriteWithState:state];
//    };
}
// 收藏 取消收藏
- (void)HMH_videoBottomViewFavoriteWithState:(NSInteger)state{
    // state  2 收藏    1 取消收藏
//    NSLog(@"%ld",state);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (state == 1) { // 取消收藏
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/delete"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNum,sidStr];
        }
        [self requestData:nil withUrl:getUrlStr withRequestName:@"delete" withRequestType:@"post"];
    } else { // 收藏
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/save"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }

        NSDictionary *dic = @{@"vno":self.videoNum};
        
        [self requestData:dic withUrl:getUrlStr withRequestName:@"" withRequestType:@"put"];
    }
}

#pragma mark <HFLoginViewControllerDelegate>

- (void)loginViewController:(HFLoginViewController *)viewcontroller loginFinsh:(NSDictionary *)loginData {
    
    [self HMH_videoBottomViewFavoriteWithState:self.shouchangState];
    
}

#pragma mark 分享按钮的点击事件
- (void)shareTheVideo:(UIButton *)btn{
    
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        
        return;
    }
    if (self.HMH_videoModel) {
        NSString *shareUrlStr;
        PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
        if (tools.pageUrlConfigArrary.count) {
            for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
                if([model.pageTag isEqualToString:@"fy_video_play"]) {
                    shareUrlStr = [NSString stringWithFormat:@"%@?vno=%@&shareId=%@",model.url,self.HMH_videoModel.vno,[self getUserUidStr]];
                }
            }
        }
        if (shareUrlStr.length > 0) {
            NSDictionary *dic = @{
                                  @"shareDesc":self.HMH_videoModel.videoAbstract,
                                  @"shareImageUrl":[self.HMH_videoModel.coverImageUrl get_sharImage],
                                  @"shareTitle":self.HMH_videoModel.title,
                                  @"shareUrl":shareUrlStr,
                                  @"longUrl":@"",
                                  @"shareWeixinUrl":shareUrlStr,
                                @"justUrl":@(YES)
                                  };
            [ShareTools  shareWithContent:dic];
//            [_HMH_shareTool doShare:dic];
        }
    }
}
// 此处的state返回的是json字符串
- (void)sendShareState:(NSString*)state{
    
}

// 分享状态返回 1 成功    2 失败   -1 失败 为安装客户端
- (void)shareResultState:(NSString *)state{
    NSString *sidStr = [self getUserSidStr];
    if ([state isEqualToString:@"1"] && [self isJudgeLogin]) {
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"asset.integral/share/benefit"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }
        [self requestData:nil withUrl:getUrlStr withRequestName:@"" withRequestType:@"post"];
    }
}


#pragma mark - 单击手势方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissBottomView:) object:nil];

    [self.HMH_autoDismissTimer invalidate];
    self.HMH_autoDismissTimer = nil;
    self.HMH_autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.HMH_autoDismissTimer forMode:NSDefaultRunLoopMode];
    [UIView animateWithDuration:0.5 animations:^{
        if (self.HMH_isLock) { // 锁屏
            if (self.HMH_lockBtn.hidden) {
                [self HMH_showControlView];
            } else {
                [self HMH_hiddenControlView];
            }
        } else {
            if (self.HMH_bottomView.alpha == 1.0) {
                [self HMH_hiddenControlView];
            }else{
                [self HMH_showControlView];
            }
        }

    } completion:^(BOOL finish){
        
    }];
}
#pragma mark autoDismissBottomView
-(void)autoDismissBottomView:(NSTimer *)timer{
    if (self.vodPlayer.playerState == AliyunVodPlayerStatePlay) {
        if (self.HMH_bottomView.alpha==1.0) {
            [self HMH_hiddenControlView];//隐藏操作栏
        }
    }
}
///隐藏操作栏view
-(void)HMH_hiddenControlView{
    [UIView animateWithDuration:0.5 animations:^{
        self.HMH_lockBtn.hidden = YES;
        
        self.HMH_bottomView.alpha = 0.0;
        self.HMH_topView.alpha = 0.0;
        _HMH_navigationBarHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finish){
        
    }];
}

///显示操作栏view
-(void)HMH_showControlView{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.HMH_isFullScreen) { // 全屏状态下
            if (self.HMH_isLock) {
                self.HMH_lockBtn.selected = YES;
                self.HMH_lockBtn.hidden = NO;
            } else {
                self.HMH_lockBtn.selected = NO;
                self.HMH_lockBtn.hidden = NO;
                
                self.HMH_bottomView.alpha = 1.0;
                self.HMH_topView.alpha = 1.0;
                _HMH_navigationBarHidden = NO;
            }
        } else {
            self.HMH_lockBtn.hidden = YES;
            
            self.HMH_bottomView.alpha = 1.0;
            self.HMH_topView.alpha = 1.0;
            _HMH_navigationBarHidden = NO;
        }
        
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finish){
        
    }];
}

#pragma mark - lockBtnClick 锁屏按钮的点击事件
- (void)lockBtnClick:(UIButton *)btn{
    if (self.HMH_isLock) { // 锁屏
        btn.selected = NO;
        self.HMH_isLock = NO;
        [self HMH_showControlView];
    } else {
        btn.selected = YES;
        self.HMH_isLock = YES;
        [self HMH_hiddenControlView];
        btn.hidden = NO;
    }
}

#pragma mark - PlayOrPause  播放和暂停
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
    switch (sender.tag) {
        case BUTTON_TAT_PLAY:
        {
            if (self.vodPlayer.playerState == AliyunVodPlayerStateIdle || self.vodPlayer.playerState == AliyunVodPlayerStateStop) {
                self.vodPlayer.autoPlay = YES;

                [self.vodPlayer prepareWithLiveTimeUrl:[NSURL URLWithString:self.HMH_videoModel.videoUrl]];
                
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
//            self.mProgressCanUpdate = YES;
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

#pragma mark -返回 关闭按钮点击func
-(void)colseTheVideo:(UIButton *)sender{
    if (_HMH_isFullScreen) {
        self.HMH_fullScreenBtn.selected = !self.HMH_fullScreenBtn.selected;
        [self setFullScreen:false];
    }else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        // 在用户登录的情况下 插入观看历史
        if (sidStr.length > 0 && ![sidStr isEqualToString:@"(null)"]) {
            [self HMH_watchHistoryRequest];
        }
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self.HMH_autoDismissTimer invalidate];
        self.HMH_autoDismissTimer = nil;
        
        [self.HMH_redPacketTimer invalidate];
        self.HMH_redPacketTimer = nil;

        [self.vodPlayer pause];
        [self.vodPlayer releasePlayer];

        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *temp = self.navigationController.viewControllers[i];
            if ([temp isKindOfClass:[HMHAliyunTimeShiftLiveViewController class]]) {
                if (i == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[i-1] animated:YES];
                }
            }
        }
    }
}

#pragma mark rotate
/**
 *  旋转屏幕的时候，是否自动旋转子视图，NO的话不会旋转控制器的子控件
 *
 */
- (BOOL)shouldAutorotate{
    return true;
}
/**
 *  当前控制器支持的旋转方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft  ;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (self.HMH_isFullScreen)
        return UIInterfaceOrientationPortrait;
    return UIInterfaceOrientationLandscapeRight ;
}

#pragma mark - 全屏按钮点击func
-(void)fullScreenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    [self setFullScreen:sender.selected];
}

/**
 需要切换的屏幕方向，手动转屏
 */
- (void)setFullScreen:(BOOL)isFullScreen {
    self.HMH_isFullScreen = isFullScreen;
    
    if (isFullScreen) {
        [self rotateOrientation:UIInterfaceOrientationLandscapeRight];
        self.HMH_lockBtn.hidden = NO;
        self.HMH_shareBtn.hidden = YES;
    }else{
        [self rotateOrientation:UIInterfaceOrientationPortrait];
        self.HMH_lockBtn.hidden = YES;
        self.HMH_shareBtn.hidden = NO;
    }
}
// 是否显示状态栏
- (BOOL)prefersStatusBarHidden{
    return _HMH_navigationBarHidden;
}

- (void)rotateOrientation:(UIInterfaceOrientation)orientation {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
}

//自动转屏或者手动调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    self.HMH_isFullScreen = size.width > size.height;
}

#pragma mark===== viewWillLayoutSubviews
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.HMH_isFullScreen){
        
        [self.navigationController setNavigationBarHidden:true];
        
        self.HMH_vodContentView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        self.HMH_playerView.frame = self.HMH_vodContentView.frame;
        self.HMH_lockBtn.hidden = NO;
        self.HMH_shareBtn.hidden = YES;
        self.HMH_lockBtn.frame = CGRectMake(10, self.HMH_vodContentView.frame.size.height / 2 - 25, 50, 50);
        self.HMH_videoBottomView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_vodContentView.frame), self.HMH_vodContentView.frame.size.width, 30);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame) + 10, ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame));
        
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
    }else{
        [self.navigationController setNavigationBarHidden:true];
        
        self.HMH_vodContentView.frame = CGRectMake(0, self.HMH_statusHeghit, self.view.width, self.view.width*9/16);
        self.HMH_playerView.frame = CGRectMake(0, 0, self.HMH_vodContentView.frame.size.width, self.HMH_vodContentView.frame.size.height);
        self.HMH_shareBtn.hidden = NO;
        self.HMH_lockBtn.hidden = YES;
        self.HMH_lockBtn.frame = CGRectMake(10, self.HMH_vodContentView.frame.size.height / 2 - 25, 50, 50);
        self.HMH_videoBottomView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_vodContentView.frame), self.HMH_vodContentView.frame.size.width, 30);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame), ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame)) ;
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
        
    }
    //    self.indicationrView.center = self.mediaPlayer.view.center;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSString *)returndate:(NSTimeInterval)num{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    return [dateformatter stringFromDate:date1];
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark - AliyunVodPlayerDelegate
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            //播放准备完成时触发
            if (_HMH_isRedLeave) {
                [_vodPlayer pause];
                _HMH_isRedLeave = NO;
            }
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发
            break;
        case AliyunVodPlayerEventFirstFrame:
            //播放视频首帧显示出来时触发
            if (_HMH_isRedLeave) {
                [_vodPlayer pause];
                _HMH_isRedLeave = NO;
            }

            break;
        case AliyunVodPlayerEventPause:
            //视频暂停时触发
            break;
        case AliyunVodPlayerEventStop:
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
            break;
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            break;
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            break;
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            break;
        default:
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    // errorModel.errorMsg
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"视频加载失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alert show];
}

#pragma mark - timerRun
- (void)timerRun:(NSTimer *)sender{
    if (self.vodPlayer) {
        //开始时间
        double s = self.vodPlayer.timeShiftModel.startTime;
        //记录总的结束时间， getmodel 直播时间 - 播放时间<2分钟， getmodel直播时间+5分钟
        if (self.HMH_tempTotalTime ==0) {
            self.HMH_tempTotalTime = self.vodPlayer.timeShiftModel.endTime;
        }
        //可时移时间
        double shiftTime = (self.vodPlayer.timeShiftModel.endTime - self.vodPlayer.timeShiftModel.startTime)*0.1;
//        //直播结束时间
//        double liveEnd = self.vodPlayer.currentPlayTime + shiftTime;
        
        if ((self.HMH_tempTotalTime-self.vodPlayer.liveTime)<0.5*shiftTime) {
            self.HMH_tempTotalTime = self.vodPlayer.liveTime+shiftTime;
        }
        //进度条总长度
        double n = self.HMH_tempTotalTime - s;
        
        //播放进度百分比，小球位置
        double t = (self.vodPlayer.currentPlayTime-s)/n;
//        NSLog(@"self -- %f--%f---%f---%f",self.vodPlayer.currentPlayTime,t,s,n);
        if (isnan(t)|isinf(t)) {
            t = 0;
        }
        //直播进度百分比，红色区域
        double p = (self.vodPlayer.liveTime-s)/n;
        
        //红色竖线位置
        if (isnan(p)|isinf(p)) {
            p = 0;
        }
    }
}

- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer *)vodPlayer{
}

- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer {
    
}

- (void)networkStateChange{
    if(!self.vodPlayer) return;
    [self networkChangePop:NO];
}

-(BOOL)networkChangePop:(BOOL)isShow{
    BOOL ret = NO;
    switch ([self.reachability currentReachabilityStatus]) {
        case NotReachable:
        {
            ret = YES;
        }
            break;
        case ReachableViaWiFi:
            
            break;
        case ReachableViaWWAN:
            
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName withRequestType:(NSString *)requestType{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestMethod;
    YTKRequestSerializerType type = YTKRequestSerializerTypeHTTP;
    if ([requestType isEqualToString:@"get"]) {
        requestMethod = YTKRequestMethodGET;
    }else if ([requestType isEqualToString:@"put"]) {
        requestMethod = YTKRequestMethodPUT;
        type = YTKRequestSerializerTypeJSON;
    }else {
        requestMethod = YTKRequestMethodPOST;
        type = YTKRequestSerializerTypeJSON;
    }

    [HFCarRequest requsetUrl:urlstr1 withRequstType:requestMethod requestSerializerType:type params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if(request.requestMethod == YTKRequestMethodGET ) {
            [weakSelf getPrcessdata:request.responseObject];
        }else if (request.requestMethod == YTKRequestMethodPUT) {
             weakSelf.HMH_videoBottomView.shouCangBtn.selected = YES;
        }else {
            if ([requestName isEqualToString:@"delete"]) { // "取消收藏成功"
                weakSelf.HMH_videoBottomView.shouCangBtn.selected = NO;
            }else if ([requestName isEqualToString:@"redPacket"]){ // 红包
                [weakSelf redPacketRequestDataCallBack:request.responseObject];
            } else { // 插入观看次数成功
            }
        }
       
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
    }];
    
    
    
//    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
//        if(request.requestMethod == YTKRequestMethodGET ) {
//            [weakSelf getPrcessdata:request.responseObject];
//        }else if (request.requestMethod == YTKRequestMethodPUT) {
//
//        }else {
//            if ([requestName isEqualToString:@"delete"]) { // "取消收藏成功"
//            }else if ([requestName isEqualToString:@"redPacket"]){ // 红包
//                [weakSelf redPacketRequestDataCallBack:request.responseObject];
//            } else { // 插入观看次数成功
//            }
//        }
//
//    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"失败");
//
//    }];
}

- (void)getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        self.HMH_videoModel = [[HMHVideoListModel alloc] init];
        [self.HMH_videoModel setValuesForKeysWithDictionary:dataDic];
        self.HMH_titleLab.text = self.HMH_videoModel.title;
        [_HMH_videoBottomView refreshPlayerBottomViewWithModel:self.HMH_videoModel isFromTimeLive:YES];
        
        [self refreshCourseware];
        
        NSString *videoStr;
        if (self.HMH_videoModel.videoUrl.length>0) {
            videoStr = self.HMH_videoModel.videoUrl;
        }
        
        NSURL *url = [NSURL URLWithString:videoStr];
        [self.vodPlayer prepareWithURL:url];
        
        self.vodPlayer.autoPlay = YES; // 进入直播时  默认是播放
    }
}

// 刷新课件
- (void)refreshCourseware{
    // 课件地址 以“|”分割  title以"_"分割
    if (self.HMH_videoModel.coursewareAddr.length > 0 && ![self.HMH_videoModel.coursewareAddr isEqualToString:@"(null)"]) {
        NSArray *arr = [self.HMH_videoModel.coursewareAddr componentsSeparatedByString:@"|"];
        for (int i = 0; i < arr.count; i++) {
            if ([arr[i] length] > 0) {
                NSString *url = arr[i];
                // 目的是为了去掉 url后的 “|”
                NSString *endStr = [url substringFromIndex:url.length- 1];
                NSString *normalStr;
                if ([endStr isEqualToString:@"|"]) {
                    normalStr = [url substringToIndex:url.length - 1];
                } else {
                    normalStr = url;
                }
                [_HMH_coursewareUrlArr addObject:normalStr];
                NSArray *allTitleArr = [arr[i] componentsSeparatedByString:@"_"];
                if (allTitleArr.count == 2) {
                    if ([allTitleArr[1] length] > 0) {
                        [_HMH_coursewareTitleArr addObject:allTitleArr[1]];
                    }
                }
            }
        }
    }
    // 是否显示或隐藏课件
    [_HMH_courseView refreshUIWithCoursewareUrlArr:_HMH_coursewareUrlArr isFromTimeShift:YES redPacketWithModel:_HMH_redModel];
}
// 红包数据返回
- (void)redPacketRequestDataCallBack:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) { // fy_hongbao_openBalance
        NSDictionary *dataDic = resDic[@"data"];
        if (!dataDic) {
            [self invalidateRedPacketTimer];
            return;
        }
        _HMH_redModel = [[HMHVideoRedPacketModel alloc] init];
        [_HMH_redModel setValuesForKeysWithDictionary:dataDic];
        /*
         1 当前视频是否有红包 有则按时间轮询 否则app不轮询
         2 如果 hasRedPacket返回false 则停止定时器
         3 如果当前窗口退出 则停止定时器 并销毁
         4 hong键 或者重新打开窗口 定时器不用停止
         */
        [_HMH_courseView refreshUIWithCoursewareUrlArr:_HMH_coursewareUrlArr isFromTimeShift:YES redPacketWithModel:_HMH_redModel];

        if ([_HMH_redModel.hasRedPacket boolValue]) {
            if (self.HMH_redPacketTimer==nil) {
                if ([_HMH_redModel.interval floatValue] > 0) {
                    self.HMH_redPacketTimer = [NSTimer timerWithTimeInterval:[_HMH_redModel.interval floatValue] target:self selector:@selector(redPacketRequest:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.HMH_redPacketTimer forMode:NSDefaultRunLoopMode];
                } else { // 返回轮询时间小于0
                    [self invalidateRedPacketTimer];
                }
            }
        } else { // 没有红包
            [_HMH_courseView refreshUIWithCoursewareUrlArr:_HMH_coursewareUrlArr isFromTimeShift:YES redPacketWithModel:nil];

            [self invalidateRedPacketTimer];
        }
    } else { // 失败
        [self invalidateRedPacketTimer];
    }
}
-(void)invalidateRedPacketTimer{
    if (self.HMH_redPacketTimer) {
        [self.HMH_redPacketTimer invalidate];
        self.HMH_redPacketTimer = nil;
    }
}
// 定时器 红包请求
-(void)redPacketRequest:(NSTimer *)timer{
    [self HMH_redPacketRequestData];
}

#pragma mark
#pragma mark 进入后台
- (void)appVodDidEnterBackground:(NSNotification*)note{
    if (self.vodPlayer.playerState !=AliyunVodPlayerStatePause) {
        [self.vodPlayer pause];
        self.HMH_playOrPauseBtn.selected = YES;
    }
}
#pragma mark
#pragma mark 进入前台
- (void)appVodWillEnterForeground:(NSNotification*)note{
    if (self.vodPlayer.playerState ==AliyunVodPlayerStatePause) {
//        [self.vodPlayer resume];
        self.HMH_playOrPauseBtn.selected = YES;
    }
    self.HMH_fullScreenBtn.selected = NO;
    self.HMH_isLock = NO;
    self.HMH_lockBtn.hidden = YES;
    [self HMH_showControlView];
}


#pragma mark
#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //这个是用来判断, 如果有多个手指点击则不做出响应
    UITouch * touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1 || event.allTouches.count > 1) {
        return;
    }
    //    这个是用来判断, 手指点击的是不是本视图, 如果不是则不做出响应
    if (![[(UITouch *)touches.anyObject view] isEqual:self.HMH_vodContentView] &&  ![[(UITouch *)touches.anyObject view] isEqual:self.vodPlayer]) {
//        return;
    }
    [super touchesBegan:touches withEvent:event];
    
    //触摸开始, 初始化一些值
    HMH_hasMoved = NO;
    //位置
    _HMH_touchBeginPoint = [touches.anyObject locationInView:self.HMH_vodContentView];
    //亮度
    HMH_touchBeginLightValue = self.vodPlayer.brightness;
    //声音
    HMH_touchBeginVoiceValue = self.vodPlayer.volume;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.HMH_isLock) { // 如果是锁屏 则不操作
        return;
    }
    UITouch * touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1  || event.allTouches.count > 1) {
        return;
    }

    if (![[(UITouch *)touches.anyObject view] isEqual:self.HMH_vodContentView] && ![[(UITouch *)touches.anyObject view] isEqual:self.view]) {
//        return;
    }
    [super touchesMoved:touches withEvent:event];
    
    //如果移动的距离过于小, 就判断为没有移动
    CGPoint tempPoint = [touches.anyObject locationInView:self.HMH_vodContentView];
    if (fabs(tempPoint.x - _HMH_touchBeginPoint.x) < 15 && fabs(tempPoint.y - _HMH_touchBeginPoint.y) < 15) {
        return;
    }
    HMH_hasMoved = YES;
    //如果还没有判断出使什么控制手势, 就进行判断
    //滑动角度的tan值
    float tan = fabs(tempPoint.y - _HMH_touchBeginPoint.y)/fabs(tempPoint.x - _HMH_touchBeginPoint.x);
    if(tan > sqrt(3)){  //当滑动角度大于60度的时候, 声音和亮度
        //判断是在屏幕的左半边还是右半边滑动, 左侧控制为亮度, 右侧控制音量
        if (_HMH_touchBeginPoint.x < self.HMH_vodContentView.frame.size.width/2) {
            _controlType = TimelightControl;
        }else{
            _controlType = TimevoiceControl;
        }
        //            _controlJudge = YES;
    }else{     //如果是其他角度则不是任何控制
        _controlType = TimenoneControl;
        return;
    }
    if(_controlType == TimevoiceControl){    //如果是音量手势
        if (self.HMH_isFullScreen) {//全屏的时候才开启音量的手势调节
            
            if (self.HMH_enableVolumeGesture) {
                //根据触摸开始时的音量和触摸开始时的点去计算出现在滑动到的音量
                float voiceValue = HMH_touchBeginVoiceValue - ((tempPoint.y - _HMH_touchBeginPoint.y)/self.HMH_vodContentView.frame.size.height);
                //判断控制一下, 不能超出 0~1
                if (voiceValue < 0) {
                    self.vodPlayer.volume = 0;
                }else if(voiceValue > 1){
                    self.vodPlayer.volume = 1;
                }else{
                    self.vodPlayer.volume = voiceValue;
                }
            }
        }else{
            return;
        }
    }else if(_controlType == TimelightControl){   //如果是亮度手势
        //显示音量控制的view
        [self hideTheLightViewWithHidden:NO];
        if (self.HMH_isFullScreen) {
            //根据触摸开始时的亮度, 和触摸开始时的点来计算出现在的亮度
            float tempLightValue = HMH_touchBeginLightValue - ((tempPoint.y - _HMH_touchBeginPoint.y)/self.HMH_vodContentView.frame.size.height);
            if (tempLightValue < 0) {
                tempLightValue = 0;
            }else if(tempLightValue > 1){
                tempLightValue = 1;
            }
            //        控制亮度的方法
            [self.vodPlayer setBrightness:tempLightValue];
        }else{
        }
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.HMH_isLock) { // 如果是锁屏 则不操作
        return;
    }
    [super touchesCancelled:touches withEvent:event];
    //判断是否移动过,
    if (HMH_hasMoved) {
        if (_controlType == TimelightControl){//如果是亮度控制, 控制完亮度还要隐藏显示亮度的view
            [self hideTheLightViewWithHidden:YES];
        }
    }else{    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.HMH_isLock) { // 如果是锁屏 则不操作
        return;
    }
    [self hideTheLightViewWithHidden:YES];
    [super touchesEnded:touches withEvent:event];
    //判断是否移动过,
    if (HMH_hasMoved) {
        if (_controlType == TimelightControl){//如果是亮度控制, 控制完亮度还要隐藏显示亮度的view
            [self hideTheLightViewWithHidden:YES];
        }
    }else{    }
}

#pragma mark -
#pragma mark - 用来控制显示亮度的view, 以及毛玻璃效果的view
-(void)hideTheLightViewWithHidden:(BOOL)hidden{
    if (self.HMH_isFullScreen) {//全屏才出亮度调节的view
        if (hidden) {
            [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                    self.HMH_effectView.alpha = 0.0;
                }
            } completion:nil];
        }else{
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                self.HMH_effectView.alpha = 1.0;
            }
        }
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            self.HMH_effectView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.height)/2-155/2, ([UIScreen mainScreen].bounds.size.width)/2-155/2, 155, 155);
        }
    }else{
        return;
    }
}

- (void)dealloc{
    [self.vodPlayer pause];
    [self.HMH_autoDismissTimer invalidate];
    self.HMH_autoDismissTimer = nil;
    [self.HMH_redPacketTimer invalidate];
    self.HMH_redPacketTimer = nil;
    [self.vodPlayer releasePlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
