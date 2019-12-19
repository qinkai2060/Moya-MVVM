//
//  SelVideoViewController.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SelVideoViewController.h"
#import "SelVideoPlayer.h"


@interface SelVideoViewController ()

@property (nonatomic, strong) SelVideoPlayer *player;

@end

@implementation SelVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;

    self.navigationItem.title = self.playerItem.fileName;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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

    CGFloat width = self.view.frame.size.width;
    
//    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 100, width, 300) configuration:configuration];
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height)];
    [_player playerVido:configuration];

    [self.view addSubview:_player];
}

- (void)refreshVideoPlayer:(SelPlayerConfiguration*)config{
    if (_player) {
        [_player _pauseVideo];
        [_player _deallocPlayer];
       [self.view addSubview:[_player initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
    }
    [_player playerVido:config];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [_player _deallocPlayer];
}

@end
