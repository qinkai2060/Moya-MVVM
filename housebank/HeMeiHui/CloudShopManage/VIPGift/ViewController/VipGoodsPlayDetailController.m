//
//  VipGoodsPlayDetailController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGoodsPlayDetailController.h"
#import "UILabel+Vertical.h"
#import "TracyVideoPlayer.h"
#import "TracyPlayerConfiguration.h"
#import "TracyPlaybackControls.h"
#import "VipSelPlaybackControls.h"
#import "VipPlayDetailBottomView.h"
#import "VipGiftPlayListViewModel.h"
#import "SpGoodsDetailViewController.h"
@interface VipGoodsPlayDetailController ()
@property (nonatomic, strong) VipPlayDetailBottomView * VipBottomView;
@property (nonatomic, strong) TracyVideoPlayer *player;
@property (nonatomic, strong) VipSelPlaybackControls * controls;
@property (nonatomic, strong) TracyPlayerConfiguration *configuration;
@property (nonatomic, strong) VipGiftPlayListViewModel * playViewModel;
@property (nonatomic, strong) NSURL  * videoUrl;
@property (nonatomic, strong) NSDictionary * playDetailDic;
@property (nonatomic, strong) UIImageView * closeImage;
@end

@implementation VipGoodsPlayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.videoUrl = [NSURL URLWithString:objectOrEmptyStr(self.listModel.videoAddress)];
    
    @weakify(self);
    [[self.playViewModel loadVIP_PlayDetailRequestWith:objectOrEmptyStr(self.listModel.productId)]subscribeNext:^(NSDictionary * x) {
        @strongify(self);
        self.playDetailDic = x.copy;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.playDetailDic.allValues.count >0) {
                @weakify(self);
                [self.VipBottomView setUpDetailUIWtihDic:self.playDetailDic withBlock:^{
                    @strongify(self);
                    [self pushToDetailVIPVC];
                }];
            }
        });
    } error:^(NSError * _Nullable error) {
        NSString * errorAlert = [error.userInfo objectForKey:@"error"];
        [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
    }];
}

- (void)pushToDetailVIPVC {
    SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
    SpGoodsDetailVC.productId=objectOrEmptyStr(self.listModel.productId);
    SpGoodsDetailVC.goodsType=VipWholesaleGoodsDetailStyle;
    [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deallocPlayer];
}

- (void)setUpUI {
    
    self.controls.hideInterval = self.configuration.hideControlsInterval;
    self.controls.statusBarHideState = self.configuration.statusBarHideState;
    self.player = [[TracyVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)configuration:self.configuration withControls:self.controls];
    [self.view addSubview:self.player];
    [self.player addSubview:self.VipBottomView];
    self.player.userInteractionEnabled = YES;
    
    [self.player addSubview:self.closeImage];
    [self.player bringSubviewToFront:self.closeImage];
    CGFloat top = IS_IPHONE_X() ? 47:37;
    [self.closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.player).offset(top);
        make.right.equalTo(self.player).offset(-13);
        make.width.height.equalTo(@23);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [self.closeImage addGestureRecognizer:tap];
    @weakify(self);
    [[tap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
         [self deallocPlayer];
         [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)deallocPlayer {
    if (self.player || self.player.playerItem) {
        [self.player _deallocPlayer];
        self.player.playerItem = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:YES];
    self.view.userInteractionEnabled = YES;
    self.customNavBar.hidden = YES;
    [self setUpUI];
}

#pragma mark -- lazy load
- (VipPlayDetailBottomView *)VipBottomView {
    if (!_VipBottomView) {
        _VipBottomView = [[VipPlayDetailBottomView alloc]init];
        _VipBottomView.frame = CGRectMake(0, kHeight-WScale(110)-WScale(60), kWidth, WScale(110));
    }
    return _VipBottomView;
}

- (TracyPlayerConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[TracyPlayerConfiguration alloc]init];
        _configuration.shouldAutoPlay = YES;
        _configuration.supportedDoubleTap = NO;
        _configuration.shouldAutorotate = NO;
        _configuration.repeatPlay = NO;
        _configuration.statusBarHideState = SelStatusBarHideStateAlways;
        _configuration.sourceUrl = self.videoUrl;
        _configuration.videoGravity = SelVideoGravityResizeAspectFill;
    }
    return _configuration;
}
/** 播放器控制面板 */
- (VipSelPlaybackControls *)controls
{
    if (!_controls) {
        _controls = [[VipSelPlaybackControls alloc]init];
    }
    return _controls;
}

- (VipGiftPlayListViewModel *)playViewModel {
    if (!_playViewModel) {
        _playViewModel = [[VipGiftPlayListViewModel alloc]init];
    }
    return _playViewModel;
}

- (NSDictionary *)playDetailDic {
    if (!_playDetailDic) {
        _playDetailDic = [NSDictionary dictionary];
    }
    return _playDetailDic;
}

- (UIImageView *)closeImage {
    if (!_closeImage) {
        _closeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Vip_playDetail_close"]];
        _closeImage.userInteractionEnabled = YES;
    }
    return _closeImage;
}

@end
