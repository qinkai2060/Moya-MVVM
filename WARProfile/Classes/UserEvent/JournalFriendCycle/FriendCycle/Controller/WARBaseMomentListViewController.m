//
//  WARFriendViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARBaseMomentListViewController.h"

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
#import "WARMomentTools.h"

#import "WARFriendMomentLayout.h"
#import "WARMoment.h"
#import "WARFeedModel.h"
#import "WARCMessageModel.h"
#import "WARMomentUser.h"
#import "WARFriendComment.h"
#import "WARFriendCommentLayout.h"
#import "WARFeedGame.h"

#import "WARDBNotification.h"
#import "WARDBUserModel.h"
#import "WARDBContactModel.h"
#import "WARDBUser.h"

#import "WARPhotoBrowser.h"
#import "WARProgressHUD.h"
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARCAVAudioPlayer.h"
#import "WARPlayerFlashView.h"
#import "WARFriendCommentVoiceView.h"
#import "UIMessageInputView.h"
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
#import "WARGameWebViewController.h"
#import "WARGameRankContainerViewController.h"

#define kWARFriendPageCellId @"kWARFriendPageCellId"
#define kWARFriendSinglePageCellId @"kWARFriendSinglePageCellId"
#define kWARNewMessageTipCellId @"kWARNewMessageTipCellId"

@interface WARBaseMomentListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARFriendBaseCellDelegate,UIMessageInputViewDelegate,WARPhotoBrowserDelegate>

/** 面具Id */
@property (nonatomic, copy) NSString *maskId;
/** 朋友圈或关注 */
@property (nonatomic, copy) NSString *followOrFriendType;
/** 来源（MESSAGE：消息模块的推荐；CHAT: 群内的推荐；默认（好友圈、关注）不传） */
@property (nonatomic, copy) NSString *from;
/** moment展现在什么模块 */
@property (nonatomic, assign) WARMomentShowType momentShowType;
/** pushController */
@property (nonatomic, weak) UIViewController *pushController;

/** 动态数据数组 */
@property (nonatomic, copy) NSMutableArray <WARMoment *>*momentLists;
/** 最后一条动态id */
@property (nonatomic, copy) NSString *lastFindId;

/** showMessageTipCell */
@property (nonatomic, assign) BOOL showMessageTipCell;
/** 消息通知变化通知 */
@property (nonatomic, strong) RLMNotificationToken *sumOfUnreadNotification;
/** 用户模型 */
@property (nonatomic, strong) WARDBUserModel *userModel;

/** 评论键盘 */
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
/** repliedMessage */
@property (nonatomic, strong) WARFriendComment *repliedMessage;
/** 点中的动态 */
@property (nonatomic, strong) WARMoment *didMoment;
/** 当前选中的indexPath */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 将要发送评论的参数 */
@property (nonatomic, strong) NSMutableDictionary *willSendMsgParams;

/** 最后的播放音频view */
@property (nonatomic, strong) WARFriendCommentVoiceView *lastVoiceView;

/** 定时器 */
@property (nonatomic, strong) NSTimer *seeAdTimer;
/** 面具数组（关注、体育、娱乐。。。） */
@property (nonatomic, strong) NSArray <NSString *>*maskIdLists;
/** 选中的面具数组 */
@property (nonatomic, strong) NSArray <NSString *>*selectedMaskIdLists;
/** 需要滚动到顶部 */
@property (nonatomic, assign) BOOL needScrollToTop;

/** 图片浏览器正在浏览的图集 */
@property (nonatomic, strong) NSMutableArray<WARFeedImageComponent *> *currentBrowseImageComponents;
/** currentBrowseMagicImageView */
@property (nonatomic, weak) UIView *currentBrowseMagicImageView;
@end

@implementation WARBaseMomentListViewController

#pragma mark - System

- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId {
    if (self = [super init]) {
        self.maskId = maskId;
        self.followOrFriendType = type;
        if ([type isEqualToString:@"FRIEND"]) {
            self.momentShowType = WARMomentShowTypeFriend;
        } else if ([type isEqualToString:@"FOLLOW"]) {
            self.momentShowType = WARMomentShowTypeFriendFollow;
        } 
    }
    return self;
}
 
- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId
                        from:(NSString *)from
              pushController:(UIViewController *)pushController {
    if (self = [super init]) {
        self.maskId = maskId;
        self.from = from;
        self.followOrFriendType = type;
        self.pushController = pushController; 
        if ([type isEqualToString:@"FRIEND"]) {
            self.momentShowType = WARMomentShowTypeFriend;
        } else if ([type isEqualToString:@"FOLLOW"]) {
            self.momentShowType = WARMomentShowTypeFriendFollow;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES]; 
    /// 及时刷新消息提醒
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    [self disMissInputView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRealmObserver];
    [self loadDataRefresh:YES];
    self.userModel = [WARDBUserManager userModel];
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

- (void)loadDataWithMaskId:(NSString *)maskId {
//    self.maskId = maskId;
    self.maskId = @"";
    self.from = @"";
    self.followOrFriendType = @"";
    if ([maskId isEqualToString:@"FOLLOW"]) {
        self.followOrFriendType = maskId;
        self.momentShowType = WARMomentShowTypeFriendFollow;
    } else if ([maskId isEqualToString:@"MESSAGE"]) {
        self.from = maskId;
    } else {
        
    } 
    self.needScrollToTop = YES;
    
    [self loadDataRefresh:YES];
}

- (void)loadDataWithMaskIdLists:(NSArray *)maskIdLists {
    self.selectedMaskIdLists = [NSArray arrayWithArray:maskIdLists];
    [self loadDataRefresh:YES];
}

- (void)loadDataRefresh:(BOOL)refresh {
    NSInteger unreadMomentCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)];;
    self.showMessageTipCell = (unreadMomentCount > 0);
    
    if (refresh) {
        self.lastFindId = @"";
        [self.tableView.mj_footer endRefreshing];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        if (self.from && self.from.length > 0) {
            // 1.分类
            dispatch_group_enter(group);
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager getFlowCategoryCompletion:^(NSArray<NSString *> *results, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.maskIdLists = [NSArray arrayWithArray:results];
                if (strongSelf.maskIdListsBlock) {
                    strongSelf.maskIdListsBlock(results);
                }
                
                dispatch_group_leave(group);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
                dispatch_semaphore_signal(semaphore); // + 1
            }];
        }
        
        // 2.朋友圈列表
        if (self.followOrFriendType && self.followOrFriendType.length > 0) {
            dispatch_group_enter(group);
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager loadFriendListFromType:self.from friendOrFollow:self.followOrFriendType categoryId:nil groupId:nil maskIds:self.selectedMaskIdLists lastFindId:self.lastFindId compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!err && results.count > 0) {
                    strongSelf.lastFindId = model.lastFindId;
                }
                
                [strongSelf.momentLists removeAllObjects];
                [strongSelf.momentLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
                
                dispatch_group_leave(group);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_signal(semaphore);
            }];
        } else {
            dispatch_group_enter(group);
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager loadFriendListFromType:self.from lastFindId:self.lastFindId maskId:self.maskId type:self.followOrFriendType compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!err && results.count > 0) {
                    strongSelf.lastFindId = model.lastFindId;
                }
                
                [strongSelf.momentLists removeAllObjects];
                [strongSelf.momentLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
                
                dispatch_group_leave(group);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_signal(semaphore);
            }];
        }
        
        //刷新
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (self.needScrollToTop) {
                [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
            }
            
            [self.tableView reloadData];
            [self dealWithLoadResultNoMoreData:self.momentLists.count == 0];
        });
    }else{
        [self.tableView.mj_header endRefreshing];
        
        if (self.followOrFriendType && self.followOrFriendType.length > 0) {
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager loadFriendListFromType:self.from friendOrFollow:self.followOrFriendType categoryId:nil groupId:nil maskIds:self.selectedMaskIdLists lastFindId:self.lastFindId compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!err && results.count > 0) {
                    strongSelf.lastFindId = model.lastFindId;
                }
                
                if (results.count > 0) {
                    [strongSelf.momentLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
                } else {
                    [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
                    return ;
                }
                
                [strongSelf.tableView reloadData];
                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
            }];
        } else {
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager loadFriendListFromType:self.from lastFindId:self.lastFindId maskId:self.maskId type:self.followOrFriendType compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!err && results.count > 0) {
                    strongSelf.lastFindId = model.lastFindId;
                }
                
                if (results.count > 0) {
                    [strongSelf.momentLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
                } else {
                    [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
                    return ;
                }
                
                [strongSelf.tableView reloadData];
                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
            }];
        }
    }
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
    [self removeRealmObserver];
    [_seeAdTimer invalidate];
}

