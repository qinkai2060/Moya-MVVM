//
//  HMHAliYunVodPlayerViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/7/3.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHAliYunVodPlayerViewController.h"
#import "HMHVideoEveryoneSaidViewController.h"
#import "HMHVideoMorewonderfulViewController.h"
#import "HMHVideoPlayBottomView.h"
#import "HMHVideoDescribeViewController.h"
#import "HMHVideoCoursewareViewController.h"
#import "HMHCoursewareAndRedpacketView.h"
#import "WMLightView.h"
#import "HFLoginViewController.h"

@interface HMHAliYunVodPlayerViewController ()<UIAlertViewDelegate,ShareToolDelegete,CoursewareAndRedpacketDelegate,UIGestureRecognizerDelegate,AliWMPlayerDelegate,HFLoginViewControllerDelegate>
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
@property (nonatomic, strong) Reachability *reachability;

//是否使用手势控制音量
@property (nonatomic,assign) BOOL  HMH_enableVolumeGesture;
// 记录是否是全屏状态
@property (nonatomic, assign) BOOL HMH_isFullScreen;

@property (nonatomic, strong) HMHVideoRedPacketModel *HMH_redModel;
// 显示或隐藏状态栏
@property (nonatomic, assign) BOOL navigationBarHidden;

//@property (nonatomic, assign) BOOL isLock; // 是否显示锁

@property (nonatomic, strong) UIView *HMH_bgView; //pageView的HMH_bgView

@property (nonatomic, strong) HMHVideoPlayBottomView *HMH_videoBottomView;

@property (nonatomic, strong) HMHVideoListModel *HMH_videoModel;

@property (nonatomic, strong) ShareTools *shareTool;
// 课件 红包
@property (nonatomic, strong) HMHCoursewareAndRedpacketView *HMH_courseView;
@property (nonatomic, strong) NSMutableArray *HMH_coursewareUrlArr;
@property (nonatomic, strong) NSMutableArray *HMH_coursewareTitleArr;
// 是否是红包跳转出去
@property (nonatomic, assign) BOOL HMH_isRedLeave;
// 用来判断观看历史的
@property (nonatomic, assign) BOOL HMH_isFristIn;

@property (nonatomic,assign)NSUInteger shouchangState;
@end

@implementation HMHAliYunVodPlayerViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isFull = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isFull = NO;
    if (self.player.vodPlayer.playerState != AliyunVodPlayerStatePause) {
        [self.player pause];
        // 改变播放暂停的状态
        self.player.playOrPauseBtn.selected = YES;
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
    NSTimeInterval currentTime = self.player.currentTime;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-watchhistory/watchhistory/save"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }

    // {vno:视屏编号,episode:集数（默认0）,seekTime:播放时间（默认0）}
    NSString *currentTimeStr = [NSString stringWithFormat:@"%f",currentTime];
    NSDictionary *dic = @{@"vno":self.videoNum,@"episode":@1,@"seekTime":[NSNumber numberWithLong:[currentTimeStr longLongValue]]};
    
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
        getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNum,sidStr];
    }

    [self requestData:nil withUrl:getUrlStr withRequestName:@"hits" withRequestType:@"post"];
}
#pragma  mark - viewDidload
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _navigationBarHidden = NO; // 默认显示
    _HMH_coursewareUrlArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_coursewareTitleArr = [NSMutableArray arrayWithCapacity:1];

    // 更新观看次数时用
    self.HMH_isFristIn = YES;

    _HMH_isRedLeave = NO;
    _shareTool = [[ShareTools alloc]init];
    _shareTool.delegete = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appVodDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appVodWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self HMH_initView];
    
    // 获取视频信息
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    [self HMH_createPageController];
    // 更新观看次数
    [self HMH_videoHitsRequest];
}

