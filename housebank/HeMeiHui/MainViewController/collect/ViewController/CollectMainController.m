//
//  CollectMainController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectMainController.h"
#import "CollectProductController.h"
#import "CollectShopViewController.h"
#import "CollectGlobalHomeViewController.h"
#import <VTMagic/VTMagic.h>
@interface CollectMainController ()<VTMagicViewDelegate,VTMagicViewDataSource>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray * titles ;
@property (nonatomic, strong) NSArray * controllers ;
@end

@implementation CollectMainController

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
    self.customNavBar.title = @"我的收藏";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
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
        [mentItem setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateSelected];
        [mentItem setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        mentItem.titleLabel.font = kFONT(15);
    }
    return mentItem;
}

- (void)setSelectIndex:(SelectIndex)selectIndex {
    _selectIndex = selectIndex;
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
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.itemWidth = kWidth/3;
        _magicController.magicView.delegate = self;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.sliderWidth = 28;
        _magicController.magicView.scrollEnabled = NO;
    }
    return _magicController;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"商品",@"店铺",@"全球家"];
    }
    return _titles;
}

- (NSArray *)controllers {
    if (!_controllers) {
        CollectProductController *collectProVC = [[CollectProductController alloc]init];
        CollectShopViewController *collectShopVC = [[CollectShopViewController alloc]init];
        CollectGlobalHomeViewController *globalHomeVC = [[CollectGlobalHomeViewController alloc]init];
        _controllers = @[collectProVC,collectShopVC,globalHomeVC];
    }
    return _controllers;
}

@end
