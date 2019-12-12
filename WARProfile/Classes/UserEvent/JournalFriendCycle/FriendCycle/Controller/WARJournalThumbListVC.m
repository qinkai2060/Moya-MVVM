//
//  WARThumbListViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/8.
//

#import "WARJournalThumbListVC.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "MJRefresh.h"
#import "WARJournalFriendCycleNetManager.h"

#import "WARThumbListCell.h"

@interface WARJournalThumbListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *lastId;

/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** thumbTotalCount */
@property (nonatomic, assign) NSInteger thumbTotalCount;
/** 是否是公众 */
@property (nonatomic, assign) BOOL isPMoment;
@end

@implementation WARJournalThumbListVC

#pragma mark - System

- (instancetype)initWithMomentId:(NSString *)momentId thumbTotalCount:(NSInteger)thumbTotalCount isPMoment:(BOOL)isPMoment {
    if (self = [super init]) {
        self.momentId = momentId;
        self.thumbTotalCount = thumbTotalCount;
        self.isPMoment = isPMoment;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
    
    [self loadDataRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Event Response

#pragma mark - Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = UIColorWhite;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth, 14)];
    label.text = [NSString stringWithFormat:@"%@%ld",WARLocalizedString(@"点赞"),self.thumbTotalCount];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = TextColor;
    [headerV addSubview:label];
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, kScreenWidth, 0.5)];
    lineV.backgroundColor = SeparatorColor;
    [headerV addSubview:lineV];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARThumbListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARThumbListCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Private

- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
        self.lastId = @"";
    }else{
        [self.tableView.mj_header endRefreshing];
        
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadThumbUsersListWithModule:(self.isPMoment ? @"PMOMENT" : @"FMOMENT") LastFindId:self.lastId itemId:self.momentId compeletion:^(WARThumbModel *model, NSArray<WARMomentUser *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NDLog(@"VC正在刷新");
        if (!err && results > 0) {
            strongSelf.lastId = model.lastId;
        }
        
        if (refresh) {
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            } else {
                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
                return ;
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
}

- (void)getThumListData {
//    WS(weakSelf);
//    [WARUserDiaryManager getThumbListWithItemId:self.momentId lastId:self.lastId compeletion:^(NSArray *results, NSString *lastId, NSError *err) {
//        if (results.count) {
//            [weakSelf.tableView.mj_footer endRefreshing];
//            [weakSelf.dataArray addObjectsFromArray:results];
//            self.lastId = lastId;
//            [self.tableView reloadData];
//        }else {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    }];
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadThumbUsersListWithModule:(self.isPMoment ? @"PMOMENT" : @"FMOMENT") LastFindId:self.lastId itemId:self.momentId compeletion:^(WARThumbModel *model, NSArray<WARMomentUser *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (results.count) {
            [strongSelf.tableView.mj_footer endRefreshing];
            [strongSelf.dataArray addObjectsFromArray:results];
            strongSelf.lastId = model.lastId;
            [strongSelf.tableView reloadData];
        }else {
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.backgroundColor = UIColorWhite;
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[WARThumbListCell class] forCellReuseIdentifier:@"WARThumbListCell"];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        [_tableView registerClass:[WARThumbListCell class] forCellReuseIdentifier:@"WARThumbListCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        WS(weakSelf);
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataRefresh:NO];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
