//
//  WARFriendViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WAROtherTrackListVC.h"

#import "UIImage+WARBundleImage.h"
#import "NSString+UUID.h"
#import "WARMediator+WebBrowser.h"
#import "WARMediator+Contacts.h"
#import "WARMediator+Publish.h"

#import "WARDBUserManager.h"
#import "HKFloatManager.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARUserDiaryManager.h"

#import "WARLocalizedHelper.h"
#import "WARBaseMacros.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "WARUIHelper.h"
#import "YYWeakProxy.h"
#import "MJExtension.h"

#import "WARFriendMomentLayout.h"
#import "WARMoment.h"
#import "WARFeedModel.h"
#import "WARCMessageModel.h"
#import "WARMomentUser.h"
#import "WARFriendComment.h"
#import "WARFriendCommentLayout.h"

#import "WARPhotoBrowser.h"
#import "WARProgressHUD.h"
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARCAVAudioPlayer.h"
#import "WARPlayerFlashView.h"
#import "WARRewordAnimationTool.h"
#import "WARFriendBottomView.h"
#import "WARRewordView.h"
#import "WARFriendPageCell.h"
#import "WARNewMessageTipCell.h"
#import "WARFriendSinglePageCell.h"
#import "WARNewMessageTipView.h"

#import "WARFollowDetailViewController.h"
#import "WARFriendDetailViewController.h"
#import "WARMessageListViewController.h"
#import "WARPlayViewController.h"
#import "WARProfileOtherViewController.h"
#import "WARUserCenterViewController.h"
#import "WARDouYinPlayVideoVC.h"
#import "WARLightPlayVideoVC.h"

#define kWARFriendPageCellId @"kWARFriendPageCellId"
#define kWARFriendSinglePageCellId @"kWARFriendSinglePageCellId"
#define kWARNewMessageTipCellId @"kWARNewMessageTipCellId"

@interface WAROtherTrackListVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARFriendBaseCellDelegate>

/** moment展现在什么模块 */
@property (nonatomic, assign) WARMomentShowType momentShowType;
/** pushController */
@property (nonatomic, weak) UIViewController *pushController; 
/** 动态数据数组 */
@property (nonatomic, copy) NSMutableArray <WARMoment *>*momentLists;
/** 最后一条动态id */
@property (nonatomic, copy) NSString *lastFindId;
/** 定时器 */
@property (nonatomic, strong) NSTimer *seeAdTimer;
/** 需要滚动到顶部 */
@property (nonatomic, assign) BOOL needScrollToTop;

/** 加载参数 */
/** 用户id */
@property (nonatomic, copy) NSString *accountId;
/** 纬度 */
@property (nonatomic, copy) NSString *lat;
/** 经度 */
@property (nonatomic, copy) NSString *lon;
/** 排序 */
@property (nonatomic, copy) NSString *searchSort;
/** momentId */
@property (nonatomic, copy) NSString *momentId;

@end

@implementation WAROtherTrackListVC

#pragma mark - System

- (instancetype)initWithAccountId:(NSString *)accountId
                              lat:(NSString *)lat
                              lon:(NSString *)lon
                         momentId:(NSString *)momentId
                       searchSort:(NSString *)searchSort
                   pushController:(UIViewController *)pushController {
    if (self = [super init]) {
        self.momentShowType = WARMomentShowTypeMapProfile;
        self.accountId = accountId;
        self.lat = lat;
        self.lon = lon;
        self.momentId = momentId;
        self.searchSort = searchSort;
        self.pushController = pushController;
    }
    return self;
}
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}
  
- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
        self.lastFindId = @"";
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadTrackMomentListWithAccountId:self.accountId lastFindId:self.lastFindId compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err && results.count > 0) {
            strongSelf.lastFindId = model.lastFindId;
        }
        if (refresh) {
            [strongSelf.momentLists removeAllObjects];
            [strongSelf.momentLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.momentLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            }
        }
        [strongSelf.tableView reloadData];
        [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
//    if (noMoreData) {
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }
    if (self.dealWithLoadResultNoMoreDataBlock) {
        self.dealWithLoadResultNoMoreDataBlock(noMoreData);
    }
}

- (void)dealloc {
    [_seeAdTimer invalidate];
}

#pragma mark - Event Response

