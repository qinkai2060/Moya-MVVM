//
//  WAROtherJournalListViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WAROtherJournalListViewController.h"

#import "WARLocalizedHelper.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "UIImage+WARBundleImage.h"
#import "WARNewUserDiaryTableHeaderView.h"
#import "WARDBUserManager.h"
#import "WARMediator+SendInfo.h"
#import "WARUserDiaryManager.h"
#import "MJRefresh.h"
#import "WARUIHelper.h"
#import "WARPhotoBrowser.h"
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARProgressHUD.h"
#import "WARFeedModel.h"
#import "WARJournalTableHeaderView.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARJournalSuspendingBar.h"

#import "WARJournalSinglePageCell.h"
#import "WARJournalMultiPageCell.h"

#import "WARDBUserManager.h"
#import "WARDBUserModel.h"
#import "WARDBUser.h"
#import "WARDBContactModel.h"
#import "WARDBNotification.h"

#define kWARProfileBundle @"WARProfile.bundle"
#define kWARJournalMultiPageCellId @"kWARJournalMultiPageCellId"
#define kWARJournalSinglePageCellId @"kWARJournalSinglePageCellId"

@interface WAROtherJournalListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARJournalBaseCellDelegate>


@property (nonatomic, strong) NSMutableArray<WARMoment *> *userDiaryLists;
@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *lastPublishTime;
@property (nonatomic, copy) NSString *friendId;

@property (nonatomic, strong) WARDBUserModel *userModel;
 
@property (nonatomic, strong) WARJournalTableHeaderView *tableHeaderView;
@property (nonatomic, strong) WARJournalSuspendingBar *suspendingBar;

@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@end

@implementation WAROtherJournalListViewController

#pragma mark - System

- (instancetype)initWithFriendId:(NSString *)friendId{
    if (self = [super init]) {
        self.friendId = friendId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [self addRealmObserver];
    
    self.userModel = [WARDBUserManager userModel];
    
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-kTabbarHeightAndSafeArea);
    }];
    
    [self.view addSubview:self.suspendingBar];
    [self.suspendingBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kWARJournalSuspendingBarHeight);
    }];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)dealloc {
    [self removeRealmObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadDataRefresh:(BOOL)refresh {
    
    if (refresh) {
        self.lastFindId = @"";
        self.lastPublishTime = @"";
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.friendId == nil || self.friendId.length <= 0) {
        [WARProgressHUD showAutoMessage:@"朋友不存在"];
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadJournalListWithLastFindId:self.lastFindId lastPublishTime:self.lastPublishTime friendId:self.friendId  compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!err && results > 0) {
            self.lastFindId = model.lastFindId;
            self.lastPublishTime = model.lastPublishTime;
        }
        
        if (refresh) {
            [self.userDiaryLists removeAllObjects];
            [self.userDiaryLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [self.userDiaryLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            } else {
                [self dealWithLoadResultNoMoreData:results.count == 0];
                return ;
            }
        }
        
        [self.tableView reloadData];
        [self dealWithLoadResultNoMoreData:results.count == 0];
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

- (void)showBottomViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath{
    WARPopHorizontalMenuConfiguration *config = [WARPopHorizontalMenuConfiguration defaultConfiguration];
    config.tintColor = [UIColor blackColor];
    config.needArrow = YES;
    NSArray *images = @[@"newfriend_delete",@"newfriend_edit"];
    NSArray *imageArrays = @[@"newfriend_delete",@"daily_lock",@"newfriend_edit"];//daily_public
    
    __weak typeof(self) weakSelf = self;
    [WARPopHorizontalMenu showFromSenderFrame:frame imageArray:imageArrays doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
    } dismissBlock:^{
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userDiaryLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARMoment *moment = self.userDiaryLists[indexPath.row]; 
    
    WARJournalBaseCell *cell;
    if (moment.isMultilPage) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARJournalMultiPageCellId];
        if (!cell) {
            cell = [[WARJournalMultiPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARJournalMultiPageCellId];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARJournalSinglePageCellId];
        if (!cell) {
            cell = [[WARJournalSinglePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARJournalSinglePageCellId];
        }
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.moment = moment;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARMoment *moment = self.userDiaryLists[indexPath.row];
    return moment.journalListLayout.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.000001f;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pushToDiaryDetailblock) {
                WARJournalBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                WARMoment *moment = cell.moment;
                self.pushToDiaryDetailblock(moment);
    }
}

#pragma mark  - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView){
        //与父控制器的滑动交互
        if (!self.canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY<0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
            self.canScroll = NO;
            scrollView.contentOffset = CGPointZero;
        }
     
        //月份悬浮工具条
        //显示与隐藏时机
        if ((offsetY) >= (self.tableHeaderView.bounds.size.height)) {
            if (self.suspendingBar.hidden) {
                self.suspendingBar.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    self.suspendingBar.alpha = 1.0;
                }];
            }
        } else {
            if (!self.suspendingBar.hidden) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.suspendingBar.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.suspendingBar.hidden = YES;
                }];
            }
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //    self.isTouch = YES;
}

