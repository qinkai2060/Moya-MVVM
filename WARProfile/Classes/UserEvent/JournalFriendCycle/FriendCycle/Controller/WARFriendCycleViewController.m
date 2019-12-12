//
//  WARFriendCycleViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFriendCycleViewController.h"
#import "WARUserDiaryManager.h"
#import "WARBaseMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"

#import "WARUserDiaryPageCell.h"
#import "WARNewUserDiaryMomentLayout.h"
#import "WARNewUserDiaryModel.h"

#import "WARNavgationCutsomBar.h"
#import "WARFriendCycleSegmentBar.h"
#import "WARFriendCycleFriendTypeView.h"
#import "WARFriendCycleTableHeaderView.h"
#import "WARCPageContentView.h"

#import "WARFriendListViewController.h" 

#import "WARFollowDetailViewController.h"
#import "WARFriendMessageViewController.h"

#import "WARMediator+Publish.h"
#import "Masonry.h"
#import "WARPRofilePersonTableView.h"
#import "WARProfileNetWorkTool.h"
#import "WARProfileUserModel.h"
#import "WARFriendMaskModel.h"

#import "WARProgressHUD.h"
#import "MJRefresh.h"

#import "UIView+Frame.h"

#import "WARMediator+WebBrowser.h"
#import "WARFriendNavigationBar.h"
#import "WARProfileOtherViewController.h"
#import "WARPlayViewController.h"
#import "WARFriendDetailViewController.h"
#import "WARMoment.h"
#import "WARUserCenterViewController.h"

#import "WARActionSheet.h"
#import "ReactiveObjC.h"
#import "WARImagePickerController.h"
#import "WARCameraViewController.h"
#import "UIImage+PreViewImage.h"
#import "WARTweetVideoTool.h"
#import "WARDouYinPlayVideoVC.h"
#import "WARRecommendVideo.h" 
  
#import "WARLightPlayVideoVC.h"

//#define kHeaderView (190 + kStatusBarAndNavigationBarHeight)


@interface WARFriendCycleViewController ()<UIScrollViewDelegate,WARFriendCycleFriendTypeViewDelegate,UITableViewDelegate,UITableViewDataSource,WARFriendCycleTableHeaderViewDelegate>

@property (nonatomic, strong) WARPRofilePersonTableView *tableView;
@property (nonatomic, strong) WARCPageContentView *pageContentView;

@property (nonatomic, strong) WARFriendNavigationBar *customBar; 
@property (nonatomic, strong) WARFriendCycleFriendTypeView *friendTypeView;
@property (nonatomic, strong) WARFriendCycleTableHeaderView *headerView;
@property (nonatomic, strong) WARFriendCycleSegmentBar *segmentBar;

/** segment点击更改selectIndex,切换页面 */
@property (assign, nonatomic) NSInteger selectIndex;

@property (strong, nonatomic) UIPageViewController *pageViewCtrl;
@property (strong, nonatomic) NSMutableArray *controllerArray;

@property (nonatomic, strong) WARFriendListViewController *friendController;
@property (nonatomic, strong) WARFriendListViewController *followController;

@property (nonatomic, strong) NSString *friendMaskId;
@property (nonatomic, strong) NSString *followMaskId;

@property (nonatomic, strong) NSArray<WARFriendMaskModel *> *maskArray;

@property (nonatomic, assign) BOOL headerViewIsToTop;
@property (nonatomic, assign) CGFloat childViewContentOffsetY;
@property (nonatomic, assign) CGFloat currentContentOffsetY;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL showStatusBarStyleLightContent;
@end

@implementation WARFriendCycleViewController

#pragma mark - System

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.friendTypeView hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.canScroll = YES;
    self.showStatusBarStyleLightContent = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kWARFriendCycleLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollDown:) name:@"kWARFriendCycleScrollDownNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollUp:) name:@"kWARFriendCycleScrollUpNtf" object:nil];
    
    [self loadHeaderData];
    
    [self loadMaskList];
}

- (void)loadMaskList {
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager getMaskListWithCompletion:^(NSArray<WARFriendMaskModel *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NDLog(@"results:%@",results);
        strongSelf.maskArray = [NSArray arrayWithArray:results];
        
        NSArray *tags = [strongSelf.maskArray valueForKeyPath:@"nickname"];
        
        strongSelf.friendTypeView.tags = tags;//strongSelf.maskArray;
        if (tags.count > 0) {
            [strongSelf.friendTypeView selectedBtnIndex:0];
        }
    }];
}

