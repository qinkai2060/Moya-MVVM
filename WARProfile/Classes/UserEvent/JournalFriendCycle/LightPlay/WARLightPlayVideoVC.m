
//
//  WARLightPlayVideoVC.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/6/28.
//

#import "WARLightPlayVideoVC.h"
#import "WARPlayer.h"
#import "WARAVPlayerManager.h"
#import "WARPlayerControlView.h"
#import "MJRefresh.h"

#import "WARJournalFriendCycleNetManager.h"
#import "WARRecommendVideoModel.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARLightPlayVideoCellLayout.h"
#import "WARLightPlayVideoCell.h"
#import "UIImage+Tint.h"
#import "HKFloatManager.h"
#import "WARUserDiaryManager.h"
#import "WARSmallFloatControlView.h"

@interface WARLightPlayVideoVC ()<UITableViewDelegate,UITableViewDataSource,WARLightPlayVideoCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARPlayerController *player;
@property (nonatomic, strong) WARPlayerController *smallWindowPlayer;
@property (nonatomic, strong) WARPlayerControlView *controlView;
@property (nonatomic, strong) WARSmallFloatControlView *smallWindowControlView;
@property (nonatomic, strong) WARAVPlayerManager *playerManager;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSMutableArray <WARLightPlayVideoCellLayout *> *layouts;
@property (nonatomic, strong) NSMutableArray <WARRecommendVideo *> *videos;
@property (nonatomic, strong) WARRecommendVideo *firstVideo;
@property (nonatomic, strong) NSMutableArray *urls;

/** refId */
@property (nonatomic, copy) NSString *refId;

@end

@implementation WARLightPlayVideoVC

#pragma mark - System

- (instancetype)initWithFirstVideo:(WARRecommendVideo *)firstVideo {
    if (self = [super init]) {
        self.firstVideo = firstVideo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urls = @[].mutableCopy;
    self.videos = @[].mutableCopy;
    self.layouts = @[].mutableCopy;
    
    [[HKFloatManager shared] dismissSmallVideoWindow];
    
    self.playerManager = [[WARAVPlayerManager alloc] init];
    
    UIView *playerManagerView = [self.playerManager valueForKey:@"_view"];
    playerManagerView.backgroundColor = [UIColor clearColor];
    
    /// player,tag值必须在cell里设置
    self.player = [WARPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(WARPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.playingIndexPath.row < self.urls.count - 1 && !self.player.isFullScreen) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
        } else if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        } else {
            [self.player stopCurrentPlayingCell];
        }
    };
     
    [self loadDataRefresh:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated]; 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)initSubviews {
    [super initSubviews];
    
    //小窗口播放视频
    UIImage *image = [[[UIImage war_imageName:@"short" curClass:[self class] curBundle:@"WARProfile.bundle"] imageWithTintColor:[UIColor whiteColor]]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    
    //tableView
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
}

- (void)rightAction {
    
    [self.player stop];
    [[HKFloatManager shared] showSmallWindow];
    [self smallWindowPlay];
    
    [self.player stopCurrentPlayingCell];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
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
        
        NSMutableArray *tempLayouts = [NSMutableArray array];
        for (WARRecommendVideo *video in results) {
            WARLightPlayVideoCellLayout *layout = [WARLightPlayVideoCellLayout layoutWithVideo:video];
            [tempLayouts addObject:layout];
        }

        if (refresh) {
            [strongSelf.layouts removeAllObjects];
            
            
            WARLightPlayVideoCellLayout *layout = [WARLightPlayVideoCellLayout layoutWithVideo:strongSelf.firstVideo];
            [strongSelf.layouts addObject:layout];
            [strongSelf.videos addObject:strongSelf.firstVideo];
            
            [strongSelf.layouts addObjectsFromArray:[NSMutableArray arrayWithArray:tempLayouts]];
            
            [strongSelf.videos addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.layouts addObjectsFromArray:[NSMutableArray arrayWithArray:tempLayouts]];
                
                [strongSelf.videos addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            }
        }
        
        [strongSelf.urls removeAllObjects];
        NSArray *videoURLs = [self.videos valueForKeyPath:@"videoURL"];
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

#pragma mark - Delegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARLightPlayVideoCell *cell = [WARLightPlayVideoCell cellWithTableView:tableView];
    [cell setDelegate:self withIndexPath:indexPath];
    cell.layout = self.layouts[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARLightPlayVideoCellLayout *layout = self.layouts[indexPath.row];
    return layout.cellHeight;
}

#pragma mark - WARLightPlayVideoCellDelegate

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

- (void)lightPlayVideoCell:(WARLightPlayVideoCell *)cell didCommentAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)lightPlayVideoCell:(WARLightPlayVideoCell *)cell didPraiseAtIndexPath:(NSIndexPath *)indexPath {
    [self praiseOrCancle:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    @weakify(self)
    [scrollView war_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        if ([indexPath compare:self.tableView.shouldPlayIndexPath] != NSOrderedSame) {
            @strongify(self)
            /// 显示黑色蒙版
            WARLightPlayVideoCell *cell1 = [self.tableView cellForRowAtIndexPath:self.tableView.shouldPlayIndexPath];
            [cell1 showMaskView];
            /// 隐藏黑色蒙版
            WARLightPlayVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell hideMaskView];
        }
    }];
}

