//
//  WARJournalListViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalListViewController.h"

#import "WARLocalizedHelper.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARUserDiaryManager.h"
#import "MJRefresh.h"
#import "WARUIHelper.h"
#import "WARPhotoBrowser.h"
#import "WARPublishUploadManager.h"
#import "WARNetwork.h"

#import "WARJournalSinglePageCell.h"
#import "WARJournalMultiPageCell.h"
#import "WARJournalSuspendingBar.h"
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARMomentCellOperationMenu.h"
#import "WARProgressHUD.h"
#import "WARJournalTableHeaderView.h"
#import "WARJournalBottomView.h"
#import "WARMomentSendingView.h"
#import "WARMomentSendFailView.h"

#import "UIImage+WARBundleImage.h"
#import "WARMediator+SendInfo.h"

#import "WARFeedModel.h"

#import "WARDBUserManager.h"
#import "WARDBUserManager.h"
#import "WARDBUserModel.h"
#import "WARDBUser.h"
#import "WARDBContactModel.h"
#import "WARDBNotification.h"

#import "WARFriendDetailViewController.h"

#define kWARProfileBundle @"WARProfile.bundle"
#define kWARJournalMultiPageCellId @"kWARJournalMultiPageCellId"
#define kWARJournalSinglePageCellId @"kWARJournalSinglePageCellId"

@interface WARJournalListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARJournalBaseCellDelegate,WARPhotoBrowserDelegate>

@property (nonatomic, strong) WARJournalTableHeaderView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray<WARMoment *> *userDiaryLists;
@property (nonatomic, strong) NSMutableArray<WARMoment *> *publishDiaryLists;
@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *lastPublishTime;

@property (nonatomic, strong) WARDBUserModel *userModel;
/** 悬浮条 */
@property (nonatomic, strong) WARJournalSuspendingBar *suspendingBar;

@property (nonatomic, strong) RLMNotificationToken *notificationToken;
 
/** 图片浏览器正在浏览的图集 */
@property (nonatomic, strong) NSMutableArray<WARFeedImageComponent *> *currentBrowseImageComponents;
/** currentBrowseMagicImageView */
@property (nonatomic, weak) UIView *currentBrowseMagicImageView;
@end

@implementation WARJournalListViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// 添加realm 观察者
    [self addObserver];
    
    /// 当前用户模型
    self.userModel = [WARDBUserManager userModel];
    
    /// 消息未读数
    NSInteger friendUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)];
    NSInteger groupUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypePerson)];
    /// 设置消息未读数
    [self.suspendingBar configFriendBadge:friendUnReadCount];
    [self.suspendingBar configGroupMomentBadge:groupUnReadCount];
    [self.tableHeaderView.friendItem configBadge:friendUnReadCount userIconId:nil];
    [self.tableHeaderView.groupMomentItem configBadge:groupUnReadCount userIconId:nil];
    
//    /// 取出之前未发布完成数据
//    [self monitorPublish];
    
    /// 加载日志列表数据
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-kSafeAreaBottom);
    }];
    
    [self.view addSubview:self.suspendingBar];
    [self.suspendingBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kWARJournalSuspendingBarHeight);
    }];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUnreadTip];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 取出之前未发布完成数据
    [self monitorPublish];
}

