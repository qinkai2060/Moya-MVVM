//
//  WARJournalDetailFriendVC.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import "WARJournalDetailFriendVC.h"

#import "WARMacros.h"
#import "MJRefresh.h"
#import "WARPhotoBrowser.h"
#import "WARCAVAudioPlayer.h"
#import "WARPopOverMenu.h"
#import "WARUserDiaryManager.h"

#import "WARMoment.h"
#import "WARFeedModel.h"
#import "WARCMessageModel.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"

#import "WARDBUserManager.h"
#import "WARDBUserModel.h"
#import "WARDBUser.h"
#import "WARDBContactModel.h"

#import "UIMessageInputView.h"
#import "WARFriendCommentVoiceView.h"
#import "WARJournalThumbCell.h"
#import "WARJournalCommentCell.h"
#import "WARJournalArrowCell.h"
#import "WARJournalDetailMoreThumbCell.h"

#import "WARFriendDetailViewController.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARProfileOtherViewController.h"
#import "WARPlayViewController.h"
#import "WARMomentThumbListVC.h"

#import "WARMediator+WebBrowser.h"
#import "WARMediator+Publish.h"

@interface WARJournalDetailFriendVC ()<UITableViewDelegate,UITableViewDataSource,UIMessageInputViewDelegate,WARJournalThumbCellDelegate,WARJournalCommentCellDelegate>

/** tableView */
@property (nonatomic, strong) UITableView* tableView;
/** comments */
@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*commentLayouts;
/** commentModel */
@property (nonatomic, copy) NSString *commentLastId;

//@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, copy) NSString *momentId;
@property (nonatomic, copy) NSString *friendId; 
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) WARDBUserModel *userModel;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
/** repliedMessage */
@property (nonatomic, strong) WARFriendComment *repliedMessage;
@property (nonatomic, copy) NSString *refId;

/** 点赞 */
@property (nonatomic, copy) NSString *thumbLastId;
/** thumbModel */
@property (nonatomic, strong) WARThumbModel *thumbModel;

@property (nonatomic, strong) WARFriendCommentVoiceView *lastVoiceView;  

@end

@implementation WARJournalDetailFriendVC

#pragma mark - System

- (instancetype)initWithMomentId:(NSString *)momentId friendId:(NSString *)friendId {
    if (self = [super init]) {
        self.momentId = momentId;
        self.friendId = friendId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.myMsgInputView prepareToShow];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self disMissInputView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HEXCOLOR(0xf4f4f4);

    self.myMsgInputView.toId = self.friendId;

    [self loadThumbUsersList:YES];

    [self loadComments:YES];
}

- (void)initSubviews {
    [super initSubviews];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-80-kSafeAreaBottom);
    }];
}

- (void)loadThumbUsersList:(BOOL)refresh {
    if (refresh) {
        self.thumbLastId = @"";
    }
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadThumbUsersListWithModule:@"FMOMENT" LastFindId:self.thumbLastId itemId:self.momentId compeletion:^(WARThumbModel *model, NSArray<WARMomentUser *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.thumbModel = model;
        strongSelf.thumbLastId = model.lastId;
        [strongSelf.tableView reloadData];
    }];
}

