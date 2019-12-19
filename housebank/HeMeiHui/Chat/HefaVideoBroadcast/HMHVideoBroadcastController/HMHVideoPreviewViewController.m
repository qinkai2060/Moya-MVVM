//
//  HMHVideoPreviewViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoPreviewViewController.h"
#import "HMHVideoDescribeViewController.h"
#import "HMHVideoInteractionViewController.h"
#import "HMHVideoPreviewTopView.h"
#import "AliWMPlayerView.h"
#import "HFLoginViewController.h"

@interface HMHVideoPreviewViewController ()<AliWMPlayerDelegate,ShareToolDelegete>
{
    NSArray *HMH_titleArr;
    UIPageViewController *HMH_pageView;
    NSInteger index;
    NSMutableArray *HMH_vcArr;
    UIButton *HMH_weakBtn;
    
    UIView *HMH_moveLine;
    HMHVideoDescribeViewController *HMH_describeVC;
    HMHVideoInteractionViewController *HMH_interactionVC;
}
@property (nonatomic, strong) HMHVideoPreviewTopView *HMH_topView;

//@property (nonatomic, strong) WMPlayer *player;
@property (nonatomic, strong) AliWMPlayerView *player;

@property (nonatomic, assign) CGRect HMH_originalFrame;
@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) UIView *HMH_bgView;
// 显示或隐藏状态栏
@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, strong) HMHVideoListModel *HMH_videoModel;
//
@property (nonatomic, assign) BOOL HMH_isFristIn;

@property (nonatomic, strong) ShareTools *shareTool;
// 用来判断当前预告视频是否已播放完 （播放 和 重新播放是两个方法）
@property (nonatomic, assign) BOOL HMH_isPreViewFinish;

@end

@implementation HMHVideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _shareTool = [[ShareTools alloc]init];
    _shareTool.delegete = self;

    [self HMH_initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isFull = YES;
    // 获取视频信息
    [self loadVideoData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isFull = NO;
    if (self.player) {
        if (self.player.vodPlayer.playerState != AliyunVodPlayerStatePause) {
            [self.player pause];
            // 改变播放暂停的状态
            self.player.playOrPauseBtn.selected = YES;
        }
    }
}

// 更新视频观看次数
-(void)HMH_videoHitsRequest{
//    NSString *uuidStr = [VersionTools UUIDString];
//    NSDictionary *dic = @{@"watcherId":uuidStr};

    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-hits/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@/%@",getUrlStr,self.videoNum];
    }

    [self requestData:nil withUrl:getUrlStr requestType:@"post"];
}


- (void)HMH_initData{
    HMH_titleArr = @[@"简介",@"互动"];
    HMH_vcArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    self.HMH_isFristIn = YES;
    
    index = 100;
    [self HMH_createTopView];
    [self HMH_createPlayer];
    [self HMH_createUI];
    [self HMH_createPageView];
    
    self.player.hidden = YES;
    self.HMH_topView.hidden = NO;
}

- (void)HMH_createPlayer{
    self.HMH_originalFrame = CGRectMake(0, self.HMH_statusHeghit, self.view.bounds.size.width, self.view.frame.size.width*9/16);
    self.player = [[AliWMPlayerView alloc] init];
    self.player.delegate = self;
    [self.view addSubview:_player];
}

// 视频数据请求
- (void)loadVideoData{
    if (self.videoNum.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];

        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-info/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNum,sidStr];
        }

        [self requestData:nil withUrl:getUrlStr requestType:@"get"];
    }
}

