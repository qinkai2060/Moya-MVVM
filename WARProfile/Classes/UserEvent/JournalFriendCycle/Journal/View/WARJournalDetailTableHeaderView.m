//
//  WARJournalDetailTableHeaderView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import "WARJournalDetailTableHeaderView.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARPhotoBrowser.h"
#import "WARUIHelper.h"
#import "WARUserDiaryManager.h"
#import "WARProgressHUD.h"

#import "WARMoment.h"
#import "WARFeedGame.h"

#import "WARDBUserManager.h"
#import "WARDBUserModel.h"
#import "WARDBUser.h"
#import "WARDBContactModel.h"
 
#import "WARFriendPageCell.h"
#import "WARFriendSinglePageCell.h"

#import "UIView+ViewController.h"
#import "UIView+Frame.h"
#import "WARMediator+Publish.h"
#import "WARMediator+WebBrowser.h"

#import "WARFriendDetailViewController.h"
#import "WARProfileOtherViewController.h"
#import "WARGameWebViewController.h"
#import "WARGameRankContainerViewController.h"

static NSString *kWARFriendSinglePageCellID = @"kWARFriendSinglePageCellID";
static NSString *kWARFriendPageCellID = @"kWARFriendPageCellID";

@interface WARJournalDetailTableHeaderView()<UITableViewDelegate,UITableViewDataSource,WARFriendBaseCellDelegate>

/** tableView */
@property (nonatomic, strong) UITableView* tableView;
/** 当前用户model */
@property (nonatomic, strong) WARDBUserModel *userModel;

@end

@implementation WARJournalDetailTableHeaderView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        
        self.userModel = [WARDBUserManager userModel];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame moment:(WARMoment *)moment{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        
        self.moment = moment;
        self.userModel = [WARDBUserManager userModel];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self);
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moment == nil ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
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
        [cell showBottomSeparatorView:NO];
        [cell hideLikeView:YES];
        [cell hideCommentView:YES];
        [cell hideCellSeparatorView:YES];
        
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WARFriendMomentLayout *layout = self.moment.friendMomentLayout;
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

#pragma mark - WARFriendBaseCellDelegate

-(void)friendBaseCellDidAllContext:(WARFriendBaseCell *)friendBaseCell  indexPath:(NSIndexPath *)indexPath {
    NDLog(@"查看全文");
    WARMoment *moment = friendBaseCell.moment;
    WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:moment type:@"FRIEND"];
    [self.viewController.navigationController pushViewController:controller animated:YES];
}

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType value:(id)value {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidPageContent:
        {
            WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:self.moment type:@"FRIEND"];
            [self.viewController.navigationController pushViewController:controller animated:YES];
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
//            [self praiseOrCancle];
            break;
        }
        case WARFriendBaseCellActionTypeDidFollowComment:{
            //            _myMsgInputView.toId = self.moment.accountId;
            //            _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
            //            _myMsgInputView.actionType = UIMessageInputActionTypeComment;
            //            [_myMsgInputView isAndResignFirstResponder];
            break;
        }
        default:
            break;
    }
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents  magicImageView:(UIView *)magicImageView {
//    WARFeedImageComponent *didComponent = [imageComponents objectAtIndex:index]; 
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

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
    NSMutableArray *tempArray = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
        photoBrowserModel.picUrl = [kCMPRPhotoUrl(obj) absoluteString];
        [tempArray addObject:photoBrowserModel];
    }];
    
    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
    photoBrowser.photoArray = tempArray;
    photoBrowser.currentIndex = index;
    [photoBrowser show];
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent) {
        UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:nil];
        [self.viewController.navigationController pushViewController:controllr animated:YES];
    }
}

- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didGameLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent) {
        WARGameWebViewController *controller = [[WARGameWebViewController alloc]initWithUrlString:linkContent.url];
        [self.viewController.navigationController pushViewController:controller animated:YES];
    }
}

-(void)friendBaseCellDidAllRank:(WARFriendBaseCell *)friendBaseCell game:(WARFeedGame *)game {
    /// 查看游戏排行
    WARGameRankContainerViewController *controller = [[WARGameRankContainerViewController alloc]initWithGameId:game.gameId rankNames:[game.gameRanks valueForKey:@"rankName"]];
    [self.viewController.navigationController pushViewController:controller animated:YES];
}

-(void)friendBaseCellDidUserHeader:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model {
    WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:model.accountId friendWay:@""];
    [self.viewController.navigationController pushViewController:controller animated:YES];
}

-(void)friendBaseCellDidDelete:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
    [WARUserDiaryManager deleteDiaryOrFriendMoment:moment.momentId compeletion:^(bool success, NSError *err) {
        if (success) {
            [self.viewController.navigationController popViewControllerAnimated:YES];
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"删除成功")];
        } else {
            [WARProgressHUD showErrorMessage:WARLocalizedString(@"删除失败")];
        }
    }];
}

-(void)friendBaseCellDidEdit:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment {
    UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForFeedEditingViewController:moment.momentId];
    [self.viewController.navigationController pushViewController:controllr animated:YES];
}

-(void)friendBaseCellDidLock:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment lock:(BOOL)lock {
    
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMoment:(WARMoment *)moment {
    _moment = moment;
    
    self.height = moment.friendMomentLayout.cellHeight;
    
    [self.tableView reloadData];
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)]; 
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