- (void)monitorPublish {
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager fetchAllPublishContentWithCompeletion:^(NSArray<WARMoment *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NDLog(@"%@",results);
        strongSelf.publishDiaryLists = [NSMutableArray arrayWithArray:results];
        [strongSelf monitorPushlish:strongSelf.publishDiaryLists];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)monitorPushlish:(NSArray<WARMoment *> *)lists {
    if (lists.count <= 0) {
        return ;
    }
    
    [lists enumerateObjectsUsingBlock:^(WARMoment * _Nonnull moment, NSUInteger idx, BOOL * _Nonnull stop) { 
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        WARJournalBaseCell *journalBaseCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if(moment.isPublishIng){
            moment.showSendFailView = NO;
            moment.showSendingView = YES;
        } else {
            moment.showSendFailView = YES;
            moment.showSendingView = NO;
        }
        journalBaseCell.moment = moment;
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(journalBaseCell) weakJournalBaseCell = journalBaseCell;
        [[WARPublishUploadManager shareduploadManager] fatchPublishContentWithSerialId:moment.serialId progressBlock:^(CGFloat progress) {
            NDLog(@"progress:%.f",progress);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            __strong typeof(weakJournalBaseCell) strongJournalBaseCell = weakJournalBaseCell;
            strongJournalBaseCell.bottomView.sendFailView.hidden = YES;
            strongJournalBaseCell.bottomView.sendingView.hidden = NO;
            
            [journalBaseCell.bottomView.sendingView setProgress:progress animated:YES];
            
            moment.showSendFailView = NO;
            moment.showSendingView = YES;
            
            strongJournalBaseCell.moment = moment;
        } completeBlock:^(BOOL isFailed) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            __strong typeof(weakJournalBaseCell) strongJournalBaseCell = weakJournalBaseCell;
            
            if (!isFailed) { /// 发布成功
                strongJournalBaseCell.bottomView.sendFailView.hidden = YES;
                
                [strongSelf.publishDiaryLists removeObject:moment];
                
                [strongSelf loadDataRefresh:YES];
            } else { /// 发布失败
                strongJournalBaseCell.bottomView.sendFailView.hidden = NO ;
                
                moment.showSendFailView = YES;
                moment.showSendingView = NO;
            }
            strongJournalBaseCell.bottomView.sendingView.hidden = YES;
            
            strongJournalBaseCell.moment = moment;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}

- (void)dealloc {
    [self removeObserver];
    [kNotificationCenter removeObserver:self];
}

/**
  拉取数据，朋友圈是否有新消息
 */
- (void)getUnreadTip {
    NSInteger friendUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)];
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager getMomentUnreadWithCompeletion:^(BOOL hasUnread, NSString *headId, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err) {
            [strongSelf.tableHeaderView.friendItem configBadge:friendUnReadCount userIconId:hasUnread ? headId : nil];
        }
    }];
}
 
/**
 加载日志列表数据

 @param refresh 是否刷新
 */
- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
        self.lastFindId = @"";
        self.lastPublishTime = @"";
    }else{
        [self.tableView.mj_header endRefreshing];
         //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshEnd" object:nil];
     
    }
    
    __weak typeof(self) weakSelf = self; 
    [WARJournalFriendCycleNetManager loadJournalListWithLastFindId:self.lastFindId lastPublishTime:self.lastPublishTime friendId:nil compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NDLog(@"VC正在刷新");
        if (!err && results > 0) {
            strongSelf.lastFindId = model.lastFindId;
            strongSelf.lastPublishTime = model.lastPublishTime;
        }
        
        if (refresh) {
            [strongSelf.userDiaryLists removeAllObjects];
            [strongSelf.userDiaryLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.userDiaryLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            } else {
                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
                return ;
            }
        }
   
        [strongSelf.tableView reloadData];
        [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.publishDiaryLists.count;
    }
    return self.userDiaryLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARMoment *moment;
    if (indexPath.section == 0) {
        moment = self.publishDiaryLists[indexPath.row];
    } else {
        moment = self.userDiaryLists[indexPath.row];
    }
    
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
    WARMoment *moment;
    if (indexPath.section == 0) {
        moment = self.publishDiaryLists[indexPath.row];
    } else {
        moment = self.userDiaryLists[indexPath.row];
    }
    
    return moment.journalListLayout.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else {
        if (self.pushToDiaryDetailblock) {
            WARJournalBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            WARMoment *moment = cell.moment;
            self.pushToDiaryDetailblock(moment);
        }
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


- (void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didImageIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    self.currentBrowseImageComponents = [NSMutableArray arrayWithArray:imageComponents];
    self.currentBrowseMagicImageView = magicImageView;
    
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
        photoBrowser.delegate = self;
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
    if (self.pushToDiaryDetailblock) {
        WARJournalBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        WARMoment *moment = cell.moment;
        self.pushToDiaryDetailblock(moment);
    }
}

-(void)journalBaseCellDidDelete:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath {
    WARMoment *moment = journalBaseCell.moment;
    [[WARPublishUploadManager shareduploadManager] deleteWithSerialId:moment.serialId];
    
    /// 刷新
    [self.publishDiaryLists removeObject:moment];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)journalBaseCellDidPublish:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath {
    WARMoment *moment = journalBaseCell.moment;
    [[WARPublishUploadManager shareduploadManager] reSendWithSerialId:moment.serialId];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(journalBaseCell) weakJournalBaseCell = journalBaseCell;
    [[WARPublishUploadManager shareduploadManager] fatchPublishContentWithSerialId:moment.serialId progressBlock:^(CGFloat progress) {
        NDLog(@"progress:%.f",progress);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakJournalBaseCell) strongJournalBaseCell = weakJournalBaseCell;
        
        strongJournalBaseCell.bottomView.sendFailView.hidden = YES;
        strongJournalBaseCell.bottomView.sendingView.hidden = NO;

        [journalBaseCell.bottomView.sendingView setProgress:progress animated:YES];
    } completeBlock:^(BOOL isFailed) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakJournalBaseCell) strongJournalBaseCell = weakJournalBaseCell;
        
        if (!isFailed) { /// 发布成功
            strongJournalBaseCell.bottomView.sendFailView.hidden = YES;

            [strongSelf.publishDiaryLists removeObject:moment];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

            [strongSelf loadDataRefresh:YES];
        } else { /// 发布失败
            strongJournalBaseCell.bottomView.sendFailView.hidden = NO ;
        } 
        strongJournalBaseCell.bottomView.sendingView.hidden = YES;
    }];
}