#pragma mark - Private

- (void)toPlay {
    // player,tag值必须在cell里设置
    self.player.assetURLs = self.urls;
    
    @weakify(self)
    [self.tableView war_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    WARLightPlayVideoCell *cell = [self.tableView cellForRowAtIndexPath:self.tableView.shouldPlayIndexPath];
    [cell hideMaskView];
}


- (void)smallWindowPlay {
    WARAVPlayerManager *playerManager = [[WARAVPlayerManager alloc] init];
    /// 播放器相关
    self.smallWindowPlayer = [WARPlayerController playerWithPlayerManager:playerManager containerView:[HKFloatManager shared].floatBall.iconImageView];
    self.smallWindowPlayer.controlView = self.smallWindowControlView;
    self.smallWindowControlView.player = self.smallWindowPlayer;
    [[HKFloatManager shared] addPlayer:self.smallWindowPlayer];
    @weakify(self)
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
    self.smallWindowPlayer.assetURL = self.player.assetURL;
    [self.smallWindowPlayer seekToTime:self.player.currentTime completionHandler:^(BOOL finished) {
        @strongify(self)
        NDLog(@"smallWindowPlayer seekToTime");
        
//        self.smallWindowPlayer.currentPlayerManager.view.userInteractionEnabled = NO;
    }];
}


/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    WARLightPlayVideoCellLayout *layout = self.layouts[indexPath.row];
    [self.controlView showTitle:@""//layout.video.desc
                 coverURLString:kVideoCoverUrl(layout.video.url)
                 fullScreenMode:layout.isVerticalVideo?WARFullScreenModePortrait:WARFullScreenModeLandscape];
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
}

- (void)praiseOrCancle:(NSIndexPath *)indexPath {
    if (indexPath.row < self.layouts.count) {
        WARLightPlayVideoCellLayout *layout = self.layouts[indexPath.row];
        WARRecommendVideo *video = layout.video;
        
        NSString *itemId = video.momentId;
        NSString *msgId = video.momentId;
        NSString *thumbedAcctId = video.account.accountId;
        
        NSString *thumbState = @"UP";
        if (video.commentWapper.thumbUp) {
            thumbState = @"DOWN";
        }

        __weak typeof(self) weakSelf = self;
        [WARUserDiaryManager praiseWithItemId:itemId msgId:msgId thumbedAcctId:thumbedAcctId thumbState:thumbState compeletion:^(bool success, NSError *err) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            //构建点赞用户 model
//            WARMomentUser *thumb = [[WARMomentUser alloc]init];
//            thumb.accountId = strongSelf.userModel.accountId;
//            thumb.nickname = strongSelf.userModel.nickname;
//
//            if (!moment.commentWapper) {
//                WARCommentWrapper *commentWapper = [[WARCommentWrapper alloc] init];
//                moment.commentWapper = commentWapper;
//            }
//            if (!moment.commentWapper.comment) {
//                WARFriendCommentModel *comment = [[WARFriendCommentModel alloc] init];
//                NSMutableArray *comments = [NSMutableArray array];
//                comment.comments = comments;
//                moment.commentWapper.comment = comment;
//            }
//            if (!moment.commentWapper.thumb) {
//                WARThumbModel *thumb = [[WARThumbModel alloc] init];
//                NSMutableArray *thumbUserBos = [NSMutableArray array];
//                thumb.thumbUserBos = thumbUserBos;
//                moment.commentWapper.thumb = thumb;
//            }
//
//            NSMutableArray *thumbUserBos = [NSMutableArray arrayWithArray:moment.commentWapper.thumb.thumbUserBos];
//            moment.commentWapper.thumbUp = !moment.commentWapper.thumbUp;
//            if (moment.commentWapper.thumbUp) { //已点赞
//                moment.commentWapper.praiseCount += 1;
//                [thumbUserBos addObject:thumb];
//            } else { // 取消点赞
//                moment.commentWapper.praiseCount -= 1;
//                [thumbUserBos enumerateObjectsUsingBlock:^(WARMomentUser *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.accountId isEqualToString:thumb.accountId]) {
//                        [thumbUserBos removeObject:obj];
//                    }
//                }];
//            }
//            
//            moment.commentWapper.thumb.thumbUserBos = [thumbUserBos copy];
//            
//            //原布局
//            WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
//            //新生成布局
//            WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.type moment:moment openLike:NO openComment:NO];
//            layout.feedLayoutArr = originalLayout.feedLayoutArr;
//            layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
//            layout.currentPageIndex = originalLayout.currentPageIndex;
//            moment.friendMomentLayout = layout;
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            });
        }];

    }
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]; 
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor blackColor];
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

- (WARSmallFloatControlView *)smallWindowControlView {
    if (!_smallWindowControlView) {
        _smallWindowControlView = [WARSmallFloatControlView new];
        _smallWindowControlView.userInteractionEnabled = YES;
        _smallWindowControlView.showInSmallWindow = YES;
    }
    return _smallWindowControlView;
}


- (WARPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [WARPlayerControlView new];
    }
    return _controlView;
}

@end
