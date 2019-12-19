//
//  PlayerViewController.m
//  YCDownloadSession
//
//  Created by wz on 2017/9/30.
//  Copyright © 2017年 onezen.cc. All rights reserved.
//

#import "HMHVideoVodPlayerViewController.h"
#import "HMHVideoEveryoneSaidViewController.h"
#import "HMHVideoMorewonderfulViewController.h"
#import "HMHVideoPlayBottomView.h"
#import "HMHVideoDescribeViewController.h"
#import "HMHVideoCoursewareViewController.h"
#import "HMHCoursewareAndRedpacketView.h"
#import "HFLoginViewController.h"

@interface HMHVideoVodPlayerViewController ()<WMPlayerDelegate,ShareToolDelegete,CoursewareAndRedpacketDelegate>
{
    NSArray*HMH_titleArr;
    
    UIPageViewController *HMH_pageView;
    NSInteger HMH_index;
    NSMutableArray *HMH_vcAr;
    UIButton *HMH_weakBtn;
    
    UIView*HMH_moveLine;
    HMHVideoEveryoneSaidViewController *HMH_first;
    HMHVideoDescribeViewController *HMH_second;
    HMHVideoMorewonderfulViewController *HMH_third;
}

@property (nonatomic, assign) CGRect HMH_originalFrame;
@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) UIView *HMH_bgView;
// 显示或隐藏状态栏
@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, strong) HMHVideoPlayBottomView *HMH_videoBottomView;

@property (nonatomic, strong) HMHVideoListModel *HMH_videoModel;
// 用来判断观看历史的
@property (nonatomic, assign) BOOL HMH_isFristIn;
@property (nonatomic, strong) ShareTools *shareTool;
// 课件 红包
@property (nonatomic, strong) HMHCoursewareAndRedpacketView *HMH_courseView;
@property (nonatomic, strong) NSMutableArray *HMH_coursewareUrlArr;
@property (nonatomic, strong) NSMutableArray *HMH_coursewareTitleArr;

@end

@implementation HMHVideoVodPlayerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if(self.player.state !=WMPlayerStatePause){
        [_player pause];
    }
}

// 插入观看历史
-(void)HMH_watchHistoryRequest{
    NSTimeInterval currentTime = self.player.currentTime;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-watchhistory/watchhistory/save"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }
    // {vno:视屏编号,episode:集数（默认0）,seekTime:播放时间（默认0）}
    NSString *currentTimeStr = [NSString stringWithFormat:@"%f",currentTime];
    NSDictionary *dic = @{@"vno":self.videoNo,@"episode":@1,@"seekTime":[NSNumber numberWithLong:[currentTimeStr longLongValue]]};
    
    [self requestData:dic withUrl:getUrlStr withRequestName:@"history" withRequestType:@"put"];
}

// 更新视频观看次数
-(void)HMH_videoHitsRequest{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
//    NSString *uuidStr = [VersionTools UUIDString];
//    NSDictionary *dic = @{@"watcherId":uuidStr};
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-hits/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNo,sidStr];
    }

    [self requestData:nil withUrl:getUrlStr withRequestName:@"hits" withRequestType:@"post"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _HMH_coursewareUrlArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_coursewareTitleArr = [NSMutableArray arrayWithCapacity:1];
    
    _shareTool = [[ShareTools alloc]init];
    _shareTool.delegete = self;
    
    self.HMH_originalFrame = CGRectMake(0, self.HMH_statusHeghit, self.view.bounds.size.width, self.view.frame.size.width*9/16);
    // 更新观看次数时用
    self.HMH_isFristIn = YES;
    
    self.player = [[WMPlayer alloc] init];
    self.player.delegate = self;
    [self.view addSubview:_player];
    
    [self HMH_createPageController];
    
    // 获取视频信息
    [self loadData];
}
// 视频数据请求
- (void)loadData{
    if (self.videoNo.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-info/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNo,sidStr];
        }
        [self requestData:nil withUrl:getUrlStr withRequestName:@"" withRequestType:@"get"];
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
    // 视频底部的view
    _HMH_videoBottomView = [[HMHVideoPlayBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30)];
    
    __weak typeof(self)weakSelf = self;
    _HMH_videoBottomView.shouCangBtnClick = ^(NSInteger state) {
        // state  2 收藏    1 取消收藏
        [weakSelf isJudgeLoginFavoriteWithState:state];
    };
    
    _HMH_videoBottomView.downloadBtnClick = ^{
        NSLog(@"回放下载按钮的点击事件");
        
//        [weakSelf.player pause];

    };
    [self.view addSubview:_HMH_videoBottomView];

    
    _HMH_bgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_HMH_videoBottomView.frame), ScreenW, 44)];
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

