//
//  WARFollowDetailHeaderView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/8.
//

#import "WARFollowDetailHeaderView.h"
#import "WARDBUserModel.h"
#import "WARFriendBaseCell.h"
#import "WARMoment.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"
#import "WARFriendSinglePageCell.h"
#import "WARFriendPageCell.h"
#import "WARDBUserManager.h"
#import "WARUserDiaryManager.h"
#import "WARDBContactModel.h"
#import "WARFriendCommentLayout.h"
#import "WARPopOverMenu.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARFriendThumbCell.h"
#import "UIView+Frame.h"
#import "WARFriendDetailMoreThumbCell.h"
#import "WARFriendDetailTitleCell.h"
#import "WARFriendDetailViewController.h"

static NSString *kWARFriendSinglePageCellID = @"kWARFriendSinglePageCellID";
static NSString *kWARFriendPageCellID = @"kWARFriendPageCellID";
static NSString *kWARFriendThumbCellID = @"kWARFriendThumbCellID";
static NSString *kWARFriendDetailMoreThumbCellID = @"kWARFriendDetailMoreThumbCellID";
static NSString *kWARFriendDetailTitleCellID = @"kWARFriendDetailTitleCellID";

 
@interface WARFollowDetailHeaderView()<UITableViewDelegate,UITableViewDataSource,WARFriendBaseCellDelegate,WARFriendThumbCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) WARDBUserModel *userModel;

/** thumbLastId */
@property (nonatomic, copy) NSString *thumbLastId;
/** thumbModel */
@property (nonatomic, strong) WARThumbModel *thumbModel;
@end

@implementation WARFollowDetailHeaderView

#pragma mark - System


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
        
        self.userModel = [WARDBUserManager userModel];
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
   
        [self loadThumbUsersList:YES];
    }
    return self;
}

- (void)initSubViews {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self);
//        make.left.top.right.mas_equalTo(self);
//        make.bottom.mas_equalTo(self.allPraiseButton.mas_top);
    }];
    
//    [self addSubview:self.bottomLine];
//    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.bottom.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(0.5);
//    }];
}

