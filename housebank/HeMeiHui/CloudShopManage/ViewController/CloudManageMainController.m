//
//  CloudManageMainController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudManageMainController.h"
#import "CloudManageViewModel.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "CloudManageBtn.h"
#import "AddCloudBackView.h"
#import "CloudCodeView.h"
#import "CloudAlertView.h"
#import "CloudWeiShopMainController.h"
#import "MyJumpHTML5ViewController.h"
#import "CreateWeiShopViewController.h"
#import "ShareTools.h"
#import "CloudManageModel.h"
#import "HFYDWeiDDetialViewController.h"
#import "HFYDDetialViewController.h"
#import "CloudManageShopViewController.h"
@interface CloudManageMainController ()<UITableViewDelegate,UITableViewDataSource,ShareToolDelegete>
@property (nonatomic, strong) CloudManageViewModel * viewModel;
@property (nonatomic, strong) UITableView      * mangeTableView;
@property (nonatomic, strong) CloudManageBtn   * addShopBtn;   // 点击增加店铺按钮
@property (nonatomic, strong) AddCloudBackView * cloudBackView;
@property (nonatomic, strong) CloudCodeView    * cloudCodeView; // 二维码
@property (nonatomic, strong) CloudAlertView   * alertView;
@end

@implementation CloudManageMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self registDataSourceView];
    
    @weakify(self);
    //    [self.viewModel.refreshUISubject subscribeNext:^(NSArray * x) {
    //        @strongify(self);
    //        [self.mangeTableView reloadData];
    //    }];
    //
    self.mangeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[self.viewModel loadRequest_ShopList]subscribeNext:^(NSArray * x) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.viewModel.dataSource = x;
                [self judge_toRMGrade];
                [self.mangeTableView reloadData];
                [self.mangeTableView.mj_header endRefreshing];
            });
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.mangeTableView.mj_header endRefreshing];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.cloudCodeView) [self.cloudBackView removeFromSuperview];
}

/** 判断是不是RM门店*/
- (void)judge_toRMGrade {
    if(self.RMGrade > 1) {
        self.addShopBtn.hidden = NO;
        self.mangeTableView.frame = CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-65);
    }else {
        self.addShopBtn.hidden = YES;
        self.mangeTableView.frame = CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT);
    }
    if (self.viewModel.dataSource.count == 0 && self.RMGrade > 1) {
        // 添加无店铺界面
        [self.cloudBackView popViewAnimation];
    }
}

