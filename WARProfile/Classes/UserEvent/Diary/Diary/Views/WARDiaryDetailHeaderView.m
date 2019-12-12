//
//  WARDiaryDetailHeaderView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/11.
//

#import "WARDiaryDetailHeaderView.h"
#import "WARDBUserModel.h"
#import "WARFriendBaseCell.h"
#import "WARMoment.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"
#import "WARFriendSinglePageCell.h"
#import "WARDBUserManager.h"
#import "WARUserDiaryManager.h"
#import "WARDBContactModel.h"
#import "WARFriendCommentLayout.h"
#import "WARPopOverMenu.h"
#import "WARFriendPageCell.h"

static NSString *kWARFriendSinglePageCellID = @"kWARFriendSinglePageCellID";
static NSString *kWARFriendPageCellID = @"kWARFriendPageCellID";

@interface WARDiaryDetailHeaderView()<UITableViewDelegate,UITableViewDataSource,WARFriendBaseCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) WARDBUserModel *userModel;

@end

@implementation WARDiaryDetailHeaderView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userModel = [WARDBUserManager userModel];
        
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame moment:(WARMoment *)moment type:(NSString *)type {
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
        
        self.type = type;
        WARMoment *copyMoment = [moment copy];
        
        if ([type isEqualToString:@"FRIEND"]) {
            copyMoment.momentShowType = WARMomentShowTypeFriendDetail;
        } else if ([type isEqualToString:@"FOLLOW"]) {
            copyMoment.momentShowType = WARMomentShowTypeFriendFollowDetail;
        }
        
        self.moment = copyMoment;
        
        self.userModel = [WARDBUserManager userModel];
        
        [self.tableView reloadData];
    }
    return self;
}

- (void)initSubViews {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
//        make.bottom.mas_equalTo(80);
    }];
}

#pragma mark - Event Response

- (void)allPraiseAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(headerViewDidAllPraise:)]) {
        [self.delegate headerViewDidAllPraise:self];
    }
}

#pragma mark - Delegate

#pragma mark - WARFriendBaseCellDelegate

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType value:(id)value {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidPageContent:
        {
            if ([self.delegate respondsToSelector:@selector(headerViewDidToFullText:)]) {
                [self.delegate headerViewDidToFullText:self];
            }
            break;
        }
        case WARFriendBaseCellActionTypeScrollHorizontalPage:{
            
            break;
        }
        case WARFriendBaseCellActionTypeFinishScrollHorizontalPage:{
            
            break;
        }
        case WARFriendBaseCellActionTypeDidUserHeader: {
            
            break;
        }
        case WARFriendBaseCellActionTypeDidPraise: {
            [self praiseOrCancle];
            break;
        }
        case WARFriendBaseCellActionTypeDidFollowComment:{
            
            break;
        }
        default:
            break;
    }
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents  magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(headerView:didImageIndex:imageComponents:)]) {
        [self.delegate headerView:self didImageIndex:index imageComponents:imageComponents];
    }
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(headerView:showPhotoBrower:currentIndex:)]) {
        [self.delegate headerView:self showPhotoBrower:photos currentIndex:index];
    }
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent) {
        if ([self.delegate respondsToSelector:@selector(headerView:didLink:)]) {
            [self.delegate headerView:self didLink:linkContent];
        }
    }
}

-(void)friendBaseCellDidUserHeader:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model {
    if ([self.delegate respondsToSelector:@selector(headerView:didUser:)]) {
        [self.delegate headerView:self didUser:model.accountId];
    }
}

- (void)friendBaseCellShowPop:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidTopPop:
        {
            break;
        }
        case WARFriendBaseCellActionTypeDidBottomPop:
        {
            [self showBottomViewPopWithFrame:frame];
            break;
        }
            
        default:
            break;
    }
}

- (void)showBottomViewPopWithFrame:(CGRect)frame {
    NSArray *titles = @[WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的朋友圈")];
    
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    __weak typeof(self) weakSelf = self;
    [WARPopOverMenu showFromSenderFrame:frame withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        switch (selectedIndex) {
            case 0:
            {
                
                break;
            }
                
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARFriendBaseCell *cell;
    if (self.moment.isMultilPage) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendPageCellID];
        if (!cell) {
            cell = [[WARFriendPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendPageCellID];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendSinglePageCellID];
        if (!cell) {
            cell = [[WARFriendSinglePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendSinglePageCellID];
        }
    }
    
    cell.delegate = self;
    cell.moment = self.moment;
    
    [cell showTopExtendView:NO];
    [cell showBottomSeparatorView:YES];
    [cell hideLikeView:YES];
    [cell hideCommentView:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARFriendMomentLayout *layout = self.moment.friendMomentLayout;
    return layout.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Public
 
#pragma mark - Private

- (void)praiseOrCancle {
    WARMoment *moment = self.moment;
    
    NSString *itemId = moment.momentId;
    NSString *msgId = moment.momentId;
    NSString *thumbedAcctId = moment.friendModel.accountId;
    
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
            moment.commentWapper.comment = comment;
        }
        if (!moment.commentWapper.thumb) {
            WARThumbModel *thumb = [[WARThumbModel alloc] init];
            moment.commentWapper.thumb = thumb;
        }
        
        NSMutableArray *thumbUserBos = [NSMutableArray arrayWithArray:moment.commentWapper.thumb.thumbUserBos];
        moment.commentWapper.thumbUp = !moment.commentWapper.thumbUp;
        if (moment.commentWapper.thumbUp) { //已点赞
            moment.commentWapper.praiseCount += 1;
        } else { // 取消点赞
            moment.commentWapper.praiseCount -= 1;
        }
        
        WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [[WARFriendMomentLayout alloc] init];
        NSMutableArray *pageLayouts = [NSMutableArray array];
        for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
            WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
            [layout configComponentLayoutsWithPage:pageM contentScale:kContentScale momentShowType:(WARMomentShowTypeFriendFollowDetail) isMultilPage:moment.isMultilPage];
            [pageLayouts addObject:layout];
        }
        friendMomentLayout.feedLayoutArr = pageLayouts;
        moment.friendMomentLayout = friendMomentLayout;
        friendMomentLayout.moment = moment;
        
        //朋友圈列表评论布局
        NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
        [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARFriendCommentLayout* layout = [WARFriendCommentLayout commentFollowDetailLayout:obj openCommentLayout:NO];
            [commentsLayoutArr addObject:layout];
        }];
        moment.commentsLayoutArr = commentsLayoutArr;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadData];
        });
    }];
}

#pragma mark - Setter And Getter

- (void) configMoment:(WARMoment *)moment {
    _moment = moment;
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kColor(whiteColor);
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[WARFriendSinglePageCell class] forCellReuseIdentifier:kWARFriendSinglePageCellID];
        [_tableView registerClass:[WARFriendPageCell class] forCellReuseIdentifier:kWARFriendPageCellID];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedRowHeight = 0;
        }
    }
    return _tableView;
}


@end
