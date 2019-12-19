//
//  HMHShortVideoViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHShortVideoViewController.h"
#import "HMHVideoDescribeTableViewCell.h"
#import "HMHVideoCardTableViewCell.h"
#import "HMHShortVideoMoreTableViewCell.h"
#import "HMHVideoAllCardViewController.h"
//#import "WMPlayer.h"
#import "HMHVideoPlayBottomView.h"
#import "VideoCommentToolBarView.h"
#import "VideoSendMessageView.h"
#import "AliWMPlayerView.h"
#import "HFLoginViewController.h"

@interface HMHShortVideoViewController ()<UITableViewDataSource,UITableViewDelegate,VideoDescribeTableViewCellDelegate,CommentToolBarDelegate,AliWMPlayerDelegate,UITextFieldDelegate,VideoCardTableViewCellDelegate,ShareToolDelegete,HFLoginViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VideoCommentToolBarView *commentToolBar;
@property (nonatomic, strong) AliWMPlayerView *player;
//@property (nonatomic, strong) WMPlayer *player;
@property (nonatomic, assign) CGRect HMH_originalFrame;
@property (nonatomic, assign) BOOL HMH_isFullScreen;

// 显示或隐藏状态栏
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, strong) HMHVideoPlayBottomView *HMH_videoBottomView;

@property (nonatomic, strong) UITextField *HMH_searchTextField;

@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;

@property (nonatomic, strong) HMHVideoListModel *HMH_videoModel;

@property (nonatomic, assign) NSInteger HMH_currrentPage;
@property (nonatomic, strong) NSMutableArray *HMH_moreDataArr;

@property (nonatomic, assign) NSInteger HMH_judgeIsLogin;
@property (nonatomic, assign) NSInteger HMH_dianZanSelectIndex;

@property (nonatomic, assign) NSInteger HMH_isFristIn;

@property (nonatomic, strong) ShareTools *shareTool;

@property (nonatomic, assign) long HMH_commentTotal;

@property (nonatomic,assign)NSUInteger shouchangState;

@end

@implementation HMHShortVideoViewController

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
    [self requestData:dic withUrl:getUrlStr withRequestType:@"put" requestName:@"history"];
}

// 更新视频观看次数
-(void)HMH_videoHitsRequest{
//    NSString *uuidStr = [VersionTools UUIDString];
//    NSDictionary *dic = @{@"watcherId":uuidStr};
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-hits/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@/%@",getUrlStr,self.videoNo];
    }

    [self requestData:nil withUrl:getUrlStr withRequestType:@"post" requestName:@"hits"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_moreDataArr = [NSMutableArray arrayWithCapacity:1];
    
    _shareTool = [[ShareTools alloc]init];
    _shareTool.delegete = self;

    self.HMH_originalFrame = CGRectMake(0, self.HMH_statusHeghit, self.view.bounds.size.width,  self.view.frame.size.width*9/16);
    self.HMH_judgeIsLogin = 0;
    
    // 更新观看次数时时用
    self.HMH_isFristIn = YES;

    [self createPlayer];
    
    [self HMH_crateTableView];
    
    // 获取视频信息
    [self loadData];
    // 获取跟帖
    [self loadCommentData];
    //更多精彩
    [self refreshData];
}


- (void)createPlayer{
//    self.player = [[WMPlayer alloc] init];
//    self.player.delegate = self;
//    [self.view addSubview:_player];
    self.player = [[AliWMPlayerView alloc] init];
    self.player.delegate = self;
    [self.view addSubview:_player];

    //保存路径需要转换为url路径，才能播放  http://player.alicdn.com/video/aliyunmedia.mp4
    
    // 视频底部的view
    _HMH_videoBottomView = [[HMHVideoPlayBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30)];
    
    __weak typeof(self)weakSelf = self;
    _HMH_videoBottomView.shouCangBtnClick = ^(NSInteger state) {
        // state  2 收藏    1 取消收藏
        [weakSelf HMH_isJudgeLoginFavoriteWithState:state];
    };
    _HMH_videoBottomView.downloadBtnClick = ^{
        NSLog(@"短视频下载按钮的点击事件");
    };

    [_HMH_videoBottomView refreshPlayerBottomViewWithModel:nil isFromTimeLive:NO];
    [self.view addSubview:_HMH_videoBottomView];
}