- (void)loadComments:(BOOL)refresh {
    if (refresh) {
        self.commentLastId = @"";
    }
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadCommentsListWithModule:@"FMOMENT" lastFindId:self.commentLastId itemId:self.momentId compeletion:^(WARFriendCommentModel *model, NSArray<WARFriendCommentLayout *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err && results > 0) {
            strongSelf.commentLastId = model.refId;
        }
        if (refresh) {
            [strongSelf.commentLayouts removeAllObjects];
            [strongSelf.commentLayouts addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.commentLayouts addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
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
    [self.myMsgInputView prepareToShow];
    //    [self.myMsgInputView notAndBecomeFirstResponder];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.commentLayouts.count;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.thumbModel.thumbUserBos.count > 0 || self.commentLayouts.count > 0) {
            WARJournalArrowCell *cell = [WARJournalArrowCell cellWithTableView:tableView];
            return cell;
        }
        return [UITableViewCell new];
    } else if (indexPath.section == 1) {
        WARJournalThumbCell *cell = [WARJournalThumbCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.thumbModel = self.thumbModel;
        [cell hideBottomLine:(self.thumbModel.thumbUserBos.count > 0)];
        return cell;
    } else if (indexPath.section == 2) {
        if (self.thumbModel.thumbUserBos.count > 0) {
            WARJournalDetailMoreThumbCell *cell = [WARJournalDetailMoreThumbCell cellWithTableView:tableView];
            [cell configPraiseCount:self.thumbModel.thumbUserBos.count];
            return cell;
        }
    } else {
        WARJournalCommentCell *cell = [WARJournalCommentCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.commentLayout = self.commentLayouts[indexPath.row];
        [cell hideCommentIcon:(indexPath.row != 0)];
        
        return cell;
    }

    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.thumbModel.thumbUserBos.count > 0 || self.commentLayouts.count > 0) {
            return 15.5;
        }
        return 0;
    } else if(indexPath.section == 1){
        return self.thumbModel.journalThumbLayout.cellHeight;
    } else if (indexPath.section == 2) {
        if (self.thumbModel.thumbUserBos.count > 0) {
            return kWARJournalDetailMoreThumbCellHeight;
        }
    } else {
        WARFriendCommentLayout *layout = self.commentLayouts[indexPath.row];
        return layout.cellHeight;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        WARMomentThumbListVC *controller = [[WARMomentThumbListVC alloc] initWithMomentId:self.momentId
                                                                         pThumbTotalCount:self.detailModel.pCommentWapper.praiseCount
                                                                         fThumbTotalCount:self.detailModel.fCommentWapper.praiseCount
                                                                                 nickname:self.detailModel.friendModel.nickname];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == 3) {
        if (indexPath.row < self.commentLayouts.count) {
            self.repliedMessage = self.commentLayouts[indexPath.row].comment;
            self.myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复：%@",self.repliedMessage.commentorInfo.nickname];
            self.myMsgInputView.toId = self.repliedMessage.commentorInfo.accountId;
        }
        
        [self.myMsgInputView prepareToShow];
        [self.myMsgInputView notAndBecomeFirstResponder];
    }
}

#pragma mark  - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_myMsgInputView isAndResignFirstResponder];
    
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

#pragma mark - WARJournalThumbCellDelegate

-(void)journalThumbCell:(WARJournalThumbCell *)journalThumbCell  didThumber:(NSString *)accountId {
    WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:accountId friendWay:@""];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)journalThumbCell:(WARJournalThumbCell *)journalThumbCell  didOpenThumber:(BOOL)openThumber {

}

#pragma mark - WARJournalCommentCellDelegate

/// 图片浏览
- (void)showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
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

/// 视频播放
- (void)playVideoWithUrl:(NSString *)url {
    WARPlayViewController *controller = [[WARPlayViewController alloc] initWithVideoUrl:[NSURL URLWithString:url]];
    [self presentViewController:controller animated:YES completion:nil];
}

/// 头像点击
- (void)tapIconWithAccountId:(NSString*)accountId {
    WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:accountId friendWay:@""];
    [self.navigationController pushViewController:controller animated:YES];
}

/// 点击了 Label 的链接
- (void)cell:(UIView *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    WARMomentUser *momentUser = info[kLinkReplyName];
    if (momentUser) {
        WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:momentUser.accountId friendWay:@""];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/// 播放音频
- (void)audioPlay:(WARMomentVoice*)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView {
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

#pragma mark - UIMessageInputViewDelegate

- (void)messageInputViewSelectedPhotos:(UIMessageInputView *)inputView {
    [self.myMsgInputView prepareToShow];
}

- (void)inputViewWillSendMsg:(UIMessageInputView *)inputView{
    [WARProgressHUD showMessageToWindow:@"正在发送"];
}

- (void)inputViewDidSendMsg:(UIMessageInputView *)inputView success:(BOOL)success commentId:(NSString *)commentId commentTime:(NSString *)commentTime{
    [WARProgressHUD hideHUD];
    if (success) {
        self.repliedMessage = nil;

        self.myMsgInputView.toId = self.friendId;
        _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
        _myMsgInputView.actionType = UIMessageInputActionTypeComment;
        [_myMsgInputView isAndResignFirstResponder];

        [self loadComments:YES];

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
    NSString *replyId = self.momentId;
    NSString *repliedAcctId = self.friendId;
    NSString *itemId = self.momentId;//source messageID;

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

#pragma mark - Private

#pragma mark - UIMessageInputView
- (void)disMissInputView {
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
}

- (UIMessageInputView *)myMsgInputView {
    if (!_myMsgInputView) {
        _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
        _myMsgInputView.moduleType = WARCommentTweetType;
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadComments:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;

        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadComments:NO];
        }];
        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (NSMutableArray <WARFriendCommentLayout *>*)commentLayouts{
    if (!_commentLayouts) {
        _commentLayouts = [NSMutableArray<WARFriendCommentLayout *> array];
    }
    return _commentLayouts;
}


@end
