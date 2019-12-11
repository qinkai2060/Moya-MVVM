//
//  WARGameRankListViewController.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/26.
//

#import "WARGameRankListViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "WARJournalFriendCycleNetManager.h"

#import "WARFeedGameRank.h"
#import "WARFeedGameRankModel.h"
#import "WARFeedGame.h" 

#import "WARGameRankListCell.h"

@interface WARGameRankListViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** cursor */
@property (nonatomic, copy) NSString *cursor;
/** gameId */
@property (nonatomic, copy) NSString *gameId;
/** rankName */
@property (nonatomic, copy) NSString *rankName;
/** currentRanks */
@property (nonatomic, strong) NSMutableArray <WARFeedGameRank *>*currentRanks;
///** 排名版 */
//@property (nonatomic, strong) NSMutableArray <WARFeedGameRankModel *> *gameRanks;
/** game */
@property (nonatomic, strong) WARFeedGame *game;
@end

@implementation WARGameRankListViewController

#pragma mark - Initial

- (instancetype)initWithGameId:(NSString *)gameId rankName:(NSString *)rankName {
    if (self = [super init]) {
        self.gameId = gameId;
        self.rankName = rankName; 
    }
    return self;
}

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
        self.cursor = @"";
    }else{
        [self.tableView.mj_header endRefreshing];
        
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadGameRankWithCursor:self.cursor gameId:self.gameId rankName:self.rankName compeletion:^(WARFeedGameRankModel *rankModel, NSArray<WARFeedGameRank *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NDLog(@"VC正在刷新");
        if (!err && results > 0) {
            strongSelf.cursor = rankModel.cursor;
        }
        
        if (refresh) {
            [strongSelf.currentRanks removeAllObjects];
            [strongSelf.currentRanks addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.currentRanks addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            }
        }
        
        [strongSelf.tableView reloadData];
        [strongSelf dealWithLoadResultNoMoreData:(results.count == 0 && !err)];
    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentRanks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARFeedGameRank *rank = self.currentRanks[indexPath.row];
    rank.isMultiPage = self.game.isMultiPage;
    
    WARGameRankListCell *cell = [WARGameRankListCell cellWithTableView:tableView];
    cell.rank = rank;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Public

#pragma mark - Private

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.backgroundColor = kRandomColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
        /// refresh
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
        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (NSMutableArray<WARFeedGameRank *> *)currentRanks {
    if (!_currentRanks) {
        _currentRanks = [NSMutableArray <WARFeedGameRank *>array];
    }
    return _currentRanks;
}

@end
