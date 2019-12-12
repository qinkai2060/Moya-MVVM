//
//  WARDiaryDetailViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/11.
//

#import "WARDiaryDetailViewController.h"
#import "WARMacros.h"
#import "WARDiaryDetailHeaderView.h"
#import "WARNewUserDiaryModel.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"

@interface WARDiaryDetailViewController ()<WARDiaryDetailHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource>
/** headerView */
@property (nonatomic, strong) WARDiaryDetailHeaderView *headerView;
/** tableView */
@property (nonatomic, strong) UITableView* tableView;
/** comments */
@property (nonatomic, strong) NSMutableArray *comments;

@property (nonatomic, strong) WARNewUserDiaryMoment *moment;
@property (nonatomic, copy) NSString *type;
@end

@implementation WARDiaryDetailViewController

#pragma mark - System

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initSubviews {
    [super initSubviews];
    self.title = [NSString stringWithFormat:@"详情"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view); 
    }];
    
    CGFloat headerViewHeight = self.moment.friendMomentLayout.cellHeight + 60;
    
    self.headerView = [[WARDiaryDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, headerViewHeight) moment:self.moment type:self.type];
    self.headerView.delegate = self; 
    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
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

#pragma mark - Private

#pragma mark - getter mothed

- (void)configMoment:(WARNewUserDiaryMoment *)moment {
    
    WARNewUserDiaryMoment *copyMoment = [moment copy];
    copyMoment.momentShowType = WARMomentShowTypeFriendDetail;
    
    WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [[WARFriendMomentLayout alloc] init];
    NSMutableArray *pageLayouts = [NSMutableArray array];
    for (WARFeedPageModel *pageM in copyMoment.pageContents) {
        WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
        [layout configComponentLayoutsWithPage:pageM contentScale:kContentScale momentShowType:(WARMomentShowTypeFriendDetail) isMultilPage:copyMoment.pageContents.count > 1];
        [pageLayouts addObject:layout];
    }
    friendMomentLayout.feedLayoutArr = pageLayouts;
    copyMoment.friendMomentLayout = friendMomentLayout;
    
    friendMomentLayout.moment = copyMoment;
    
    _moment = copyMoment;
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
//        @weakify(self)
//        [_tableView war_headerRefreshBlock:^{
//            @strongify(self)
//            self.lastId = @"";
//            [self tableViewDidRefreshed];
//            [self loadMoreComments:NO];
//
//        }];
//        [_tableView war_beginRefresh];
//        [_tableView war_footerRefreshBlock:^{
//            @strongify(self)
//            [self loadMoreComments:YES];
//        }];
    }
    return _tableView;
}

- (NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

@end