// 点击收藏时 判断登录
- (void)HMH_isJudgeLoginFavoriteWithState:(NSInteger)state{
//    if (self.isLogin) {
//        [self HMH_videoBottomViewFavoriteWithState:state];
//        return;
//    }
//    __weak typeof(self)weakSelf = self;
//    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
//        weakSelf.HMH_judgeIsLogin = 0;
//        [weakSelf HMH_videoBottomViewFavoriteWithState:state];
//    };
    self.shouchangState = state;
    if (self.isJudgeLogin) {
        [self HMH_videoBottomViewFavoriteWithState:state];
        return;
    }
    //这里就是没有登录成功
    [HFLoginViewController showViewController:self];
}
// 收藏 取消收藏
- (void)HMH_videoBottomViewFavoriteWithState:(NSInteger)state{
    // state  2 收藏    1 取消收藏
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (state == 1) { // 取消收藏
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/delete"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNo,sidStr];
        }

        [self requestData:nil withUrl:getUrlStr withRequestType:@"post" requestName:@"favorite"];
    } else { // 收藏
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/save"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }
        NSDictionary *dic = @{@"vno":self.videoNo};
        [self requestData:dic withUrl:getUrlStr withRequestType:@"put" requestName:@"favorite"];
    }
}

#pragma mark <HFLoginViewControllerDelegate>

- (void)loginViewController:(HFLoginViewController *)viewcontroller loginFinsh:(NSDictionary *)loginData {
    
    [self HMH_videoBottomViewFavoriteWithState:self.shouchangState];
    
}

- (void)HMH_crateTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_HMH_videoBottomView.frame), ScreenW, ScreenH - CGRectGetMaxY(_HMH_videoBottomView.frame) - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
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

        [self requestData:nil withUrl:getUrlStr withRequestType:@"get" requestName:@"videoInfo"];
    }
}

// 获取跟帖信息
-(void)loadCommentData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (self.videoNo.length > 0) {
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-vno/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@/%@?sid=%@",getUrlStr,self.videoNo,[NSNumber numberWithInteger:1],sidStr];
        }

        [self requestData:nil withUrl:getUrlStr withRequestType:@"get" requestName:@"comment"];
    }
}

- (void)refreshData {
    _HMH_currrentPage = 1;
    [self moreWonderfulRequest];
    // 刷新跟帖
    [self loadCommentData];
}

- (void)loadMoreData {
    _HMH_currrentPage ++;
    [self moreWonderfulRequest];
}

// 更多精彩数据请求
- (void)moreWonderfulRequest{
    NSString *urlStr = [NSString stringWithFormat:@"/video/search/%@/%@/%ld",@"similar",self.videoNo,(long)_HMH_currrentPage];
    [self requestData:nil withUrl:urlStr withRequestType:@"get" requestName:@"more"];
}

// 判断评论登录
- (void)isJudgeLoginCommentWithText:(NSString *)sendStr{
    
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    [self sendCommentRequestWithText:sendStr];
//    if (self.isLogin) {
//        [self sendCommentRequestWithText:sendStr];
//        return;
//    }
//    __weak typeof(self)weakSelf = self;
//    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
//        weakSelf.HMH_judgeIsLogin = 0;
//        [weakSelf sendCommentRequestWithText:sendStr];
//    };
}

// 发送评论数据请求
- (void)sendCommentRequestWithText:(NSString *)sendText{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{@"pid":@0,@"content":sendText,@"vno":self.videoNo};
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment/add"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }

    [self requestData:dic withUrl:getUrlStr withRequestType:@"put" requestName:@""];
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

- (void)rotateOrientation:(UIInterfaceOrientation)orientation {
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
}

//自动转屏或者手动调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    self.HMH_isFullScreen = size.width > size.height;
}