// 判断数据源店铺类型
- (void)judgeShopTypes {
    shopTypes types = [self.viewModel judgeShopTypes];
    switch (types) {
        case NoWeiShop:
        {
            // 添加无店铺界面
            [self.cloudBackView popViewAnimation];
        }
            break;
            
        case haveWeiShop:
        {
            NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/xls/shop/guide"];
            MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
            htmlVC.webUrl = strUrl;
            [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"云店管理";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
    [self.mangeTableView.mj_header beginRefreshing];
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
        [noRecordCell reloadString:@"您还没有云店店铺!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.mangeTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell customViewWithData:model indexPath:indexPath];
    return (UITableViewCell *)cell;
}

// 路由操作
- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    if ([eventName isEqualToString:ClodeCode]) {
        CloudManageItemModel * itemModel = [userInfo objectForKey:@"model"];
        [self judgeShopType:itemModel withEvent:ClodeCode];
        
    }else if([eventName isEqualToString:CloudePushManage]) {
        // 看是微店还是OTO
        if([[userInfo objectForKey:@"shopType"] isEqualToString:@"2"]) {
            NSString * state = [userInfo objectForKey:@"state"];
            if ([state isEqualToString:@"3"] || [state isEqualToString:@"5"]) {
                /** OTO*/
                NSString *strUrl = [NSString stringWithFormat:@"/html/house/oto/shop_manage_love.html?stealAge=0&shopsId=%@",[userInfo objectForKey:@"shopID"]];
                MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
                htmlVC.webUrl = strUrl;
                [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
            }else if([state isEqualToString:@"2"]){
                NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/xls/shop/register?stealAge=0&shopsId=%@",[userInfo objectForKey:@"shopID"]];
                MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
                htmlVC.webUrl = strUrl;
                [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
            }
            else if([state isEqualToString:@"0"] || [state isEqualToString:@"1"]){
                /** OTO*/
                NSString *strUrl = [NSString stringWithFormat:@"/html/house/oto/reg-progress.html?shopType=2&stealAge=0&shopsId=%@",[userInfo objectForKey:@"shopID"]];
                MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
                htmlVC.webUrl = strUrl;
                [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
            }
        }else if ([[userInfo objectForKey:@"shopType"]isEqualToString:@"3"]) {
            /** 微店*/
            /**判断审核状态*/
//            NSString * state = [userInfo objectForKey:@"state"];
//            if([state isEqualToString:@"3"] || [state isEqualToString:@"5"]) {
//                // 店铺详情
//                CloudWeiShopMainController * mainVC = [[CloudWeiShopMainController alloc]init];
//                mainVC.shopID = [userInfo objectForKey:@"shopID"];
//                mainVC.itemModel = objectOrEmptyStr([userInfo objectForKey:@"itemModel"]);
//                [self.navigationController pushViewController:mainVC animated:YES];
//            }else if([state isEqualToString:@"2"]){
//                CreateWeiShopViewController * weiVC = [[CreateWeiShopViewController alloc]init];
//                weiVC.reason = objectOrEmptyStr([userInfo objectForKey:@"auditRemark"]);
//                weiVC.itemModel = objectOrEmptyStr([userInfo objectForKey:@"itemModel"]);
//                weiVC.createType = ChangeShop;
//                weiVC.canEdit = YES;
//                [[UIViewController visibleViewController].navigationController pushViewController:weiVC animated:YES];
//            }else if ([state isEqualToString:@"0"] || [state isEqualToString:@"1"]){
//                NSString *strUrl = [NSString stringWithFormat:@"/html/house/oto/reg-progress.html?shopType=3&stealAge=0&shopsId=%@",objectOrEmptyStr([userInfo objectForKey:@"shopID"])];
//                MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
//                htmlVC.webUrl = strUrl;
//                [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
//            }
            
            CloudManageShopViewController * manageShop = [[CloudManageShopViewController alloc]init];
            manageShop.reason = objectOrEmptyStr([userInfo objectForKey:@"auditRemark"]);
            manageShop.itemModel = objectOrEmptyStr([userInfo objectForKey:@"itemModel"]);
            [self.navigationController pushViewController:manageShop animated:YES];

 
        }
    }else if([eventName isEqualToString:Cloudshare]) {
        CloudManageItemModel * itemModel = [userInfo objectForKey:@"model"];
        [self judgeShopType:itemModel withEvent:Cloudshare];
    }
}

- (void)judgeShopType:(CloudManageItemModel *)itemModel withEvent:(NSString *)event{
    
    if ([itemModel.shopType isEqualToString:@"2"]) {
        // OTO
        if ([event isEqualToString:ClodeCode]) {
            // 二维码
            [HFYDDetialViewController showQRCode:objectOrEmptyStr(itemModel.shopId) vc:self itemModel:itemModel];
        }else if([event isEqualToString:Cloudshare]) {
            [HFYDDetialViewController showTuiG:objectOrEmptyStr(itemModel.shopId) vc:self itemModel:itemModel];
        }
        
    }else if ([itemModel.shopType isEqualToString:@"3"]) {
        // 微店
        if ([event isEqualToString:ClodeCode]) {
            // 二维码
            [HFYDWeiDDetialViewController showQRCode:objectOrEmptyStr(itemModel.shopId) vc:self itemModel:itemModel];
        }else if([event isEqualToString:Cloudshare]) {
            [HFYDWeiDDetialViewController showTuiG:objectOrEmptyStr(itemModel.shopId) vc:self itemModel:itemModel];
        }
    }
}

- (void)addShopBtnView {
    [self.view addSubview:self.addShopBtn];
    [self.addShopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@40);
    }];
    @weakify(self);
    [[self.addShopBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self judgeShopTypes];
    }];
}

- (void)registDataSourceView {
    [self.view addSubview:self.mangeTableView];
    [self.mangeTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    [self addShopBtnView];
}

#pragma mark -- lazy load
- (CloudManageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CloudManageViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)mangeTableView {
    if (!_mangeTableView) {
        _mangeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-65) style:UITableViewStylePlain];
        _mangeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mangeTableView.delegate = self;
        _mangeTableView.dataSource = self;
        _mangeTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _mangeTableView;
}

- (CloudManageBtn *)addShopBtn {
    if (!_addShopBtn) {
        _addShopBtn = [[CloudManageBtn alloc]init];
        [_addShopBtn initWithLayerWidth:kWidth-20 font:16 height:40];
        [_addShopBtn setTitle:@"+ 新增店铺" forState:UIControlStateNormal];
    }
    return _addShopBtn;
}

- (AddCloudBackView *)cloudBackView {
    if (!_cloudBackView) {
        _cloudBackView = [[AddCloudBackView alloc]init];
        @weakify(self);
        _cloudBackView.missBlock = ^{
            @strongify(self);
            if (self.viewModel.dataSource.count == 0 && self.RMGrade > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.cloudBackView closeAnimation];
            }
        };
    }
    return _cloudBackView;
}

- (CloudCodeView *)cloudCodeView {
    if (!_cloudCodeView) {
        _cloudCodeView = [[CloudCodeView alloc]init];
        _cloudCodeView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:_cloudCodeView];
    }
    return _cloudCodeView;
}

- (CloudAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[CloudAlertView alloc]init];
        _alertView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
    }
    return _alertView;
}

@end
