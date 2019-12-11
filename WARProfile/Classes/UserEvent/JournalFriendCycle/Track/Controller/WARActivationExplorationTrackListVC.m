//
//  WARFriendViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARActivationExplorationTrackListVC.h"

#import "UIImage+WARBundleImage.h"
#import "WARMediator+WebBrowser.h"

#import "WARDBUserManager.h"
#import "WARJournalFriendCycleNetManager.h"

#import "WARLocalizedHelper.h"
#import "WARBaseMacros.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "WARUIHelper.h"

#import "WARMomentTraceInfo.h"
#import "WARActivationExplorationModel.h"

#import "WARProfileOtherViewController.h"
#import "WARUserCenterViewController.h"

#import "WARActivationExplorationCell.h"

@interface WARActivationExplorationTrackListVC ()<UITableViewDelegate,UITableViewDataSource,WARActivationExplorationCellDelegate>

/** pushController */
@property (nonatomic, weak) UIViewController *pushController; 
/** 足迹数据数组 */
@property (nonatomic, copy) NSMutableArray <WARActivationExplorationLayout *>*trackLists;
/** 最后一条动态id */
@property (nonatomic, copy) NSString *lastFindId;  

/** 加载参数 */
/** 用户id */
@property (nonatomic, copy) NSString *accountId;
/** 纬度 */
@property (nonatomic, copy) NSString *lat;
/** 经度 */
@property (nonatomic, copy) NSString *lon;

@end

@implementation WARActivationExplorationTrackListVC

#pragma mark - System

- (instancetype)initWithAccountId:(NSString *)accountId
                              lat:(NSString *)lat
                              lon:(NSString *)lon
                   pushController:(UIViewController *)pushController {
    if (self = [super init]) {
        self.accountId = accountId;
        self.lat = lat;
        self.lon = lon;
        self.pushController = pushController;
    }
    return self;
}
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}
  
- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
        self.lastFindId = @"";
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager loadActivitionExpTrackListWithAccountId:self.accountId lastFindId:self.lastFindId compeletion:^(WARActivationExplorationModel *model, NSArray<WARActivationExplorationLayout *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err && results.count > 0) {
            strongSelf.lastFindId = model.lastFindId;
        }
        if (refresh) {
            [strongSelf.trackLists removeAllObjects];
            [strongSelf.trackLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
        } else {
            if (results.count > 0) {
                [strongSelf.trackLists addObjectsFromArray:[NSMutableArray arrayWithArray:results]];
            }
        }
        [strongSelf.tableView reloadData];
        [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
//    if (noMoreData) {
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.trackLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARActivationExplorationLayout *layout = self.trackLists[indexPath.row]; 
    WARActivationExplorationCell *cell = [WARActivationExplorationCell cellWithTableView:tableView];
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - WARActivationExplorationCellDelegate

-(void)activationExplorationCell:(WARActivationExplorationCell *)cell indexPath:(NSIndexPath *)indexPath accountId:(NSString *)accountId {
    if (self.pushController) {
//        if (self.isMine) {
//            WARUserCenterViewController *controller = [[WARUserCenterViewController alloc] init];
//            controller.isOtherfromWindow = YES;
//            [self.pushController.navigationController pushViewController:controller animated:YES];
//        } else {
            WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:accountId friendWay:@""];
            [self.pushController.navigationController pushViewController:controller animated:YES];
//        }
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (NSMutableArray<WARActivationExplorationLayout *> *)trackLists {
    if (!_trackLists) {
        _trackLists = [NSMutableArray <WARActivationExplorationLayout *>array];
    }
    return _trackLists;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.userInteractionEnabled = YES;
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
