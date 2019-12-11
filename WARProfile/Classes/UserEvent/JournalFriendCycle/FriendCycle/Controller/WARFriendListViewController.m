//
//  WARFriendViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFriendListViewController.h"

#import "WARFriendPageCell.h"
#import "WARNewMessageTipCell.h"
#import "WARFriendSinglePageCell.h"
#import "WARNewMessageTipView.h"
#import "UIMessageInputView.h"
#import "WARPlayerFlashView.h"
#import "WARFriendCommentVoiceView.h"
#import "WARFriendBottomView.h"
#import "WARRewordView.h"
#import "WARPlayerControlView.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "WARPhotoBrowser.h"
#import "WARProgressHUD.h"
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARUIHelper.h"
#import "WARMomentTools.h"
#import "YYWeakProxy.h"
#import "WARUserDiaryManager.h"
#import "WARLocalizedHelper.h"
#import "WARBaseMacros.h"
#import "MJExtension.h"
#import "WARCAVAudioPlayer.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARRewordAnimationTool.h"
#import "HKFloatManager.h"
#import "WARAVPlayerManager.h"
#import "WARUbtManager.h"

#import "WARDBUserManager.h"
#import "WARDBUserModel.h"
#import "WARDBUser.h"
#import "WARDBContactModel.h"

#import "WARFeedModel.h"
#import "WARCMessageModel.h"
#import "WARMoment.h"
#import "WARFriendComment.h"
#import "WARMomentUser.h"
#import "WARFeedGame.h"

#import "WARFriendMomentLayout.h"
#import "WARFriendCommentLayout.h"

#import "WARFollowDetailViewController.h"
#import "WARFriendDetailViewController.h"
#import "WARFriendMessageViewController.h"
#import "WARPlayViewController.h"
#import "WARProfileOtherViewController.h"
#import "WARUserCenterViewController.h"
#import "WARDouYinPlayVideoVC.h"
#import "WARLightPlayVideoVC.h"
#import "WARGameWebViewController.h"
#import "WARGameRankContainerViewController.h"

#import "UIScrollView+WARPlayer.h"
#import "UIImage+WARBundleImage.h"
#import "NSString+UUID.h"
#import "WARMediator+WebBrowser.h"
#import "WARMediator+Publish.h"
#import "WARMediator+Contacts.h"

#define kWARFriendPageCellId @"kWARFriendPageCellId"
#define kWARFriendSinglePageCellId @"kWARFriendSinglePageCellId"
#define kWARNewMessageTipCellId @"kWARNewMessageTipCellId"

@interface WARFriendListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARFriendBaseCellDelegate,UIMessageInputViewDelegate,WARPlayerControlViewDelegate,WARPhotoBrowserDelegate>

@property (nonatomic, copy) NSMutableArray <WARMoment *>*friendCycleListLists;
@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *maskId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *chatLabel;
@property (nonatomic, copy) NSArray<NSString *> *chatSysLabel;
/** moment展现在什么模块 */
@property (nonatomic, assign) WARMomentShowType momentShowType;

/** showMessageTipCell */
@property (nonatomic, assign) BOOL showMessageTipCell;

@property (nonatomic, strong) RLMNotificationToken *userModelnotification;

@property (nonatomic, strong) WARDBUserModel *userModel;

@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
/** repliedMessage */
@property (nonatomic, strong) WARFriendComment *repliedMessage;
@property (nonatomic, strong) WARMoment *didMoment;
@property (nonatomic, copy) NSString *refId;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
 
@property (nonatomic, strong) WARFriendCommentVoiceView *lastVoiceView;

/** pushController */
@property (nonatomic, weak) UIViewController *pushController;

/** 定时器 */
@property (nonatomic, strong) NSTimer *seeAdTimer;

@property (nonatomic, strong) NSArray <NSString *>*categorys;

/** 需要滚动到顶部 */
@property (nonatomic, assign) BOOL needScrollToTop;

