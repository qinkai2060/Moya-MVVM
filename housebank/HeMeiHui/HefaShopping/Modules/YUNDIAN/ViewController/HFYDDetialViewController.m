//
//  HFYDDetialViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDDetialViewController.h"
#import "HFYDDetialViewModel.h"
#import "HFYDDetialMainView.h"
#import "WRNavigationBar.h"
#import "HFYDWeiDDetialViewController.h"
#import "HFLoginViewController.h"
#import "FeatureViewController.h"
#import "HFYDMapViewController.h"
#import "CloudCodeView.h"
#import "HFAlertView.h"
@interface HFYDDetialViewController ()<HFLoginViewControllerDelegate,FeatureViewDelegate>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)HFYDDetialMainView *mainView;
@property (nonatomic, strong) CloudCodeView    * cloudCodeView; // 二维码
@property (nonatomic, strong)UIView *blackView;
@end

@implementation HFYDDetialViewController
- (void)hh_layoutNavigation {
    [self setNav];
}
- (void)setNav {
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)hh_addSubviews {
    [self.view addSubview:self.mainView];
    UIView *v = [[UIView alloc] initWithFrame:self.mainView.frame];
    v.backgroundColor = [UIColor clearColor];
    [self.view addSubview:v];
//    [self.viewModel.ydDataCommand execute:nil];
//    [self.cloudCodeView popAnimation];
    @weakify(self)
    [[self.mainView.customNavBar.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self backClick];
    }];
    [[self.mainView.customNavBar.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self fowardClick];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissVC) name:@"removeShare" object:nil];
}
- (void)dissMissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}
+(void)showQRCode:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel {
   
    HFYDDetialViewController *ydvc = [[HFYDDetialViewController alloc] init];
    ydvc.view.backgroundColor = [UIColor whiteColor];
    ydvc.hidesBottomBarWhenPushed = YES;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [HFAlertView showAlertViewType:0 title:@"你尚未开启定位服务" detailString:@"建议您开启服务" cancelTitle:@"不开启" cancelBlock:^(HFAlertView *view) {
            [ydvc showQRID:shopId vc:vc itemModel:itemModel];
        } sureTitle:@"去开启" sureBlock:^(HFAlertView *view) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }else {
        [ydvc showQRID:shopId vc:vc itemModel:itemModel];
    }
}
- (void)showQRID:(NSString *)shopId  vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel {
     [SVProgressHUD show];
    self.viewModel.shopId = shopId.length==0?@"":shopId;
    [self.viewModel.ydDataCommand execute:nil];
    [self.viewModel.ydDataSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[HFYDDetialDataModel class]]) {
            [[self.viewModel create_shopQrcode:objectOrEmptyStr(shopId) shopType:objectOrEmptyStr(itemModel.shopType)]subscribeNext:^(NSString * x) {
                self.modalPresentationStyle=UIModalPresentationFullScreen;
                [vc presentViewController:self animated:YES completion:nil];
               
                [self.cloudCodeView popAnimation];
                self.cloudCodeView.titleString = objectOrEmptyStr(itemModel.shopName);
                [self.cloudCodeView initWithCodeString:objectOrEmptyStr(x) codeBlock:^{
                    // 保存图片到相册中
                    UIImageWriteToSavedPhotosAlbum(self.cloudCodeView.codeImageView.image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
                    [self.cloudCodeView closeAnimation];
                }];
            } error:^(NSError * _Nullable error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"云店二维码生成失败"];
                [SVProgressHUD dismissWithDelay:1];
            }];
            
        }else {
            [SVProgressHUD dismiss];
            [MBProgressHUD showAutoMessage:@"页面异常"];
        }
    }];
    
}
+(void)showTuiG:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel{
   
    HFYDDetialViewController *ydvc = [[HFYDDetialViewController alloc] init];
    ydvc.viewModel.shopId = (shopId.length==0?@"":shopId);
    ydvc.view.backgroundColor = [UIColor whiteColor];
    ydvc.hidesBottomBarWhenPushed = YES;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [HFAlertView showAlertViewType:0 title:@"你尚未开启定位服务" detailString:@"建议您开启服务" cancelTitle:@"不开启" cancelBlock:^(HFAlertView *view) {
            [ydvc shouTuiGID:shopId vc:vc itemModel:itemModel];
        } sureTitle:@"去开启" sureBlock:^(HFAlertView *view) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }else {
        [ydvc shouTuiGID:shopId vc:vc itemModel:itemModel];
    }
    
}
- (void)shouTuiGID:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel{
    [SVProgressHUD show];
    [self.viewModel.ydDataCommand execute:nil];
    [self.viewModel.shareSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD dismiss];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[ShareTools dict:x]];
            if([itemModel.shopType isEqualToString:@"2"]) {
                [dict setObject:objectOrEmptyStr([[itemModel.shopImg  get_Image] absoluteString]) forKey:@"shareImageUrl"];
                [dict setObject:objectOrEmptyStr([[itemModel.shopImg  get_Image] absoluteString]) forKey:@"shareWeixinUrl"];
                
            }else  if ([itemModel.shopType isEqualToString:@"3"]){
                [dict setObject:objectOrEmptyStr([[itemModel.logoImg  get_Image] absoluteString]) forKey:@"shareImageUrl"];
                [dict setObject:objectOrEmptyStr([[itemModel.logoImg  get_Image] absoluteString]) forKey:@"shareWeixinUrl"];
                
            }
            [dict setObject:objectOrEmptyStr(itemModel.shopName) forKey:@"shareTitle"];
            [dict setObject:@"云店分享" forKey:@"yundian"];
            self.modalPresentationStyle=UIModalPresentationFullScreen;
            [vc presentViewController:self animated:NO completion:^()
             {
                 [ShareTools shareWithContent:dict];
            }];
           
           
        }else {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:@"分享数据异常"];
            [SVProgressHUD dismissWithDelay:1];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
    [self.viewModel.ydDataSubjc subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[HFYDDetialDataModel class]]) {
              if([itemModel.shopType isEqualToString:@"2"]) {
                  self.viewModel.pageTage= @"fy_newretail_shops";
              }else if ([itemModel.shopType isEqualToString:@"3"]) {
                  self.viewModel.pageTage= @"fy_micro_shops";
              }
            
            [self.viewModel.shareCommand execute:nil];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD dismiss];
            [MBProgressHUD showAutoMessage:@"分享失败 页面异常"];
        }
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    if (error != NULL){
        [SVProgressHUD showErrorWithStatus:@"保存二维码图片失败!"];
    }
    else{
        [SVProgressHUD showSuccessWithStatus:@"保存二维码图片成功!"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loginViewController:(HFLoginViewController*)viewcontroller loginFinsh:(NSDictionary*)loginData {
     [self.viewModel.ydDataCommand execute:nil];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.enterMapSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self)
        HFYDMapViewController *vc = [[HFYDMapViewController alloc] initWithViewModel:self.viewModel];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.enterWDSubjc subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        HFYDWeiDDetialViewController *vc = [[HFYDWeiDDetialViewController alloc] initWithViewModel:self.viewModel];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    [self.viewModel.loginSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [HFLoginViewController showViewController:self];
    }];
    [self.viewModel.selectSpecialIDSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self)
        if (x && [x isKindOfClass:[HFYDSpecificationsModel class]]) {
            _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            _blackView.alpha=0.6;
            _blackView.backgroundColor=HEXCOLOR(0X000000);
            _blackView.tag = 440;
            [self.view addSubview:_blackView];
            _blackView.alpha=0;
            [UIView animateWithDuration:0.5f animations:^{
                _blackView.alpha = 0.6;
                
            } completion:^(BOOL finished) {
                
            }];
            HFYDSpecificationsModel *sp = (HFYDSpecificationsModel*)x;
            FeatureViewController *vc = [[FeatureViewController alloc] init];
            vc.Delegate = self;
            vc.productId = [NSString stringWithFormat:@"%ld",self.viewModel.productId];
            vc.type=@"购物车重置";
            ProductFeatureModel *featureModel = [[ProductFeatureModel alloc]init];
            featureModel.data=[[FeatureModelDetail alloc]init];
//            featureModel.data.rsMap=[[RsMap alloc]initWithDictionary:sp.productspMap error:nil];
            featureModel.data.rsMap = [RsMap modelWithJSON:sp.productspMap];
            vc.featureModel=featureModel;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:vc animated:YES completion:nil];
        }
        
    } error:^(NSError * _Nullable error) {
    
    }];
}