// 是否显示状态栏
- (BOOL)prefersStatusBarHidden{
    return _navigationBarHidden;
}

#pragma mark 重新布局
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.HMH_isFullScreen){
        
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.view.bounds;
        self.player.playerView.frame = self.player.frame;

        self.player.isFullscreen = true;
        //        self.player.lockBtn.hidden = NO;
        self.player.shareBtn.hidden = YES;

        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        
        _HMH_videoBottomView.frame = CGRectMake(0,CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30);
      _tableView.frame=CGRectMake(0,CGRectGetMaxY(_HMH_videoBottomView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_videoBottomView.frame)) ;
    }else{
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.HMH_originalFrame;
        self.player.playerView.frame = CGRectMake(0, 0, self.player.frame.size.width, self.player.frame.size.height);

        self.player.isFullscreen = false;
        self.player.shareBtn.hidden = NO;
        self.player.lockBtn.hidden = YES;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
        _HMH_videoBottomView.frame = CGRectMake(0,CGRectGetMaxY(self.player.frame), self.view.frame.size.width, 30);
       _tableView.frame=CGRectMake(0,CGRectGetMaxY(_HMH_videoBottomView.frame), ScreenW, ScreenH-CGRectGetMaxY(_HMH_videoBottomView.frame));
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){ // 跟帖显示两条
        return 2;
    }
    return _HMH_moreDataArr.count; // 更多精彩
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        //
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW / 2 - 100, 5, 200, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16.0];
        lab.text = @"更多精彩";
        [bgView addSubview:lab];

        return bgView;
    } else {
        //
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        bgView.backgroundColor = RGBACOLOR(241, 242, 244, 1);
        
        //
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 40)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:whiteView];
        
        //
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW / 2 - 25, 5, 50, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16.0];
        lab.text = @"跟帖";
        [whiteView addSubview:lab];
        
        //
        UILabel *labNum = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 30 - 80, 5, 80, 30)];
        labNum.text = [NSString stringWithFormat:@"%lu条跟帖",(unsigned long)_HMH_commentTotal];
        labNum.textColor = RGBACOLOR(9, 78, 196, 1);
        labNum.font = [UIFont systemFontOfSize:14.0];
        labNum.textAlignment = NSTextAlignmentRight;
        [whiteView addSubview:labNum];
        
        //
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labNum.frame) + 5, (whiteView.frame.size.height) / 2 - 8.5, 17, 17)];
        image.image = [UIImage imageNamed:@"VC_rightImage"];
        [whiteView addSubview:image];
        
        //
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenW - 30 - 80, 0, 110, 40);
        [btn addTarget:self action:@selector(genTieBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        
        return bgView;
    }
}

// 全部跟帖按钮的点击事件
-(void)genTieBtnClick:(UIButton *)btn{
    self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext; //半透明
    HMHVideoAllCardViewController *vc = [[HMHVideoAllCardViewController alloc] init];
    vc.videoNo = self.videoNo;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:vc animated:NO completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 66)];
    footView.backgroundColor = RGBACOLOR(241, 242, 244, 1);
    
    //
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 56)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:whiteView];
    
    // 添加输入框
    [whiteView addSubview:[self createTextField]];
    
    //_commentToolBar
//    _commentToolBar = [[VideoCommentToolBarView alloc] initWithFrame:CGRectMake(0,0, ScreenW, [VideoCommentToolBarView defaultHeight])];
//    _commentToolBar.isFromDetail = YES;
//    _commentToolBar.isFromGenTie = YES;
//    _commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
//    _commentToolBar.delegate = self;
//    _commentToolBar.maxTextInputViewHeight = 40;
//    [_commentToolBar.inputTextView setPlaceHolder:@"写跟帖"];
//    [whiteView addSubview:_commentToolBar];
    
    return footView;
}

- (UIView *)createTextField{
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20,40)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = bgView.frame.size.height / 2;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = RGBACOLOR(242, 242, 242, 1).CGColor;

