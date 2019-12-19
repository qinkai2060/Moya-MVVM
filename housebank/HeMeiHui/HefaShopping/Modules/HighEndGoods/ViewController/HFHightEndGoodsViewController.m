//
//  HFHightEndGoodsViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHightEndGoodsViewController.h"
#import "WRNavigationBar.h"
#import "HFHightEndGoodsViewModel.h"
#import "HFHightEndGoodsMainView.h"
#import "HFDataModel.h"

@interface HFHightEndGoodsViewController ()
@property(nonatomic,strong)HFHightEndGoodsViewModel *viewModel;
@property(nonatomic,strong)HFHightEndGoodsMainView *mainView;
@end

@implementation HFHightEndGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.mainView];
    [HFKefuButton kefuBtn:self];
    [SVProgressHUD show];
    [self.viewModel.dataCommand execute:nil];
    @weakify(self)
    [self.viewModel.didSelectSubjc subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        HFDataModel *dataModel = (HFDataModel*)x;
        if (x != nil) {
            GetProductListByConditionModel *list = [[GetProductListByConditionModel alloc] init];
            list.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
            SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] initWithModel:list];
            vc.goodsType=DirectSupplyGoodsDetailStyle;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.viewModel.shareSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
            [ShareTools shareWithContent:[ShareTools dict:x]];
        }else {
            [SVProgressHUD showWithStatus:@"分享失败"];
        }
    }];


}
- (void)setNav {
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self wr_setNavBarShadowImageHidden:NO];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 20)];
    titleView.image = [UIImage imageNamed:@"highEnd_title"];
    self.navigationItem.titleView = titleView;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"highEnd_title_forward"] style:UIBarButtonItemStyleDone target:self action:@selector(fowardClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HMH_back_light"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

- (void)fowardClick {
     [self.viewModel.shareCommand execute:nil];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (HFHightEndGoodsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFHightEndGoodsViewModel alloc] init];
    }
    return _viewModel;
}
- (HFHightEndGoodsMainView *)mainView {
    if (!_mainView) {
        CGFloat navH = (IS_iPhoneX)? 64+24:64;
        _mainView = [[HFHightEndGoodsMainView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) WithViewModel:self.viewModel];
    }
    return _mainView;
}
@end