/** WARPlayer 视频播放 */
@property (nonatomic, strong) WARPlayerControlView *controlView;
@property (nonatomic, strong) WARPlayerController *player;
@property (nonatomic, strong) WARAVPlayerManager *playerManager;

/** 图片浏览器正在浏览的图集 */
@property (nonatomic, strong) NSMutableArray<WARFeedImageComponent *> *currentBrowseImageComponents;
/** currentBrowseMagicImageView */
@property (nonatomic, weak) UIView *currentBrowseMagicImageView;
@end

@implementation WARFriendListViewController

#pragma mark - System

- (instancetype)initWithType:(NSString *)type maskId:(NSString *)maskId {
    if (self = [super init]) {
        self.maskId = maskId;
        self.type = type;
        if ([type isEqualToString:@"FRIEND"]) {
            self.momentShowType = WARMomentShowTypeFriend;
        } else if ([type isEqualToString:@"FOLLOW"]) {
            self.momentShowType = WARMomentShowTypeFriendFollow;
        }
        self.needScrollToTop = NO;
    }
    return self;
}
 
- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId
                        from:(NSString *)from
              pushController:(UIViewController *)pushController {
    if (self = [super init]) {
        self.from = from; 
        self.maskId = maskId;
        self.type = type;
        self.pushController = pushController;
        
        self.needScrollToTop = NO;
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
                       label:(NSString *)lable
                    sysLabel:(NSArray<NSString *> *)sysLabel
              pushController:(UIViewController *)pushController {
    if (self = [super init]) {
        self.from = from;
        self.maskId = maskId;
        self.type = type;
        self.chatLabel = lable;
        self.chatSysLabel = sysLabel;
        self.pushController = pushController;
        
        self.needScrollToTop = NO;
        if ([type isEqualToString:@"FRIEND"]) {
            self.momentShowType = WARMomentShowTypeFriend;
        } else if ([type isEqualToString:@"FOLLOW"]) {
            self.momentShowType = WARMomentShowTypeFriendFollow;
        }
    }
    return self;
}

- (void)loadDataWithMaskId:(NSString *)maskId {
    self.maskId = @"";
    self.from = @"";
    self.type = @"";
    if ([maskId isEqualToString:@"FOLLOW"]) {
        self.type = maskId;
        self.momentShowType = WARMomentShowTypeFriendFollow;
    } else if ([maskId isEqualToString:@"MESSAGE"]) {
        self.type = @"FOLLOW";
        self.from = maskId;
    } else {
    }
    self.needScrollToTop = YES;
    [self loadDataRefresh:YES];
}

- (void)loadDataWithCategory:(NSString *)category {
    self.maskId = @"";
    self.from = @"";
    self.type = @"";
    if ([category isEqualToString:@"FOLLOW"]) {
        self.type = category;
        self.momentShowType = WARMomentShowTypeFriendFollow;
    } else if ([category isEqualToString:@"MESSAGE"]) {
        self.type = @"FOLLOW";
        self.from = category;
    } else {
    }
    self.needScrollToTop = YES;
    [self loadDataRefresh:YES];
}

- (void)loadDataWithCategory:(NSString *)category isFollow:(BOOL)isFollow {
    self.maskId = @"";
    self.from = @"";
    self.type = @"";
    if (isFollow) {
        self.type = @"FOLLOW";
        self.momentShowType = WARMomentShowTypeFriendFollow;
    } else {
        self.type = @"FOLLOW";
        self.from = @"MESSAGE";
        self.maskId = category;
    }
    self.needScrollToTop = YES;
    [self loadDataRefresh:YES];
}

- (void)loadDataWithLable:(NSString *)lable {
    self.chatLabel = lable;
    self.needScrollToTop = YES;
    [self loadDataRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.playerManager play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self disMissInputView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.playerManager pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRealmObserver];
    
    [self initPlayer];
    
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

- (void)initPlayer {
    /// playerManager
    self.playerManager = [[WARAVPlayerManager alloc] init];
    self.playerManager.volume = 0.0;
    self.playerManager.muted = YES;
    UIView *playerManagerView = [self.playerManager valueForKey:@"_view"];
    playerManagerView.backgroundColor = [UIColor clearColor];
    
    /// player,tag值必须在cell里设置
    self.player = [WARPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
//    self.player.playerDisapperaPercent = 0.8;
    
    /// 切换屏幕方向
    @weakify(self)
    self.player.orientationWillChange = ^(WARPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    /// 播放结束
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        } else {
            [self.player stopCurrentPlayingCell];
        }
    };
}

- (void)loadDataRefresh:(BOOL)refresh {
    NSInteger unreadMomentCount = [WARDBUserManager unreadMomentCount];
    self.showMessageTipCell = NO;//(unreadMomentCount > 0);
    
    if (refresh) {
        self.lastFindId = @"";
        [self.tableView.mj_footer endRefreshing];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        // 1.分类
        dispatch_group_enter(group);
        __weak typeof(self) weakSelf = self;
        [WARJournalFriendCycleNetManager getFlowCategoryCompletion:^(NSArray<NSString *> *results, NSError *err) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.categorys = [NSArray arrayWithArray:results];
            if (strongSelf.maskIdListsBlock) {
                strongSelf.maskIdListsBlock(results);
            }
            
            dispatch_group_leave(group);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
            dispatch_semaphore_signal(semaphore); // + 1
        }];
        // 2.moment列表
        dispatch_group_enter(group);
        [WARJournalFriendCycleNetManager loadFriendListFromType:self.from lastFindId:self.lastFindId maskId:self.maskId type:self.type label:self.chatLabel sysLabel:self.chatSysLabel compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!err && results > 0) {
                strongSelf.lastFindId = model.lastFindId;
            }
            
            [strongSelf.friendCycleListLists removeAllObjects];
            [strongSelf.friendCycleListLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            
            dispatch_group_leave(group);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_signal(semaphore);
        }];
        //刷新
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (self.needScrollToTop) {
                [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
            }
            
            [self.tableView reloadData];
            [self dealWithLoadResultNoMoreData:self.friendCycleListLists.count == 0];
            [self starToPlay];
        });
        
    }else{
        [self.tableView.mj_header endRefreshing];
        
        __weak typeof(self) weakSelf = self;
        
        [WARJournalFriendCycleNetManager loadFriendListFromType:self.from lastFindId:self.lastFindId maskId:self.maskId type:self.type label:self.chatLabel sysLabel:self.chatSysLabel compeletion:^(WARMomentModel *model, NSArray<WARMoment *> *results, NSError *err) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!err && results > 0) {
                strongSelf.lastFindId = model.lastFindId;
            }
            
            if (results.count > 0) {
                [strongSelf.friendCycleListLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            } else {
                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
                return ;
            }
            
            [strongSelf.tableView reloadData];
            [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
        }];
    }
}


- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
 
    if (self.dealWithLoadResultNoMoreDataBlock) {
        self.dealWithLoadResultNoMoreDataBlock(noMoreData);
    }
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)dealloc {
    [self removeRealmObserver];
    [_seeAdTimer invalidate];
}

#pragma mark - Event Response

- (void)showTopViewPopAdWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath; 
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    config.tintColor = HEXCOLOR(0x4B5054);
    
    NSArray *titles = @[WARLocalizedString(@"收藏"),WARLocalizedString(@"举报"),WARLocalizedString(@"不感兴趣")];
    WARMoment *moment = self.friendCycleListLists[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [WARPopOverMenu showFromSenderFrame:frame withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
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
                __weak typeof(self) weakSelf = self;
                [WARJournalFriendCycleNetManager flowNointerestWithFlowId:moment.momentId compeletion:^(BOOL success, NSError *err) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.friendCycleListLists removeObject:moment];
                    [strongSelf.tableView reloadData];
                }];
                break;
            }
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
}

- (void)showTopViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    config.tintColor = HEXCOLOR(0x4B5054);
    
    NSArray *titles = @[WARLocalizedString(@"收藏"),WARLocalizedString(@"举报"),WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的消息")];
    WARMoment *moment = self.friendCycleListLists[indexPath.row];
    if (moment.isMine) {
        titles = @[WARLocalizedString(@"分享"),WARLocalizedString(@"收藏"),];
    } else {
        titles = @[WARLocalizedString(@"分享"),WARLocalizedString(@"收藏"),WARLocalizedString(@"举报"),WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的消息")];
    }
    
    __weak typeof(self) weakSelf = self;
    [WARPopOverMenu showFromSenderFrame:frame withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
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
            case 3:
            {
                __weak typeof(self) weakSelf = self;
                [WARJournalFriendCycleNetManager flowNointerestWithFlowId:moment.momentId compeletion:^(BOOL success, NSError *err) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
//                    if (success) {
//                        NSLog(@"对%@不感兴趣成功",moment.momentId);
                        [strongSelf.friendCycleListLists removeObject:moment];
                        [strongSelf.tableView reloadData];
                    
//                        [strongSelf.tableView beginUpdates];
//                        [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        [strongSelf.tableView endUpdates];
//                    }
                }];
                break;
            }
            case 4:
            {
                __weak typeof(self) weakSelf = self;
                [WARJournalFriendCycleNetManager flowNoseeWithGuyId:moment.accountId compeletion:^(BOOL success, NSError *err) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
//                    if (success) {
//                        NSLog(@"不看%@的消息",moment.friendModel.nickname);
                        [strongSelf.friendCycleListLists removeObject:moment];
                        [strongSelf.tableView reloadData];
                    
//                        [strongSelf.tableView beginUpdates];
//                        [strongSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        [strongSelf.tableView endUpdates];
//                    }
                }];
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
            if (indexPath.row < strongSelf.friendCycleListLists.count) {
                strongSelf.didMoment = strongSelf.friendCycleListLists[indexPath.row];
                strongSelf.repliedMessage = nil;
                
                strongSelf.myMsgInputView.toId = strongSelf.didMoment.accountId;
                [strongSelf.myMsgInputView prepareToShow];
                [strongSelf.myMsgInputView notAndBecomeFirstResponder];
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
    return self.friendCycleListLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WARNewMessageTipCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARNewMessageTipCellId];
        [cell configData:@{@"messageCount":@([WARDBUserManager unreadMomentCount]),
                           @"imageUrl":[NSString stringWithFormat:@"%@",[WARDBUserManager userModel].latestNoticationHeaderId]}];
        return cell;
    }
    
    WARMoment *moment = self.friendCycleListLists[indexPath.row];
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
    
    [cell showBottomSeparatorView:(self.friendCycleListLists.count - 1) != indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.showMessageTipCell ? 49 : 0;
    }
    
    WARMoment *moment = self.friendCycleListLists[indexPath.row];
    WARFriendMomentLayout *layout = moment.friendMomentLayout;
    return layout.cellHeight; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    
    NDLog(@"index：%ld",indexPath.row);
    if (indexPath.section != 0) {
        
        if ([self.type isEqualToString:@"FOLLOW"]) {
            WARMoment *moment = self.friendCycleListLists[indexPath.row];
            
            if (self.pushController) {
//                WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:moment type:@"FOLLOW"];
//                [self.pushController.navigationController pushViewController:controller animated:YES];
                
                WARFollowDetailViewController *controller = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:moment.momentId];
                [controller configMoment:moment];
                [self.pushController.navigationController pushViewController:controller animated:YES];
            } else {
                if (self.pushBlock) {
                    self.pushBlock(moment);
                }
            }
        }
        
    } else {
        [WARDBUserManager cleanUnreadMomentCount];
        self.showMessageTipCell = NO;
        
        if (self.pushController) {
            WARFriendMessageViewController *controller = [[WARFriendMessageViewController alloc]init];
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
     
//    /// 智能预加载
//    CGFloat current = scrollView.contentOffset.y + scrollView.frame.size.height;
//    CGFloat total = scrollView.contentSize.height;
//    CGFloat ratio = current / total;
//    if (ratio >= threshold) {
//        [self loadDataRefresh:NO];
//    }
      
    if (self.from) {
        return ;
    }
    if ((scrollView.contentOffset.y - self.contentOffsetY) < 0 && self.canScroll) {
        //向下滑
        CGFloat offset = self.contentOffsetBottomY - scrollView.contentOffset.y;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleScrollDownNtf" object:[NSNumber numberWithFloat:offset]];
    }
    else {
        self.contentOffsetBottomY = scrollView.contentOffset.y;
    }
    if ((scrollView.contentOffset.y - self.contentOffsetY) > 0 && self.canScroll) {
        //向上滑
        CGFloat offset = scrollView.contentOffset.y - self.contentOffsetUpY;
        if (scrollView.contentOffset.y  > 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleScrollUpNtf" object:[NSNumber numberWithFloat:offset]];
        }
    }else {
        self.contentOffsetUpY = scrollView.contentOffset.y;
    }
    self.contentOffsetY = scrollView.contentOffset.y;
    //与父控制器的滑动交互
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleLeaveTopNtf" object:@1];
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }

    [self disMissInputView]; 
}