- (void)showTopViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath {
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    config.tintColor = HEXCOLOR(0x4B5054);
    
    NSArray *titles = @[WARLocalizedString(@"收藏"),WARLocalizedString(@"举报"),WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的消息")];
    WARMoment *moment = self.momentLists[indexPath.row];
    if (moment.isMine) {
        titles = @[WARLocalizedString(@"分享"),WARLocalizedString(@"收藏"),];
    } else {
        titles = @[WARLocalizedString(@"分享"),WARLocalizedString(@"收藏"),WARLocalizedString(@"举报"),WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的消息")];
    }
    
//    __weak typeof(self) weakSelf = self;
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
            case 2:
            {
                
                break;
            }
                
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
}

- (void)showBottomViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath{
    WARPopHorizontalMenuConfiguration *config = [WARPopHorizontalMenuConfiguration defaultConfiguration];
    config.tintColor = HEXCOLOR(0x4B5054);
    config.textColor = [UIColor whiteColor]; 
    config.needArrow = NO;

    NSArray *images = @[@"great_nor",@"wechat_message_nor"];
    NSArray *titles = @[@"赞",@"评论"];
    __weak typeof(self) weakSelf = self;
    [WARPopHorizontalMenu showFromSenderFrame:frame imageArray:images titleArray:titles doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (selectedIndex == 0) {//点赞
            [strongSelf praiseOrCancle:indexPath];
        } else { //评论
            if (indexPath.row < strongSelf.momentLists.count) {
//                strongSelf.didMoment = strongSelf.momentLists[indexPath.row];
//                strongSelf.repliedMessage = nil;
//
//                strongSelf.myMsgInputView.toId = strongSelf.didMoment.accountId;
//                [strongSelf.myMsgInputView prepareToShow];
//                [strongSelf.myMsgInputView notAndBecomeFirstResponder];
                
                strongSelf.view.backgroundColor = HEXCOLOR(0xf4f4f4);
            }
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.momentLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARMoment *moment = self.momentLists[indexPath.row];
    moment.momentShowType = self.momentShowType;
    
    WARFriendBaseCell *cell;
    if (moment.isMultilPage) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendPageCellId];
        if (!cell) {
            cell = [[WARFriendPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendPageCellId];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendSinglePageCellId];
        if (!cell) {
            cell = [[WARFriendSinglePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendSinglePageCellId];
        }
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.moment = moment;
    
    [cell showBottomSeparatorView:(self.momentLists.count - 1) != indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARMoment *moment = self.momentLists[indexPath.row];
    WARFriendMomentLayout *layout = moment.friendMomentLayout;
    return layout.cellHeight; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.momentLists.count) {
        WARMoment *moment = self.momentLists[indexPath.row];
        if (self.pushController) {
            WARFollowDetailViewController *controller = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:moment.momentId];
            [controller configMoment:moment];
            [self.pushController.navigationController pushViewController:controller animated:YES];
        } else {
            if (self.pushFriendDetailBlock) {
                self.pushFriendDetailBlock(moment);
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark  - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _endSeeAdTimer];
    
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
    [self tableView:self.tableView scrollViewDidScroll:scrollView]; 
}

/** 松手时已经静止, 只会调用scrollViewDidEndDragging */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self _startSeeAdTimer];
    
    if (self.scrollViewDidEndDraggingBlock) {
        self.scrollViewDidEndDraggingBlock(scrollView, decelerate);
    }
    [self tableView:self.tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

/** 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self _endSeeAdTimer];
    [self _startSeeAdTimer];
    
    if (self.scrollViewDidEndDeceleratingBlock) {
        self.scrollViewDidEndDeceleratingBlock(scrollView);
    }
    [self tableView:self.tableView scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self tableView:self.tableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self tableView:self.tableView scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

/** 子类重写 */
- (void)tableView:(UITableView *)tableView scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}
- (void)tableView:(UITableView *)tableView scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
}
- (void)tableView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView {
}
- (void)tableView:(UITableView *)tableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}
- (void)tableView:(UITableView *)tableView scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - WARFriendBaseCellDelegate

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents {
    WARMoment *moment = friendBaseCell.moment;
    WARFeedImageComponent *didComponent = [imageComponents objectAtIndex:index];
    
    WARMomentUser *account = [[WARMomentUser alloc]init];
    account.accountId = moment.friendModel.accountId;
    account.headId = moment.friendModel.headId;
    account.friendName = moment.friendModel.nickname;
    account.nickname = moment.friendModel.nickname;
    
    WARCommentWrapper *commentWapper = moment.commentWapper;
    
    WARRecommendVideo *video = [[WARRecommendVideo alloc] init];
    video.url = didComponent.videoUrl.absoluteString;
    video.commentWapper = commentWapper;
    video.account = account;
    video.belongMomentId = moment.momentId;
    
    if (self.pushController) {
        if (didComponent.frameRect.size.width < didComponent.frameRect.size.height) {
            WARDouYinPlayVideoVC *controller = [[WARDouYinPlayVideoVC alloc] initWithFirstVideo:video];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            WARLightPlayVideoVC *controller = [[WARLightPlayVideoVC alloc] initWithFirstVideo:video];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        if (self.pushToPlayBlock) {
            self.pushToPlayBlock(video,!(didComponent.frameRect.size.width > didComponent.frameRect.size.height));
        }
    }
} 

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
    NSMutableArray *tempArray = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSURL class]]) {
            urlString = ((NSURL *)obj).absoluteString;
        } else {
            urlString = obj;
        }
        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
        photoBrowserModel.picUrl = [kCMPRPhotoUrl(urlString) absoluteString];
        [tempArray addObject:photoBrowserModel];
    }];
    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
    photoBrowser.photoArray = tempArray;
    photoBrowser.currentIndex = index;
    [photoBrowser show];
}