- (void)journalBaseCellDidAllContext:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath {
    WARMoment *moment = journalBaseCell.moment;
    if(self.pushToAllContextblock){
        self.pushToAllContextblock(moment);
    }
} 

#pragma mark - WARPhotoBrowserDelegate

- (CGRect)imageBrowser:(WARPhotoBrowser *)imageBrowser disappearFrameForIndex:(NSInteger)index {
    WARFeedImageComponent *imageComponent = [self.currentBrowseImageComponents objectAtIndex:index];
    //                                             [self.currentBrowseImageComponents removeAllObjects]
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:imageComponent.listRect fromView:self.currentBrowseMagicImageView];
    return rect;
}

#pragma mark - Observer

- (void)addObserver {
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
                
                [strongSelf.suspendingBar configFriendBadge:friendUnReadCount];
                [strongSelf.suspendingBar configGroupMomentBadge:groupUnReadCount];
            }
        }
    }];
    
    [kNotificationCenter addObserver:self selector:@selector(publishContent:) name:WARPublishViewControllerDismissedNotificationKey object:nil];
}

- (void)removeObserver {
    [_notificationToken invalidate];
}

- (void)publishContent:(NSNotification *)notification {
    [self monitorPublish];
}

#pragma mark - public

//-(void)dl_refresh{
//    if (!self.isRefreshing) {
//        self.isRefreshing = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self.delegate && [self.delegate respondsToSelector:@selector(dl_UserDiarviewControllerDidFinishRefreshing:)]) {
//                [self.delegate dl_UserDiarviewControllerDidFinishRefreshing:self];
//                self.isRefreshing = NO;
//            }
//        });
//    }
//}

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
        
        //原布局
        WARJournalListLayout *originalLayout = moment.journalListLayout;
        //新生成布局
        WARJournalListLayout *layout = [WARJournalListLayout journalListLayoutWithMoment:moment]; 
        layout.feedLayoutArr = originalLayout.feedLayoutArr;
        layout.currentPageIndex = originalLayout.currentPageIndex;
        moment.journalListLayout = layout;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }];
}

#pragma mark - getther methods

- (WARJournalSuspendingBar *)suspendingBar {
    if (!_suspendingBar) {
        _suspendingBar = [[WARJournalSuspendingBar alloc] initWithFrame:CGRectZero herderType:WARJournalTableHeaderTypeMine];
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
        _tableHeaderView = [[WARJournalTableHeaderView alloc]initWithFrame:CGRectZero herderType:WARJournalTableHeaderTypeMine];
        _tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth,[WARJournalTableHeaderView herderHeightWithHeaderType:WARJournalTableHeaderTypeMine]);
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
            [strongSelf loadDataRefresh:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;
        
        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDataRefresh:NO];
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


- (NSMutableArray<WARMoment *> *)publishDiaryLists {
    if (!_publishDiaryLists) {
        _publishDiaryLists = [[NSMutableArray <WARMoment *>alloc] init];
    }
    return _publishDiaryLists;
}



@end