- (void)loadHeaderData {
    WS(weakself);
    [WARProfileNetWorkTool getUserInfoWithCallBack:^(id response) {
        
        WARProfileUserModel *model = [[WARProfileUserModel alloc] init];
        model.isMine = YES;
        [model praseData:response];
        if (model.MasksArr.count > 0) {
            weakself.headerView.model = model.MasksArr.firstObject;
        }
    } failer:^(id response) {
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"加载失败")];
    }];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.friendController.canScroll = NO;
    self.followController.canScroll = NO;
    if (!self.friendController.canScroll) {
        self.friendController.tableView.contentOffset = CGPointZero;
    }
    if (!self.followController.canScroll) {
        self.followController.tableView.contentOffset = CGPointZero;
    }
}

- (void)onOtherScrollDown:(NSNotification *)ntf {
    CGFloat offset = [ntf.object floatValue];
    CGFloat scale = offset / 100;
    if (scale <= 1) {
        self.segmentBar.frame = CGRectMake(0, CGRectGetMaxY(self.customBar.frame) - kSegmentBarHeight * ((1 - scale) <= 0 ? 0 : (1 - scale)), kScreenWidth, kSegmentBarHeight);
    }else {
        scale = (offset - 100) / 100;
        CGFloat reduceHeight = (kStatusBarAndNavigationBarHeight - (kStatusBarHeight + 20)) * (scale >= 1 ? 1 : scale);
        self.customBar.height = kStatusBarHeight + 20 + reduceHeight;
        CGFloat fontScale = self.customBar.height / kStatusBarAndNavigationBarHeight;
        [self.customBar scrollWithScale:scale fontScale:fontScale changeAlpha:NO];
        self.segmentBar.frame = CGRectMake(0, CGRectGetMaxY(self.customBar.frame), kScreenWidth, kSegmentBarHeight);
    }
    [self.segmentBar changeButtonWithSelectIndex:self.selectIndex];
    self.segmentBar.hidden = NO;
}

- (void)onOtherScrollUp:(NSNotification *)ntf {
    CGFloat offset = [ntf.object floatValue];
    CGFloat scale = offset / 100;
    if (!self.canScroll) {
        if (scale <= 1) {
            self.segmentBar.frame = CGRectMake(0, CGRectGetMaxY(self.customBar.frame) - kSegmentBarHeight * (scale >= 1 ? 1 : scale), kScreenWidth, kSegmentBarHeight);
            [self.segmentBar changeButtonWithSelectIndex:self.selectIndex];
            self.segmentBar.hidden = NO;
        }else {
            scale = (offset - 100) / 100;
            CGFloat reduceHeight = (kStatusBarAndNavigationBarHeight - (kStatusBarHeight + 20)) * (scale >= 1 ? 1 : scale);
            self.customBar.height = kStatusBarAndNavigationBarHeight - reduceHeight;
            CGFloat fontScale = (kStatusBarAndNavigationBarHeight - reduceHeight) / kStatusBarAndNavigationBarHeight;
            [self.customBar scrollWithScale:scale fontScale:fontScale changeAlpha:NO];
            self.segmentBar.hidden = YES;
        }
    }
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = HEXCOLOR(0xf4f4f4);
    self.canScroll = YES;
    
    [self initNavigationBar];
    
    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    self.tableView.tableHeaderView = self.headerView;
    
//    [self.view addSubview:self.friendTypeView];
    
    [self.view addSubview:self.segmentBar];
    
    [self.view bringSubviewToFront:self.customBar];
}

- (void)initNavigationBar {
    [self.view addSubview:self.customBar];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.showStatusBarStyleLightContent) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

#pragma mark - Event Response

- (void)addAction:(UIButton *)button {
    NDLog(@"Navigation addAction");
    
}

- (void)rightAction{

    @weakify(self)
    NSArray* titles = @[@"从手机相册选择", @"拍摄", @"文字"];
    [WARActionSheet actionSheetWithBtnTitles:titles cancelTitle:WARLocalizedString(@"取消") completionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        @strongify(self)
        if (index == 0) {
            [self showImagePicker];
        }else if (index == 1){
            [self showCamera];
        }else {
            [self toPublish];
        }
    }];
}