-(void)friendBaseCellDidNoInterest:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath {
    WARFriendBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager putNoInterestFriendMoment:cell.moment.momentId compeletion:^(bool success, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            [strongSelf.momentLists removeObjectAtIndex:indexPath.row];
            [strongSelf.tableView reloadData];
            
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置成功")];
        } else {
            [WARProgressHUD showErrorMessage:WARLocalizedString(@"设置失败")];
        }
    }];
}

-(void)friendBaseCellShowPop:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidTopPop:
        {
            [self showTopViewPopWithFrame:frame indexPath:indexPath];
            break;
        }
        case WARFriendBaseCellActionTypeDidBottomPop:
        {
            [self showBottomViewPopWithFrame:frame indexPath:indexPath];
            break;
        }
            
        default:
            break;
    }
}

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType value:(id)value {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidPageContent:
        {
            WARMoment *moment = (WARMoment *)value;
            if (self.pushController && moment) {
                WARFollowDetailViewController *controller = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:moment.momentId];
                [controller configMoment:moment];
                [self.pushController.navigationController pushViewController:controller animated:YES];
            } else  if (self.pushFriendDetailBlock && moment) {
                self.pushFriendDetailBlock(moment);
            }
            break;
        }
        case WARFriendBaseCellActionTypeScrollHorizontalPage:{
            BOOL scrollToLeft = [value boolValue];
            NDLog(@"scroll to %@",scrollToLeft ? @"left" : @"right");
            
            self.tableView.scrollEnabled = NO;
            break;
        }
        case WARFriendBaseCellActionTypeFinishScrollHorizontalPage:{
            self.tableView.scrollEnabled = YES;
            break;
        }
        case WARFriendBaseCellActionTypeDidUserHeader: {
            
            break;
        }
        case WARFriendBaseCellActionTypeDidPraise: {
            NSIndexPath *indexPath = (NSIndexPath *)value;
            [self praiseOrCancle:indexPath];
            break;
        }
        case WARFriendBaseCellActionTypeDidFollowComment:{
            NSIndexPath *indexPath = (NSIndexPath *)value;
            if (indexPath.row >= self.momentLists.count) {
                return ;
            }
            WARMoment *moment = self.momentLists[indexPath.row];
            if (self.pushController && moment) {
                WARFollowDetailViewController *controller = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:moment.momentId scrollToComment:YES];
                [controller configMoment:moment]; 
                [self.pushController.navigationController pushViewController:controller animated:YES];
            } else  if (self.pushCommentBlock && moment) {
                self.pushCommentBlock(moment);
            }
            break;
        }
        default:
            break;
    }
}