///用于判断手指是否离开了 要做到当用户手指离开了，tableview滑道顶部，也不显示出主控制器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //    self.isTouch = NO;
}


#pragma mark - WARJournalBaseCellDelegate

#pragma mark - WARJournalBaseCellDelegate

-(void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell actionType:(WARJournalBaseCellActionType)actionType value:(id)value {
    switch (actionType) {
        case WARJournalBaseCellActionTypeDidPageContent:
        {
            WARMoment *moment = (WARMoment *)value;
            if (self.pushToDiaryDetailblock && moment) {
                self.pushToDiaryDetailblock(moment);
            }
            break;
        }
        case WARJournalBaseCellActionTypeScrollHorizontalPage:{
            BOOL scrollToLeft = [value boolValue];
            self.tableView.scrollEnabled = NO;
            break;
        }
        case WARJournalBaseCellActionTypeFinishScrollHorizontalPage:{
            self.tableView.scrollEnabled = YES;
            break;
        }
        default:
            break;
    }
}


- (void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didImageIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents {
    
//    WARMoment *moment = journalBaseCell.moment;
    WARFeedImageComponent *didComponent = [imageComponents objectAtIndex:index];
    
//    WARMomentUser *account = [[WARMomentUser alloc]init];
//    account.accountId = moment.friendModel.accountId;
//    account.headId = moment.friendModel.headId;
//    account.friendName = moment.friendModel.nickname;
//    account.nickname = moment.friendModel.nickname;
//
//    WARCommentWrapper *commentWapper = moment.commentWapper;
//
//    WARRecommendVideo *video = [[WARRecommendVideo alloc] init];
//    video.url = didComponent.videoUrl.absoluteString;
//    video.commentWapper = commentWapper;
//    video.account = account;
//    video.belongMomentId = moment.momentId;
    
//    if (didComponent.videoUrl && index == 0) {
//        if (self.pushToPlayBlock) {
//            self.pushToPlayBlock(video,!(didComponent.frameRect.size.width > didComponent.frameRect.size.height));
//        }
//    } else {
        NSMutableArray *tempArray = [NSMutableArray array];
        [imageComponents enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
            if (obj.videoId && obj.videoId.length > 0) {
                photoBrowserModel.videoURL = obj.videoId;
                photoBrowserModel.thumbnailUrl = [kVideoCoverUrl(obj.videoId) absoluteString];;
            } else {
                photoBrowserModel.picUrl = [kCMPRPhotoUrl(obj.imgId) absoluteString];
            }
            [tempArray addObject:photoBrowserModel];
        }];
        
        WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
        photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
        photoBrowser.photoArray = tempArray;
        photoBrowser.currentIndex = index;
        [photoBrowser show]; 
}

-(void)journalBaseCellShowPop:(WARJournalBaseCell *)journalBaseCell actionType:(WARJournalBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    [self showBottomViewPopWithFrame:frame indexPath:indexPath];
}

- (void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent && self.pushToWebBrowserblock) {
        self.pushToWebBrowserblock(linkContent.url);
    }
}

