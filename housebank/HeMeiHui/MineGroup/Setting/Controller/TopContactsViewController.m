//
//  TopContactsViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "TopContactsViewController.h"
#import "TopContactsView.h"
#import "EditTopContactsViewController.h"

@interface TopContactsViewController ()
@property (nonatomic, strong) TopContactsView *topContactsView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *arrTabel;
@end

@implementation TopContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    _currentPage = 1;
    [_topContactsView.tableView.mj_header beginRefreshing];
}
- (void)setUI{
    self.title = @"常用联系人";
    [self.view addSubview:self.topContactsView];
}

- (void)requestQueryContactsList{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"pageNum":@(_currentPage),
                          @"pageSize":@"20"
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/member/queryContactsList"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_topContactsView.tableView.mj_header endRefreshing];
        [_topContactsView.tableView.mj_footer endRefreshing];

        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
                [SVProgressHUD dismiss];
             NSArray *arr = [NSArray modelArrayWithClass:[TopContactsModel class] json:[NSMutableArray arrayWithArray:[[[dic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"list"]]];
            if (_currentPage == 1) {
                _arrTabel = [NSMutableArray arrayWithArray:arr];
                 _topContactsView.arrDateSoure =  [NSMutableArray arrayWithArray:_arrTabel];
            } else {
                [_arrTabel addObjectsFromArray:arr];
                _topContactsView.arrDateSoure = [NSMutableArray arrayWithArray:_arrTabel];
            }
           
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_topContactsView.tableView.mj_header endRefreshing];
        [_topContactsView.tableView.mj_footer endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
- (TopContactsView *)topContactsView{
    if (!_topContactsView) {
        _topContactsView = [[TopContactsView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88)];
        __weak typeof (self) weakself = self;
        //新建联系人
        _topContactsView.createBlock = ^{
            [weakself createBlockAction];
        };
        _topContactsView.cellBlock = ^(TopContactsModel * _Nonnull model) {
            [weakself cellBlock:model];
        };
        
        _topContactsView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            [self requestQueryContactsList];
        }];
        // 上拉刷新
        _topContactsView.tableView.mj_footer =
        [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _currentPage++;
            [self requestQueryContactsList];
        }];

    }
    return _topContactsView;
}

/**
 编辑

 @param model 传过去的model
 */
- (void)cellBlock:(TopContactsModel *)model{
    EditTopContactsViewController *edit = [[EditTopContactsViewController alloc] init];
    edit.ntitle = @"编辑常用联系人";
    edit.model = model;
    WEAKSELF
    edit.refrenshBlock = ^{
        [weakSelf.topContactsView.tableView.mj_header beginRefreshing];

    };
    [self.navigationController pushViewController:edit animated:YES];
}
/**
 新建联系人跳转
 */
- (void)createBlockAction{
    EditTopContactsViewController *edit = [[EditTopContactsViewController alloc] init];
    edit.ntitle = @"新建常用联系人";
    WEAKSELF
    edit.refrenshBlock = ^{
        [weakSelf.topContactsView.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:edit animated:YES];
}
@end
