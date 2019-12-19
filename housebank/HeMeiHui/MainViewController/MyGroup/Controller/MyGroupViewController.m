//
//  MyGroupViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyGroupViewController.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "GroupViewModel.h"
#import "SpGoodsDetailViewController.h"
#import "MyJumpHTML5ViewController.h"
#import "MyEmplyDataTableViewCell.h"
#import "EmptyModel.h"
@interface MyGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * groupTableView;
@property (nonatomic, strong) GroupViewModel * viewModel;
@property (nonatomic, assign) NSInteger  openIndex;
@property (nonatomic, assign) NSInteger  jionIndex;
@end

@implementation MyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.groupTableView];
    [self.groupTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    
    self.openIndex = 1;
    self.jionIndex = 1;
    
    @weakify(self);
    /** 下拉刷新*/
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.openIndex = 1;
        self.jionIndex = 1;
        [[self.viewModel loadRequest_GroupPurchaseWithType:self.myGroupType == MyOpenGroup ? @"OPEN" : @"PART" pageNo:(self.myGroupType == MyOpenGroup? self.openIndex : self.jionIndex)]subscribeNext:^(NSMutableArray * x) {
            if (x.count == 0) {

                self.viewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
            }
            [self.groupTableView.mj_footer resetNoMoreData];
            [self.groupTableView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.groupTableView reloadData];
            });
        } error:^(NSError * _Nullable error) {
            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
        }];
    }];
    
    /** 上拉加载*/
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.myGroupType == MyOpenGroup) {
            self.openIndex ++;
        }else {
            self.jionIndex ++;
        }
        [[self.viewModel loadMoreRequest_GroupPurchaseWithType:self.myGroupType == MyOpenGroup ? @"OPEN" : @"PART" pageNo:(self.myGroupType == MyOpenGroup? self.openIndex : self.jionIndex)] subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.groupTableView.mj_footer endRefreshing];
                [self.groupTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.groupTableView.mj_footer endRefreshing];
                    [self.groupTableView reloadData];
                });
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    NSString * selectType = self.myGroupType == MyOpenGroup ? @"OPEN" : @"PART";
    @weakify(self);
    [[self.viewModel loadRequest_GroupPurchaseWithType:selectType pageNo:(self.myGroupType == MyOpenGroup? self.openIndex : self.jionIndex)] subscribeNext:^(NSMutableArray * x) {
        @strongify(self);
        if (x.count == 0) {
            self.viewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.groupTableView reloadData];
        });
    } error:^(NSError * _Nullable error) {
        NSString * errorAlert = [error.userInfo objectForKey:@"error"];
        [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
    }];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self.viewModel jx_modelAtIndexPath:indexPath];
    /** 加载空数据页面*/
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        MyEmplyDataTableViewCell *noRecordCell = [tableView dequeueReusableCellWithIdentifier:@"MyEmplyDataTableViewCell"];
        noRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [noRecordCell reloadString:@"您还没有拼团!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.groupTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier forIndexPath:indexPath];
    }
    [cell customViewWithData:model indexPath:indexPath];
    
    return (UITableViewCell *)cell;
}

- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    NSString * orderNo = [userInfo objectForKey:@"orderNo"];
    NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/my/group/detail?orderNo=%@", orderNo];
    MyJumpHTML5ViewController * HtmlVC = [[MyJumpHTML5ViewController alloc] init];
    HtmlVC.webUrl = strUrl;
    [self.navigationController pushViewController:HtmlVC animated:YES];
}

#pragma mark -- lazy load
- (UITableView *)groupTableView {
    if (!_groupTableView) {
        _groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT) style:UITableViewStylePlain];
        _groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        _groupTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _groupTableView;
}

- (GroupViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[GroupViewModel alloc]init];
    }
    return _viewModel;
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