- (void)showImagePicker {
    
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVc.allowPickingMultipleVideo = YES;
    imagePickerVc.allowTakePicture = NO;
    @weakify(self);
    imagePickerVc.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        @strongify(self)
        UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerWithImages:photos assets:assets videoData:nil];
        [self.navigationController pushViewController:publishVC animated:YES];
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)showCamera {
    
    WARCameraViewController *vc = [[WARCameraViewController alloc] init];
    @weakify(self);
    vc.takeBlock = ^(id item) {
        @strongify(self)
        if ([item isKindOfClass:[NSURL class]]) {
            //视频url
            NSURL *videoURL = item;
            [WARTweetVideoTool war_movFileTransformToMP4WithSourcePath:videoURL.absoluteString completion:^(NSString *Mp4FilePath) {
                UIImage *image = [UIImage getPreViewImageWithUrl:videoURL];
                NSUInteger duration = [WARTweetVideoTool war_durationWithVideo:videoURL];
                NSDictionary* dict = @{@"videoCoverImg" : @[image],
                                       @"duration" : [NSNumber numberWithInteger:duration],
                                       @"videoFilePath" : Mp4FilePath
                                       };
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerWithImages:@[] assets:@[]  videoData:dict];
                    [self.navigationController pushViewController:publishVC animated:YES];
                });
                
            } session:^(AVAssetExportSession *session) {
                
            }];
        } else if ([item isKindOfClass:[UIImage class]]){
            //图片
            UIImage *image = item;
            UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerWithImages:@[image] assets:@[] videoData:nil];
            [self.navigationController pushViewController:publishVC animated:YES];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)toPublish {
    
    UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerNoParams];
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)didBarAction{
//    [UIView animateWithDuration:0.35 animations:^{
        self.customBar.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight);
        [self.customBar scrollWithScale:1 fontScale:1 changeAlpha:YES];
//    }];
}

- (void)leftAtction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = kScreenHeight - kSafeAreaBottom;
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"UITableViewCell"];
        [cell.contentView addSubview:self.pageContentView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"cycle offsetY:%.f",scrollView.contentOffset.y);
    self.currentContentOffsetY = scrollView.contentOffset.y;
    
    if (self.lastContentOffsetY > scrollView.contentOffset.y) {
        //向下滑动
//        NSLog(@"向下滑动");
    } else if (self.lastContentOffsetY < scrollView.contentOffset.y){
        //向上滑动
//        NSLog(@"向上滑动");
    }
    
    //滑动
    if (scrollView == self.tableView) {
        //子控制器和主控制器之间的滑动状态切换
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y - kSegmentBarHeight;
        if (scrollView.contentOffset.y >= tabOffsetY) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            if (self.canScroll) {
                self.canScroll = NO;
                self.friendController.canScroll = YES;
                self.followController.canScroll = YES;
            }
        } else {
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    CGFloat scale = (self.currentContentOffsetY - 180) / 100;
    
    self.lastContentOffsetY = scrollView.contentOffset.y;
    
    if (self.canScroll) {
        //需要减少的高度
        CGFloat reduceHeight = (kStatusBarAndNavigationBarHeight - (kStatusBarHeight + 20)) * ((scale <= 0 ? 0 : scale) >= 1 ? 1 : scale);
        self.customBar.height = kStatusBarAndNavigationBarHeight - reduceHeight;
        
        //导航栏比例
        CGFloat fontScale = (kStatusBarAndNavigationBarHeight - reduceHeight) / kStatusBarAndNavigationBarHeight;
        [self.customBar scrollWithScale:scale fontScale:fontScale changeAlpha:YES];
        
        [self.headerView.segmentBar changeButtonWithSelectIndex:self.selectIndex];
        self.segmentBar.hidden = YES;
    }

    self.friendTypeView.frame = CGRectMake(0,kHeaderView - self.currentContentOffsetY, kScreenWidth, kScreenHeight); 
    [self.friendTypeView hide];
    
    self.showStatusBarStyleLightContent = (scale < 0.5);
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - WARFriendCycleSegmentBarDelegate

- (void)friendCycleSegmentBar:(WARFriendCycleSegmentBar *)toolBar didSelectIndex:(NSInteger)index state:(WARFriendCycleTagState)state {
    [self headerView:self.headerView didSelectIndex:index state:state];
}

#pragma mark - WARFriendCycleFriendTypeViewDelegate

- (void)friendCycleFriendTypeView:(WARFriendCycleFriendTypeView *)friendCycleFriendTypeView didSelectedIndex:(NSUInteger)index {
    [self.friendTypeView hide];
    [self.headerView.segmentBar changeCurrentButtonState];
    
    if (self.selectIndex == 0) {//好友
        self.friendMaskId = self.maskArray[index].maskId;
        [self.friendController loadDataWithMaskId:self.friendMaskId];
    } else {// 关注
        self.followMaskId = self.maskArray[index].maskId;
        [self.followController loadDataWithMaskId:self.followMaskId];
    }
}

- (void)friendCycleFriendTypeViewDidHidden:(WARFriendCycleFriendTypeView *)friendCycleFriendTypeView {
    [self.friendTypeView hide];
    [self.headerView.segmentBar changeCurrentButtonState];
}

#pragma mark - WARFriendCycleTableHeaderViewDelegate

- (void)headerView:(WARFriendCycleTableHeaderView *)headerView didSelectIndex:(NSInteger)index state:(WARFriendCycleTagState)state {
    self.selectIndex = index;
    [self.pageContentView setPageCententViewCurrentIndex:index];
    
    switch (state) {
        case WARFriendCycleTagStateNormal:
        {
            [self.friendTypeView hide];
            break;
        }
        case WARFriendCycleTagStateSelected:
        {
            [self.friendTypeView hide];
            break;
        }
        case WARFriendCycleTagStateOpen:
        {
            if (!self.segmentBar.hidden) {
                self.friendTypeView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentBar.frame), kScreenWidth, kScreenHeight - kSegmentBarHeight - kStatusBarAndNavigationBarHeight);
            }else {
                self.friendTypeView.frame = CGRectMake(0,kHeaderView - self.currentContentOffsetY, kScreenWidth, kScreenHeight - kSegmentBarHeight - kStatusBarAndNavigationBarHeight);
            }
            [self.friendTypeView showInView:self.view];
            break;
        }
        case WARFriendCycleTagStateNoArrowNormal:
        {
            [self.friendTypeView hide];
            break;
        }
        case WARFriendCycleTagStateNoArrowSelected:
        {
            [self.friendTypeView hide];
            break;
        }
    }
    
    //改变选中类型
    if (index == 0) { //好友
        [self selectFriendTypeWithMaskId:self.friendMaskId];
    } else { // 关注
        [self selectFriendTypeWithMaskId:self.followMaskId];
    }
}
  
