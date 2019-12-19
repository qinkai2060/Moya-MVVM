//
//  HFYDWeiDDetialViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDWeiDDetialViewController.h"
#import "HFWDMainView.h"
#import "HFYDDetialViewModel.h"
#import "WRNavigationBar.h"
#import "CloudCodeView.h"
#import "HFAlertView.h"
@interface HFYDWeiDDetialViewController ()
@property (nonatomic, strong) CloudCodeView    * cloudCodeView; // 二维码
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)HFWDMainView *mainView;

@end

@implementation HFYDWeiDDetialViewController
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithViewModel:viewModel]) {
        
    }
    return self;
}
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissVC) name:@"removeShare" object:nil];
}

- (void)dissMissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(void)showQRCode:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel {
    [SVProgressHUD show];
    HFYDWeiDDetialViewController *ydvc = [[HFYDWeiDDetialViewController alloc] init];
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
    self.viewModel.shopId = shopId.length==0?@"":shopId;
    [self.viewModel.wdDataCommand execute:nil];
    [self.viewModel.wdDataSubjc subscribeNext:^(id  _Nullable x) {
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
    [SVProgressHUD show];
    HFYDWeiDDetialViewController *ydvc = [[HFYDWeiDDetialViewController alloc] init];
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
    [self.viewModel.wdDataCommand execute:nil];
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
//            [ShareTools shareWithContent:dict];
            
        }else {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:@"分享数据异常"];
            [SVProgressHUD dismissWithDelay:1];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
    [self.viewModel.wdDataSubjc subscribeNext:^(id  _Nullable x) {
        
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
- (void)hh_bindViewModel {
//    [self.viewModel.wdDataCommand execute:nil];
}
- (HFWDMainView *)mainView {
    if (!_mainView) {
        //        CGFloat navH = IS_IPHONE_X()?88:64;
        _mainView = [[HFWDMainView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewModel];
    }
    return _mainView;
}
- (CloudCodeView *)cloudCodeView {
    if (!_cloudCodeView) {
        _cloudCodeView = [[CloudCodeView alloc]init];
        _cloudCodeView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
         [self.view addSubview:_cloudCodeView];
        @weakify(self)
        _cloudCodeView.missBlock = ^{
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    return _cloudCodeView;
}
- (HFYDDetialViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFYDDetialViewModel alloc] init];
    }
    return _viewModel;
}
@end