- (void)HMH_createTopView{
    _HMH_topView = [[HMHVideoPreviewTopView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit, ScreenW, self.view.frame.size.width*9/16)];
    __weak typeof(self) weakSelf = self;
    _HMH_topView.backClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _HMH_topView.shareBtnBlock = ^{
        
        [weakSelf videoShare];
    };
    _HMH_topView.seePreViewBlock = ^{
//        NSLog(@"看预告片");
        weakSelf.HMH_topView.hidden = YES;
        weakSelf.player.hidden = NO;
        
        if (weakSelf.HMH_isPreViewFinish) {
            weakSelf.player.isPreviewPlayAgain = YES;

            [weakSelf.player play];
        } else {
            NSURL *url = [NSURL URLWithString:weakSelf.HMH_videoModel.coverVideoUrl];
            
            [weakSelf.player setURLString:url.absoluteString];
            weakSelf.player.isPreviewPlayAgain = YES; // 用来去人是否是从预告页进入的
            [weakSelf.player play];
            weakSelf.player.vodPlayer.autoPlay = YES; // 进入预告时  默认是播放
            weakSelf.player.titleLabel.text = weakSelf.HMH_videoModel.title;
        }
        weakSelf.HMH_isPreViewFinish = NO;
    };
    _HMH_topView.yuYueBtnClick = ^{
        NSLog(@"预约观看");
        [weakSelf judgeLoginToPreview];
    };
    [self.view addSubview:_HMH_topView];
}

- (void)judgeLoginToPreview{
    if (self.isLogin) {
        [self previewRequestData];
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
        [weakSelf previewRequestData];
    };
}
// 预约请求
-(void)previewRequestData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    if (self.HMH_videoModel.appointment) {//如果点过预约了 就不能点击了
        return;
    } else {
        if (self.HMH_videoModel.vno && self.HMH_videoModel.liveStartTime) {
            // 预约观看数据请求
            NSDictionary *dic = @{@"vno":self.HMH_videoModel.vno,@"apptTime":self.HMH_videoModel.liveStartTime,@"tuiId":@0};
            NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-appointment/appointment/save"];
            if (getUrlStr) {
                getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
            }
            [self requestData:dic withUrl:getUrlStr requestType:@"put"];
        }
    }
}

