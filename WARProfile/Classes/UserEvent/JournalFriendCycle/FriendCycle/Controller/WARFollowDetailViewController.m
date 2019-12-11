//
//  WARFollowDetailViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/8.
//

#import "WARFollowDetailViewController.h"
#import "WARCMessageModel.h"
#import "Masonry.h"
#import "WARDBContactManager.h"
#import "WARDBContact.h"
#import "WARDBMessage.h"
#import "WARUIHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ReactiveObjC.h"
#import "NSString+UUID.h"

#import "WARCommentModel.h"

#import "WARTextContentView.h"
#import "WARLinkContentView.h"
#import "WARImageContentView.h"
#import "WARVoiceContentView.h"

#import "WARCommentsHeaderView.h"
#import "WARReplyFooterView.h"
#import "WARNavgationCutsomBar.h"
#import "WARFollowDetailHeaderView.h"

#import "WARMoment.h"
#import "WARFeedGame.h"

#import "WARFriendMomentLayout.h"
#import "WARFriendCommentLayout.h"
#import "WARFeedComponentLayout.h"

#import "WARMediator+WebBrowser.h"
#import "WARProfileOtherViewController.h"
#import "WARPhotoBrowser.h"
#import "WARThumbListViewController.h"
#import "WARGameRankContainerViewController.h"
#import "WARGameWebViewController.h"

//#import "WARPlayViewController.h"
#import "WARFriendDetailViewController.h"
#import "UIImage+Tint.h"
#import "WARMediator+Contacts.h"

#import "WARUbtManager.h"

@interface WARFollowDetailViewController ()<WARFollowDetailHeaderViewDelegate,WARPhotoBrowserDelegate>

//@property (nonatomic,strong) WARNavgationCutsomBar *customBar;
/** WARReplyDetailHeaderView */
@property (nonatomic, strong) WARFollowDetailHeaderView *headerView;
/** second repliedMessage 对第二层的回复*/
@property (nonatomic, strong) WARCMessageModel *secondRepliedMessage;

@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) WARDBUserModel *userModel;
@property (nonatomic, assign) BOOL scrollToComment;

/** 图片浏览器正在浏览的图集 */
@property (nonatomic, strong) NSMutableArray<WARFeedImageComponent *> *currentBrowseImageComponents;
/** currentBrowseMagicImageView */
@property (nonatomic, weak) UIView *currentBrowseMagicImageView;
@end

@implementation WARFollowDetailViewController

#pragma mark - System

- (instancetype)initCommentsVCWithItemId:(NSString *)itemId scrollToComment:(BOOL)scrollToComment {
    self = [super initCommentsVCWithItemId:itemId];
    if (self) {
        self.scrollToComment = scrollToComment;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self pageBuryPoint:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self pageBuryPoint:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xf4f4f4);
    self.moment.isFollowDetail = YES;
    
    UIImage *image = [[[UIImage war_imageName:@"person_zone_details_more2" curClass:[self class] curBundle:@"WARProfile.bundle"] imageWithTintColor:[UIColor whiteColor]]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    
    CGFloat headerViewHeight = self.moment.friendMomentLayout.detailCellHeight; 
    self.headerView = [[WARFollowDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, headerViewHeight) moment:self.moment type:self.type];
    self.headerView.delegate = self;
    [self setTableViewHeader:self.headerView];
    
    
    WARCMessageModel *sourceMsg = nil;
    if (self.repliedMessage) {
        sourceMsg = self.repliedMessage;
    }else {
        WARDBMessage *msg = nil;
        if (self.isMoreList) {
            msg = [WARDBMessage objectForPrimaryKey:self.commentID];
        }else {
            msg = [WARDBMessage objectForPrimaryKey:self.itemId];
        }
        sourceMsg = [WARCMessageModel modelWithMessage:msg];
    }
    
    self.title = [NSString stringWithFormat:@"%@",self.moment.friendModel.nickname];
    self.repliedMessage = sourceMsg;
    self.secondRepliedMessage = nil;
}

/**
 行为采集
 */
- (void)pageBuryPoint:(BOOL)enter {
    WARUbtAction *action = [[WARUbtAction alloc]init];
    action.type = enter ? VISIT_DETAIL : RETURN;
    
    WARUbtTarget *target = [[WARUbtTarget alloc]init];
    target.targetId = self.moment.momentId;
    target.type = kTargetTypeInfo;
    
    WARUbtParam *ubt = [[WARUbtParam alloc]init];
    ubt.accountId = self.moment.friendModel.accountId;
    ubt.target = target;
    ubt.action = action;
    
    [WARUbtManager buryPointWithUbtParam:ubt compeletion:^(BOOL success, NSError *err) {
        if (success) {
            NDLog(@"埋点上传成功");
        }
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view) ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WARCommentModuleType)commentModuleType{
    if (self.isMoreList) {
        return WARCommentPublicCicleType;
    }else {
        return WARCommentPublicCicleType;
    }
} 
#pragma mark - Event Response
 
- (void)rightAction{
    
}

- (void)leftAtction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NDLog(@"%.f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - WARFollowDetailHeaderViewDelegate

- (void)headerViewReloadData {
    [self.tableView reloadData];
    
    if (self.scrollToComment) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:CGPointMake(0, self.headerView.height - 42)];
            self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.height - 42, 0, 0, 0);
        });
    }
}