/**
self.viewModel.resetSpecialPrams = @{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"id":@(self.model.storeId.integerValue),@"productID":@(storModel.commodityId.integerValue),@"productTypeID":@(storModel.specifications.integerValue),@"shoppingCount":@(storModel.countStr.integerValue),@"shopsId":@(self.model.shopsId.integerValue),@"shopsType":@(1),@"stealAge":@(0),@"price":@(storModel.resetprice.floatValue)};
 */
- (void)selectedItemType:(NSString*)type dic:(NSDictionary*)dic {
    [self.viewModel.sendSelectedDataSubjc sendNext:dic];
    self.viewModel.rightModel.productId = [[HFUntilTool EmptyCheckobjnil:[dic valueForKey:@"productId"]] integerValue];
    self.viewModel.rightModel.cashPrice = [[HFUntilTool EmptyCheckobjnil:[dic valueForKey:@"price"]] floatValue];
    self.viewModel.rightModel.productSpecificationsId = [[HFUntilTool EmptyCheckobjnil:[dic valueForKey:@"specifications"]] integerValue];
    self.viewModel.shopId = [HFUntilTool EmptyCheckobjnil:[[dic valueForKey:@"id"] description]];
    self.viewModel.rightModel.addCount = [[HFUntilTool EmptyCheckobjnil:[dic valueForKey:@"shoppingCount"]] integerValue];
    [self.viewModel.addOrminCarCommand execute:nil];
}
- (void)featureViewdismissVC
{
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.35f animations:^{
        _blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [_blackView removeFromSuperview];
    }];
    
    
}
- (void)fowardClick {

}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (HFYDDetialMainView *)mainView {
    if (!_mainView) {
//        CGFloat navH = IS_IPHONE_X()?88:64;
        _mainView = [[HFYDDetialMainView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewModel];
    }
    return _mainView;
}
- (HFYDDetialViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFYDDetialViewModel alloc] init];
    }
    return _viewModel;
}
- (CloudCodeView *)cloudCodeView {
    if (!_cloudCodeView) {
        _cloudCodeView = [[CloudCodeView alloc]init];
        _cloudCodeView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
//        [[UIApplication sharedApplication].keyWindow addSubview:_cloudCodeView];
         [self.view addSubview:_cloudCodeView];
       
        @weakify(self)
        _cloudCodeView.missBlock = ^{
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _cloudCodeView;
}
@end
