//
//  HFVIPViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPViewController.h"
#import "HFVIPViewModel.h"
#import "HFVIPMainView.h"
#import "WRNavigationBar.h"
#import "HFTextCovertImage.h"
#import "HFVipSeachViewController.h"
#import "HFAlertView.h"
#import "ZTGCDTimerManager.h"
//#import "HFVIPBrowserImage.h"
#import "HFFashionModel.h"
#import "VipGoodsPlayViewController.h"
#import "VipGiftGetViewController.h"
#import "HFBrowserModel.h"
//#import "HFVIDeoNode.h"
#import "HFHightEndGoodsViewController.h"
#import "VipGiftBagViewController.h"
@interface HFVIPViewController ()
@property(nonatomic,strong)HFVIPViewModel *viewModel;
@property(nonatomic,strong)HFVIPMainView *mainView;
@end

@implementation HFVIPViewController


- (void)hh_layoutNavigation {


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor colorWithHexString:@"333333"]];
    [self wr_setNavBarShadowImageHidden:1];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setHidesBackButton:YES];
    UILabel *lb = [HFUIkit textColor:@"CC9F7C" blodfont:17 numberOfLines:1];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.attributedText = [HFTextCovertImage attrbuteStrVIP:@"VIP专区" rangeOfArray:@[@"专区"] font:17 color:@"333333"];
    self.navigationItem.titleView = lb;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-b"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homeforward"] style:UIBarButtonItemStyleDone target:self action:@selector(fowardClick)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.mainView Behavior];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//     [self.navigationController.navigationBar setTranslucent:YES];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fowardClick {
//    HFVipSeachViewController *vc =  [[HFVipSeachViewController alloc] init];
//    vc.viewModel = self.viewModel;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.viewModel.VipShareCommand execute:nil];
}
- (void)hh_addSubviews {
 
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    v.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
    [self.view addSubview:v];
    [self.view addSubview:self.mainView];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[ZTGCDTimerManager sharedInstance]  cancelTimerWithName:NSStringFromClass([HFVIPBrowserImage class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    [self.viewModel.homeMainCommand execute:nil];
    if ([HFUserDataTools isVip]) {
        [HFAlertView showAlertViewType:HFAlertViewTypeVip title:@"批发商城是VIP会员专享区域，您还不是VIP会员！购买商品不会享受批发价。" detailString:@"" cancelTitle:@"" cancelBlock:^(HFAlertView *view) {
            
            [[self requestVipInformation] subscribeNext:^(NSNumber * x) {
                if (x) {
                    if ([x isEqualToNumber:@1]) {
                        VipGiftBagViewController *vip = [[VipGiftBagViewController alloc] init];
                        [self.navigationController pushViewController:vip animated:YES];
                    } else {
                        VipGiftGetViewController *vip = [[VipGiftGetViewController alloc] init];
                        [self.navigationController pushViewController:vip animated:YES];
                    }
                }
            }];
            //            SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
            //            SpGoodsDetailVC.productId=objectOrEmptyStr(@"127");
            //            SpGoodsDetailVC.isVipGiftPackage = YES;
            //            SpGoodsDetailVC.goodsType=DirectSupplyGoodsDetailStyle;
            //            [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
            
        } sureTitle:@"确定" sureBlock:^(HFAlertView *view) {
            
        }];
    }
}
/** VIP个人中心信息*/
- (RACSignal *)requestVipInformation{
    
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/vip/member/queryVipQualification"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         if (Is_Kind_Of_NSDictionary_Class(request.responseJSONObject))
         {
             NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
             if ([[dict objectForKey:@"state"] isEqual:@1]) {
                 NSDictionary * dataDic = [dict objectForKey:@"data"];
                 NSNumber * vipRecommendFlag = [dataDic objectForKey:@"vipRecommendFlag"];
                 [subject sendNext:vipRecommendFlag];
                 [subject sendCompleted];
             }else {
                 NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":[dict objectForKey:@"msg"]}];
                 [subject sendError:error];
             }
         }
     }error:^(__kindof YTKBaseRequest * _Nonnull request) {
         [SVProgressHUD dismiss];
         [SVProgressHUD showErrorWithStatus:@"网络异常请稍后重试！"];
     }];
    return  subject;
}

- (void)hh_bindViewModel {
    @weakify(self)
    
     [self.viewModel.homeMainSubjc subscribeNext:^(id  _Nullable x) {
         [SVProgressHUD dismiss];
         if ([x isKindOfClass:[NSArray class]]) {

         }
     }];
    // 进入搜索
    [self.viewModel.enterSearchSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFVipSeachViewController *vc =  [[HFVipSeachViewController alloc] init];
        vc.viewModel = self.viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    // 点击轮播图
    [self.viewModel.didBrowserSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFBrowserModel class]]) {
            HFBrowserModel *model = (HFBrowserModel*)x;
            SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
            SpGoodsDetailVC.productId=objectOrEmptyStr(model.goodsId);
            SpGoodsDetailVC.goodsType=VipWholesaleGoodsDetailStyle;
            [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
        }else {
            [SVProgressHUD showInfoWithStatus:@"商品ID不能为空"];
            [SVProgressHUD dismissWithDelay:1];
        }
        
    }];
    // 点击轮播图下面的模块
    [self.viewModel.didFashionSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFFashionModel class]]) {
            HFFashionModel *fashion = (HFFashionModel*)x;
            SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
            SpGoodsDetailVC.productId=objectOrEmptyStr(fashion.goodsId);
            SpGoodsDetailVC.goodsType=VipWholesaleGoodsDetailStyle;
            [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
        }
    }];
    // 点击视频好物想播
    [self.viewModel.didVideoSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
   //     HFHightEndGoodsViewController *vc = [[HFHightEndGoodsViewController alloc] init];
       VipGoodsPlayViewController *vc = [[VipGoodsPlayViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    // 点击商品详情页
    [self.viewModel.didGoodsSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFVIPModel *model = (HFVIPModel*)x;
        if ([x isKindOfClass:[HFVIPModel class]]) {
            SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
            SpGoodsDetailVC.productId=objectOrEmptyStr(model.productId);
            SpGoodsDetailVC.goodsType=VipWholesaleGoodsDetailStyle;
            [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
        }

    }];
    // 点击分享
    [self.viewModel.VipShareSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSDictionary class]]) {
            [ShareTools shareWithContent:[ShareTools dict:x]];
        }else {
            [SVProgressHUD showWithStatus:@"分享失败"];
            [SVProgressHUD dismiss];
        }
        
    }];
}
- (HFVIPMainView *)mainView {
    if (!_mainView) {
        _mainView = [[HFVIPMainView alloc] initWithFrame:CGRectMake(0,0, ScreenW, ScreenH-STATUSBAR_NAVBAR_HEIGHT-1) WithViewModel:self.viewModel];
    }
    return _mainView;
}
- (HFVIPViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFVIPViewModel alloc] init];
    }
    return _viewModel;
}

@end
