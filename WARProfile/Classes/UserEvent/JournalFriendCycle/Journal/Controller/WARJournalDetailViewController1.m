//
//  WARJournalDetailViewController1.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/17.
//

#import "WARJournalDetailViewController1.h"

#import "WARMacros.h"
#import "MJRefresh.h"

#import "WARMoment.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"

#import "WARDBUserManager.h"
#import "WARDBUserModel.h"
#import "WARDBUser.h"
#import "WARDBContactModel.h"

#import "WARFeedModel.h"
#import "WARCMessageModel.h"

#import "WARPopOverMenu.h"
#import "WARUserDiaryManager.h"

//#import "UIMessageInputView.h"
#import "WARJournalThumbCell.h"
#import "WARFriendPageCell.h"
#import "WARFriendSinglePageCell.h"
#import "WARJournalCommentCell.h"
#import "WARJournalArrowCell.h"
#import "WARFriendCommentVoiceView.h"
#import "WARJournalDetailTableHeaderView.h"
#import "WARCPageContentView.h"
#import "WARCPageTitleView.h"

#import "WARFriendDetailViewController.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARProfileOtherViewController.h"
#import "WARPlayViewController.h"
#import "WARPhotoBrowser.h"
#import "WARCAVAudioPlayer.h"
#import "WARJournalDetailFriendVC.h"
#import "WARJournalDetailPublicVC.h"

#import "WARMediator+WebBrowser.h"
#import "WARMediator+Publish.h"
#import "UIImage+WARBundleImage.h"
#import "UIImage+Tint.h"

static NSInteger kPageTitleHeight = 35;

@interface WARJournalDetailViewController1 ()<UITableViewDelegate,UITableViewDataSource,WARFriendBaseCellDelegate,WARCPageTitleViewDelegate>

/** tableView */
@property (nonatomic, strong) WARMultiPageTableView *tableView;
/** comments */
@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*commentLayouts;
/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** friendId */
@property (nonatomic, copy) NSString *friendId;
/** 详情model */
@property (nonatomic, strong) WARJournalDetailModel *detailModel;
/** 动态 */
@property (nonatomic, strong) WARMoment *moment;
/** 最后播放的音频视图 */
@property (nonatomic, strong) WARFriendCommentVoiceView *lastVoiceView;
/** tableHeaderView */
@property (nonatomic, strong) WARJournalDetailTableHeaderView *tableHeaderView;
/** pageContentView */
@property (nonatomic, strong) WARCPageContentView *pageContentView;
/** titleSegmentView */
@property (nonatomic, strong) WARCPageTitleView *titleSegmentView;
@property (nonatomic, strong) UIView *segmentBarSuperView;
/** journalDetailFriendVC */
@property (nonatomic, strong) WARJournalDetailFriendVC *journalDetailFriendVC;
/** journalDetailFriendVC */
@property (nonatomic, strong) WARJournalDetailPublicVC *journalDetailPublicVC;

@property (nonatomic, assign) BOOL canScroll;
@end

@implementation WARJournalDetailViewController1

#pragma mark - System

- (instancetype)initWithMomentId:(NSString *)momentId friendId:(NSString *)friendId {
    if (self = [super init]) {
        self.momentId = momentId;
        self.friendId = friendId;
    }
    return self;
}