#pragma mark - Event Response

- (void)showTopViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    
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
    self.currentIndexPath = indexPath;
    
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
                strongSelf.didMoment = strongSelf.momentLists[indexPath.row];
                strongSelf.repliedMessage = nil;
                
                strongSelf.myMsgInputView.toId = strongSelf.didMoment.accountId;
                [strongSelf.myMsgInputView prepareToShow];
                [strongSelf.myMsgInputView notAndBecomeFirstResponder];
                 
                strongSelf.view.backgroundColor = HEXCOLOR(0xf4f4f4);
            }
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.showMessageTipCell ? 1 : 0;
    }
    return self.momentLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WARNewMessageTipCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARNewMessageTipCellId];
        [cell configData:@{@"messageCount":@([WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)]),
                           @"imageUrl":[NSString stringWithFormat:@"%@",[WARDBUserManager userModel].latestNoticationHeaderId]}];
        return cell;
    }
    
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
    if (indexPath.section == 0) {
        return self.showMessageTipCell ? 49 : 0;
    }
    WARMoment *moment = self.momentLists[indexPath.row];
    WARFriendMomentLayout *layout = moment.friendMomentLayout;
    return layout.cellHeight; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    
    if (indexPath.section != 0) {
        if ([self.followOrFriendType isEqualToString:@"FOLLOW"]) {
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
    } else {
        self.showMessageTipCell = NO;
        
        if (self.pushController) {
            WARMessageListViewController *controller = [[WARMessageListViewController alloc]initWithNotificationType:(WARNotificationTypeFriend)];
            [self.pushController.navigationController pushViewController:controller animated:YES];
        } else {
            if (self.pushToFriendMessageblock) {
                self.pushToFriendMessageblock();
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

static CGFloat threshold = 0.7;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _endSeeAdTimer];
    
    /// 智能预加载
//    CGFloat current = scrollView.contentOffset.y + scrollView.frame.size.height;
//    CGFloat total = scrollView.contentSize.height;
//    CGFloat ratio = current / total;
//    if (ratio >= threshold) {
//        [self loadDataRefresh:NO];
//    }
    
    if (self.from && self.from.length > 0) {
        return ;
    }
//    if ((scrollView.contentOffset.y - self.contentOffsetY) < 0 && self.canScroll) {
//        //向下滑
//        CGFloat offset = self.contentOffsetBottomY - scrollView.contentOffset.y;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleScrollDownNtf" object:[NSNumber numberWithFloat:offset]];
//    }
//    else {
//        self.contentOffsetBottomY = scrollView.contentOffset.y;
//    }
//    if ((scrollView.contentOffset.y - self.contentOffsetY) > 0 && self.canScroll) {
//        //向上滑
//        CGFloat offset = scrollView.contentOffset.y - self.contentOffsetUpY;
//        if (scrollView.contentOffset.y  > 200) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleScrollUpNtf" object:[NSNumber numberWithFloat:offset]];
//        }
//    }else {
//        self.contentOffsetUpY = scrollView.contentOffset.y;
//    }
//    self.contentOffsetY = scrollView.contentOffset.y;
    
    //与父控制器的滑动交互
//    if (!self.canScroll) {
//        [scrollView setContentOffset:CGPointZero];
//    }
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY<0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleLeaveTopNtf" object:@1];
//        self.canScroll = NO;
//        scrollView.contentOffset = CGPointZero;
//    }
    [self disMissInputView];
    
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

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    self.currentBrowseImageComponents = [NSMutableArray arrayWithArray:imageComponents];
    self.currentBrowseMagicImageView = magicImageView;
    
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
    
    if (didComponent.videoUrl && index == 0 && ([self.followOrFriendType isEqualToString:@"FOLLOW"]||self.maskId.length > 0)) {
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
        
    } else {
        NSMutableArray *tempArray = [NSMutableArray array];
        [imageComponents enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
            if (obj.videoId && obj.videoId.length > 0) {
                photoBrowserModel.videoURL = obj.videoId;
                photoBrowserModel.thumbnailUrl =  [kVideoCoverUrl(obj.videoId) absoluteString];;
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
        case WARFriendBaseCellActionTypeDidTopPopAd:
        {
            break;
        }
        default:
            break;
    }
}

-(void)friendBaseCellDidAllContext:(WARFriendBaseCell *)friendBaseCell  indexPath:(NSIndexPath *)indexPath {
    NDLog(@"查看全文");
    WARMoment *moment = friendBaseCell.moment;
    WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:moment type:@"FOLLOW"];
    [self.pushController.navigationController pushViewController:controller animated:YES];
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

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didGameLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent && self.pushController) {
        WARGameWebViewController *controller = [[WARGameWebViewController alloc]initWithUrlString:linkContent.url];
        [self.pushController.navigationController pushViewController:controller animated:YES];
    } else {
        if (linkContent && self.pushToGameWebBrowserblock) {
            self.pushToGameWebBrowserblock(linkContent.url);
        }
    }
}

-(void)friendBaseCellDidAllRank:(WARFriendBaseCell *)friendBaseCell game:(WARFeedGame *)game {
    /// 查看游戏排行
    if (self.pushController) {
        WARGameRankContainerViewController *controller = [[WARGameRankContainerViewController alloc]initWithGameId:game.gameId rankNames:[game.gameRanks valueForKey:@"rankName"]];
        [self.pushController.navigationController pushViewController:controller animated:YES];
    } else {
        //        if (self.pushToUserProfileBlock) {
        //            self.pushToUserProfileBlock(accountId, @"",moment.isMine);
        //        }
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

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell audioPlay:(WARMomentVoice *)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView {
    if (self.lastVoiceView == voiceView) {
        voiceView.playBtn.selected = !voiceView.playBtn.isSelected;
        [[WARCAVAudioPlayer sharePlayer] stopAudioPlayer];
        if (sender.selected) {
            [[WARCAVAudioPlayer sharePlayer] playAudioWithURLString:audio.voiceURLStr identifier:@""];
        }else{
            [WARCAVAudioPlayer sharePlayer].audioPlayerState = CVoiceMessageStateNormal;
            [voiceView pauseVoicePlay];
        }
        return;
    }
    self.lastVoiceView.playBtn.selected = NO;
    voiceView.playBtn.selected = YES;
    if (self.lastVoiceView) {
        [self.lastVoiceView pauseVoicePlay];
    }
    [[WARCAVAudioPlayer sharePlayer] stopAudioPlayer];
    [[WARCAVAudioPlayer sharePlayer] playAudioWithURLString:audio.voiceURLStr identifier:@""];
    self.lastVoiceView = voiceView;
}

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didOpen:(BOOL)open indexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        WARMoment *moment = self.momentLists[indexPath.row];
        //原布局
        WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
        //新生成布局
        WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.followOrFriendType moment:moment openLike:open openComment:NO];
        layout.feedLayoutArr = originalLayout.feedLayoutArr;
        layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
        layout.currentPageIndex = originalLayout.currentPageIndex;
        moment.friendMomentLayout = layout;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    });
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment didComment:(WARFriendComment *)comment {
    if ([comment.commentorInfo.accountId isEqualToString:self.userModel.accountId]) {
        WARMoment *moment = friendBaseCell.moment;
        [WARMomentTools showDeleteActionSheetWithActionHandler:^(NSUInteger index) {
            __weak typeof(self) weakSelf = self;
            [WARJournalFriendCycleNetManager deleteCommentWithModule:@"FMOMENT" fromAccId:comment.commentorInfo.accountId itemId:moment.momentId msgId:comment.msgId compeletion:^(BOOL success, NSError *err) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                /// 移除评论内容
                NSMutableArray <WARFriendComment *> *comments = [NSMutableArray arrayWithArray:moment.commentWapper.comment.comments];
                [comments removeObject:comment];
                moment.commentWapper.comment.comments = [NSArray arrayWithArray:comments];
                
                /// 移除评论布局
                NSMutableArray <WARFriendCommentLayout *>*commentLayoutArray = [NSMutableArray arrayWithArray:moment.commentsLayoutArr];
                [commentLayoutArray enumerateObjectsUsingBlock:^(WARFriendCommentLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.comment.msgId isEqualToString:comment.msgId]) {
                        [commentLayoutArray removeObject:obj];
                    }
                }];
                moment.commentsLayoutArr = commentLayoutArray;
                
                //原布局
                WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
                //新生成布局
                WARFriendMomentLayout *layout = [WARFriendMomentLayout type:strongSelf.followOrFriendType moment:moment openLike:NO openComment:NO];
                layout.feedLayoutArr = originalLayout.feedLayoutArr;
                layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
                layout.currentPageIndex = originalLayout.currentPageIndex;
                moment.friendMomentLayout = layout;
                
                [strongSelf.tableView reloadData];
            }];
        }];
    } else {
        self.didMoment = moment;
        self.repliedMessage = comment;
        
        self.myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复：%@",self.repliedMessage.commentorInfo.nickname];
        self.myMsgInputView.toId = self.repliedMessage.commentorInfo.accountId;
        [self.myMsgInputView prepareToShow];
        [self.myMsgInputView notAndBecomeFirstResponder];
        
        self.view.backgroundColor = HEXCOLOR(0xf4f4f4);
    }
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


