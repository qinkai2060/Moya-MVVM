//
//  HMHDowmLoadPlayerViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/1.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHDowmLoadPlayerViewController.h"
#import "WMPlayer.h"
#import "SelPlayerConfiguration.h"


@interface HMHDowmLoadPlayerViewController ()<WMPlayerDelegate>

@property (nonatomic, strong) WMPlayer *player;

@property (nonatomic, assign) CGRect HMH_originalFrame;
@property (nonatomic, assign) BOOL HMH_isFullScreen;

@end

@implementation HMHDowmLoadPlayerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if(self.player.state ==WMPlayerStatePlaying || self.player.state == WMPlayerStateBuffering){
        [_player pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.HMH_originalFrame = CGRectMake(0, self.statusHeghit, self.view.bounds.size.width, self.view.frame.size.height - self.statusHeghit-self.buttomBarHeghit);
//
//
//    self.player = [[WMPlayer alloc] init];
//    self.player.delegate = self;
//    [self.view addSubview:_player];
//    // .url.absoluteString
//    NSURL *url = [NSURL URLWithString:self.playerItem.savePath];
//
//    //        NSLog(@"savepath=%@\n url=%@\n %@",self.playerItem.savePath,url.absoluteString,self.playerItem);
//    [self.player setURLString:url.absoluteString];
//    [_player play];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = YES;
    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = NO;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.videoGravity = SelVideoGravityResizeAspect;
    
    //    configuration.sourceUrl = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
    
    //保存路径需要转换为url路径，才能播放
    NSURL *url = [NSURL fileURLWithPath:self.playerItem.savePath];
    configuration.sourceUrl = [NSURL URLWithString:url.absoluteString];
    
//    CGFloat width = self.view.frame.size.width;
    
    //    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 100, width, 300) configuration:configuration];
    
//    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height)];
//    [_player playerVido:configuration];
    
    [self.view addSubview:_player];

}

#pragma mark 重新布局
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.HMH_isFullScreen){
        
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.view.bounds;
        self.player.isFullscreen = true;
        //        self.player.lockBtn.hidden = NO;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
    }else{
        [self.navigationController setNavigationBarHidden:true];
        self.player.frame = self.HMH_originalFrame;
        self.player.isFullscreen = false;
        self.player.lockBtn.hidden = YES;
        self.player.lockBtn.frame = CGRectMake(10, self.player.frame.size.height / 2 - 25, 50, 50);
    }
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
    }else{
        [self rotateOrientation:UIInterfaceOrientationPortrait];
        self.player.lockBtn.hidden = YES;
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
#pragma mark - player view delegate
//点击播放暂停按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    //    NSLog(@"%s", __func__);
}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    
    if (self.player.isFullscreen) {
        [self setFullScreen:false];
    }else{
        //        [self.player stop];
        //        [self.vodPlayer releasePlayer];
        //        self.vodPlayer = nil;
        //        if (self.timer) {
        //            [self.timer invalidate];
        //            self.timer = nil;
        //        }
        
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *temp = self.navigationController.viewControllers[i];
            if ([temp isKindOfClass:[HMHDowmLoadPlayerViewController class]]) {
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
//            _navigationBarHidden = YES;
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
//                    _navigationBarHidden = NO;
                    
                }
            } else {
                self.player.lockBtn.hidden = YES;
                
                bottomView.alpha = 1.0;
                topView.alpha = 1.0;
//                _navigationBarHidden = NO;
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
    //    NSLog(@"%s", __func__);
}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    //    NSLog(@"%s", __func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