- (instancetype)initWithMoment:(WARMoment *)moment {
    if (self = [super init]) {
        self.momentId = moment.momentId;
        self.friendId = moment.accountId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
     
    self.canScroll = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kWARJournalDetailLeaveTopNtf" object:nil];
    
    [self loadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor]; 
    self.title = [NSString stringWithFormat:@"详情"];
    
    /// 列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    /// tableHeaderView
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    /// 收藏、举报
    UIImage *image = [[[UIImage war_imageName:@"person_zone_details_more2" curClass:[self class] curBundle:@"WARProfile.bundle"] imageWithTintColor:[UIColor whiteColor]]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadPersonalDetailWithMomentId:self.momentId friendId:self.friendId compeletion:^(WARJournalDetailModel *model, WARMoment *moment, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tableView.hidden = NO;
        
        strongSelf.detailModel = model;
        strongSelf.moment = moment;
        strongSelf.tableHeaderView.moment = strongSelf.moment;
        
        strongSelf.journalDetailFriendVC.detailModel = strongSelf.detailModel;
        strongSelf.journalDetailPublicVC.detailModel = strongSelf.detailModel;
        
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Event Response

- (void)rightAction {
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    config.tintColor = HEXCOLOR(0x4B5054);
    
    NSArray *titles = @[WARLocalizedString(@"收藏"),WARLocalizedString(@"举报")];
    if(self.moment.isMine){
        titles = @[WARLocalizedString(@"收藏")];
    }
    //    __weak typeof(self) weakSelf = self;
    CGRect frame = CGRectMake(kScreenWidth - 25, kStatusBarAndNavigationBarHeight, 1, 1);
    [WARPopOverMenu showFromSenderFrame:frame withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
        //        __strong typeof(weakSelf) strongSelf = weakSelf;
        switch (selectedIndex) {
            case 0:
            {
                
                break;
            }
            case 1:
            {
                
                break;
            }
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARCPageContentView"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"WARCPageContentView"];
        [cell.contentView addSubview:self.pageContentView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = kScreenHeight - kStatusBarAndNavigationBarHeight - kSafeAreaBottom ;//- self.moment.friendMomentLayout.cellHeight;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kPageTitleHeight;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return self.segmentBarSuperView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //滑动
    if (scrollView == self.tableView) {
        //子控制器和主控制器之间的滑动状态切换
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
        if (scrollView.contentOffset.y >= tabOffsetY) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            if (self.canScroll) {
                self.canScroll = NO;
                self.journalDetailFriendVC.canScroll = YES;
                self.journalDetailPublicVC.canScroll = YES; 
            }
        } else {
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

#pragma mark - WARCPageTitleViewDelegate

- (void)WARCPageTitleView:(WARCPageTitleView *)WARCPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    [self updateSubControllersWithIndex:selectedIndex];
}

- (void)updateSubControllersWithIndex:(NSInteger)selectedIndex {
    if (selectedIndex < self.childViewControllers.count) {
        for (int i = 0; i < self.childViewControllers.count; i++) {
            UIViewController *vc = [self.childViewControllers objectAtIndex:i];
            if (i == selectedIndex) {
                [vc viewWillAppear:NO];
            }else {
                [vc viewWillDisappear:NO];
            }
        }
    }
}

#pragma mark - Notification

/** 子控制器到顶部了 主控制器可以滑动 */
- (void)onOtherScrollToTop:(NSNotification *)notification {
    self.canScroll = YES;
    self.journalDetailPublicVC.canScroll = NO;
    self.journalDetailFriendVC.canScroll = NO; 
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (WARJournalDetailTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[WARJournalDetailTableHeaderView alloc] init];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeaderView;
}

- (WARMultiPageTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WARMultiPageTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
//        [_tableView registerClass:[WARJournalThumbCell class] forCellReuseIdentifier:kWARJournalThumbCellID];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
//        __weak typeof(self) weakSelf = self;
//        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
////            [strongSelf loadComments:YES];
//        }];
//        mj_header.automaticallyChangeAlpha = YES;
//        _tableView.mj_header = mj_header;
//        
//        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
////            [strongSelf loadComments:NO];
//        }];
//        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (UIView *)segmentBarSuperView {
    if (!_segmentBarSuperView) {
        _segmentBarSuperView = [[UIView alloc]init];
        [_segmentBarSuperView addSubview:self.titleSegmentView];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kPageTitleHeight - 0.5, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = HEXCOLOR(0xDCDEE6);
        [_segmentBarSuperView addSubview:bottomLine];
    }
    return _segmentBarSuperView;
}

- (WARCPageTitleView *)titleSegmentView {
    if (!_titleSegmentView) {
        NSArray *titleArray = @[WARLocalizedString(@"好友"),WARLocalizedString(@"公众")];
        _titleSegmentView = [[WARCPageTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, kPageTitleHeight) delegate:self titleNames: titleArray badgeViewType:WARBadgeNumberViewType];
        _titleSegmentView.isNeedBounces = NO;
        _titleSegmentView.backgroundColor = kColor(whiteColor);
        _titleSegmentView.titleColorStateSelected = HEXCOLOR(0x2CBE61);
        _titleSegmentView.titleColorStateNormal = COLOR_WORD_GRAY_9;
        _titleSegmentView.indicatorColor = HEXCOLOR(0x2CBE61);
        _titleSegmentView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
        _titleSegmentView.titleLabelFont = kFont(14);
        
        //        [_titleSegmentView disPlayBadgeAtIndexPath:0 isShow:NO];
        //        [_titleSegmentView disPlayBadgeAtIndexPath:1 isShow:NO];
        //        [_titleSegmentView disPlayBadgeAtIndexPath:2 isShow:NO];
    }
    return _titleSegmentView;
}

- (WARCPageContentView *)pageContentView {
    if (!_pageContentView) {
        self.journalDetailFriendVC = [[WARJournalDetailFriendVC alloc] initWithMomentId:self.momentId friendId:self.friendId];
        self.journalDetailPublicVC = [[WARJournalDetailPublicVC alloc] initWithMomentId:self.momentId friendId:self.friendId];
        
        NSArray *childArr = @[self.journalDetailFriendVC,self.journalDetailPublicVC];
        CGFloat contentViewHeight = self.view.frame.size.height;
        
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.isScrollEnabled = NO;
        _pageContentView.delegatePageContentView = self;
    }
    
    return _pageContentView;
}


- (NSMutableArray <WARFriendCommentLayout *>*)commentLayouts{
    if (!_commentLayouts) {
        _commentLayouts = [NSMutableArray<WARFriendCommentLayout *> array];
    }
    return _commentLayouts;
}

@end

@implementation WARMultiPageTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

//#pragma mark - WARFriendBaseCellDelegate
//
//- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType value:(id)value {
//    switch (actionType) {
//        case WARFriendBaseCellActionTypeDidPageContent:
//        {
//            WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:self.moment type:@"FRIEND"];
//            [self.navigationController pushViewController:controller animated:YES];
//            break;
//        }
//        case WARFriendBaseCellActionTypeScrollHorizontalPage:{
//
//            break;
//        }
//        case WARFriendBaseCellActionTypeFinishScrollHorizontalPage:{
//
//            break;
//        }
//        case WARFriendBaseCellActionTypeDidUserHeader: {
//
//            break;
//        }
//        case WARFriendBaseCellActionTypeDidPraise: {
////            [self praiseOrCancle];
//            break;
//        }
//        case WARFriendBaseCellActionTypeDidFollowComment:{
////            _myMsgInputView.toId = self.moment.accountId;
////            _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
////            _myMsgInputView.actionType = UIMessageInputActionTypeComment;
////            [_myMsgInputView isAndResignFirstResponder];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents {
//    WARFeedImageComponent *didComponent = [imageComponents objectAtIndex:index];
//
//    NSMutableArray *tempArray = [NSMutableArray array];
//    [imageComponents enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
//        if (obj.videoId && obj.videoId.length > 0) {
//            photoBrowserModel.videoURL = obj.videoId;
//            photoBrowserModel.thumbnailUrl = [kVideoCoverUrl(obj.videoId) absoluteString];;
//        } else {
//            photoBrowserModel.picUrl = obj.imgId;
//        }
//        [tempArray addObject:photoBrowserModel];
//    }];
//
//    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
//    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
//    photoBrowser.photoArray = tempArray;
//    photoBrowser.currentIndex = index;
//    [photoBrowser show];
//}
//
//-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
//    NSMutableArray *tempArray = [NSMutableArray array];
//    [photos enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
//        photoBrowserModel.picUrl = obj;
//        [tempArray addObject:photoBrowserModel];
//    }];
//
//    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
//    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
//    photoBrowser.photoArray = tempArray;
//    photoBrowser.currentIndex = index;
//    [photoBrowser show];
//}
//
//-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didLink:(WARFeedLinkComponent *)linkContent {
//    if (linkContent) {
//        UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:nil];
//        [self.navigationController pushViewController:controllr animated:YES];
//    }
//}
//
//-(void)friendBaseCellDidUserHeader:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model {
//    WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:model.accountId friendWay:@""];
//    [self.navigationController pushViewController:controller animated:YES];
//}
//
//-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell audioPlay:(WARMomentVoice *)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView {
//    if (self.lastVoiceView == voiceView) {
//        voiceView.playBtn.selected = !voiceView.playBtn.isSelected;
//        [[WARCAVAudioPlayer sharePlayer] stopAudioPlayer];
//        if (sender.selected) {
//            [[WARCAVAudioPlayer sharePlayer] playAudioWithURLString:audio.voiceURLStr identifier:@""];
//        }else{
//            [WARCAVAudioPlayer sharePlayer].audioPlayerState = CVoiceMessageStateNormal;
//            [voiceView pauseVoicePlay];
//        }
//        return;
//    }
//    self.lastVoiceView.playBtn.selected = NO;
//    voiceView.playBtn.selected = YES;
//    if (self.lastVoiceView) {
//        [self.lastVoiceView pauseVoicePlay];
//    }
//    [[WARCAVAudioPlayer sharePlayer] stopAudioPlayer];
//    [[WARCAVAudioPlayer sharePlayer] playAudioWithURLString:audio.voiceURLStr identifier:@""];
//    self.lastVoiceView = voiceView;
//}
//
//- (void)friendBaseCellShowPop:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
//    switch (actionType) {
//        case WARFriendBaseCellActionTypeDidTopPop:
//        {
//            break;
//        }
//        case WARFriendBaseCellActionTypeDidBottomPop:
//        {
//            [self showBottomViewPopWithFrame:frame];
//            break;
//        }
//
//        default:
//            break;
//    }
//}
//
//- (void)showBottomViewPopWithFrame:(CGRect)frame {
//    NSArray *titles = @[WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的朋友圈")];
//
//    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
//    config.needArrow = YES;
//    config.textAlignment = NSTextAlignmentCenter;
//    __weak typeof(self) weakSelf = self;
//    [WARPopOverMenu showFromSenderFrame:frame withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        switch (selectedIndex) {
//            case 0:
//            {
//
//                break;
//            }
//
//            default:
//                break;
//        }
//    } dismissBlock:^{
//
//    }];
//}
//
//-(void)friendBaseCellDidDelete:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
//    [WARUserDiaryManager deleteDiaryOrFriendMoment:moment.momentId compeletion:^(bool success, NSError *err) {
//        if (success) {
//            [self.navigationController popViewControllerAnimated:YES];
//            [WARProgressHUD showAutoMessage:WARLocalizedString(@"删除成功")];
//        } else {
//            [WARProgressHUD showErrorMessage:WARLocalizedString(@"删除失败")];
//        }
//    }];
//}
//
//-(void)friendBaseCellDidEdit:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
//    UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForFeedEditingViewController:moment.momentId];
//    [self.navigationController pushViewController:controllr animated:YES];
//}
//
//-(void)friendBaseCellDidLock:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment lock:(BOOL)lock {
//
//}


