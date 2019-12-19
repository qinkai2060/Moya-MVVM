//
//  ManageSortViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageSortViewController.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "ManageSortTableViewCell.h"
#import "EmptyModel.h"
#import "HandleEventDefine.h"
#import "ManageOwnModel.h"
#import "ManageOwnViewModel.h"
#import "CloudCodeView.h"
#import "CloudManageViewModel.h"
#import "HFYDWeiDDetialViewController.h"
@interface ManageSortViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * sortTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) NSInteger soldIndex;
@property (nonatomic, strong) ManageOwnViewModel * viewModel;
@property (nonatomic, strong) CloudCodeView    * cloudCodeView; // 二维码
@property (nonatomic, strong) CloudManageViewModel * manageViewModel;
@end

@implementation ManageSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.sortTableView];
    [self.sortTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    [self.sortTableView registerNib:[UINib nibWithNibName:@"ManageSortTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManageSortTableViewCell"];

    
    @weakify(self);
    self.sortTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.soldIndex = 1;
        [[self.viewModel loadRequest_sellDataWithShopID:objectOrEmptyStr(self.shopID) Type:@"1" pageNo:self.soldIndex]subscribeNext:^(NSMutableArray * x) {
            @strongify(self);
            if (x.count == 0) {
                self.dataSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
            }
            self.dataSource = x;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sortTableView reloadData];
            });
            [self.sortTableView.mj_footer resetNoMoreData];
            [self.sortTableView.mj_header endRefreshing];
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.sortTableView.mj_header endRefreshing];
        }];
    }];
    
    /** 上拉加载*/
    self.sortTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.soldIndex ++;
        [[self.viewModel loadMore_sellDataWithShopID:objectOrEmptyStr(self.shopID) Type:@"1" pageNo:self.soldIndex] subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.sortTableView.mj_footer endRefreshing];
                [self.sortTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            self.dataSource = dataSource;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.sortTableView reloadData];
                    [self.sortTableView.mj_footer endRefreshing];
                });
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
        }];
    }];
    
    self.viewModel.shopID = self.shopID;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"微店管理";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
    
    UIButton * item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item1];
    item1.frame = CGRectMake(kWidth-30-50, 0, 40, 40);
    item1.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item1 setImage:[UIImage imageNamed:@"cloud_tui"] forState:UIControlStateNormal];
    
    UIButton * item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item2];
    item2.frame = CGRectMake(kWidth-30-15, 0, 40, 40);
    item2.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item2 setImage:[UIImage imageNamed:@"cloudCord"] forState:UIControlStateNormal];
    
    @weakify(self);
    [[item1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [HFYDWeiDDetialViewController showTuiG:objectOrEmptyStr(self.shopID) vc:self itemModel:self.itemModel];
    }];
    
    [[item2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [HFYDWeiDDetialViewController showQRCode:objectOrEmptyStr(self.shopID) vc:self itemModel:self.itemModel];
    }];
    
    [self.sortTableView.mj_header beginRefreshing];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManageSortTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManageSortTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:TopProduct]) {
        @weakify(self);
        [[self.viewModel TopShopWithProductID:objectOrEmptyStr([userInfo objectForKey:@"microProductId"])]subscribeNext:^(NSString * x) {
            @strongify(self);
            if (x) {
                [SVProgressHUD showSuccessWithStatus:@"商品置顶成功!"];
                [self.sortTableView.mj_header beginRefreshing];
            }
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD showSuccessWithStatus:@"商品置顶失败!"];
        }];
    }
}

#pragma mark -- lazy load
- (UITableView *)sortTableView {
    if (!_sortTableView) {
        _sortTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT) style:UITableViewStylePlain];
        _sortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sortTableView.delegate = self;
        _sortTableView.dataSource = self;
        _sortTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _sortTableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (ManageOwnViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[ManageOwnViewModel alloc]init];
    }
    return _viewModel;
}

- (CloudManageViewModel *)manageViewModel {
    if (!_manageViewModel) {
        _manageViewModel = [[CloudManageViewModel alloc]init];
    }
    return _manageViewModel;
}

- (CloudCodeView *)cloudCodeView {
    if (!_cloudCodeView) {
        _cloudCodeView = [[CloudCodeView alloc]init];
        _cloudCodeView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:_cloudCodeView];
    }
    return _cloudCodeView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