- (void)headerViewDidAllPraise:(WARFollowDetailHeaderView *)headerView {
    WARThumbListViewController *vc = [[WARThumbListViewController alloc] init];
    vc.moment = self.moment;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerView:(WARFollowDetailHeaderView *)headerView didUser:(NSString *)accountId {
    if (self.moment.friendModel.thirdType && self.moment.friendModel.homeUrl) {
        UIViewController *controller = [[WARMediator sharedInstance]Mediator_ThirdHomeViewControllerWithTitle:self.moment.friendModel.nickname urlString:self.moment.friendModel.homeUrl guyId:self.moment.friendModel.accountId isFollow:self.moment.friendModel.followed]; 
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:accountId friendWay:@""];
        [self.navigationController.navigationController pushViewController:controller animated:YES];
    }
}

- (void)headerView:(WARFollowDetailHeaderView *)headerView didLink:(WARFeedLinkComponent *)linkContent {
    UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:nil];
    [self.navigationController pushViewController:controllr animated:YES];
}

-(void)headerView:(WARFollowDetailHeaderView *)headerView didGameLink:(WARFeedLinkComponent *)didGameLink {
    WARGameWebViewController *controller = [[WARGameWebViewController alloc]initWithUrlString:didGameLink.url];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)headerViewDidAllRank:(WARFollowDetailHeaderView *)headerView game:(WARFeedGame *)game {
    /// 查看游戏排行
    WARGameRankContainerViewController *controller = [[WARGameRankContainerViewController alloc]initWithGameId:game.gameId rankNames:[game.gameRanks valueForKey:@"rankName"]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)headerView:(WARFollowDetailHeaderView *)headerView didImageIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents  magicImageView:(UIView *)magicImageView {
    self.currentBrowseImageComponents = [NSMutableArray arrayWithArray:imageComponents];
    self.currentBrowseMagicImageView = magicImageView;
    
    WARFeedImageComponent *didComponent = [imageComponents objectAtIndex:index];
//    if (didComponent.videoUrl && index == 0) {
//        WARPlayViewController *controller = [[WARPlayViewController alloc] initWithVideoUrl:didComponent.videoUrl];
//        [self presentViewController:controller animated:YES completion:nil];
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

-(void)headerView:(WARFollowDetailHeaderView *)headerView showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
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

- (void)headerViewDidToFullText:(WARFollowDetailHeaderView *)headerView {
    WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:self.moment type:@"FOLLOW"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - WARPhotoBrowserDelegate

- (CGRect)imageBrowser:(WARPhotoBrowser *)imageBrowser disappearFrameForIndex:(NSInteger)index {
    WARFeedImageComponent *imageComponent = [self.currentBrowseImageComponents objectAtIndex:index];
    //                                             [self.currentBrowseImageComponents removeAllObjects]
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:imageComponent.listRect fromView:self.currentBrowseMagicImageView];
    return rect;
}

#pragma mark - UIMessageInputViewDelegate

- (NSDictionary *)inputViewWillSendMsgWithParam {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    
    NSString *commentId = nil;
//    NSString *willSendMessageID = [NSString stringWithFormat:@"%@",[NSString UUID]];//messageID
    NSString *replyId = nil;
    NSString *repliedAcctId = nil;
    NSString *itemId = self.moment.momentId;
    
    if (self.secondRepliedMessage) {
        replyId = self.secondRepliedMessage.messageId;
        repliedAcctId = self.secondRepliedMessage.fromUserId;
        commentId = self.secondRepliedMessage.messageId;
    }else {
        replyId = self.moment.momentId;
        repliedAcctId = self.moment.accountId;
//        commentId = willSendMessageID;
    }
    
    if (commentId) {
        [paramDict setObject:commentId forKey:@"commentId"];
    }
//    if (willSendMessageID) {
//        [paramDict setObject:willSendMessageID forKey:@"msgId"];
//    }
    if (replyId) {
        [paramDict setObject:replyId forKey:@"replyId"];
    }
    if (repliedAcctId) {
        [paramDict setObject:repliedAcctId forKey:@"repliedAcctId"];
    }
    if (itemId) {
        [paramDict setObject:itemId forKey:@"itemId"];
    }
    
    self.secondRepliedMessage = nil;
    
    return paramDict;
}

- (void)updateLocalMessage:(NSDictionary *)paramDict {
//    NSString *messageID = paramDict[@"msgId"];
}

- (void)replyComment:(WARCommentModel *)comment {
    WARCMessageModel *model = [[WARCMessageModel alloc] init];
    model.messageId = comment.commentId;
    model.fromUserId = comment.commentorInfo.accountId;
    model.replyModel.firstRepliedMsgId = comment.commentId;
    
    self.secondRepliedMessage = model;
}

- (void)enterMoreListView:(WARCommentModel *)comment {
    //    WARReplyDetailController *detalController = [[WARReplyDetailController alloc] initCommentsVCWithItemId:self.repliedMessage.messageId commentID:comment.commentId];
    //    detalController.sessionId = self.sessionId;
    //
    //    [self.navigationController pushViewController:detalController animated:YES];
}

- (void)enterMoreListViewWithLayout:(WARCommentLayout *)comment {
//    WARFollowDetailViewController *detalController = [[WARFollowDetailViewController alloc] initCommentsVCWithItemId:self.repliedMessage.messageId commentLayout:comment];
//    [self.navigationController pushViewController:detalController animated:YES];
}

- (void)loadCommentsFinished:(NSInteger)commentCount {
    self.moment.commentWapper.commentCount = commentCount;
    
    [self.headerView configMoment:self.moment];
}


#pragma mark - Setter And Getter

- (void)configMoment:(WARMoment *)moment {
    self.title = [NSString stringWithFormat:@"%@", moment.friendModel.nickname];
    
    WARMoment *copyMoment = [moment copy];
    copyMoment.momentShowType = WARMomentShowTypeFriendFollowDetail;
    
    NSMutableArray *pageLayouts = [NSMutableArray array];
    for (WARFeedPageModel *pageM in copyMoment.ironBody.pageContents) {
        WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
        [layout configComponentLayoutsWithPage:pageM contentScale:kContentScale momentShowType:(WARMomentShowTypeFriendFollowDetail) isMultilPage:copyMoment.isMultilPage];
        [pageLayouts addObject:layout];
    }
    
    WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout mapProfileMomentListLayoutWithMoment:moment]; 
    friendMomentLayout.feedLayoutArr = pageLayouts;
    friendMomentLayout.currentPageIndex = 0;
    copyMoment.friendMomentLayout = friendMomentLayout;
    
    _moment = copyMoment;
}


@end

