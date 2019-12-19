//
//  HFPayMentViewController.m
//  housebank
//
//  Created by usermac on 2018/11/12.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPayMentViewController.h"
#import "HFPayMentMainView.h"
#import "HFShouYinViewController.h"
#import "SpBaseNavigationController.h"
#import "HFAlertView.h"
#import "UIBarButtonItem+Exetention.h"
#import "HFEditingAddressViewController.h"
#import "HFAdreesListViewController.h"
#import "HFAddressListViewModel.h"
@interface HFPayMentViewController ()<HFAdreesListViewControllerDelegate,HFEditingAddressViewControllerDelegate,HFShouYinViewControllerDelegate>
@property (nonatomic,strong)HFPayMentMainView *payMentView;
@property (nonatomic,assign) HFPayMentViewControllerEnterType contentMode;
@end

@implementation HFPayMentViewController
- (instancetype)initWithType:(HFPayMentViewControllerEnterType)contentMode {
    if (self = [super init]) {
        self.contentMode = contentMode;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setHidden:NO];
    [self.viewModel.getDetialAddressCommand execute:nil];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    self.title = @"填写订单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"HMH_back_light" target:self action:@selector(back)];
   
 
    [self.view addSubview:self.payMentView];
  
    @weakify(self)
    [self.viewModel.enterAddressOrEditingSubj subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) {
            HFEditingAddressViewController *editVC = [[HFEditingAddressViewController alloc] init];
            editVC.delegate = self;
            editVC.source = HFEditingEnterSourceAdd;
            editVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:editVC animated:YES];
        }else {
            HFAdreesListViewController *vc = [[HFAdreesListViewController alloc] init];
            vc.delegate = self;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.viewModel.fromeSource = HFAddressListViewModelSourcePay;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
//    @weakify(self)
//    [self.viewModel.enterAddressOrEditingSubj subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
//        vc.isMore = YES;
//        if (x == nil) {
//            vc.shareUrl =[NSString stringWithFormat:@"%@/html/home/#/orderForm?index=2&platform=mobile&create=1",fyMainHomeUrl];
//        }else {
//            vc.shareUrl =[NSString stringWithFormat:@"%@/html/home/#/orderForm?index=2&platform=mobile",fyMainHomeUrl];
//        }
//        vc.delegate = self;
//        vc.fromeSource = @"address";
//        vc.view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    [self.viewModel.enterStoreSubjc subscribeNext:^(id  _Nullable x) {
          @strongify(self)
        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
         vc.isMore = YES;
        vc.shareUrl =[NSString stringWithFormat:@"%@/html/home/#/orderForm/manage",fyMainHomeUrl]  ;
        vc.delegate = self;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.commitOrderSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
    
        if ([x isKindOfClass:[NSNumber class]]) {
                  [MBProgressHUD hideHUD];
                  [MBProgressHUD showAutoMessage:@"下单失败"];
        }
        if([x isKindOfClass:[NSDictionary class]])  {
            NSDictionary *dict = (NSDictionary*)x;
            if ([dict valueForKey:@"msg"]) {
                if([[dict valueForKey:@"msg"] hasPrefix:@"商品已抢完"]){
                    [HFAlertView showAlertViewType:0 title:[dict valueForKey:@"msg"] detailString:@"" cancelTitle:@"" cancelBlock:^(HFAlertView *view){
                        
                    } sureTitle:@"我知道了" sureBlock:^(HFAlertView *view){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShopCar" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                }else {
                    [HFAlertView showAlertViewType:0 title:[dict valueForKey:@"msg"] detailString:@"" cancelTitle:@"" cancelBlock:^(HFAlertView *view){
                        
                    } sureTitle:@"返回查看" sureBlock:^(HFAlertView *view){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShopCar" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                }
            }

        }
         if([x isKindOfClass:[NSString class]]) {
           NSString *orderNo =  (NSString*)x;

////            HFCommitPayModel *commitModel = (HFCommitPayModel*)x;
//        收银台
            HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
            pvc.urlStr = [NSString stringWithFormat:@"%@/html/home/#/pay/order/shopping/cashier?platform=mobile&orderNo=%@",fyMainHomeUrl,orderNo];
            pvc.isPushFromVideoWeb = NO;
            pvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pvc animated:NO];
        

//          HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
//            vc.shareUrl = [NSString stringWithFormat:@"%@/html/home/#/pay/order/shopping/cashier?platform=mobile&orderNo=%@",fyMainHomeUrl,orderNo];
//            vc.view.backgroundColor = [UIColor whiteColor];
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)back {
    [HFAlertView showAlertViewType:HFAlertViewTypeNone title:@"优惠不等人,请三思而行" detailString:@"" cancelTitle:@"去意已决" cancelBlock:^(HFAlertView *view){
        
        [self.navigationController popViewControllerAnimated:YES];
    } sureTitle:@"我再想想" sureBlock:^(HFAlertView *view){
        
    }];
}
- (void)beforePopViewController:(SpBaseNavigationController *)viewcontroller {
    [HFAlertView showAlertViewType:HFAlertViewTypeNone title:@"优惠不等人,请三思而行" detailString:@"" cancelTitle:@"去意已决" cancelBlock:^(HFAlertView *view){
        
        [self.navigationController popViewControllerAnimated:YES];
    } sureTitle:@"我再想想" sureBlock:^(HFAlertView *view){
        
    }];
}

- (void)requestPram:(NSArray*)array {
    self.viewModel.shoppingcartId = [array firstObject];
    self.viewModel.commodityId = [array lastObject];
    [self.viewModel.getDetialAddressCommand execute:nil];
}

- (void)backMangeAddress:(HFAddressModel *)model {
    self.viewModel.addressmodel = model;
    [self.payMentView requstData:model];
    [self.viewModel.resetAddressSubjc sendNext:model];
    if (self.viewModel.contentType != 3) {
        [self.viewModel.getPostPriceCommand execute:nil];
    }
    
}
- (void)backMangeEditinAddress:(HFAddressModel*)model {
    self.viewModel.addressmodel = model;
    [self.payMentView requstData:model];
    [self.viewModel.resetAddressSubjc sendNext:model];
    if (self.viewModel.contentType != 3) {
        [self.viewModel.getPostPriceCommand execute:nil];
    }
}
- (void)backLeft {
    [HFAlertView showAlertViewType:HFAlertViewTypeNone title:@"" detailString:@"" cancelTitle:@"去意已决" cancelBlock:^(HFAlertView *view){
        [self.navigationController popViewControllerAnimated:YES];
    } sureTitle:@"我再想想" sureBlock:^(HFAlertView *view){
        
    }];
}
- (HFPayMentMainView *)payMentView {
    if (!_payMentView) {
        CGFloat height = 0;
        if (self.contentMode == HFPayMentViewControllerEnterTypeNone) {
            height = IS_iPhoneX ? 64+24+34:64;
        }else {
            height =  IS_iPhoneX ? 64+34+24:64;
        }
        
        _payMentView = [[HFPayMentMainView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-height) WithViewModel:self.viewModel];
       
    }
    return _payMentView;
}

- (HFPayMentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFPayMentViewModel alloc] init];
    }
    return _viewModel;
}
- (void)dealloc {
    
}
@end