/**
 * Called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
 * 松手时已经静止, 只会调用scrollViewDidEndDragging
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self.tableView jp_scrollViewDidEndDraggingWillDecelerate:decelerate];
    
    [self _startSeeAdTimer];
}

/**
 * Called on tableView is static after finger up if the user dragged and tableView is scrolling.
 * 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self _endSeeAdTimer];
    [self _startSeeAdTimer];
}

#pragma mark - WARFriendBaseCellDelegate

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView {
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
    
    if (didComponent.videoUrl && index == 0 && ([self.type isEqualToString:@"FOLLOW"]||self.maskId.length > 0 || [self.from isEqualToString:@"MESSAGE"])) {
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
    photoBrowser.delegate = self;
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
            [strongSelf.friendCycleListLists removeObjectAtIndex:indexPath.row];
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
            [self showTopViewPopAdWithFrame:frame indexPath:indexPath];
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
            } else  if (self.pushBlock && moment) {
                self.pushBlock(moment);
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
            if (indexPath.row >= self.friendCycleListLists.count) {
                return ;
            }
            WARMoment *moment = self.friendCycleListLists[indexPath.row];
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
//                UIViewController *controller = [[WARMediator sharedInstance]Mediator_ThirdHomeViewControllerWithTitle:moment.friendModel.nickname urlString:moment.friendModel.homeUrl guyId:moment.friendModel.accountId isFollow:moment.friendModel.followed];//
//                [self.pushController.navigationController pushViewController:controller animated:YES];

                UIViewController *vc = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:moment.friendModel.homeUrl callback:nil];
                [self.pushController.navigationController pushViewController:vc animated:YES];
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
        [self linkBuryPoint:YES moment:friendBaseCell.moment];
        
        __weak typeof(self) weakSelf = self;
        UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:^(NSArray<NSDictionary *> *hotLists) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf linkBuryPoint:NO moment:friendBaseCell.moment];
        }];
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
//        UIViewController *controller = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:nil];
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
//                UIViewController *controller = [[WARMediator sharedInstance]Mediator_ThirdHomeViewControllerWithTitle:moment.friendModel.nickname urlString:moment.friendModel.homeUrl guyId:moment.friendModel.accountId isFollow:moment.friendModel.followed];//
//                [self.pushController.navigationController pushViewController:controller animated:YES];

                UIViewController *vc = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:moment.friendModel.homeUrl callback:nil];
                [self.pushController.navigationController pushViewController:vc animated:YES];
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
        
        WARMoment *moment = self.friendCycleListLists[indexPath.row];
        //原布局
        WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
        //新生成布局
        WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.type moment:moment openLike:open openComment:NO];
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
    self.didMoment = moment;
    self.repliedMessage = comment;

    self.myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复：%@",self.repliedMessage.commentorInfo.nickname];
    self.myMsgInputView.toId = self.repliedMessage.commentorInfo.accountId;
    [self.myMsgInputView prepareToShow];
    [self.myMsgInputView notAndBecomeFirstResponder];
}

-(void)friendBaseCellDidDelete:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager deleteDiaryOrFriendMoment:moment.momentId compeletion:^(bool success, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            if (success) {
                NSInteger momentIndex = [strongSelf.friendCycleListLists indexOfObject:moment];
                [strongSelf.friendCycleListLists removeObjectAtIndex:momentIndex];
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

#pragma mark - WARPlayerControlViewDelegate

- (void)didControlView:(WARPlayerControlView *)controlView indexPath:(NSIndexPath *)indexPath component:(id)component {
    WARMoment *moment = self.friendCycleListLists[indexPath.row];
    WARFeedImageComponent *didComponent = component;
    
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
    
    if (didComponent.videoUrl) {
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
    WARFriendComment *comment = [[WARFriendComment alloc]init];
    if(params) {
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
    
    NSInteger momentIndex =  [self.friendCycleListLists indexOfObject:self.didMoment];
    if (momentIndex < 0 || momentIndex >= self.friendCycleListLists.count) {
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
    WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.type moment:tempMoment openLike:open openComment:NO];;
    layout.feedLayoutArr = originalLayout.feedLayoutArr;
    layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
    layout.currentPageIndex = originalLayout.currentPageIndex;
    tempMoment.friendMomentLayout = layout;
    
    [self.tableView reloadData];
}

- (void)inputViewDidSendMsg:(UIMessageInputView *)inputView success:(BOOL)success commentId:(NSString *)commentId commentTime:(NSString *)commentTime{
    [WARProgressHUD hideHUD];
    if (success) {
        self.repliedMessage = nil;
        
        [self loadMoreComments];
        _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
        //        _myMsgInputView.toId = self.urlID;
        _myMsgInputView.actionType = UIMessageInputActionTypeComment;
        [_myMsgInputView prepareToDismiss];
        [self messageInputViewBecomeFirstResponder:NO];
        
        [WARProgressHUD showSuccessMessage:@"发送成功"];
    }
}

- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
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
        commentId = self.repliedMessage.commentId;
        replyId = self.repliedMessage.commentId;
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
    WARDBUser *dbUser = [WARDBUser user];
    self.userModelnotification = [dbUser addNotificationBlock:^(BOOL deleted, NSArray<RLMPropertyChange *> * _Nullable changes, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NDLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }else{
            if (changes.count) {
                for (RLMPropertyChange *property in changes) {
                    if ([property.name isEqualToString:@"unReadMementsCount"] ||
                        [property.name isEqualToString:@"latestNoticationHeaderId"]) {
                        
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                        [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }
    }];
}

- (void)removeRealmObserver {
    [_userModelnotification invalidate];
}

#pragma mark - WARPlayer

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    if(indexPath.row >= self.friendCycleListLists.count){
        return ;
    }
    WARMoment *moment = self.friendCycleListLists[indexPath.row];
    WARFeedImageComponent *component = moment.ironBody.pageContents.firstObject.components.firstObject.content.pintu;
    
    /// 查找视频url
    NSString *videoId;
    WARFeedImageComponent *imageComponent;
    for (WARFeedPageModel *page in moment.ironBody.pageContents) {
        if (videoId) {
            break ;
        }
        for (WARFeedComponentModel *component in page.components) {
            if (component.content.images.count == 1) {
                imageComponent = component.content.images.firstObject;
                videoId = imageComponent.videoId;
                break ;
            }  
        }
    }
    
    /// 找到视频开始播放
    if (videoId != nil) {
        NSURL *videoUrl = kVideoUrl(videoId);
        [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
        self.player.assetURL = videoUrl;
        [self.controlView showComponent:imageComponent indexPath:indexPath coverURLString:kVideoCoverUrl(videoId) fullScreenMode:WARFullScreenModeLandscape];
//        [self.controlView showTitle:@""
//                     coverURLString:kVideoCoverUrl(videoId)
//                     fullScreenMode:WARFullScreenModeLandscape];
    }
}

- (void)starToPlay {
    // player,tag值必须在cell里设置
//    self.player.assetURL = self.urls;
    
    @weakify(self)
    [self.tableView war_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}

#pragma mark - Private

/**
 链接行为采集
 */