- (void)selectFriendTypeWithMaskId:(NSString *)maskId {
    if (maskId == nil || maskId.length <= 0) {
        if (self.maskArray.count <= 0) {
            return ;
        }
        [self.friendTypeView selectedBtnIndex:0];
        
        return ;
    }
    
    for (int i = 0; i < self.maskArray.count; i++) {
        WARFriendMaskModel *maskModel = self.maskArray[i];
        if ([maskModel.maskId isEqualToString:maskId]) {
            [self.friendTypeView selectedBtnIndex:i];
        }
    }
}

#pragma mark - Private

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark - Setter And Getter

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
}

- (WARFriendCycleFriendTypeView *)friendTypeView {
    if (!_friendTypeView) {
        _friendTypeView = [[WARFriendCycleFriendTypeView alloc]init];
        _friendTypeView.delegate = self;
        _friendTypeView.coverColor = [UIColor colorWithWhite:0 alpha:0.5];
        _friendTypeView.frame = CGRectMake(0, kSegmentBarHeight + kStatusBarAndNavigationBarHeight + kHeaderView, kScreenWidth, kScreenHeight - kSegmentBarHeight - kStatusBarAndNavigationBarHeight);
        _friendTypeView.hidden = YES;
    }
    return _friendTypeView;
}

- (WARFriendNavigationBar *)customBar{
    if (!_customBar) {
        WS(weakself);
        _customBar = [[WARFriendNavigationBar alloc] init];
        _customBar.leftHandler = ^{
            [weakself leftAtction];
        };
        _customBar.rightHandler = ^{
            [weakself rightAction];
        };
        _customBar.didBarHandler = ^{
            [weakself didBarAction];
        };
        _customBar.titleHandler = ^{
            [weakself didBarAction];
        };
        _customBar.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight);
    }
    return _customBar;
}

- (WARFriendCycleTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WARFriendCycleTableHeaderView alloc]init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderView);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (WARPRofilePersonTableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSafeAreaBottom);
        _tableView = [[WARPRofilePersonTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.userInteractionEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.selectIndex == 0) {
                [strongSelf.friendController loadDataRefresh:YES];
            } else {
                [strongSelf.followController loadDataRefresh:YES];
            }
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;
    }
    return _tableView;
}