#pragma mark - WARPhotoBrowserDelegate

- (CGRect)imageBrowser:(WARPhotoBrowser *)imageBrowser disappearFrameForIndex:(NSInteger)index {
    WARFeedImageComponent *imageComponent = [self.currentBrowseImageComponents objectAtIndex:index];
    //                                             [self.currentBrowseImageComponents removeAllObjects]
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:imageComponent.listRect fromView:self.currentBrowseMagicImageView];
    return rect;
}

#pragma mark - UIMessageInputViewDelegate

- (void)messageInputViewSelectedPhotos:(UIMessageInputView *)inputView {
    [self.myMsgInputView prepareToShow];
}

- (void)inputViewWillSendMsg:(UIMessageInputView *)inputView{
    [WARProgressHUD showMessageToWindow:@"正在发送"];
}

- (void)inputViewWillSendMsg:(UIMessageInputView *)inputView params:(NSDictionary *)params {
    NDLog(@"params:%@",params);
    
    self.willSendMsgParams = params; 
}

- (void)inputViewDidSendMsg:(UIMessageInputView *)inputView success:(BOOL)success commentId:(NSString *)commentId commentTime:(NSString *)commentTime{
    [WARProgressHUD hideHUD];
    if (success) {
        WARFriendComment *comment = [[WARFriendComment alloc]init];
        
        NSDictionary *params = self.willSendMsgParams;
        if(params) {
            comment.msgId = commentId;
            comment.title = [params objectForKey:@"title"];
            comment.replyId = [params objectForKey:@"replyId"];
            
            comment.noFriend = [[params objectForKey:@"noFriend"] isEqualToString:@"true"];
            comment.whisper = [[params objectForKey:@"whisper"] isEqualToString:@"true"];
            
            //commentorInfo
            WARMomentUser *commentorInfo = [[WARMomentUser alloc]init];
            commentorInfo.accountId = self.userModel.accountId;
            commentorInfo.headId = self.userModel.headId;
            commentorInfo.nickname = self.userModel.nickname;
            comment.commentorInfo = commentorInfo;
            
            NSString *commentId = [params objectForKey:@"commentId"];
            if (commentId) {
                WARMomentUser *replyorInfo = [[WARMomentUser alloc]init];
                replyorInfo.accountId = self.repliedMessage.commentorInfo.accountId;
                replyorInfo.nickname = self.repliedMessage.commentorInfo.nickname ;
                comment.replyorInfo = replyorInfo;
            }
            
            //commentVoiceInfo
            NSDictionary *voiceDict = [params objectForKey:@"voice"];
            if (voiceDict) {
                WARMomentVoice *commentVoiceInfo = [[WARMomentVoice alloc] init];
                commentVoiceInfo.duration = [voiceDict objectForKey:@"voiceDuration"];
                commentVoiceInfo.voiceId = [voiceDict objectForKey:@"voiceId"];
                comment.commentVoiceInfo = commentVoiceInfo;
            }
            
            //medias
            NSMutableArray <WARMomentMedia *>*mediaModels = [NSMutableArray <WARMomentMedia *>array];
            NSArray *medias = [params objectForKey:@"medias"];
            if (medias && [medias isKindOfClass:[NSArray class]] && medias.count > 0) {
                for (NSDictionary *mediaDict in medias) {
                    WARMomentMedia *mediaModel = [WARMomentMedia mj_objectWithKeyValues:mediaDict];
                    [mediaModels addObject:mediaModel];
                }
            }
            comment.medias = mediaModels;
        }
        NSInteger momentIndex =  [self.momentLists indexOfObject:self.didMoment];
        if (momentIndex < 0 || momentIndex >= self.momentLists.count) {
            return ;
        }
        WARMoment *tempMoment = self.didMoment;
        NSMutableArray <WARFriendComment *> *comments = [NSMutableArray arrayWithArray:tempMoment.commentWapper.comment.comments];
        [comments insertObject:comment atIndex:0];
        tempMoment.commentWapper.comment.comments = [NSArray arrayWithArray:comments];
        
        //创建评论布局
        WARFriendCommentLayout *commentLayout = [WARFriendCommentLayout commentLayout:comment openCommentLayout:NO];
        [tempMoment.commentsLayoutArr addObject:commentLayout];
        
        //原布局
        WARFriendMomentLayout *originalLayout = tempMoment.friendMomentLayout;
        //新生成布局
        WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.followOrFriendType moment:tempMoment openLike:NO openComment:NO];;
        layout.feedLayoutArr = originalLayout.feedLayoutArr;
        layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
        layout.currentPageIndex = originalLayout.currentPageIndex;
        tempMoment.friendMomentLayout = layout;
        [self.tableView reloadData];
        
        /// 
        self.willSendMsgParams[@"commentId"] = commentId;
        self.repliedMessage = nil;
        [self loadMoreComments];
        _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
        _myMsgInputView.actionType = UIMessageInputActionTypeComment;
        [_myMsgInputView prepareToDismiss];
        [self messageInputViewBecomeFirstResponder:NO];
        [WARProgressHUD showSuccessMessage:@"发送成功"];
    }
}

- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom{
//    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
        
    } completion:nil];
}

- (NSDictionary *)inputViewWillSendMsgWithParam {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    NSString *commentId = nil;  //first reply id
    NSString *replyId = self.didMoment.momentId;
    NSString *repliedAcctId = self.didMoment.accountId;
    NSString *itemId = self.didMoment.momentId;//source messageID;
    if (self.repliedMessage) {
        /** 消息类型
         @property (nonatomic, copy) NSString *contentType;
         TEXT(1, "文本"), PICTURE(2, "图片"), VIDEO(3, "视频"), VOICE(4, "音频"), CANCEL(5, "消息撤回"), GIF(6, "gif图"), LINK(7, "链接"), SYSTEM(8,"系统"),BIZCARDP(10,"名片人"),BIZCARDG(11,"名片群"),LOC(12,"位置"),
         GIFT(13,礼物)
         if ([self.repliedMessage.contentType isEqualToString:@"BBS"]) {
         commentId = self.repliedMessage.replyModel.firstRepliedMsgId;
         itemId = self.repliedMessage.replyModel.sourceMsgId;
         }else {
         itemId = self.repliedMessage.messageId;
         }
         */
        commentId = self.repliedMessage.commentId == nil ? self.willSendMsgParams[@"commentId"] : self.repliedMessage.commentId;
        replyId = self.repliedMessage.commentId == nil ? self.willSendMsgParams[@"commentId"] : self.repliedMessage.commentId;
        repliedAcctId = self.repliedMessage.commentorInfo.accountId;
    }
    if (commentId) {
        [paramDict setObject:commentId forKey:@"commentId"];
    }
    if (replyId) {
        [paramDict setObject:replyId forKey:@"replyId"];
    }
    if (repliedAcctId) {
        [paramDict setObject:repliedAcctId forKey:@"repliedAcctId"];
    }
    if (itemId) {
        [paramDict setObject:itemId forKey:@"itemId"];
    }
    return paramDict;
}

