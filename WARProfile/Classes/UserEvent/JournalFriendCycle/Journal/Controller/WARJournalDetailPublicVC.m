//
//  WARJournalDetailPublicVC.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import "WARJournalDetailPublicVC.h"

#import "Masonry.h"

#import "WARDBContactManager.h"
#import "WARDBContact.h"
#import "WARDBMessage.h"
#import "WARCMessageModel.h"

#import "WARMoment.h"
#import "WARCommentModel.h"
#import "WARJournalDetailModel.h"

#import "WARJournalDetailPublicTableHeaderView.h"

#import "WARMomentThumbListVC.h"

@interface WARJournalDetailPublicVC ()<WARJournalDetailPublicTableHeaderViewDelegate>

@property (nonatomic, copy) NSString *momentId;
@property (nonatomic, copy) NSString *friendId;

/** tableHeaderView */
@property (nonatomic, strong) WARJournalDetailPublicTableHeaderView *tableHeaderView;

@property (nonatomic, strong) WARCMessageModel *repliedMessage;
/** second repliedMessage 对第二层的回复*/
@property (nonatomic, strong) WARCMessageModel *secondRepliedMessage;
@end

@implementation WARJournalDetailPublicVC

#pragma mark - System
 
- (instancetype)initWithMomentId:(NSString *)momentId friendId:(NSString *)friendId {
    self = [super initCommentsVCWithItemId:momentId];
    if (self) {
        self.momentId = momentId;
        self.friendId = friendId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self messageInputViewHide:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTableViewHeader:self.tableHeaderView];
//    self.tableView.backgroundColor = [UIColor redColor];
    
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
    self.repliedMessage = sourceMsg;
    self.secondRepliedMessage = nil;
}

- (WARCommentModuleType)commentModuleType{
    if (self.isMoreList) {
        return WARCommentPublicCicleType;
    }else {
        return WARCommentPublicCicleType;
    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark  - scrollView delegate

- (void)tableViewwDidScroll:(UIScrollView *)scrollView {
    //当自己不能滚动是，offsetY设为 0
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARJournalDetailLeaveTopNtf" object:@1];
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - WARJournalDetailPublicTableHeaderViewDelegate

- (void)headerViewDidAllPraise:(WARJournalDetailPublicTableHeaderView *)headerView {
    WARMomentThumbListVC *controller = [[WARMomentThumbListVC alloc] initWithMomentId:self.momentId
                                                                     pThumbTotalCount:self.detailModel.pCommentWapper.praiseCount
                                                                     fThumbTotalCount:self.detailModel.fCommentWapper.praiseCount
                                                                             nickname:self.detailModel.friendModel.nickname];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIMessageInputViewDelegate

- (NSDictionary *)inputViewWillSendMsgWithParam {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    
    NSString *commentId = nil; 
    NSString *replyId = nil;
    NSString *repliedAcctId = nil;
    NSString *itemId = self.momentId;
    
    if (self.secondRepliedMessage) {
        replyId = self.secondRepliedMessage.messageId;
        repliedAcctId = self.secondRepliedMessage.fromUserId;
        commentId = self.secondRepliedMessage.messageId;
    }else {
        replyId = self.momentId;
        repliedAcctId = self.friendId;
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
}

- (void)loadCommentsFinished:(NSInteger)commentCount {
//    self.moment.commentWapper.commentCount = commentCount;
//
//    [self.headerView configMoment:self.moment];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (WARJournalDetailPublicTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[WARJournalDetailPublicTableHeaderView alloc] initWithFrame:CGRectZero momentId:self.momentId];
        _tableHeaderView.delegate = self;
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeaderView;
}

@end