// 点击收藏时 判断登录
- (void)isJudgeLoginFavoriteWithState:(NSInteger)state{
    if (self.isLogin) {
        [self videoBottomViewFavoriteWithState:state];
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
        [weakSelf videoBottomViewFavoriteWithState:state];
    };
}
// 收藏 取消收藏
- (void)videoBottomViewFavoriteWithState:(NSInteger)state{
    // state  2 收藏    1 取消收藏
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (state == 1) { // 取消收藏
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/delete"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNo,sidStr];
        }

        [self requestData:nil withUrl:getUrlStr withRequestName:@"delete" withRequestType:@"post"];
    } else { // 收藏
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/save"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }
        NSDictionary *dic = @{@"vno":self.videoNo};
        
        [self requestData:dic withUrl:getUrlStr withRequestName:@"" withRequestType:@"put"];
    }
}


-(void)HMH_createPageView{
    __weak  typeof(self)weakSelf=self;
    HMH_first=[[HMHVideoEveryoneSaidViewController alloc]init];
    HMH_first.videoNum = self.videoNo;
    [HMH_first setMyBlock:^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
//        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    [HMH_vcAr addObject:HMH_first];
    
    HMH_second=[[HMHVideoDescribeViewController alloc]init];
    HMH_second.isFromVodPlay = YES;
    HMH_second.videoNum = self.videoNo;
    //    HMH_second.CityId=self.CityId;
    [HMH_second setMyBlock:^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [HMH_second setMyPopBlock:^(UIViewController *vc) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [HMH_vcAr addObject:HMH_second];
    
    HMH_third=[[HMHVideoMorewonderfulViewController alloc]init];
    HMH_third.videoNum=self.videoNo;
    [HMH_third setMyBlock:^(UIViewController *vc) {
        if(weakSelf.player.state !=WMPlayerStatePause){
            [weakSelf.player pause];
        }
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    
    [HMH_vcAr addObject:HMH_third];
    
    HMH_pageView=[[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, self.view.frame.size.height-CGRectGetMaxY(_HMH_bgView.frame)) ;
    
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
    _HMH_courseView.delegate = self;
    [self.view addSubview:_HMH_courseView];
}
// 课件按钮的点击事件
- (void)pptBtnClickWithBtn:(UIButton *)pptBtn{
    if(self.player.state !=WMPlayerStatePause){
        [_player pause];
    }
    
    self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext; //半透明
    HMHVideoCoursewareViewController *vc = [[HMHVideoCoursewareViewController alloc] init];
    vc.urlArr = self.HMH_coursewareUrlArr;
    vc.titleArr = self.HMH_coursewareTitleArr;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
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

#pragma mark rotate
// *  旋转屏幕的时候，是否自动旋转子视图，NO的话不会旋转控制器的子控件
- (BOOL)shouldAutorotate{
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
//    if (self.player.isFullscreen)
//        return UIInterfaceOrientationPortrait;
//    return UIInterfaceOrientationLandscapeRight ;
    if (self.player.isFullscreen)
        return UIInterfaceOrientationLandscapeRight ;

        return UIInterfaceOrientationPortrait;
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


#pragma mark - player view delegate
// 点击分享时的代理方法
- (void)videoPlayerDoShare{
    
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    if (self.HMH_videoModel) {
        NSString *shareUrlStr;
        PopAppointViewControllerToos *tools = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
        if (tools.popWindowUrlsArrary.count) {
            
            for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
                if([model.pageTag isEqualToString:@"fy_video_play"]) {
                    
                    shareUrlStr = [NSString stringWithFormat:@"%@?vno=%@&shareId=%@",model.url,self.HMH_videoModel.vno,[self getUserUidStr]];
                }
            }
        }
        // @"shareDesc":@"测试分享描述",
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
        [self requestData:nil withUrl:getUrlStr withRequestName:@"" withRequestType:@"post"];
    }
}

//点击播放暂停按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
//    NSLog(@"%s", __func__);
}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    if (self.player.isFullscreen) {
        [self setFullScreen:false];
    }else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        if (sidStr.length > 0 && ![sidStr isEqualToString:@"(null)"]) {//已经登录
            [self HMH_watchHistoryRequest];
        }
        
        [_player pause];
        [_player destroyPlayer];
        
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *temp = self.navigationController.viewControllers[i];
            if ([temp isKindOfClass:[HMHVideoVodPlayerViewController class]]) {
                if (i == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[i-1] animated:YES];
                }
            }
        }
    }
}
//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    fullScreenBtn.selected = !fullScreenBtn.selected;

    [self setFullScreen:!self.player.isFullscreen];
}
//单击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    
}
//双击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
//    NSLog(@"%s", __func__);
}
//WMPlayer的的操作栏隐藏和显示
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL )isHidden withBottomView:(UIView *)bottomView topView:(UIView *)topView lockBtn:(UIButton *)lockBtn isLock:(BOOL)isLock{
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
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    //    NSLog(@"%s", __func__);
}

