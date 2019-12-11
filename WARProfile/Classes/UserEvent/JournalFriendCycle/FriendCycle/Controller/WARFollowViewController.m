//
//  WARFollowViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFollowViewController.h"
#import "Masonry.h"
#import "WARBaseMacros.h"
#import "MJRefresh.h"

@interface WARFollowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *lastPublishTime;

@end

@implementation WARFollowViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottom);
    }];
}


- (void)loadDataRefresh:(BOOL)refresh {
    
    if (refresh) {
        self.lastFindId = @"";
        self.lastPublishTime = @"";
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    [self dealWithLoadResultNoMoreData:NO];
    
//    __weak typeof(self) weakSelf = self;
//    [WARUserDiaryManager loadFriendCycleListWithLastFindId:self.lastFindId lastPublishTime:self.lastPublishTime compeletion:^(WARNewUserDiaryModel *model, NSArray<WARNewUserDiaryMoment *> *results, NSArray<WARFriendMomentLayout *> *layouts, NSError *err) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (!err && results > 0) {
//            strongSelf.lastFindId = model.lastFindId;
//            strongSelf.lastPublishTime = model.lastPublishTime;
//        }
//
//        if (refresh) {
//            strongSelf.showMessageTipCell = YES;
//            strongSelf.friendCycleListLists = [NSArray arrayWithArray:results];
//        } else {
//            if (results.count > 0) {
//                NSMutableArray *mutableAry = [NSMutableArray arrayWithArray:strongSelf.friendCycleListLists];
//                [mutableAry addObjectsFromArray:results];
//                strongSelf.friendCycleListLists = [NSArray arrayWithArray:mutableAry];
//            } else {
//                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
//                return ;
//            }
//        }
//
//        [strongSelf.tableView reloadData];
//        [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
//    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.dealWithLoadResultNoMoreDataBlock) {
        self.dealWithLoadResultNoMoreDataBlock(noMoreData);
    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.contentView.backgroundColor = kRandomColor;
    
    return cell;
}

#pragma mark  - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y - self.contentOffsetY) < 0 && self.canScroll) {
        //向下滑
        CGFloat offset = self.contentOffsetBottomY - scrollView.contentOffset.y;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleScrollDownNtf" object:[NSNumber numberWithFloat:offset]];
    }
    else {
        self.contentOffsetBottomY = scrollView.contentOffset.y;
    }
    if ((scrollView.contentOffset.y - self.contentOffsetY) > 0 && self.canScroll) {
        //向上滑
        CGFloat offset = scrollView.contentOffset.y - self.contentOffsetUpY;
        if (scrollView.contentOffset.y  > 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleScrollUpNtf" object:[NSNumber numberWithFloat:offset]];
        }
    }else {
        self.contentOffsetUpY = scrollView.contentOffset.y;
    }
    if (scrollView == _tableView){
        if (!self.canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY<0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWARFriendCycleLeaveTopNtf" object:@1];
            self.canScroll = NO;
            scrollView.contentOffset = CGPointZero;
        }
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.userInteractionEnabled = YES; 
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