- (void)HMH_createUI{
    _HMH_bgView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.player.frame), ScreenW, 44)];
    _HMH_bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_HMH_bgView];
    
    CGFloat width=ScreenW/HMH_titleArr.count;
    for (NSInteger i=0; i<HMH_titleArr.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(width*i,0, width - 10, 44 - 1)];
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
    }
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0,43, ScreenW, 1)];
    lineLab.backgroundColor = RGBACOLOR(226, 228, 229, 1);
    [_HMH_bgView addSubview:lineLab];
}
-(void)HMH_createPageView{
    __weak  typeof( self)weakSelf=self;
    HMH_describeVC = [[HMHVideoDescribeViewController alloc]init];
    HMH_describeVC.isFromVodPlay = NO;
    HMH_describeVC.videoNum = self.videoNum;
    [HMH_describeVC setMyBlock:^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [HMH_describeVC setMyPopBlock:^(UIViewController *vc) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [HMH_vcArr addObject:HMH_describeVC];
    
    HMH_interactionVC = [[HMHVideoInteractionViewController alloc]init];
    HMH_interactionVC.videoNum = self.videoNum;
    [HMH_interactionVC setMyBlock:^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [HMH_vcArr addObject:HMH_interactionVC];
    
    HMH_pageView=[[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    HMH_pageView.view.frame=CGRectMake(0,self.HMH_statusHeghit + 44 + self.view.frame.size.width*9/16, ScreenW, ScreenH-44 - self.view.frame.size.width*9/16 - self.HMH_statusHeghit);
    
    [HMH_pageView setViewControllers:@[HMH_vcArr[[self.indexSelected intValue]]] direction:0 animated:YES completion:nil];
    [self.view addSubview:HMH_pageView.view ];
    
    //
    UIScrollView *sc=(UIScrollView *)HMH_pageView.view.subviews[0];
    sc.scrollEnabled=NO;
    CGFloat width=ScreenW/2.0;
    HMH_moveLine=[[UIView alloc]initWithFrame:CGRectMake(width*[self.indexSelected intValue], CGRectGetMaxY(_HMH_bgView.frame) - 1, width, 2)];
    HMH_moveLine.backgroundColor= RGBACOLOR(181,148,89,1);
    [self.view addSubview:HMH_moveLine];
}

-(void)headerSwitchBtnClick:(UIButton *)sender{
    HMH_weakBtn.selected=NO;
    sender.selected=YES;
    
    HMH_weakBtn=sender;
    [HMH_pageView setViewControllers:@[HMH_vcArr[sender.tag-100]] direction:(sender.tag < index) animated:YES completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=  HMH_moveLine.frame;
        rect.origin.x=sender.frame.origin.x;
        HMH_moveLine.frame=rect;
    }];
    index=sender.tag;
}

#pragma mark rotate
/**
 *  旋转屏幕的时候，是否自动旋转子视图，NO的话不会旋转控制器的子控件
 *
 */
- (BOOL)shouldAutorotate
{
    return true;
}

/**
 *  当前控制器支持的旋转方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft  ;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.player.isFullscreen)
        return UIInterfaceOrientationPortrait;
    return UIInterfaceOrientationLandscapeRight ;
}

/**
 需要切换的屏幕方向，手动转屏
 */
- (void)setFullScreen:(BOOL)isFullScreen {
    self.isFullScreen = isFullScreen;
    if (isFullScreen) {
        [self rotateOrientation:UIInterfaceOrientationLandscapeRight];
        self.player.lockBtn.hidden = NO;
        self.player.shareBtn.hidden = YES;
    }else{
        [self rotateOrientation:UIInterfaceOrientationPortrait];
        self.player.lockBtn.hidden = YES;
        self.player.shareBtn.hidden = NO;
    }
}

- (void)rotateOrientation:(UIInterfaceOrientation)orientation {
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
}

//自动转屏或者手动调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    self.isFullScreen = size.width > size.height;
}

// 是否显示状态栏
- (BOOL)prefersStatusBarHidden{
    return _navigationBarHidden;
}

#pragma mark 重新布局
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.isFullScreen){
        
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.view.bounds;
        self.player.playerView.frame = self.player.frame;

        self.player.isFullscreen = true;
        //        self.player.lockBtn.hidden = NO;
        self.player.shareBtn.hidden = YES;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.player.frame), ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame));

        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
    }else{
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.HMH_originalFrame;
        self.player.playerView.frame = CGRectMake(0, 0, self.player.frame.size.width, self.player.frame.size.height);

        self.player.isFullscreen = false;
        self.player.shareBtn.hidden = NO;
        self.player.lockBtn.hidden = YES;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.player.frame), ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame));
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
    }
}

#pragma mark - player view delegate
// 点击分享时的代理方法
- (void)videoPlayerDoShare{
    
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    [self videoShare];
}

- (void)videoShare{
    if (self.HMH_videoModel) {
        NSString *shareUrlStr;
        PopAppointViewControllerToos *tools = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
        if (tools.popWindowUrlsArrary.count) {
            for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
                if([model.pageTag isEqualToString:@"fy_video_preview"]) {
                    
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
//            [_shareTool doShare:dic];
        }
    }
}


// 分享状态返回
- (void)sendShareState:(NSString *)state{
    
}

// 分享状态返回 1 成功    2 失败   -1 失败 为安装客户端
- (void)shareResultState:(NSString *)state{
    NSString *sidStr = [self getUserSidStr];
    if ([state isEqualToString:@"1"] && [self isJudgeLogin]) {
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"asset.integral/share/benefit"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }
        [self requestData:nil withUrl:getUrlStr requestType:@"post"];
    }
}

