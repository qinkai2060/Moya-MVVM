//
//  HFVideoViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVideoViewController.h"
#import "HFVideoView.h"
#import "HFVideoNewView.h"
#import "ZFPlayerControl.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/KSMediaPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPLayer/ZFPlayerController.h>
#import "ZFTableData.h"
@interface HFVideoViewController ()
@property(nonatomic,strong)UIButton *publishBtn;
@property(nonatomic,strong)UIButton *userBtn;
@property(nonatomic,strong)HFVideoNewView *videoView;
@property(nonatomic,strong)ZFPlayerControl *playerControl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerController *player;
@end

@implementation HFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoView];
//    [self.view addSubview:self.playeControl];
    [self.view addSubview:self.customNavBar];
    [self.customNavBar wr_setBackgroundAlpha :0];
    [self.customNavBar wr_setLeftButtonWithNormal:[UIImage imageNamed:@"icon_vipback"] highlighted:[UIImage imageNamed:@"icon_vipback"]];
    self.customNavBar.hidden = NO;
    [self.customNavBar setTitle:@"晒宝圈"];
    [self.customNavBar setTitleLabelFont:[UIFont boldSystemFontOfSize:20]];
    [self.customNavBar setTitleLabelColor:[UIColor whiteColor]];
    [self.customNavBar addSubview:self.userBtn];
    [self.customNavBar addSubview:self.publishBtn];
    self.userBtn.frame = CGRectMake(kScreenWidth-44, 0, 44, 44);
    self.publishBtn.frame = CGRectMake(self.userBtn.left-44, 0, 44, 44);
    self.publishBtn.centerY = self.customNavBar.leftButton.centerY;
    self.userBtn.centerY = self.customNavBar.leftButton.centerY;
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithScrollView:self.videoView playerManager:playerManager containerViewTag:100];
    
    self.player.assetURLs = self.videoView.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.playerControl;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
    self.player.playerDisapperaPercent = 1.0;
    self.videoView.player = self.player;
    self.videoView.playerControl = self.playerControl;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)

}
- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc] init];
        [_publishBtn setImage:[UIImage imageNamed:@"circle_publish"] forState:UIControlStateNormal];
    }
    return _publishBtn;
}
- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [[UIButton alloc] init];
        [_userBtn setImage:[UIImage imageNamed:@"circle_video"] forState:UIControlStateNormal];
    }
    return _userBtn;
}
- (HFVideoNewView *)videoView {
    if (!_videoView) {
        _videoView = [[HFVideoNewView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    }
    return _videoView;
}
- (ZFPlayerControl *)playeControl {
    if (!_playerControl) {
        _playerControl = [[ZFPlayerControl alloc] initWithFrame:self.view.bounds];
    }
    return _playerControl;
}
@end
