//
//  WeiShopSelectGoodsController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WeiShopSelectGoodsController.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "ManageSelectViewModel.h"
#import "EmptyModel.h"
#import "ManageSelectShopModel.h"
#import "ManageShopViewCellTableViewCell.h"
#import "MyJumpHTML5ViewController.h"
@interface WeiShopSelectGoodsController ()<UITableViewDelegate, UITableViewDataSource,AddSelectActionDelegate>
@property (nonatomic, strong) UITableView * shopTableView;
@property (nonatomic, strong) ManageSelectViewModel * viewModel;
@end

@implementation WeiShopSelectGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.shopTableView];
    [self.shopTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    
    @weakify(self);
    self.shopTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.viewModel loadRequest_product_list:self.shopID]subscribeNext:^(NSMutableArray * x) {
           @strongify(self);
            if (x.count == 0) {
                self.viewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shopTableView reloadData];
            });
            [self.shopTableView.mj_footer resetNoMoreData];
            [self.shopTableView.mj_header endRefreshing];
        }error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.shopTableView.mj_header endRefreshing];
        }];
    }];
    
    self.shopTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.viewModel loadMore_productList:objectOrEmptyStr(self.shopID)]subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.shopTableView.mj_footer endRefreshing];
                [self.shopTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.shopTableView reloadData];
                    [self.shopTableView.mj_footer endRefreshing];
                });
            }
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.shopTableView.mj_footer endRefreshing];
        }];
    }];
    self.viewModel.shopID = self.shopID;
    [self.shopTableView.mj_header beginRefreshing];
    
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
        [noRecordCell reloadString:@"您还没有云仓选货!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.shopTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    
    if ([cell isKindOfClass:[ManageShopViewCellTableViewCell class]]) {
        __weak ManageShopViewCellTableViewCell* newCell = (ManageShopViewCellTableViewCell *)cell;
        newCell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell customViewWithData:model indexPath:indexPath];
    
     return (UITableViewCell *)cell;
}

#pragma mark AddSelectActionDelegate
- (void)canActionTheAddToWeiShopTuple:(RACTuple *)tuple error:(errorBlock)errorBlock {
    /** 商品上架*/
    NSString * productID = tuple.first;
    @weakify(self);
    [[self.viewModel putAway_selectShop:objectOrEmptyStr(self.shopID) productArray:@[@{@"productId":objectOrEmptyStr(productID)}]]subscribeNext:^(NSString * x) {
        if (x) {
            [SVProgressHUD showSuccessWithStatus:@"商品上架成功!"];
            if (errorBlock) {
                errorBlock(YES);
                @strongify(self);
                [self.shopTableView.mj_header beginRefreshing];
            }
        }
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"商品上架失败!"];
        if (errorBlock) {
            errorBlock(NO);
        }
    }];
}

- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/cloudShop/goodsDetails?productId=%@&mocriShopId=%@&noBuy=1",[userInfo objectForKey:@"productID"],self.shopID];
    MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
    htmlVC.webUrl = strUrl;
    [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
    
}

#pragma mark -- lazy load
- (ManageSelectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ManageSelectViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)shopTableView {
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-45) style:UITableViewStylePlain];
        _shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        _shopTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _shopTableView;
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
