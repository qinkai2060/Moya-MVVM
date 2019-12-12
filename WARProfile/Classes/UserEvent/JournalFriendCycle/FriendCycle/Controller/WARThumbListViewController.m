//
//  WARThumbListViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/8.
//

#import "WARThumbListViewController.h"
#import "WARThumbListCell.h"
#import "WARLocalizedHelper.h"
#import "WARMacros.h"
#import "WARDBContactModel.h" 
#import "WARUserDiaryManager.h"
#import "MJRefresh.h"

@interface WARThumbListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *lastId;

@end

@implementation WARThumbListViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.moment.friendModel.nickname;

    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
    
    [self getThumListData];
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
    label.text = [NSString stringWithFormat:@"%@%ld",WARLocalizedString(@"点赞"),self.moment.commentWapper.praiseCount];
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

- (void)getThumListData {
    WS(weakSelf);
    [WARUserDiaryManager getThumbListWithItemId:self.moment.momentId lastId:self.lastId compeletion:^(NSArray *results, NSString *lastId, NSError *err) {
        if (results.count) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.dataArray addObjectsFromArray:results];
            self.lastId = lastId;
            [self.tableView reloadData];
        }else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorWhite;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WARThumbListCell class] forCellReuseIdentifier:@"WARThumbListCell"];
        WS(weakSelf);
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf getThumListData];
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
