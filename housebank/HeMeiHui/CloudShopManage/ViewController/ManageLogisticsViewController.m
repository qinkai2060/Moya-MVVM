//
//  ManageLogisticsViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageLogisticsViewController.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "ManageLogisticsViewModel.h"
#import "ManageLogticsHeadView.h"
#import "EmptyModel.h"
@interface ManageLogisticsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * logistcsTableView;
@property (nonatomic, strong) ManageLogisticsViewModel * viewModel;
@end

@implementation ManageLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.logistcsTableView];
    [self.logistcsTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    @weakify(self);
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.logistcsTableView reloadData];
    }];
    
    [RACObserve(self, logisticsID)subscribeNext:^(id  _Nullable x) {
        @weakify(self);
        [[self.viewModel loadRequest_logisticsDetailSource:objectOrEmptyStr(self.logisticsID)]subscribeNext:^(NSArray * x) {
            @strongify(self);
            if (x.count == 0) {
                self.viewModel.dataSource = @[[EmptyModel new]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.logistcsTableView reloadData];
            });
        } error:^(NSError * _Nullable error) {
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"物流详情";
    self.customNavBar.titleLabelColor= [UIColor colorWithHexString:@"#000000"];
    self.customNavBar.titleLabelFont=PFR18Font;
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
        noRecordCell.imageString = @"logistics_empty";
        [noRecordCell reloadString:@"暂未查到物流信息"];
        self.logistcsTableView.scrollEnabled = NO;
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.logistcsTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
        self.logistcsTableView.scrollEnabled = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell customViewWithData:model indexPath:indexPath];
    
    return (UITableViewCell *)cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ManageLogticsHeadView * headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ManageLogticsHeadView"];
    if(!headView) {
        headView = [[ManageLogticsHeadView alloc]initWithReuseIdentifier:@"ManageLogticsHeadView"];
    }
    headView.logticsModel = self.viewModel.dataSource[0];
    ManageLogticsModel * logticsModel = self.viewModel.dataSource[0];
    if (logticsModel.productImage) {
        [headView passScrollDataSource:logticsModel.productImage];
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 230;
}

#pragma mark -- lazy load
- (UITableView *)logistcsTableView {
    if (!_logistcsTableView) {
        _logistcsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT) style:UITableViewStylePlain];
        _logistcsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _logistcsTableView.delegate = self;
        _logistcsTableView.dataSource = self;
        _logistcsTableView.backgroundColor = [UIColor whiteColor];
    }
    return _logistcsTableView;
}
- (ManageLogisticsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ManageLogisticsViewModel alloc]init];
    }
    return _viewModel;
}
@end