- (void)loadMoreComments{
}

- (void)messageInputViewBecomeFirstResponder:(BOOL)isBecomeResponder{
    if (!_myMsgInputView) {
        return;
    }
    if (isBecomeResponder) {
        [_myMsgInputView notAndBecomeFirstResponder];
    }else{
        [_myMsgInputView isAndResignFirstResponder];
    }
}

#pragma mark - Observer

- (void)addRealmObserver {
    __weak typeof(self) weakSelf = self;
    _sumOfUnreadNotification = [[WARDBNotification allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NDLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }else{
            if (change) {
                strongSelf.showMessageTipCell = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)] > 0;
                
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }];
}

- (void)removeRealmObserver {
    [_sumOfUnreadNotification invalidate];
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
        if ([self.followOrFriendType isEqualToString:@"FRIEND"]) {
            moudle = @"FMOMENT";
        }
        __weak typeof(self) weakSelf = self;
        [WARUserDiaryManager praiseWithMoudle:moudle itemId:itemId msgId:msgId thumbedAcctId:thumbedAcctId thumbState:thumbState compeletion:^(bool success, NSError *err) {
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
            WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
            //新生成布局
            WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.followOrFriendType moment:moment openLike:NO openComment:NO];
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

#pragma mark - UIMessageInputView
- (void)disMissInputView {
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIMessageInputView *)myMsgInputView {
    if (!_myMsgInputView) {
        _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
        _myMsgInputView.moduleType = WARCommentFrientCicleType;
        _myMsgInputView.actionType = UIMessageInputActionTypeComment;
        _myMsgInputView.isAlwaysShow = YES;
        _myMsgInputView.delegate = self;
        _myMsgInputView.bizType = @"MOMENT";
        _myMsgInputView.friendCannotSeeButton.hidden = YES;
        _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
//        __weak typeof(self) weakSelf = self;
//        _myMsgInputView.locationView.deleteLocationBlock = ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf disMissInputView];
//            strongSelf.repliedMessage = nil;
//        };
    }
    
    return _myMsgInputView;
}

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
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDataRefresh:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;
        MJRefreshAutoFooter *mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDataRefresh:NO];
        }];
        mj_footer.triggerAutomaticallyRefreshPercent = -100;
        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

@end