- (void)linkBuryPoint:(BOOL)enter moment:(WARMoment *)moment {
    WARUbtAction *action = [[WARUbtAction alloc]init];
    action.type = enter ? VISIT_LINK : RETURN_LINK;
    
    WARUbtTarget *target = [[WARUbtTarget alloc]init];
    target.targetId = moment.momentId;
    target.type = kTargetTypeInfo;
    
    WARUbtParam *ubt = [[WARUbtParam alloc]init];
    ubt.accountId = moment.friendModel.accountId;
    ubt.target = target;
    ubt.action = action;
    
    [WARUbtManager buryPointWithUbtParam:ubt compeletion:^(BOOL success, NSError *err) {
        if (success) {
            NDLog(@"埋点上传成功");
        }
    }];
}

/// Start long press timer, used for 'highlight' range text action.
- (void)_startSeeAdTimer {
    [_seeAdTimer invalidate];
    _seeAdTimer = [NSTimer timerWithTimeInterval:1.5f
                                              target:[YYWeakProxy proxyWithTarget:self]
                                            selector:@selector(_trackDidSeeAd)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_seeAdTimer forMode:NSRunLoopCommonModes];
}

/// Invalidate the long press timer.
- (void)_endSeeAdTimer {
    if (_seeAdTimer) {
        [_seeAdTimer invalidate];
        _seeAdTimer = nil;
    }
}

