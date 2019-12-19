//
//  GroupMainViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "GroupMainViewController.h"
#import <VTMagic/VTMagic.h>
#import "MyGroupViewController.h"
@interface GroupMainViewController ()<VTMagicViewDelegate,VTMagicViewDataSource>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray * titles ;
@property (nonatomic, strong) NSArray * controllers ;
@end

@implementation GroupMainViewController

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
    self.customNavBar.title = @"我的拼团";
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
        _magicController.magicView.itemWidth = kWidth/2;
        _magicController.magicView.delegate = self;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.sliderWidth = 28;
        _magicController.magicView.scrollEnabled = YES;
    }
    return _magicController;
}

- (NSArray *)titles {

    if (!_titles) {
        _titles = @[@"我开的团",@"我参加的团"];
    }
    return _titles;
}
- (NSArray *)controllers {
    if (!_controllers) {
        MyGroupViewController *collectProVC = [[MyGroupViewController alloc]init];
        collectProVC.myGroupType = MyOpenGroup;
        MyGroupViewController *collectShopVC = [[MyGroupViewController alloc]init];
        collectShopVC.myGroupType = MyJoinGroup;
        _controllers = @[collectProVC,collectShopVC];
    }
    return _controllers;
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