// 视频数据请求
- (void)loadData{
    if (self.videoNum.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr=@"";NSString *urlStr=@"";
        if ([ud objectForKey:@"sid"]!=nil&&![[ud objectForKey:@"sid"] isEqualToString:@""]) {
            sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
            
            urlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-info/get"];
            if (urlStr) {
                urlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",urlStr,self.videoNum,sidStr];
            }
            
        }else
        {
            urlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-info/get"];
            if (urlStr) {
                urlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",urlStr,self.videoNum,@""];
            }
        }
      
        [self requestData:nil withUrl:urlStr withRequestName:@"" withRequestType:@"get"];
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
    HMH_second.isFromVodPlay = YES;
    HMH_second.videoNum = self.videoNum;
    //    HMH_second.CityId=self.CityId;
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
        if(weakSelf.player.vodPlayer.playerState !=AliyunVodPlayerStatePause){
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
    if (self.player.vodPlayer.playerState != AliyunVodPlayerStatePause) {
        [self.player pause];
        // 改变播放暂停的状态
        self.player.playOrPauseBtn.selected = !self.player.playOrPauseBtn.selected;
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

#pragma  mark - HMH_initView
- (void)HMH_initView{
    /***********播放器界面搭建**************/
    self.player = [[AliWMPlayerView alloc] init];
    self.player.delegate = self;
    [self.view addSubview:_player];
    
    // 视频底部的view
    _HMH_videoBottomView = [[HMHVideoPlayBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width*9/16 + self.HMH_statusHeghit,self.view.frame.size.width, 30)];
    
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
    
    [[UIApplication sharedApplication].keyWindow addSubview:[WMLightView sharedLightView]];
    
    self.HMH_enableVolumeGesture = YES;
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
#pragma mark rotate
//旋转屏幕的时候，是否自动旋转子视图，NO的话不会旋转控制器的子控件
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
    if (self.player.isFullscreen)
        return UIInterfaceOrientationPortrait;
    return UIInterfaceOrientationLandscapeRight ;
}

/**
 需要切换的屏幕方向，手动转屏
 */
- (void)setFullScreen:(BOOL)isFullScreen {
    self.HMH_isFullScreen = isFullScreen;
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
// 是否显示状态栏
- (BOOL)prefersStatusBarHidden{
    return _navigationBarHidden;
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


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSString *)returndate:(NSTimeInterval)num{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    return [dateformatter stringFromDate:date1];
}

- (void)networkStateChange{
    if(!self.player.vodPlayer) return;
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
    YTKRequestMethod requestTypeMethod;
    YTKRequestSerializerType  serializerType;
    if ([requestType isEqualToString:@"get"]){
//        NSLog(@"x❤️1");
        requestTypeMethod = YTKRequestMethodGET;
        serializerType = YTKRequestSerializerTypeJSON;

    } else if ([requestType isEqualToString:@"put"]){
//         NSLog(@"x❤️2");
        requestTypeMethod = YTKRequestMethodPUT;
        serializerType = YTKRequestSerializerTypeJSON;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
        serializerType = YTKRequestSerializerTypeHTTP;
    }
    [HFCarRequest requsetUrl:urlstr1 withRequstType:requestTypeMethod requestSerializerType:serializerType params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        //        [weakSelf getPrcessdata:request.responseObject];
        NSLog(@"x❤️成功");
        if ([requestType isEqualToString:@"get"]){
            [weakSelf HMH_getPrcessdata:request.responseObject];
        } else if ([requestType isEqualToString:@"put"]){
            if ([requestName isEqualToString:@"history"]) { // 插入播放历史
                NSLog(@"插入播放历史");
            } else { // 视频收藏
                NSLog(@"视频收藏");
                NSLog(@"shipin ===== %@",request.responseObject);
                weakSelf.HMH_videoBottomView.shouCangBtn.selected = YES;
                
            }
        } else if ([requestType isEqualToString:@"post"]){
            if ([requestName isEqualToString:@"delete"]) { // "取消收藏成功"
                NSLog(@"取消收藏成功");
                weakSelf.HMH_videoBottomView.shouCangBtn.selected = NO;
                
            }else { // 插入观看次数成功
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"x❤️失败");
    }];
}


// 获取视频信息
- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        
        if ([dataDic isKindOfClass:[NSNull class]]) {
            return;
        }
        
        self.HMH_videoModel = [[HMHVideoListModel alloc] init];
        [self.HMH_videoModel setValuesForKeysWithDictionary:dataDic];
        self.player.titleLabel.text = self.HMH_videoModel.title;
        [_HMH_videoBottomView refreshPlayerBottomViewWithModel:self.HMH_videoModel isFromTimeLive:NO];

        [self HMH_refreshCourseware];
        
        NSString *videoStr;
        if (self.HMH_videoModel.videoUrl.length>0) {
            videoStr = self.HMH_videoModel.videoUrl;
        }
        NSURL *url = [NSURL URLWithString:videoStr];
        [self.player setURLString:url.absoluteString];
        [self.player play];
//        [self.vodPlayer prepareWithURL:url];
        
        self.player.vodPlayer.autoPlay = YES; // 进入回播时  默认是播放
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
    // 是否显示或隐藏课件
    [_HMH_courseView refreshUIWithCoursewareUrlArr:_HMH_coursewareUrlArr isFromTimeShift:YES redPacketWithModel:_HMH_redModel];
}

#pragma mark
#pragma mark 进入后台
- (void)appVodDidEnterBackground:(NSNotification*)note{
    if (self.player.vodPlayer.playerState !=AliyunVodPlayerStatePause) {
        [self.player pause];
        self.player.playOrPauseBtn.selected = YES;
    }
}
#pragma mark
#pragma mark 进入前台
- (void)appVodWillEnterForeground:(NSNotification*)note{
    if (self.player.vodPlayer.playerState ==AliyunVodPlayerStatePause) {
        //        [self.vodPlayer resume];
        self.player.playOrPauseBtn.selected = YES;
    }
    self.player.fullScreenBtn.selected = NO;
//    self.isLock = NO;
    self.player.lockBtn.hidden = YES;
//    [self showControlView];
}
// 分享按钮的点击事件
- (void)videoPlayerDoShare{
    
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    [self shareTheVideo];
}

- (void)shareTheVideo{
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

#pragma mark AliWMPlayerView delegate 方法
//点击播放暂停按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
}
//点击关闭按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    if (_HMH_isFullScreen) {
        //        self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
        [self setFullScreen:false];
    }else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        // 在用户登录的情况下 插入观看历史
        if (sidStr.length > 6 && ![sidStr isEqualToString:@"(null)"]) {
            [self HMH_watchHistoryRequest];
        }
        [self.player pause];
        [self.player destroyPlayer];
        self.player.vodPlayer = nil;
        
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *temp = self.navigationController.viewControllers[i];
            if ([temp isKindOfClass:[HMHAliYunVodPlayerViewController class]]) {
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
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    fullScreenBtn.selected = !fullScreenBtn.selected;
    [self setFullScreen:!self.player.isFullscreen];
}
//单击WMPlayer的代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
}

//双击WMPlayer的代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
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
            if (self.HMH_isFullScreen) { // 全屏状态下
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
                // 如果播放失败 就不显示底部的view
                if (wmplayer.isVideoPlayFail) {
                    bottomView.alpha = 0.0;
                } else {
                    bottomView.alpha = 1.0;
                }
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
    NSLog(@"=========%ld", state);
}
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(AliWMPlayerView *)wmplayer WMPlayerStatus:(CustomWMPlayerState)state{
    if (self.seekTime > 0.0) {
        [self.player seekToTimeToPlay:self.seekTime];
        // 保证第一次播放的时候 跳转到指定的时间
        self.seekTime = 0.0;
    }
    
    if (self.HMH_isFristIn) {
//        [self HMH_videoHitsRequest];
        self.HMH_isFristIn = NO;
    }
}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(AliWMPlayerView *)wmplayer{
    NSLog(@"=========%@", wmplayer);

}

#pragma mark===== viewWillLayoutSubviews
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.HMH_isFullScreen){
        
        [self.navigationController setNavigationBarHidden:true];
        
        self.player.frame = self.view.bounds;
        self.player.playerView.frame = self.player.frame;
        
        self.player.isFullscreen = true;
        //        self.lockBtn.hidden = NO;
        self.player.shareBtn.hidden = YES;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        self.HMH_videoBottomView.frame = CGRectMake(0, CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame) + 10, ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame));
        
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
    }else{
        [self.navigationController setNavigationBarHidden:true];
        
        self.player.frame = CGRectMake(0, self.HMH_statusHeghit, self.view.bounds.size.width, self.view.frame.size.width*9/16);
        
        self.player.playerView.frame = CGRectMake(0, 0, self.player.frame.size.width, self.player.frame.size.height);
        
        self.player.isFullscreen = false;
        self.player.lockBtn.hidden = YES;
        
        self.player.shareBtn.hidden = NO;
        
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        self.HMH_videoBottomView.frame = CGRectMake(0, CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30);
        _HMH_bgView.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_videoBottomView.frame), ScreenW, 44);
        HMH_pageView.view.frame=CGRectMake(0,CGRectGetMaxY(_HMH_bgView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_bgView.frame)) ;
        CGRect rect = HMH_moveLine.frame;
        rect.origin.y = CGRectGetMaxY(_HMH_bgView.frame) - 1;
        HMH_moveLine.frame = rect;
    }
    //    self.indicationrView.center = self.mediaPlayer.view.center;
}

- (void)dealloc{
    [self.player pause];
    [self.player destroyPlayer];
    self.player.vodPlayer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
