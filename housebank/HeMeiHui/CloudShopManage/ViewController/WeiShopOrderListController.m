//
//  WeiShopOrderListController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WeiShopOrderListController.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "ManageOrderViewModel.h"
#import "ManageHeaderView.h"
#import "ManageOrderFooterView.h"
#import "YunDianOrderDetailViewController.h"
#import "ManageLogisticsViewController.h"
#import "EmptyModel.h"
#import "ManageOrderModel.h"
@interface WeiShopOrderListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * orderTableView;
@property (nonatomic, strong) ManageOrderViewModel * viewModel;
@end

@implementation WeiShopOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.orderTableView];
    [self.orderTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    
    @weakify(self);
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.viewModel loadRequest_orderListWith]subscribeNext:^(NSMutableArray * x) {
            if (x.count == 0) {
                self.viewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.orderTableView reloadData];
            });
            [self.orderTableView.mj_footer resetNoMoreData];
            [self.orderTableView.mj_header endRefreshing];
        }error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.orderTableView.mj_header endRefreshing];
        }];
    }];
    
    /** 上拉加载*/
    self.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.viewModel loadRequestMore_orderListWith]subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.orderTableView.mj_footer endRefreshing];
                [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.orderTableView reloadData];
                    [self.orderTableView.mj_footer endRefreshing];
                });
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
        }];
    }];
    [self.orderTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel jx_numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel jx_numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel jx_heightAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self.viewModel jx_modelAtIndexPath:indexPath];
    
    /** 加载空数据页面*/
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        MyEmplyDataTableViewCell *noRecordCell = [tableView dequeueReusableCellWithIdentifier:@"MyEmplyDataTableViewCell"];
        noRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [noRecordCell reloadString:@"您还没有订单!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.orderTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell customViewWithData:model indexPath:indexPath];
    
    return (UITableViewCell *)cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ManageHeaderView * headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ManageHeaderView"];
    if(!headView) {
        headView = [[ManageHeaderView alloc]initWithReuseIdentifier:@"ManageHeaderView"];
    }
    if ([self judge_sourceHaveHeader]) {
        headView.sectionModel = self.viewModel.mutableSource[section];
        return headView;
    }
    return nil;
}

- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if([eventName isEqualToString:ManageOrder]) {
        NSInteger index = [[userInfo objectForKey:@"index"] integerValue];
        if (index < self.viewModel.mutableSource.count) {
            ManageOrderModel * itemModel = self.viewModel.mutableSource[index];
            YunDianOrderDetailViewController * orderVC = [[YunDianOrderDetailViewController alloc]init];
            orderVC.orderNo = objectOrEmptyStr(itemModel.orderNo);
            [self.navigationController pushViewController:orderVC animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ManageOrderFooterView * footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ManageOrderFooterView"];
    if(!footView) {
        footView = [[ManageOrderFooterView alloc]initWithReuseIdentifier:@"ManageOrderFooterView"];
    }
    if ([self judge_sourceHaveHeader]) {
        footView.footerModel = self.viewModel.mutableSource[section];
        return footView;
    }
    return nil;
}

/** 判断需要展示分区*/
- (BOOL)judge_sourceHaveHeader {
    if (self.viewModel.mutableSource.count > 0 && [self.viewModel.mutableSource[0] isKindOfClass:[ManageOrderModel class]]) {
        return YES;
    }else {
        return NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([self judge_sourceHaveHeader]?45:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ([self judge_sourceHaveHeader]?60:0);
}

#pragma mark -- lazy load
- (ManageOrderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ManageOrderViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)orderTableView {
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-45) style:UITableViewStylePlain];
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _orderTableView;
}
@end
