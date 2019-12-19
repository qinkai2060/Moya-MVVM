//
//  CloudWeiShopMainController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudWeiShopMainController.h"
#import <VTMagic/VTMagic.h>
#import "WeiShopOrderListController.h"
#import "WeiShopOwnController.h"
#import "WeiShopSelectGoodsController.h"
#import "CloudCodeView.h"
#import "CloudManageViewModel.h"
#import "HFYDWeiDDetialViewController.h"
@interface CloudWeiShopMainController ()<VTMagicViewDelegate,VTMagicViewDataSource>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray * titles ;
@property (nonatomic, strong) NSArray * controllers ;
@property (nonatomic, strong) CloudCodeView    * cloudCodeView; // 二维码
@property (nonatomic, strong) CloudManageViewModel * viewModel;
@end

@implementation CloudWeiShopMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.magicController];
    self.magicController.magicView.frame = CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT);
    [self.view addSubview:_magicController.magicView];
    
    [_magicController.magicView reloadData];
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
}

#pragma mark VTMagicViewDelegate
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    return self.titles;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    static NSString *itemIdentifier = @"itemId";
    UIButton *mentItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!mentItem){
        mentItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [mentItem setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [mentItem setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        mentItem.titleLabel.font = kFONT(15);
    }
    return mentItem;
}

- (void)setCloudSelectIndex:(CloudSelectInex)cloudSelectIndex {
    _cloudSelectIndex = cloudSelectIndex;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    return [self.controllers objectAtIndex:pageIndex];
}

#pragma mark -- lazy load
- (VTMagicController *)magicController{
    if (!_magicController){
        _magicController = [[VTMagicController alloc]init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor colorWithHexString:@"F3344A"];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.itemWidth = kWidth/3;
        _magicController.magicView.delegate = self;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.sliderWidth = 68;
        _magicController.magicView.scrollEnabled = YES;
        _magicController.magicView.itemScale = 1.15;//点击字体放大
        _magicController.magicView.separatorHidden = YES;//是否隐藏导航分割线
    }
    return _magicController;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"云仓选货",@"我的微店",@"订单列表"];
    }
    return _titles;
}

- (NSArray *)controllers {
    if (!_controllers) {
        WeiShopSelectGoodsController *selctGoodsVC = [[WeiShopSelectGoodsController alloc]init];
        WeiShopOwnController *ownVC = [[WeiShopOwnController alloc]init];
        WeiShopOrderListController *orderListVC = [[WeiShopOrderListController alloc]init];
        selctGoodsVC.shopID = self.shopID;
        ownVC.shopID = self.shopID;
        ownVC.itemModel = self.itemModel;
        orderListVC.shopID = self.shopID;
        _controllers = @[selctGoodsVC,ownVC,orderListVC];
    }
    return _controllers;
}

- (CloudCodeView *)cloudCodeView {
    if (!_cloudCodeView) {
        _cloudCodeView = [[CloudCodeView alloc]init];
        _cloudCodeView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:_cloudCodeView];
    }
    return _cloudCodeView;
}

- (CloudManageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CloudManageViewModel alloc]init];
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