/// Long press detected.
- (void)_trackDidSeeAd {
    [self _endSeeAdTimer];
    
    NSArray *visibleCells = [self.tableView visibleCells];
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        WARMoment *moment = self.friendCycleListLists[indexPath.row];
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
                 ;
                
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

- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}

- (void)praiseOrCancle:(NSIndexPath *)indexPath {
    if (indexPath.row < self.friendCycleListLists.count) {
        WARMoment *moment = self.friendCycleListLists[indexPath.row];
        
        NSString *itemId = moment.momentId;
        NSString *msgId = moment.momentId;
        NSString *thumbedAcctId = moment.friendModel.accountId;
        
        NSString *thumbState = @"UP";
        if (moment.commentWapper.thumbUp) {
            thumbState = @"DOWN";
        }
        
        NSString *moudle = @"PMOMENT";
        if ([self.type isEqualToString:@"FRIEND"]) {
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
            WARFriendMomentLayout *layout = [WARFriendMomentLayout flowLayoutWithMoment:moment];//[WARFriendMomentLayout type:self.type moment:moment openLike:NO openComment:NO];
            layout.feedLayoutArr = originalLayout.feedLayoutArr;
            layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
            layout.currentPageIndex = originalLayout.currentPageIndex;
            moment.friendMomentLayout = layout;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
}

- (UIMessageInputView *)myMsgInputView {
    if (!_myMsgInputView) {
        _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
        _myMsgInputView.moduleType = WARCommentPublicCicleType;
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

- (NSMutableArray<WARMoment *> *)friendCycleListLists {
    if (!_friendCycleListLists) {
        _friendCycleListLists = [NSMutableArray <WARMoment *>array];
    }
    return _friendCycleListLists;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = YES;
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
        
        _tableView.shouldAutoPlay = YES;
        /// 停止的时候找出最合适的播放
        __weak typeof(self) weakSelf = self;
        _tableView.scrollViewDidStopScroll = ^(NSIndexPath * _Nonnull indexPath) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
        
        /// refresh
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.needScrollToTop = NO;
            [strongSelf loadDataRefresh:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;
        
        MJRefreshAutoFooter *mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.needScrollToTop = NO;
            [strongSelf loadDataRefresh:NO];
        }];
        mj_footer.triggerAutomaticallyRefreshPercent = -100;
        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (WARPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[WARPlayerControlView alloc]initWithFrame:CGRectZero controlType:WARPlayerControlTypeFlowList];
    }
    return _controlView;
}

@end
