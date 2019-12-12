//
//  WARDouYinPlayVideoVC.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import "WARDouYinPlayVideoVC.h"
#import "WARPlayer.h"
#import "WARAVPlayerManager.h"
#import "WARFloatControlView.h"
#import "MJRefresh.h"
 
#import "WARDouYinCell.h"
#import "WARDouYinControlView.h"

#import "WARJournalFriendCycleNetManager.h"

#import "WARRecommendVideoModel.h" "
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"

#import "WARSmallFloatControlView.h"
#import "HKFloatManager.h"

@interface WARDouYinPlayVideoVC () <UITableViewDelegate,UITableViewDataSource,WARDouYinControlViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARPlayerController *player;
@property (nonatomic, strong) WARPlayerController *smallWindowPlayer;

@property (nonatomic, strong) WARDouYinControlView *controlView;
@property (nonatomic, strong) WARSmallFloatControlView *smallWindowControlView;

@property (nonatomic, strong) WARAVPlayerManager *playerManager;
@property (nonatomic, strong) NSMutableArray <WARRecommendVideo *>*videos;
@property (nonatomic, strong) WARRecommendVideo *firstVideo;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *smallWindowButton;

/** refId */
@property (nonatomic, copy) NSString *refId;
@end

@implementation WARDouYinPlayVideoVC

#pragma mark - System

- (instancetype)initWithFirstVideo:(WARRecommendVideo *)firstVideo {
    if (self = [super init]) {
        self.firstVideo = firstVideo;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES]; 
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videos = @[].mutableCopy;
    self.urls = @[].mutableCopy;
    [self.videos addObject:self.firstVideo];
    
    self.refId = @"";
    
    [[HKFloatManager shared] dismissSmallVideoWindow];
    
    // playerManager
    self.playerManager = [[WARAVPlayerManager alloc] init];
    self.playerManager.scalingMode = WARPlayerScalingModeAspectFill;
    
    UIView *playerManagerView = [self.playerManager valueForKey:@"_view"];
    playerManagerView.backgroundColor = [UIColor clearColor];
    
    self.player = [WARPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:kCoverImageViewTag];
    
    // load data
    [self loadDataRefresh:YES];
    
}

- (void)initSubviews {
    [super initSubviews];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.smallWindowButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
}

- (void)dealloc {
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
        self.refId = @"";
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager getFlowVideosWithRefId:self.refId compeletion:^(WARRecommendVideoModel *model, NSArray<WARRecommendVideo *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!err && results > 0) {
            strongSelf.refId = model.refId;
        }
        
        if (refresh) {
            [strongSelf.videos removeAllObjects];
            [strongSelf.videos addObject:strongSelf.firstVideo];
            [strongSelf.videos addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.videos addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            }
        }
        [strongSelf.urls removeAllObjects];
        NSArray *videoURLs = [strongSelf.videos valueForKeyPath:@"videoURL"];
        [strongSelf.urls addObjectsFromArray:[NSMutableArray arrayWithArray:videoURLs]];
        
        [strongSelf.tableView reloadData];
        [strongSelf dealWithLoadResultNoMoreData:NO];
        
        [strongSelf toPlay];
    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - Event Response


- (void)smallWindowAction:(UIButton *)button {
    NDLog(@"切换小窗口播放视频");
    
//    [[HKFloatManager shared] showSmallVideoWindow:self.player.currentPlayerManager.view];
//    [[HKFloatManager shared] addPlayer:self.player];
    
    [self.player stop];
    [[HKFloatManager shared] showSmallWindow];
    [self smallWindowPlay];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction:(UIButton *)button {
    [[HKFloatManager shared] dismissSmallVideoWindow];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    WARDouYinCell *cell = [WARDouYinCell cellWithTableView:tableView];
    cell.video = self.videos[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

#pragma mark - WARDouYinControlViewDelegate

- (void)controlViewDidPraise:(WARDouYinControlView *)controlView video:(WARRecommendVideo *)video{
    
}

- (void)controlViewDidComment:(WARDouYinControlView *)controlView video:(WARRecommendVideo *)video{
    
}

#pragma mark - WARTableViewCellDelegate

- (void)war_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}


#pragma mark - Private

- (void)smallWindowPlay {
    WARAVPlayerManager *playerManager = [[WARAVPlayerManager alloc] init];
    /// 播放器相关
    self.smallWindowPlayer = [WARPlayerController playerWithPlayerManager:playerManager containerView:[HKFloatManager shared].floatBall.iconImageView];
    self.smallWindowPlayer.assetURL = self.player.assetURL;
    self.smallWindowPlayer.controlView = self.smallWindowControlView;
    [[HKFloatManager shared] addPlayer:self.smallWindowPlayer];
    @weakify(self)
    [self.smallWindowPlayer seekToTime:self.player.currentTime completionHandler:^(BOOL finished) {
        @strongify(self)
        NDLog(@"smallWindowPlayer seekToTime");
        
        //        self.smallWindowPlayer.currentPlayerManager.view.userInteractionEnabled = NO;
    }];
    self.smallWindowPlayer.orientationWillChange = ^(WARPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.smallWindowPlayer.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.smallWindowPlayer.isFullScreen) {
            [self.smallWindowPlayer enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.smallWindowPlayer.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.smallWindowPlayer stop];
            });
        } else {
            [self.smallWindowPlayer stop];
        }
        [[HKFloatManager shared] dismissSmallVideoWindow];
    };
    
}
 
- (void)toPlay {
    // player,tag值必须在cell里设置
    self.player.assetURLs = self.urls;
    self.player.shouldAutorotate = NO;
    self.player.disableGestureTypes = WARPlayerDisableGestureTypesDoubleTap | WARPlayerDisableGestureTypesPan |WARPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
//        [self.player.currentPlayerManager stop];
    };
    
    [self.tableView war_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    @weakify(self)
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop completionHandler:^{
        @strongify(self)
        [self.controlView resetControlView];
        WARRecommendVideo *video = self.videos[indexPath.row];
        self.controlView.video = video;
    }];
}


#pragma mark - Setter And Getter

- (UIButton *)backButton {
    if (!_backButton) {
        UIImage *image = [UIImage war_imageName:@"new_return" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.frame = CGRectMake(10, 9.5 + kStatusBarHeight, 25, 25);
        _backButton.adjustsImageWhenHighlighted = NO;
        [_backButton setImage:image forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)smallWindowButton {
    if (!_smallWindowButton) {
        UIImage *image = [UIImage war_imageName:@"short" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _smallWindowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallWindowButton addTarget:self action:@selector(smallWindowAction:) forControlEvents:UIControlEventTouchUpInside];
        _smallWindowButton.frame = CGRectMake(kScreenWidth - 37, 9.5 + kStatusBarHeight, 25, 25);
        _smallWindowButton.adjustsImageWhenHighlighted = NO;
        [_smallWindowButton setImage:image forState:UIControlStateNormal];
    }
    return _smallWindowButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        __weak typeof(self) weakSelf = self;
        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDataRefresh:NO];
        }];
        _tableView.mj_footer = mj_footer;
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.scrollViewDidStopScroll = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (WARDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [WARDouYinControlView new];
        _controlView.delegate = self;
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}

- (WARSmallFloatControlView *)smallWindowControlView {
    if (!_smallWindowControlView) {
        _smallWindowControlView = [WARSmallFloatControlView new];
        _smallWindowControlView.userInteractionEnabled = YES;
        _smallWindowControlView.showInSmallWindow = YES;
        _smallWindowControlView.smallNeedPortraitFullScreen = YES;
    }
    return _smallWindowControlView;
}

@end