//准备播放的代理方法
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    if (self.seekTime > 0.0) {
        [self.player seekToTimeToPlay:self.seekTime];
        // 保证第一次播放的时候 跳转到指定的时间
        self.seekTime = 0.0;
    }
    
    if (self.HMH_isFristIn) {
        [self HMH_videoHitsRequest];
        
        self.HMH_isFristIn = NO;
    }
}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    //    NSLog(@"%s", __func__);
}

// 当程序进入前台时 （当前为播放状态）
//- (void)wmplayer:(WMPlayer *)wmplayer appWillEnterForeground:(NSNotification *)notification withBottomView:(UIView *)bottomView topView:(UIView *)topView lockBtn:(UIButton *)lockBtn isLock:(BOOL)isLock{
//
//    if (self.isFullScreen) { // 全屏状态下
//        if (isLock) {
////            self.player.lockBtn.selected = YES;
////            self.player.lockBtn.hidden = NO;
////        } else {
//            self.player.lockBtn.selected = NO;
//            self.player.lockBtn.hidden = YES;
//
//            bottomView.alpha = 1.0;
//            topView.alpha = 1.0;
//            _navigationBarHidden = NO;
//
////            fullScreenBtn.selected = !fullScreenBtn.selected;
//
//            [self setFullScreen:!self.player.isFullscreen];
//        }
//    } else {
//        self.player.lockBtn.hidden = YES;
//
//        bottomView.alpha = 1.0;
//        topView.alpha = 1.0;
//        _navigationBarHidden = NO;
//    }
//    [self setNeedsStatusBarAppearanceUpdate];
//}


#pragma mark 数据请求 =====get put=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName withRequestType:(NSString *)requestType{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestMethod;
    if ([requestType isEqualToString:@"get"]) {
        requestMethod = YTKRequestMethodGET;
    }else if ([requestType isEqualToString:@"put"]) {
        requestMethod = YTKRequestMethodPUT;
    }else {
        requestMethod = YTKRequestMethodPOST;
    }
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if(request.requestMethod == YTKRequestMethodGET ) {
            [weakSelf HMH_getPrcessdata:request.responseObject];
        }else if (request.requestMethod == YTKRequestMethodPUT) {
            if ([requestName isEqualToString:@"history"]) { // 插入播放历史
                [self getFavoriteData:request.responseObject];
            } else { // 视频收藏
                [self getFavoriteData:request.responseObject];
            }
            
        }else {
            if ([requestName isEqualToString:@"delete"]) { // "取消收藏成功"
            }else if ([requestName isEqualToString:@"redPacket"]){ // 红包
                [weakSelf getFavoriteData:request.responseObject];
            } else { // 插入观看次数成功
            }
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

// 获取视频信息
- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        self.HMH_videoModel = [[HMHVideoListModel alloc] init];
        [self.HMH_videoModel setValuesForKeysWithDictionary:dataDic];
        self.player.titleLabel.text = self.HMH_videoModel.title;
        [_HMH_videoBottomView refreshPlayerBottomViewWithModel:self.HMH_videoModel isFromTimeLive:NO];
        NSString *videoStr;
        if (self.HMH_videoModel.videoUrl.length>0) {
            videoStr = self.HMH_videoModel.videoUrl;
        } else {
           UIImage * placeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.HMH_videoModel.coverImageUrl get_Image]]];
           self.player.placeholderImage = placeImage;
                           
        }
        // 刷新课件
        [self HMH_refreshCourseware];
        
        NSURL *url = [NSURL URLWithString:videoStr];
        //        NSLog(@"savepath=%@\n url=%@\n %@",self.playerItem.savePath,url.absoluteString,self.playerItem);
        [self.player setURLString:url.absoluteString];
        [_player play];
    }
}
// 刷新课件
- (void)HMH_refreshCourseware{
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
    // 课件 和 红包
    [_HMH_courseView refreshUIWithCoursewareUrlArr:_HMH_coursewareUrlArr isFromTimeShift:NO redPacketWithModel:nil];
}

// 收藏 或者 取消收藏 数据返回
- (void)getFavoriteData:(id)data{

}

#pragma mark 重新布局
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.isFullScreen){
        
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.view.bounds;
        self.player.isFullscreen = true;
        //        self.player.lockBtn.hidden = NO;
        self.player.shareBtn.hidden = YES;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        
        _HMH_videoBottomView.frame = CGRectMake(0,CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame), ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame));
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
        
    }else{
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.HMH_originalFrame;
        self.player.isFullscreen = false;
        self.player.lockBtn.hidden = YES;
        self.player.shareBtn.hidden = NO;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        _HMH_videoBottomView.frame = CGRectMake(0,CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame), ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame));
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
    }
}

- (void)dealloc {
    [_player pause];
    self.player = nil;
    [_player resetWMPlayer];
    [_player removeFromSuperview];
}

@end



