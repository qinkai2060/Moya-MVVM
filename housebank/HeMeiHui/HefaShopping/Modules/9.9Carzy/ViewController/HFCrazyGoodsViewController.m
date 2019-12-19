//
//  HFCrazyGoodsViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCrazyGoodsViewController.h"
#import "HFFamousGoodsViewModel.h"
#import "HFFamousGoodsMainView.h"
#import "WRNavigationBar.h"
#import "HFFamousGoodsModel.h"
#import "HFFamousGoodsBannerModel.h"
#import "HFShouYinViewController.h"
@interface HFCrazyGoodsViewController ()
@property(nonatomic,strong)HFFamousGoodsViewModel *viewModel;
@property(nonatomic,strong)HFFamousGoodsMainView *famousGoodsMainV;
@end

@implementation HFCrazyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.famousGoodsMainV];
    [HFKefuButton kefuBtn:self];
    [SVProgressHUD show];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./m/activity/panic-buying/list"];
    self.viewModel.requstURL = utrl;
    self.viewModel.requstPrams = @"Banner_99";
    [self.viewModel.dataCommand execute:nil];
    [self.viewModel.headerdataCommand execute:nil];
    @weakify(self)
    [self.viewModel.shareSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSDictionary class]]) {
            [ShareTools shareWithContent:[ShareTools dict:x]];
        }else {
            [SVProgressHUD showWithStatus:@"分享失败"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
   
    [self.viewModel.didSelectSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[HFFamousGoodsModel class]]) {
            HFFamousGoodsModel *famousModel = (HFFamousGoodsModel*)x;
            if ([NSString stringWithFormat:@"%ld",famousModel.productId].length >0) {
                SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
                vc.productId  = [NSString stringWithFormat:@"%ld",famousModel.productId];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [SVProgressHUD showWithStatus:@"productID为空"];
                [SVProgressHUD dismissWithDelay:2];
            }
        
        }else {
            [SVProgressHUD showWithStatus:@"失败"];
            [SVProgressHUD dismissWithDelay:2];
        }
       
    }];
    [self.viewModel.didBannerSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[HFFamousGoodsBannerModel class]]) {
            HFFamousGoodsBannerModel *famousModel = (HFFamousGoodsBannerModel*)x;
           
            if ([NSString stringWithFormat:@"%@",famousModel.linkContent].length >0&&famousModel.linkType == 1) {
                if (famousModel.bannerId.length !=0) {
                    [HFCarRequest updateClickNumber:famousModel.bannerId];
                }
                SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
                vc.productId  = [NSString stringWithFormat:@"%@",famousModel.linkContent];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
//                [SVProgressHUD showWithStatus:@"productID为空"];
//                [SVProgressHUD dismiss];
            }
            if ([NSString stringWithFormat:@"%@",famousModel.linkContent].length >0&&famousModel.linkType == 2) {
                HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
                vc.isMore = YES;
                [vc setShareUrl:famousModel.linkContent];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
//                [SVProgressHUD showWithStatus:@"URL为空"];
//                [SVProgressHUD dismiss];
            }
            
        }else {
//            [SVProgressHUD showWithStatus:@"失败"];
//            [SVProgressHUD dismiss];
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
        titleView.image = [UIImage imageNamed:@"crazy_title"];
        self.navigationItem.titleView = titleView;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"highEnd_title_forward"] style:UIBarButtonItemStyleDone target:self action:@selector(fowardClick)];
        self.navigationItem.rightBarButtonItem = rightButton;
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HMH_back_light"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
}
- (void)fowardClick {
    self.viewModel.pageTag = @"fy_mall_crazy_buy_9.9yuan";
    [self.viewModel.shareCommand execute:nil];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (HFFamousGoodsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFFamousGoodsViewModel alloc] init];
    }
    return _viewModel;
}
- (HFFamousGoodsMainView *)famousGoodsMainV {
    if (!_famousGoodsMainV) {
        _famousGoodsMainV = [[HFFamousGoodsMainView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) WithViewModel:self.viewModel];
    }
    return _famousGoodsMainV;
}
@end
