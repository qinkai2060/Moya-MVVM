//
//  WARJournalDetailPublicTableHeaderView.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import "WARJournalDetailPublicTableHeaderView.h"

#import "WARPopOverMenu.h"
#import "WARMacros.h"
#import "Masonry.h"

#import "WARUserDiaryManager.h"
#import "WARJournalFriendCycleNetManager.h"

#import "WARDBContactModel.h"
#import "WARDBUserManager.h"
#import "WARDBUserModel.h"

#import "WARFriendThumbCell.h"
#import "WARFriendDetailMoreThumbCell.h"
#import "WARFriendDetailTitleCell.h"

#import "UIView+Frame.h"

static NSString *kWARFriendThumbCellID = @"kWARFriendThumbCellID";
static NSString *kWARFriendDetailMoreThumbCellID = @"kWARFriendDetailMoreThumbCellID";
static NSString *kWARFriendDetailTitleCellID = @"kWARFriendDetailTitleCellID";

@interface WARJournalDetailPublicTableHeaderView()<UITableViewDelegate,UITableViewDataSource,WARFriendThumbCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WARDBUserModel *userModel;
/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** thumbLastId */
@property (nonatomic, copy) NSString *thumbLastId;
/** thumbModel */
@property (nonatomic, strong) WARThumbModel *thumbModel;

@end

@implementation WARJournalDetailPublicTableHeaderView

#pragma mark - System
 
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        self.userModel = [WARDBUserManager userModel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame momentId:(NSString *)momentId {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        
        self.momentId = momentId;
        self.userModel = [WARDBUserManager userModel];
        
        [self loadThumbUsersList:YES];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(-35);
//        make.left.bottom.right.mas_equalTo(self);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (void)loadThumbUsersList:(BOOL)refresh {
    
    if (refresh) {
        self.thumbLastId = @"";
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadThumbUsersListWithModule:@"PMOMENT" LastFindId:self.thumbLastId itemId:self.momentId compeletion:^(WARThumbModel *model, NSArray<WARMomentUser *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.thumbModel = model;
        strongSelf.thumbLastId = model.lastId;
        
        if (strongSelf.thumbModel.thumbUserBos.count > 0) {
            strongSelf.height = 15 + model.friendDetailThumbLayout.cellHeight + kFriendDetailMoreThumbCellHeight + kFriendDetailTitleCellHeight;
        } else {
            strongSelf.height = 15 + model.friendDetailThumbLayout.cellHeight + kFriendDetailTitleCellHeight;
        }
        
        //        if ([strongSelf.delegate respondsToSelector:@selector(headerViewReloadData)]) {
        //            [strongSelf.delegate headerViewReloadData];
        //        }
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARFriendThumbCellDelegate

- (void)friendThumbCell:(WARFriendThumbCell *)friendThumbCell didThumber:(NSString *)accountId {
//    if ([self.delegate respondsToSelector:@selector(headerView:didUser:)]) {
//        [self.delegate headerView:self didUser:accountId];
//    }
}

- (void)friendThumbCell:(WARFriendThumbCell *)friendThumbCell didOpen:(BOOL)open {
    
}

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    if (indexPath.row == 0) {
        WARFriendThumbCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendThumbCellID];
        if (!cell) {
            cell = [[WARFriendThumbCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendThumbCellID];
        }
        cell.delegate = self;
        cell.thumbModel = self.thumbModel;
        return cell;
    } else if (indexPath.row == 1) {
        if (self.thumbModel.thumbUserBos.count > 0) {
            WARFriendDetailMoreThumbCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendDetailMoreThumbCellID];
            if (!cell) {
                cell = [[WARFriendDetailMoreThumbCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendDetailMoreThumbCellID];
            }
            [cell configPraiseCount:self.thumbModel.thumbUserBos.count];
            return cell;
        }
    } else if (indexPath.row == 2) {
//        if (self.moment.commentWapper.commentCount > 0) {
            WARFriendDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendDetailTitleCellID];
            if (!cell) {
                cell = [[WARFriendDetailTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendDetailTitleCellID];
            }
//            [cell configCommentCount:self.moment.commentWapper.commentCount];
            return cell;
//        }
//        return [UITableViewCell new];
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.thumbModel.thumbUserBos.count > 0 ? self.thumbModel.friendDetailThumbLayout.cellHeight : 0;
    } else if (indexPath.row == 1) {
        return self.thumbModel.thumbUserBos.count > 0 ? kFriendDetailMoreThumbCellHeight : 0;
    }else if (indexPath.row == 2) {
//        if (self.moment.commentWapper.commentCount > 0) {
            return kFriendDetailTitleCellHeight;
//        }
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        if ([self.delegate respondsToSelector:@selector(headerViewDidAllPraise:)]) {
            [self.delegate headerViewDidAllPraise:self];
        }
    } else if (indexPath.row == 2) {
        if ([self.delegate respondsToSelector:@selector(headerViewDidAllPraise:)]) {
            [self.delegate headerViewDidAllPraise:self];
        }
    }else if (indexPath.row == 3) {
        
    }
}

#pragma mark - Setter And Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = NO;
//        _tableView.scrollEnabled = NO;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.backgroundColor = kColor(whiteColor);
//        _tableView.userInteractionEnabled = YES;
//        _tableView.showsHorizontalScrollIndicator = NO;
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableView.estimatedSectionHeaderHeight = 0;
//            _tableView.estimatedSectionFooterHeight = 0;
//            _tableView.estimatedRowHeight = 0;
//        }
//    }
//    return _tableView;
//}
@end