- (WARCPageContentView *)pageContentView {
    if (!_pageContentView) {
        __weak typeof(self) weakSelf = self;
        
        //FRIEND
        WARFriendListViewController *friendController = [[WARFriendListViewController alloc]initWithType:@"FRIEND" maskId:@""];
        friendController.pushBlock = ^(WARMoment *moment) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:moment type:@"FRIEND"];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        friendController.pushToFriendMessageblock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARFriendMessageViewController *controller = [[WARFriendMessageViewController alloc]init];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        friendController.dealWithLoadResultNoMoreDataBlock = ^(BOOL noMoreData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dealWithLoadResultNoMoreData:noMoreData];
        };
        friendController.pushToWebBrowserblock = ^(NSString *url) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIViewController *controller = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:url callback:nil];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        friendController.pushToUserProfileBlock = ^(NSString *guyId, NSString *friendWay,BOOL isMine) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (isMine) {
                WARUserCenterViewController *controller = [[WARUserCenterViewController alloc] init];
                controller.isOtherfromWindow = YES;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            } else {
                WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:guyId friendWay:friendWay];
                [strongSelf.navigationController pushViewController:controller animated:YES];
            }
        };
        friendController.pushToPlayBlock = ^(WARRecommendVideo *video, BOOL fullScreen) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
//            WARPlayViewController *controller = [[WARPlayViewController alloc] initWithVideoUrl:videoUrl];
//            WARRecommendVideo *video = [[WARRecommendVideo alloc] init];
//            video.url = videoUrl.absoluteString;
            
            WARDouYinPlayVideoVC *controller = [[WARDouYinPlayVideoVC alloc] initWithFirstVideo:video];
            if (!fullScreen) {
                controller = [[WARLightPlayVideoVC alloc] initWithFirstVideo:video];
            }
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        
        //FOLLOW
        WARFriendListViewController *followController = [[WARFriendListViewController alloc]initWithType:@"FOLLOW" maskId:@""];
        followController.pushBlock = ^(WARMoment *moment) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARFollowDetailViewController *controller = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:moment.momentId];
            [controller configMoment:moment];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        followController.pushCommentBlock = ^(WARMoment *moment) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARFollowDetailViewController *controller = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:moment.momentId scrollToComment:YES];
            [controller configMoment:moment];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        followController.pushToFriendMessageblock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARFriendMessageViewController *controller = [[WARFriendMessageViewController alloc]init];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        followController.dealWithLoadResultNoMoreDataBlock = ^(BOOL noMoreData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dealWithLoadResultNoMoreData:noMoreData];
        };
        followController.pushToWebBrowserblock = ^(NSString *url) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:url callback:nil];
            [strongSelf.navigationController pushViewController:controllr animated:YES];
        };
        followController.pushToUserProfileBlock = ^(NSString *guyId, NSString *friendWay,BOOL isMine) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (isMine) {
                WARUserCenterViewController *controller = [[WARUserCenterViewController alloc] init];
                controller.isOtherfromWindow = YES;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            } else {
                WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:guyId friendWay:friendWay];
                [strongSelf.navigationController pushViewController:controller animated:YES];
            }
        };
        followController.pushToPlayBlock = ^(WARRecommendVideo *video, BOOL fullScreen) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //            WARPlayViewController *controller = [[WARPlayViewController alloc] initWithVideoUrl:videoUrl];
//            WARRecommendVideo *video = [[WARRecommendVideo alloc] init];
//            video.url = videoUrl.absoluteString;
            WARDouYinPlayVideoVC *controller = [[WARDouYinPlayVideoVC alloc] initWithFirstVideo:video];
            if (!fullScreen) {
                controller = [[WARLightPlayVideoVC alloc] initWithFirstVideo:video];
            }
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        self.friendController = friendController;
        self.followController = followController;
        
        NSArray *childArr = @[self.friendController, self.followController]; 
        CGFloat contentViewHeight = kScreenHeight - kSafeAreaBottom;
        
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.isScrollEnabled = NO;
        _pageContentView.backgroundColor = [UIColor whiteColor];
    }
    
    return _pageContentView;
}

- (WARFriendCycleSegmentBar *)segmentBar {
    if (!_segmentBar) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kSegmentBarHeight);
        NSArray *tags = @[WARLocalizedString(@"好友"),WARLocalizedString(@"关注")];
        _segmentBar = [[WARFriendCycleSegmentBar alloc]initWithFrame:frame tags:tags];
        _segmentBar.delegate = self;
        _segmentBar.hidden = YES;
    }
    return _segmentBar;
}

@end
