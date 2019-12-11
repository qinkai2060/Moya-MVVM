//
//  WARFriendMessageListVC.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARFriendMessageListVC.h"

#import "WARMacros.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARDBNotification.h"
#import "MJExtension.h"

#import "WARMomentRemind.h"

#import "WARFriendMessageCell.h"
#import "WARHistoryMessageTipCell.h"

#import "UINavigationController+WARCategory.h"

@interface WARFriendMessageListVC ()<UITableViewDelegate,UITableViewDataSource,WARFriendMessageCellDelegate>

/** tableView */
@property (nonatomic, strong) UITableView* tableView;
/** layoutLists */
@property (nonatomic, strong) NSMutableArray <WARFriendMessageLayout *>*layoutLists;
/** lastId */
@property (nonatomic, copy) NSString *lastFindId;
/** 消息通知类型 */
@property (nonatomic, assign) WARNotificationType notificationType;

/** 带有历史数据 */
@property (nonatomic, assign) BOOL withHistory;
@end

@implementation WARFriendMessageListVC

#pragma mark - System

- (instancetype)initWithNotificationType:(WARNotificationType) notificationType {
    if (self = [super init]) {
        self.notificationType = notificationType;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [WARDBUserManager cleanUnreadMomentCount];
    switch (self.notificationType) {
        case WARNotificationTypeFriend:
        {
            [WARDBNotification cleanUnReadCount:WARDBNotificationTypeFriend];
        }
            break;
        case WARNotificationTypePublicGroup:
        {
            [WARDBNotification cleanUnReadCount:WARDBNotificationTypePerson];
            
        }
            break;
        case WARNotificationTypeAlbum:
        {
            [WARDBNotification cleanUnReadCount:WARDBNotificationTypePersonAlbum];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadDataWithHostory:NO];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)loadDataWithHostory:(BOOL)withHistory {
    self.withHistory = withHistory;
    
    NSArray *contens;
    switch (self.notificationType) {
        case WARNotificationTypePublicGroup:
        {
            if (withHistory) {
                contens = [WARDBNotification getHistoryNotificationWithType:WARDBNotificationTypePerson];
            } else {
                contens = [WARDBNotification getUnReadNotificationWithType:WARDBNotificationTypePerson];
            }
        }
            break;
        case WARNotificationTypeFriend:
        {
            if (withHistory) {
                contens = [WARDBNotification getHistoryNotificationWithType:WARDBNotificationTypeFriend];
            } else {
                contens = [WARDBNotification getUnReadNotificationWithType:WARDBNotificationTypeFriend];
            }
        }
            break;
        case WARNotificationTypeAlbum:
        {
            if (withHistory) {
                contens = [WARDBNotification getHistoryNotificationWithType:WARDBNotificationTypePersonAlbum];
            } else {
                contens = [WARDBNotification getUnReadNotificationWithType:WARDBNotificationTypePersonAlbum];
            }
        }
            break;
        default:
            break;
    }
    
    NSArray <WARMomentRemind *> *reminds = [WARMomentRemind mj_objectArrayWithKeyValuesArray:contens];
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager convertDataWithReminds:reminds compeletion:^(WARMomentRemindModel *model, NSArray<WARFriendMessageLayout *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (withHistory) {
            [strongSelf.layoutLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            [strongSelf.layoutLists removeAllObjects];
            [strongSelf.layoutLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        }
        
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layoutLists.count + (self.withHistory ? 0 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.layoutLists.count) {
        WARFriendMessageLayout *layout = self.layoutLists[indexPath.row];
        WARFriendMessageCell *cell = [WARFriendMessageCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.layout = layout;
        return cell;
    } else {
        WARHistoryMessageTipCell *cell = [WARHistoryMessageTipCell cellWithTableView:tableView];
        return cell;
    } 
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.layoutLists.count) {
        WARFriendMessageLayout *layout = self.layoutLists[indexPath.row];
        return layout.cellHeight;
    } else {
        return 44;
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

    if (self.layoutLists.count == indexPath.row) {
        [self loadDataWithHostory:YES];
    }
}

#pragma mark - WARFriendMessageCellDelegate

- (void)friendMessageCell:(WARFriendMessageCell *)cell didUser:(WARMomentUser *)user {
    if (self.pushToUserProfileBlock) {
        self.pushToUserProfileBlock(user);
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

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
//        __weak typeof(self) weakSelf = self;
//        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf loadDataRefresh:YES];
//        }];
//        mj_header.automaticallyChangeAlpha = YES;
//        _tableView.mj_header = mj_header;
//
//        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf loadDataRefresh:NO];
//        }];
//        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (NSMutableArray <WARFriendMessageLayout *>*)layoutLists{
    if (!_layoutLists) {
        _layoutLists = [NSMutableArray<WARFriendMessageLayout *> array];
    }
    return _layoutLists;
}


@end
