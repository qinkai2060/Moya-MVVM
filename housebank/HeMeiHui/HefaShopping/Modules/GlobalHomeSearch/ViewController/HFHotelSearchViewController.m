//
//  HFHotelSearchViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHotelSearchViewController.h"
#import "HFGlobalFamilyViewModel.h"
#import "WRNavigationBar.h"
#import "HFHotelSearchNarBarView.h"
#import "HFHotelSearchHomeView.h"
#import "HFHistoryModel.h"
@interface HFHotelSearchViewController ()<HFHotelSearchNarBarViewDelegate,HFHotelSearchHomeViewDelegate>
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@property(nonatomic,strong)HFHotelSearchHomeView *homeView;
@property(nonatomic,strong)HFHotelSearchNarBarView *titleView;
//@property(nonatomic,assign)HFHotelSearchViewControllerType type;
@end

@implementation HFHotelSearchViewController
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel withType:(HFHotelSearchViewControllerType)type{
    self.viewModel = viewModel;
//    self.type = type;
    if (self = [super initWithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_layoutNavigation {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor colorWithHexString:@"FF6600"]];
    [self wr_setNavBarShadowImageHidden:NO];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setNavBarShadowImageHidden:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [rightButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)hh_addSubviews {
   // self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.homeView];
    [self.titleView becomeVIPFirstResponse];
}
- (void)setUpKeyWord:(NSString *)keyWord {
    [self.titleView setUpKeyWord:keyWord];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.getKeyWordSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [self.viewModel.didScreenSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.titleView endEditing:YES];
    }];
}

- (void)hotelSearchNarBarView:(HFHotelSearchNarBarView *)barView keyWord:(NSString *)keyWord {
  
    if ([self.delegate respondsToSelector:@selector(hotelViewController:keyWord:)]) {
        
        [self.delegate hotelViewController:self keyWord:keyWord];
    }
    
      [self.viewModel.getKeyWordSubjc sendNext:keyWord];
      [self.navigationController popViewControllerAnimated:NO];
}
- (void)hotelSearchHomeView:(HFHotelSearchHomeView *)searchHomeView searchKey:(HFHistoryModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(hotelViewController:keyWord:)]) {
        
        [self.delegate hotelViewController:self keyWord:model.historyStr];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (HFHotelSearchNarBarView *)titleView {
    if(!_titleView) {
        _titleView = [[HFHotelSearchNarBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-35-15-15-10, 30) WithViewModel:self.viewModel];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _titleView.layer.cornerRadius = 15;
        _titleView.layer.masksToBounds = YES;
        _titleView.delegate = self;
    }
    return _titleView;
}
- (HFHotelSearchHomeView *)homeView {
    if (!_homeView) {
        _homeView = [[HFHotelSearchHomeView alloc] initWithFrame:self.view.bounds WithViewModel:self.viewModel];
        _homeView.delegate = self;

    }
    return _homeView;
}
@end