-(void)friendBaseCellDidUserHeader:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model{
    WARMoment *moment = friendBaseCell.moment;
    if (self.pushController) {
        if (moment.isMine) {
            WARUserCenterViewController *controller = [[WARUserCenterViewController alloc] init];
            controller.isOtherfromWindow = YES;
            [self.pushController.navigationController pushViewController:controller animated:YES];
        } else {
            if (moment.friendModel.thirdType && moment.friendModel.homeUrl) {
                UIViewController *controller = [[WARMediator sharedInstance]Mediator_ThirdHomeViewControllerWithTitle:moment.friendModel.nickname urlString:moment.friendModel.homeUrl guyId:moment.friendModel.accountId isFollow:moment.friendModel.followed];//
                [self.pushController.navigationController pushViewController:controller animated:YES];
            } else {
                WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:model.accountId friendWay:@""];
                [self.pushController.navigationController pushViewController:controller animated:YES];
            }
        }
    } else {
        if (self.pushToUserProfileBlock) {
            self.pushToUserProfileBlock(model.accountId, @"",moment.isMine);
        }
    }
}

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent && self.pushController) {
        UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:nil];
        [self.pushController.navigationController pushViewController:controllr animated:YES];
    } else {
        if (linkContent && self.pushToWebBrowserblock) {
            self.pushToWebBrowserblock(linkContent.url);
        }
    }
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didUser:(NSString *)accountId {
    WARMoment *moment = friendBaseCell.moment;
    if (self.pushController) {
        if (moment.isMine) {
            WARUserCenterViewController *controller = [[WARUserCenterViewController alloc] init];
            controller.isOtherfromWindow = YES;
            [self.pushController.navigationController pushViewController:controller animated:YES];
        } else {
            if (moment.friendModel.thirdType && moment.friendModel.homeUrl) {
                UIViewController *controller = [[WARMediator sharedInstance]Mediator_ThirdHomeViewControllerWithTitle:moment.friendModel.nickname urlString:moment.friendModel.homeUrl guyId:moment.friendModel.accountId isFollow:moment.friendModel.followed];//
                [self.pushController.navigationController pushViewController:controller animated:YES];
            } else {
                WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:accountId friendWay:@""];
                [self.pushController.navigationController pushViewController:controller animated:YES];
            }
        }
    } else {
        if (self.pushToUserProfileBlock) {
            self.pushToUserProfileBlock(accountId, @"",moment.isMine);
        }
    }
}

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell playVideoWithUrl:(NSString *)videoUrl {
    NSMutableArray *tempArray = [NSMutableArray array];
    NSString *urlString;
    if ([videoUrl isKindOfClass:[NSURL class]]) {
        urlString = ((NSURL *)videoUrl).absoluteString;
    } else {
        urlString = videoUrl;
    }
    WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
    photoBrowserModel.videoURL = urlString;
    photoBrowserModel.thumbnailUrl =  [kVideoCoverUrl(urlString) absoluteString];;
    [tempArray addObject:photoBrowserModel];
    
    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
    photoBrowser.photoArray = tempArray;
    photoBrowser.currentIndex = 0;
    [photoBrowser show];
}

-(void)friendBaseCellDidDelete:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager deleteDiaryOrFriendMoment:moment.momentId compeletion:^(bool success, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            if (success) {
                NSInteger momentIndex = [strongSelf.momentLists indexOfObject:moment];
                [strongSelf.momentLists removeObjectAtIndex:momentIndex];
                [strongSelf.tableView reloadData];
                
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"删除成功")];
            } else {
                [WARProgressHUD showErrorMessage:WARLocalizedString(@"删除失败")];
            }
        } else {
            [WARProgressHUD showErrorMessage:WARLocalizedString(@"删除失败")];
        }
    }];
}

-(void)friendBaseCellDidEdit:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
    UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForFeedEditingViewController:moment.momentId];
    [self.navigationController pushViewController:controllr animated:YES];
}

-(void)friendBaseCellDidLock:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment lock:(BOOL)lock {
    
}


#pragma mark - Private

/// 开启定时器
- (void)_startSeeAdTimer {
    [_seeAdTimer invalidate];
    _seeAdTimer = [NSTimer timerWithTimeInterval:1.5f
                                              target:[YYWeakProxy proxyWithTarget:self]
                                            selector:@selector(_trackDidSeeAd)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_seeAdTimer forMode:NSRunLoopCommonModes];
}

/// 移除定时器
- (void)_endSeeAdTimer {
    if (_seeAdTimer) {
        [_seeAdTimer invalidate];
        _seeAdTimer = nil;
    }
}