- (void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didGameLink:(WARFeedLinkComponent *)didGameLink {
    if (didGameLink && self.pushToWebBrowserblock) {
        self.pushToWebBrowserblock(didGameLink.url);
    }
}

-(void)journalBaseCellDidAllRank:(WARJournalBaseCell *)journalBaseCell game:(WARFeedGame *)game {
    /// 查看游戏排行
}

-(void)journalBaseCellDidPriase:(WARJournalBaseCell *)journalBaseCell indexPath:(NSIndexPath *)indexPath {
    [self praiseOrCancle:indexPath];
}

-(void)journalBaseCellDidComment:(WARJournalBaseCell *)journalBaseCell indexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Observer

- (void)addRealmObserver {
    __weak typeof(self) weakSelf = self;
    
    self.notificationToken = [[WARDBNotification allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NDLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }else{
            if (change) {
                NSInteger friendUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)];
                NSInteger groupUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypePerson)];
                
                [strongSelf.tableHeaderView.friendItem configBadge:friendUnReadCount userIconId:[NSString stringWithFormat:@"%@",[WARDBUserManager userModel].latestNoticationHeaderId]];
                [strongSelf.tableHeaderView.groupMomentItem configBadge:groupUnReadCount userIconId:nil];
            }
        }
    }];
}

- (void)removeRealmObserver {
    [_notificationToken invalidate];
}

#pragma mark - public

-(void)dl_refresh{
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dl_UserDiarviewControllerDidFinishRefreshing:)]) {
                [self.delegate dl_UserDiarviewControllerDidFinishRefreshing:self];
                self.isRefreshing = NO;
            }
        });
    }
}

#pragma mark - private

- (void)praiseOrCancle:(NSIndexPath *)indexPath {
    WARJournalBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    WARMoment *moment = cell.moment;
    
    NSString *itemId = moment.momentId;
    NSString *msgId = moment.momentId;
    NSString *thumbedAcctId = moment.accountId;
    
    NSString *thumbState = @"UP";
    if (moment.commentWapper.thumbUp) {
        thumbState = @"DOWN";
    }
    
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager praiseWithItemId:itemId msgId:msgId thumbedAcctId:thumbedAcctId thumbState:thumbState compeletion:^(bool success, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //构建点赞用户 model
        WARMomentUser *thumb = [[WARMomentUser alloc]init];
        thumb.accountId = strongSelf.userModel.accountId;
        thumb.nickname = strongSelf.userModel.nickname;
        
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }];
}

#pragma mark - getther methods


- (WARJournalSuspendingBar *)suspendingBar {
    if (!_suspendingBar) {
        _suspendingBar = [[WARJournalSuspendingBar alloc] initWithFrame:CGRectZero herderType:WARJournalTableHeaderTypeOther];
        _suspendingBar.backgroundColor = [UIColor clearColor];
        _suspendingBar.hidden = YES;
        _suspendingBar.alpha = 0.0;
        __weak typeof(self) weakSelf = self;
        _suspendingBar.didFriendBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.block) {
                strongSelf.block();
            }
        };
        _suspendingBar.didFootprintBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.pushToFootprintblock) {
                strongSelf.pushToFootprintblock();
            }
        };
        _suspendingBar.didGroupMomentBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.pushToGroupMomentblock) {
                strongSelf.pushToGroupMomentblock();
            }
        };
    }
    return _suspendingBar;
}

- (WARJournalTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[WARJournalTableHeaderView alloc]initWithFrame:CGRectZero herderType:WARJournalTableHeaderTypeOther];
        _tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth,[WARJournalTableHeaderView herderHeightWithHeaderType:WARJournalTableHeaderTypeOther]);
        __weak typeof(self) weakSelf = self;
        _tableHeaderView.didFriendBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.block) {
                strongSelf.block();
            }
        };
        _tableHeaderView.didFootprintBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.pushToFootprintblock) {
                strongSelf.pushToFootprintblock();
            }
        };
        _tableHeaderView.didGroupMomentBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.pushToGroupMomentblock) {
                strongSelf.pushToGroupMomentblock();
            }
        };
    }
    return _tableHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = kColor(whiteColor);
        _tableView.userInteractionEnabled = YES;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[WARJournalMultiPageCell class] forCellReuseIdentifier:kWARJournalMultiPageCellId];
        [_tableView registerClass:[WARJournalSinglePageCell class] forCellReuseIdentifier:kWARJournalSinglePageCellId];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [self loadDataRefresh:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;
        
        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [self loadDataRefresh:NO];
        }];
        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (NSMutableArray<WARMoment *> *)userDiaryLists {
    if (!_userDiaryLists) {
        _userDiaryLists = [[NSMutableArray <WARMoment *>alloc] init];
    }
    return _userDiaryLists;
}

@end