//点击播放暂停按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
//    NSLog(@"%s", __func__);
}
//点击关闭按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    
    if (self.player.isFullscreen) {
        [self setFullScreen:false];
    }else{
        [_player pause];
        [_player destroyPlayer];
        self.player.vodPlayer = nil;

        [self.navigationController popViewControllerAnimated:true];
    }
}
//点击全屏按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    fullScreenBtn.selected = !fullScreenBtn.selected;
    
    [self setFullScreen:!self.player.isFullscreen];
}
//单击WMPlayer的代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    
}
//双击WMPlayer的代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
//    NSLog(@"%s", __func__);
}
//WMPlayer的的操作栏隐藏和显示
-(void)wmplayer:(AliWMPlayerView *)wmplayer isHiddenTopAndBottomView:(BOOL )isHidden withBottomView:(UIView *)bottomView topView:(UIView *)topView lockBtn:(UIButton *)lockBtn isLock:(BOOL)isLock{
    if (isHidden) {
        [UIView animateWithDuration:0.5 animations:^{
            self.player.lockBtn.hidden = YES;
            bottomView.alpha = 0.0;
            topView.alpha = 0.0;
            _navigationBarHidden = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finish){
            
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            if (self.isFullScreen) { // 全屏状态下
                if (isLock) {
                    self.player.lockBtn.selected = YES;
                    self.player.lockBtn.hidden = NO;
                } else {
                    self.player.lockBtn.selected = NO;
                    self.player.lockBtn.hidden = NO;
                    
                    bottomView.alpha = 1.0;
                    topView.alpha = 1.0;
                    _navigationBarHidden = NO;
                    
                }
            } else {
                self.player.lockBtn.hidden = YES;
                
                bottomView.alpha = 1.0;
                topView.alpha = 1.0;
                _navigationBarHidden = NO;
            }
            
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finish){
            
        }];
    }
}

///播放状态
//播放失败的代理方法
-(void)wmplayerFailedPlay:(AliWMPlayerView *)wmplayer WMPlayerStatus:(CustomWMPlayerState)state{
//    NSLog(@"%s", __func__);
}
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(AliWMPlayerView *)wmplayer WMPlayerStatus:(CustomWMPlayerState)state{
    
    if (self.HMH_isFristIn) {
        // 插入视频观看次数
        [self HMH_videoHitsRequest];
        
        self.HMH_isFristIn = NO;
    }
}

//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(AliWMPlayerView *)wmplayer{
    if (self.player.isFullscreen) {
        [self setFullScreen:false];
    }
    self.player.hidden = YES;
    self.player.isPreviewPlayAgain = NO;
    self.HMH_topView.hidden = NO;
    self.HMH_isPreViewFinish = YES;
}
// 数据请求
#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url requestType:(NSString *)requestType{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestTypeMethod;
    if ([requestType isEqualToString:@"get"]){
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
    }
    
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([requestType isEqualToString:@"get"]){
            [weakSelf HMH_getVideoInfoPrcessdata:request.responseObject];
        }else if ([requestType isEqualToString:@"put"]) {
            [weakSelf HMH_getPrcessdata:request.responseObject];
        } else {
            
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}
// 预约数据返回
- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        self.HMH_videoModel.appointment = YES;
        if (self.HMH_videoModel.appointment) {//测试的key
            [_HMH_topView.previewBtn setTitle:@"已预约" forState:UIControlStateNormal];
        } else {
            [_HMH_topView.previewBtn setTitle:@"预约观看" forState:UIControlStateNormal];
        }
        _HMH_topView.previewBtn.selected = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您已预约成功，节目前5分钟将发送APP消息提醒，请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

// 视频信息数据返回
- (void)HMH_getVideoInfoPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        self.HMH_videoModel = [[HMHVideoListModel alloc] init];
        [self.HMH_videoModel setValuesForKeysWithDictionary:dataDic];
        
        [_HMH_topView refreshViewWithModel:self.HMH_videoModel];
    }
}

- (void)dealloc {
    [_player pause];
    [_player destroyPlayer];
    self.player.vodPlayer = nil;
    [_player removeFromSuperview];
}

@end