/// 响应定时器
- (void)_trackDidSeeAd {
    [self _endSeeAdTimer];
    
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        WARMoment *moment = self.momentLists[indexPath.row];
        WARMomentReword *reword = moment.reword;
        
        if (reword && !moment.alreadyGetReword) {
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager shuaRewordWithMomentId:moment.momentId rewordId:reword.rewordId compeletion:^(NSDictionary *resultDictionry, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                moment.alreadyGetReword = YES;
//                NSLog(@"\n经验值：%@ \n耐力值：%@ \n金币：%@ \n卡：%@ \n",exp,hp,jinBi,kaPian);
                WARFriendBaseCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
                
                UIWindow* window = [UIApplication sharedApplication].keyWindow;
                CGRect bottomViewRect = [cell.bottomView.rewordView convertRect:cell.bottomView.rewordView.frame fromView:cell.bottomView];
                CGRect fromRect = [cell.bottomView.rewordView convertRect:bottomViewRect toView:window];
                CGPoint finishePoint = CGPointMake(fromRect.origin.x + fromRect.size.width * 0.5, fromRect.origin.y - 80);
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:resultDictionry];
                [[WARRewordAnimationTool shareTool] startAnimationandView:[cell.bottomView.rewordView currentImageInView]
                                                                     rect:fromRect
                                                              finisnPoint:finishePoint
                                                              finishBlock:^(BOOL finish) {
                                                                  
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"kStartRewordAnimationandView" object:params];
                                                                  
                                                                  cell.bottomView.rewordView.hidden = YES;
                                                                  moment.reword = nil;
                                                              }];
            }];
        }
    }
}

- (void)praiseOrCancle:(NSIndexPath *)indexPath {
    if (indexPath.row < self.momentLists.count) {
        WARMoment *moment = self.momentLists[indexPath.row];
        NSString *itemId = moment.momentId;
        NSString *msgId = moment.momentId;
        NSString *thumbedAcctId = moment.friendModel.accountId;
        NSString *thumbState = @"UP";
        if (moment.commentWapper.thumbUp) {
            thumbState = @"DOWN";
        }
        
        NSString *moudle = @"PMOMENT";
        __weak typeof(self) weakSelf = self;
        [WARUserDiaryManager praiseWithMoudle:moudle itemId:itemId msgId:msgId thumbedAcctId:thumbedAcctId thumbState:thumbState compeletion:^(bool success, NSError *err) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //构建点赞用户 model
            WARMomentUser *thumb = [[WARMomentUser alloc]init];
            thumb.accountId = strongSelf.accountId;
            if (!moment.commentWapper) {
                WARCommentWrapper *commentWapper = [[WARCommentWrapper alloc] init];
                moment.commentWapper = commentWapper;
            }
            if (!moment.commentWapper.comment) {
                WARFriendCommentModel *comment = [[WARFriendCommentModel alloc] init];
                NSMutableArray *comments = [NSMutableArray array];
                comment.comments = comments;
                moment.commentWapper.comment = comment;
            }
            if (!moment.commentWapper.thumb) {
                WARThumbModel *thumb = [[WARThumbModel alloc] init];
                NSMutableArray *thumbUserBos = [NSMutableArray array];
                thumb.thumbUserBos = thumbUserBos;
                moment.commentWapper.thumb = thumb;
            }
            NSMutableArray *thumbUserBos = [NSMutableArray arrayWithArray:moment.commentWapper.thumb.thumbUserBos];
            moment.commentWapper.thumbUp = !moment.commentWapper.thumbUp;
            if (moment.commentWapper.thumbUp) { //已点赞
                moment.commentWapper.praiseCount += 1;
                [thumbUserBos addObject:thumb];
            } else { // 取消点赞
                moment.commentWapper.praiseCount -= 1;
                [thumbUserBos enumerateObjectsUsingBlock:^(WARMomentUser *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.accountId isEqualToString:thumb.accountId]) {
                        [thumbUserBos removeObject:obj];
                    }
                }];
            }
            moment.commentWapper.thumb.thumbUserBos = [thumbUserBos copy];
            //原布局
            WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
            //新生成布局
            WARFriendMomentLayout *layout = [WARFriendMomentLayout mapProfileMomentListLayoutWithMoment:moment];
            layout.feedLayoutArr = originalLayout.feedLayoutArr;
            layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
            layout.currentPageIndex = originalLayout.currentPageIndex;
            moment.friendMomentLayout = layout;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [strongSelf.tableView reloadData];
            });
        }];
    }
}

#pragma mark - Setter And Getter

- (NSMutableArray<WARMoment *> *)momentLists {
    if (!_momentLists) {
        _momentLists = [NSMutableArray <WARMoment *>array];
    }
    return _momentLists;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[WARNewMessageTipCell class] forCellReuseIdentifier:kWARNewMessageTipCellId];
        [_tableView registerClass:[WARFriendPageCell class] forCellReuseIdentifier:kWARFriendPageCellId];
        [_tableView registerClass:[WARFriendSinglePageCell class] forCellReuseIdentifier:kWARFriendSinglePageCellId];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

@end