- (void)loadThumbUsersList:(BOOL)refresh {
    
    if (refresh) {
        self.thumbLastId = @"";
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadThumbUsersListWithModule:@"PMOMENT" LastFindId:self.thumbLastId itemId:self.moment.momentId compeletion:^(WARThumbModel *model, NSArray<WARMomentUser *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.thumbModel = model;
        strongSelf.thumbLastId = model.lastId;
        
        if (strongSelf.thumbModel.thumbUserBos.count > 100) {
            strongSelf.height = strongSelf.moment.friendMomentLayout.detailCellHeight + 15 + model.friendDetailThumbLayout.cellHeight + kFriendDetailMoreThumbCellHeight + kFriendDetailTitleCellHeight;
        } else {
            strongSelf.height = strongSelf.moment.friendMomentLayout.detailCellHeight + 15 + model.friendDetailThumbLayout.cellHeight + kFriendDetailTitleCellHeight;
        }
        
        if ([strongSelf.delegate respondsToSelector:@selector(headerViewReloadData)]) {
            [strongSelf.delegate headerViewReloadData];
        }
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARFriendThumbCellDelegate

- (void)friendThumbCell:(WARFriendThumbCell *)friendThumbCell didThumber:(NSString *)accountId {
    if ([self.delegate respondsToSelector:@selector(headerView:didUser:)]) {
        [self.delegate headerView:self didUser:accountId];
    }
}

- (void)friendThumbCell:(WARFriendThumbCell *)friendThumbCell didOpen:(BOOL)open {
    
}

#pragma mark - WARFriendBaseCellDelegate

-(void)friendBaseCellDidAllContext:(WARFriendBaseCell *)friendBaseCell  indexPath:(NSIndexPath *)indexPath {
    NDLog(@"查看全文");
    WARMoment *moment = friendBaseCell.moment;
    WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:moment type:@"FOLLOW"];
    [self.viewController.navigationController pushViewController:controller animated:YES]; 
}

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

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(headerView:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate headerView:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
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

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didGameLink:(WARFeedLinkComponent *)linkContent {
    if ([self.delegate respondsToSelector:@selector(headerView:didGameLink:)]) {
        [self.delegate headerView:self didGameLink:linkContent];
    }
}

-(void)friendBaseCellDidAllRank:(WARFriendBaseCell *)friendBaseCell game:(WARFeedGame *)game {
    if ([self.delegate respondsToSelector:@selector(headerViewDidAllRank:game:)]) {
        [self.delegate headerViewDidAllRank:self game:game];
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
        case WARFriendBaseCellActionTypeDidTopPopAd:
        {
            [self showTopViewPopAdWithFrame:frame];
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

- (void)showTopViewPopAdWithFrame:(CGRect)frame {
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    config.tintColor = HEXCOLOR(0x4B5054);
    
    NSArray *titles = @[WARLocalizedString(@"收藏"),WARLocalizedString(@"举报"),WARLocalizedString(@"不感兴趣")];
    WARMoment *moment = self.moment;
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
//                __weak typeof(self) weakSelf = self;
                [WARJournalFriendCycleNetManager flowNointerestWithFlowId:moment.momentId compeletion:^(BOOL success, NSError *err) {
//                    __strong typeof(weakSelf) strongSelf = weakSelf;
                }];
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
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == 0) {
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
        cell.indexPath = indexPath;
        cell.moment = self.moment;
        [cell showBottomSeparatorView:YES];
        [cell showTopExtendView:NO];
        [cell hideLikeView:YES];
        [cell hideCommentView:YES];
        
        return cell;
    } else if (indexPath.row == 1) {
        WARFriendThumbCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendThumbCellID];
        if (!cell) {
            cell = [[WARFriendThumbCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendThumbCellID];
        }
        cell.delegate = self;
        cell.thumbModel = self.thumbModel;
        
        return cell;
    } else if (indexPath.row == 2) {
        if (self.thumbModel.thumbUserBos.count > 100) {
            WARFriendDetailMoreThumbCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendDetailMoreThumbCellID];
            if (!cell) {
                cell = [[WARFriendDetailMoreThumbCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendDetailMoreThumbCellID];
            }
            [cell configPraiseCount:self.thumbModel.thumbUserBos.count];
            return cell;
        }
        
    } else if (indexPath.row == 3) {
        if (self.moment.commentWapper.commentCount > 0) {
            WARFriendDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendDetailTitleCellID];
            if (!cell) {
                cell = [[WARFriendDetailTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendDetailTitleCellID];
            }
            [cell configCommentCount:self.moment.commentWapper.commentCount];
            return cell;
        }
        return [UITableViewCell new];
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WARFriendMomentLayout *layout = self.moment.friendMomentLayout;
        return layout.cellHeight;
    } else if (indexPath.row == 1) {
        return self.thumbModel.thumbUserBos.count > 0 ? self.thumbModel.friendDetailThumbLayout.cellHeight : 0;
    } else if (indexPath.row == 2) {
        return self.thumbModel.thumbUserBos.count > 100 ? kFriendDetailMoreThumbCellHeight : 0;
    }else if (indexPath.row == 3) {
        if (self.moment.commentWapper.commentCount > 0) {
            return kFriendDetailTitleCellHeight;
        }
        return 0;
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
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        if ([self.delegate respondsToSelector:@selector(headerViewDidAllPraise:)]) {
            [self.delegate headerViewDidAllPraise:self];
        }
    }else if (indexPath.row == 3) {
         
    }
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
        
        moment.commentWapper.thumbUp = !moment.commentWapper.thumbUp;
        if (moment.commentWapper.thumbUp) { //已点赞
            moment.commentWapper.praiseCount += 1;
        } else { // 取消点赞
            moment.commentWapper.praiseCount -= 1;
        }

        WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout type:@"FOLLOW" moment:moment openLike:NO openComment:NO];
        NSMutableArray *pageLayouts = [NSMutableArray array];
        for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
            WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
            [layout configComponentLayoutsWithPage:pageM contentScale:kContentScale momentShowType:(WARMomentShowTypeFriendFollowDetail) isMultilPage:moment.isMultilPage];
            [pageLayouts addObject:layout];
        }
        friendMomentLayout.feedLayoutArr = pageLayouts;
        friendMomentLayout.currentPageIndex = 0;
        moment.friendMomentLayout = friendMomentLayout;

        
        [strongSelf loadThumbUsersList:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [strongSelf.tableView reloadData];
//        });
    }];
}

#pragma mark - Setter And Getter

- (void)configMoment:(WARMoment *)moment {
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

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = COLOR_WORD_GRAY_E;
    }
    
    return _bottomLine;
}


@end