//    [ addSubview:bgView];
    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 8.5, 17, 17)];
    img.image = [UIImage imageNamed:@"VL_commentPen"];
    [bgView addSubview:img];
    
    //
    VideoSendMessageView *sendView = [[VideoSendMessageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    sendView.placeHolderStr = @"请回复跟帖......";
    sendView.titleStr = @"回复跟帖";
    
    _HMH_searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height)];
    _HMH_searchTextField.backgroundColor = [UIColor clearColor];
    _HMH_searchTextField.delegate = self;
    _HMH_searchTextField.placeholder = @"写跟帖";
    _HMH_searchTextField.font = [UIFont systemFontOfSize:14.0];
    _HMH_searchTextField.inputAccessoryView = sendView;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(sendView)weakSend = sendView;
    sendView.sendMessageBlock = ^(NSString *messageStr) {
        [weakSend.sendTextView resignFirstResponder];
        [_HMH_searchTextField resignFirstResponder];
        NSLog(@"%@",messageStr);
        [weakSelf isJudgeLoginCommentWithText:messageStr];
    };
    [bgView addSubview:_HMH_searchTextField];

    return bgView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_HMH_searchTextField resignFirstResponder];
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 订阅
//    HMHShortVideoSubscribeTableViewCell *subscribeCell = [tableView dequeueReusableCellWithIdentifier:@"subCell"];
//    if (subscribeCell == nil) {
//        subscribeCell = [[HMHShortVideoSubscribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subCell"];
//    }
//    subscribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return subscribeCell;
    
    
    if (indexPath.section == 0) { // 标题
        HMHVideoDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[HMHVideoDescribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.HMH_videoModel) {
            [cell refreshCellWithModel:self.HMH_videoModel];
        }
        return cell;
    } else if(indexPath.section == 1){ //跟帖
        HMHVideoCardTableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:@"card"];
        if (cardCell == nil) {
            cardCell = [[HMHVideoCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"card"];
            cardCell.delegate = self;
        }
        cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_HMH_dataSourceArr.count > indexPath.row) {
            HMHVideoCommentModel *model = _HMH_dataSourceArr[indexPath.row];
            model.cellIndex = indexPath.row;
            [cardCell refreshCellWithModel:model];
        }
        return cardCell;
    } else {
        HMHShortVideoMoreTableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"more"];
        if (moreCell == nil) {
            moreCell = [[HMHShortVideoMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"more"];
        }
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_HMH_moreDataArr.count > indexPath.row) {
            HMHVideoListModel *model = _HMH_moreDataArr[indexPath.row];
            [moreCell refreshCellWithModel:model];
        }
        return moreCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [HMHVideoDescribeTableViewCell cellHeightWithModel:self.HMH_videoModel];
    } else if(indexPath.section == 1){
        if (_HMH_dataSourceArr.count > indexPath.row) {
            HMHVideoCommentModel *model = _HMH_dataSourceArr[indexPath.row];
            return [HMHVideoCardTableViewCell cellHeightWithModel:model];
        }
        return 0.0;
    } else{
        return 220;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 更多精彩
    if (indexPath.section == 2) {
        if (_HMH_moreDataArr.count > indexPath.row) {
            HMHVideoListModel *model = _HMH_moreDataArr[indexPath.row];
            self.videoNo = model.vno;
           // 重新刷新当前页面的信息
            // 获取视频信息
            [self loadData];
            //更多精彩
            [self refreshData];
            
            [self loadCommentData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    } else if (section == 2){
        if (_HMH_moreDataArr.count > 0) {
            return 40;
        } else {
            return 0.0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 66;
    }
    return 0;
}
// 标题 内容 上下按钮的点击事件
-(void)showAllConentBtnClickWithIndex:(NSInteger)index{
    if (self.HMH_videoModel) {
        self.HMH_videoModel.isOpenSubTitle =!self.HMH_videoModel.isOpenSubTitle;
        [UIView performWithoutAnimation:^{ // 解决在出现分页的时候 刷新某一cell时 出现 闪 或 上下移动的问题   消除tableview自带的fade动画
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}
// 点赞按钮的点击事件
- (void)videoCardCommentZanBtbClickWithIndex:(NSInteger)index withTableViewCell:(HMHVideoCardTableViewCell *)cell{
    
    //哈哈
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    //点赞按钮的点击事件
    if (_HMH_dataSourceArr.count > index) {
        _HMH_dianZanSelectIndex = index;
        HMHVideoCommentModel *model = _HMH_dataSourceArr[index];
        [self isJudgeLoginDianZanWithModel:model tableviewCell:cell];
    }
}
//点赞时 判断登录
- (void)isJudgeLoginDianZanWithModel:(HMHVideoCommentModel *)model tableviewCell:(HMHVideoCardTableViewCell *)cell{
    if (self.isLogin) {
        [self dianZanRequestDataWithModel:model tableViewCell:cell];
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
        weakSelf.HMH_judgeIsLogin = 10;
        [weakSelf loadCommentData];
    };
}
// 点赞数据请求
- (void)dianZanRequestDataWithModel:(HMHVideoCommentModel *)model tableViewCell:(HMHVideoCardTableViewCell *)cell{
    
    NSString *zanNum ;
    if (!model.myLike) {
        zanNum = @"1";
        cell.zanBtn.selected = YES;
        
        [cell.zanBtn setImage:[UIImage imageNamed:@"Video_zanSelectImage"] forState:UIControlStateSelected];
        long zanCount = [model.likeCount longLongValue];
        
        if (zanCount > 99) {
            model.likesNum = @" 99+";
        } else {
            if (zanCount + 1 > 99) {
                model.likesNum = @" 99+";
            } else {
                model.likesNum = [NSString stringWithFormat:@" %lld",[model.likesNum longLongValue] + 1];
            }
        }
        
        [cell.zanBtn setTitle:model.likesNum forState:UIControlStateSelected];
        model.myLike = YES;
    } else if (model.myLike){
        zanNum = @"0";
        cell.zanBtn.selected = NO;
        [cell.zanBtn setImage:[UIImage imageNamed:@"Video_unZanSelectImage"] forState:UIControlStateNormal];
        long zanCount = [model.likeCount longLongValue];
        if (zanCount > 99) {
            model.likesNum = @" 99+";
        } else {
            if (zanCount - 1 > 99){
                model.likesNum = @" 99+";
            } else {
                model.likesNum = [NSString stringWithFormat:@" %lld",[model.likesNum longLongValue] - 1];
            }
        }
        [cell.zanBtn setTitle:model.likesNum forState:UIControlStateNormal];
        model.myLike = NO;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (model.id) {
        // 评论点赞数据请求
        NSArray *arr;
        NSDictionary *dic;
        
        arr = @[@{@"vcId":model.id,@"vcLike":zanNum}];
        
        dic = @{@"data":arr};
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-like/update"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }

        [self requestData:dic withUrl:getUrlStr withRequestType:@"post" requestName:@"Like"];
    }
}


#pragma mark - commenttoolbar  delegate------------

- (void)inputEndEditing{
    [_commentToolBar.inputTextView setText:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    [UIView animateWithDuration:0.3 animations:^{
        //        CGRect rect = self.tableView.frame;
        //        rect.origin.y = 0;
        //        rect.size.height = self.view.frame.size.height - toHeight;
        //        self.tableView.frame = rect;
    }];
    //    [self scrollViewToBottom:NO];
}

#pragma mark ---- UIKeyboardNotification ----
- (void)keyboardWillShow:(NSNotification *)notifi{
    CGRect keyboradFrameValue = [[notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[notifi.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
}

- (void)keyboardWillHide:(NSNotification *)notifi{
    CGFloat animationTime = [[notifi.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
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
        [self requestData:nil withUrl:getUrlStr withRequestType:@"post" requestName:@""];
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
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        if (sidStr.length > 0 && ![sidStr isEqualToString:@"(null)"]) {//已经登录
            // 插入观看历史 登录成功之后才掉观看历史
            [self HMH_watchHistoryRequest];
        }

        [_player pause];
        [_player destroyPlayer];
        _player.vodPlayer = nil;
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

    if (self.seekTime > 0.0) {
        [self.player seekToTimeToPlay:self.seekTime];
        // 保证第一次播放的时候 跳转到指定的时间
        self.seekTime = 0.0;
    }
    
    if (self.HMH_isFristIn) {
        // 插入视频观看次数
        [self HMH_videoHitsRequest];
        
        self.HMH_isFristIn = NO;
    }
}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(AliWMPlayerView *)wmplayer{
//    NSLog(@"%s", __func__);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat height = 40;
        
        if (scrollView.contentOffset.y <= height && scrollView.contentOffset.y > 0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if(scrollView.contentOffset.y >= height){
            
            scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
        }
    }
}

#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestType:(NSString *)requestType requestName:(NSString *)requestName{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    YTKRequestMethod requestTypeMethod;
    if ([requestType isEqualToString:@"get"]){
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
    }
    YTKRequestSerializerType type = YTKRequestSerializerTypeHTTP;
    if ([requestType isEqualToString:@"get"]){
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
        type = YTKRequestSerializerTypeJSON;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
        type = YTKRequestSerializerTypeJSON;

    }
    [HFCarRequest requsetUrl:urlstr1 withRequstType:requestTypeMethod requestSerializerType:type params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        //        [weakSelf getPrcessdata:request.responseObject];
        if ([requestType isEqualToString:@"get"]){
            if ([requestName isEqualToString:@"comment"]) { // 评论 跟帖
                [weakSelf getPrcessdata:request.responseObject];
            } else if ([requestName isEqualToString:@"videoInfo"]){ // 视频信息
                [weakSelf getVideoInfoData:request.responseObject];
            } else if ([requestName isEqualToString:@"more"]){ // 更多精彩
                [weakSelf getMoreWonderfullData:request.responseObject];
            }
            //            [weakSelf getPrcessdata:request.responseObject];
        } else if ([requestType isEqualToString:@"put"]){
            if ([requestName isEqualToString:@"favorite"]) { // 收藏
                 self.HMH_videoBottomView.shouCangBtn.selected = YES;
            } else if ([requestName isEqualToString:@"history"]){ // 插入观看历史
            } else {
                [weakSelf.commentToolBar.inputTextView resignFirstResponder];
                [weakSelf.commentToolBar.inputTextView setText:nil];
                [weakSelf getSendComentData:request.responseObject];
            }
        } else if ([requestType isEqualToString:@"post"]){
            NSLog(@"取消收藏成功");
            if ([requestName isEqualToString:@"favorite"]) { // 取消收藏
                self.HMH_videoBottomView.shouCangBtn.selected = NO;
            } else if ([requestName isEqualToString:@"Like"]){// 取消评论点赞
            } else if ([requestName isEqualToString:@"hits"]){
                
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
    }];

    
//    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
//        //        [weakSelf getPrcessdata:request.responseObject];
//        if ([requestType isEqualToString:@"get"]){
//            if ([requestName isEqualToString:@"comment"]) { // 评论 跟帖
//                [weakSelf getPrcessdata:request.responseObject];
//            } else if ([requestName isEqualToString:@"videoInfo"]){ // 视频信息
//                [weakSelf getVideoInfoData:request.responseObject];
//            } else if ([requestName isEqualToString:@"more"]){ // 更多精彩
//                [weakSelf getMoreWonderfullData:request.responseObject];
//            }
//            //            [weakSelf getPrcessdata:request.responseObject];
//        } else if ([requestType isEqualToString:@"put"]){
//            if ([requestName isEqualToString:@"favorite"]) { // 收藏
//            } else if ([requestName isEqualToString:@"history"]){ // 插入观看历史
//            } else {
//                [weakSelf.commentToolBar.inputTextView resignFirstResponder];
//                [weakSelf.commentToolBar.inputTextView setText:nil];
//                [weakSelf getSendComentData:request.responseObject];
//            }
//        } else if ([requestType isEqualToString:@"post"]){
//            NSLog(@"取消收藏成功");
//            if ([requestName isEqualToString:@"favorite"]) { // 取消收藏
//            } else if ([requestName isEqualToString:@"Like"]){// 取消评论点赞
//            } else if ([requestName isEqualToString:@"hits"]){
//
//            }
//        }
//    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"失败");
//
//    }];
}

// 评论列表数据返回
- (void)getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        _HMH_commentTotal = 0;
        _HMH_commentTotal = [dataDic[@"total"] longLongValue];

        [_HMH_dataSourceArr removeAllObjects];
        if ([dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dataDic[@"list"]) {
                HMHVideoCommentModel *model = [[HMHVideoCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.likesNum = model.likeCount;
                
                [_HMH_dataSourceArr addObject:model];
            }
        }
        [_tableView reloadData];
        
        if (self.HMH_judgeIsLogin == 10) {
            if (_HMH_dataSourceArr.count > _HMH_dianZanSelectIndex) {
                NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:_HMH_dianZanSelectIndex inSection:1];
                
                HMHVideoCardTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
                HMHVideoCommentModel *model = _HMH_dataSourceArr[_HMH_dianZanSelectIndex];
                [self dianZanRequestDataWithModel:model tableViewCell:cell];
                
                self.HMH_judgeIsLogin = 0;
            }
        }
    }
}
// 发送评论数据返回
- (void)getSendComentData:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        [self loadCommentData];
    } else {
        NSComparisonResult comparisonResult = [[VersionTools osVersion] compare:@"8.0"];
        if (comparisonResult == NSOrderedAscending) {//8.0以上的版本
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:resDic[@"msg"]  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确定按钮的点击事件
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

//视频信息 数据返回
- (void)getVideoInfoData:(id)data{
    NSDictionary *resDic = data;
    
    if ([data[@"data"] isKindOfClass:[NSNull class]]) {
        return;
    }
    
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        self.HMH_videoModel = [[HMHVideoListModel alloc] init];
        [self.HMH_videoModel setValuesForKeysWithDictionary:dataDic];
        
        [_HMH_videoBottomView refreshPlayerBottomViewWithModel:self.HMH_videoModel isFromTimeLive:NO];
        
        //    NSURL *url = [NSURL fileURLWithPath:self.playerItem.savePath];
        //重置播放器
//        [self.player resetWMPlayer];
        if (self.player) {
            [self.player destroyPlayer]; // releasePlayer
        }
        
        self.player = [[AliWMPlayerView alloc] init];
        self.player.delegate = self;
        [self.view addSubview:_player];

        NSString *videoStr;
        if (self.HMH_videoModel.videoUrl.length>0) {
            videoStr = self.HMH_videoModel.videoUrl;
        } else {
            
                        UIImage * placeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.HMH_videoModel.coverImageUrl get_sharImage]]]];
                        self.player.placeholderImage = placeImage;
      }
                      
        self.player.titleLabel.text = self.HMH_videoModel.title;

        NSURL *url = [NSURL URLWithString:videoStr];
        //        NSLog(@"savepath=%@\n url=%@\n %@",self.playerItem.savePath,url.absoluteString,self.playerItem);
        [self.player setURLString:url.absoluteString];
        [self.player play];
        self.player.vodPlayer.autoPlay = YES; // 进入直播时  默认是播放
    }
}

// 更多精彩数据返回
- (void)getMoreWonderfullData:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if (_HMH_currrentPage == 1) {
            [_HMH_moreDataArr removeAllObjects];
        }
        NSDictionary *dataDic = resDic[@"data"];
        if ([dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *listDic in dataDic[@"list"]) {
                HMHVideoListModel *model = [[HMHVideoListModel alloc] init];
                [model setValuesForKeysWithDictionary:listDic];
                [_HMH_moreDataArr addObject:model];
            }
        }
        [_tableView reloadData];
    }
}

- (void)dealloc {
    [_player pause];
    [_player destroyPlayer];
    self.player.vodPlayer = nil;
    [_player removeFromSuperview];
}

@end
