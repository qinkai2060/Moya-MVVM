//
//  HFAdreesListViewController.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAdreesListViewController.h"
#import "HFAddressListView.h"

#import "WRNavigationBar.h"
#import "HFEditingAddressViewController.h"
@interface HFAdreesListViewController ()
@property (nonatomic,strong)HFAddressListView *listView;

@property (nonatomic,strong)HFAddressModel  *model;
@end

@implementation HFAdreesListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.addressListComand execute:nil];

    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    [self wr_setNavBarBackgroundAlpha:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    [self.view addSubview:self.listView];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage: [UIImage imageNamed:@"back-b"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
    [self bindViewModel];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.translucent = NO;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)bindViewModel {
    @weakify(self)
    [self.viewModel.editingOriginSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            HFEditingAddressViewController *editingVC = [[HFEditingAddressViewController alloc] initWithViewModel:self.viewModel];
            editingVC.view.backgroundColor = [UIColor whiteColor];
            [editingVC editingOringModel:(HFAddressModel*)x];
            self.viewModel.addressid = ((HFAddressModel*)x).ids;
            editingVC.source = HFEditingEnterSourceEditing;
            [self.navigationController pushViewController:editingVC animated:YES];
        }

    }];
    
    [self.viewModel.addNewaddressSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)

            HFEditingAddressViewController *editingVC = [[HFEditingAddressViewController alloc] init];
            editingVC.view.backgroundColor = [UIColor whiteColor];
//            [editingVC editingOringModel:(HFAddressModel*)x];
            editingVC.source = HFEditingEnterSourceAdd;
            [self.navigationController pushViewController:editingVC animated:YES];
        
    }];
    [self.viewModel.didSelectSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            HFAddressModel *model = (HFAddressModel*)x;
            self.viewModel.addressid = model.ids;
            self.model  = model;
            [self.viewModel.defualtAddressCommnd execute:nil];
        }

    }];
    [self.viewModel.resultSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(backMangeAddress:)]) {
            [self.delegate backMangeAddress:self.model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (HFAddressListView *)listView {
    if (!_listView) {

        _listView = [[HFAddressListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) WithViewModel:self.viewModel];
    }
    return _listView;
}
- (HFAddressListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFAddressListViewModel alloc] init];
    }
    return _viewModel;
}

@end
