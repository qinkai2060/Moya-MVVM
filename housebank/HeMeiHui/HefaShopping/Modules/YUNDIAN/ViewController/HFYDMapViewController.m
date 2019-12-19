//
//  HFYDMapViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDMapViewController.h"
#import "HFAlertView.h"
#import "WRNavigationBar.h"
#import "UIBarButtonItem+Exetention.h"
#import "HFUserAnnotationView.h"
#import "HFYDDetialViewModel.h"
#import "MAPUserAnnotion.h"
#import "HFYDShopAnnotationView.h"
@interface HFYDMapViewController ()<MAMapViewDelegate>
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)UIButton * navigationBtn;
@property(nonatomic,strong)UIButton * userLocationBtn;
@property(nonatomic,strong)UIButton * shopLocationBtn;
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;

@end

@implementation HFYDMapViewController
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_layoutNavigation {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:@"HMH_back_light" target:self action:@selector(back)];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setLeftBarButtonItem:left];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hh_addSubviews {
    self.title = @"地图";

    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.viewModel.detialModel.shopsBaseInfo.pointLat floatValue], [self.viewModel.detialModel.shopsBaseInfo.pointLng floatValue]);
    pointAnnotation.title = self.viewModel.detialModel.shopsBaseInfo.shopsName;
    pointAnnotation.subtitle =  self.viewModel.detialModel.shopsBaseInfo.address;
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];

    MAPUserAnnotion *user = [[MAPUserAnnotion alloc] init];
    user.coordinate = CLLocationCoordinate2DMake(self.viewModel.usercoordinate.latitude, self.viewModel.usercoordinate.longitude);

    r.fillColor = [UIColor redColor];
    r.strokeColor = [UIColor greenColor];
    r.image = [UIImage imageNamed:@"location_fill"];
    CGFloat ipx = isIPhoneX() ? 88:64;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, ipx, ScreenW, ScreenH-ipx)];
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView.showsUserLocation = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.showTraffic = NO;
    self.mapView.zoomLevel = 15;
    self.mapView.delegate = self;
    [self.mapView updateUserLocationRepresentation:r];
    [self.view addSubview:self.mapView ];
    [self.mapView addAnnotation:pointAnnotation];
    [self.mapView addAnnotation:user];

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.viewModel.detialModel.shopsBaseInfo.pointLat floatValue], [self.viewModel.detialModel.shopsBaseInfo.pointLng floatValue]) animated:YES];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [HFAlertView showAlertViewType:0 title:@"你尚未开启定位服务" detailString:@"建议您开启服务" cancelTitle:@"不开启" cancelBlock:^(HFAlertView *view) {
            
        } sureTitle:@"去开启" sureBlock:^(HFAlertView *view) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }

    [self.view addSubview:self.shopLocationBtn];
    [self.view addSubview:self.userLocationBtn];
    [self.view addSubview:self.navigationBtn];
    CGFloat ipx2 = IS_iPhoneX ? 34:0;
    self.shopLocationBtn.frame = CGRectMake(ScreenW-93-17, ScreenH-20-30-ipx2, 93, 30);
    self.userLocationBtn.frame = CGRectMake(ScreenW-93-17, self.shopLocationBtn.top-15-30, 93, 30);
    self.navigationBtn.frame = CGRectMake(ScreenW-69-41, self.userLocationBtn.top-15-30, 69, 30);
    
}
- (void)hh_bindViewModel {
    @weakify(self)
    [[self.shopLocationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.viewModel.detialModel.shopsBaseInfo.pointLat floatValue], [self.viewModel.detialModel.shopsBaseInfo.pointLng floatValue]) animated:YES];
    }];
    [[self.userLocationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.mapView setCenterCoordinate:self.viewModel.usercoordinate animated:YES];
    }];
    [[self.navigationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f&mode=riding&src=%@", [self.viewModel.detialModel.shopsBaseInfo.pointLat floatValue], [self.viewModel.detialModel.shopsBaseInfo.pointLng floatValue],self.viewModel.detialModel.shopsBaseInfo.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else {
                [MBProgressHUD showAutoMessage:@"暂未安装该地图"];
            }
    
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
            {
             
                    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=2",@"刷哪儿",[self.viewModel.detialModel.shopsBaseInfo.pointLat floatValue],[self.viewModel.detialModel.shopsBaseInfo.pointLng floatValue],self.viewModel.detialModel.shopsBaseInfo.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSLog(@"%@",urlString);
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                    
        
                
            }else {
                [MBProgressHUD showAutoMessage:@"暂未安装该地图"];
            }
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
    
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        HFYDShopAnnotationView*annotationView = (HFYDShopAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[HFYDShopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.shopTitle = annotation.title;
        annotationView.address = annotation.subtitle;
        annotationView.backgroundColor = [UIColor greenColor];
        return annotationView;
    }else if([annotation isKindOfClass:[MAPUserAnnotion class]]){
        
        static NSString *pointReuseIndentifier = @"user";
        HFUserAnnotationView*annotationView = (HFUserAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[HFUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.backgroundColor = [UIColor greenColor];
        return annotationView;
    }
    return nil;
}
- (UIButton *)userLocationBtn {
    if (!_userLocationBtn) {
        _userLocationBtn = [[UIButton alloc] init];
        [_userLocationBtn setImage:[UIImage imageNamed:@"yd_me_location"] forState:UIControlStateNormal];
        [_userLocationBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        [_userLocationBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _userLocationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _userLocationBtn.backgroundColor = [UIColor whiteColor];
        _userLocationBtn.layer.cornerRadius = 5;
        _userLocationBtn.layer.masksToBounds = YES;
    }
    return _userLocationBtn;
}
- (UIButton *)navigationBtn {
    if (!_navigationBtn) {
        _navigationBtn = [[UIButton alloc] init];
        [_navigationBtn setImage:[UIImage imageNamed:@"yd_location"] forState:UIControlStateNormal];
        [_navigationBtn setTitle:@"导航" forState:UIControlStateNormal];
        [_navigationBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _navigationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _navigationBtn.backgroundColor = [UIColor whiteColor];
        _navigationBtn.layer.cornerRadius = 5;
        _navigationBtn.layer.masksToBounds = YES;
    }
    return _navigationBtn;
}
- (UIButton *)shopLocationBtn {
    if (!_shopLocationBtn) {
        _shopLocationBtn = [[UIButton alloc] init];
        [_shopLocationBtn setImage:[UIImage imageNamed:@"yd_shop_light"] forState:UIControlStateNormal];
        [_shopLocationBtn setTitle:@"店铺位置" forState:UIControlStateNormal];
        [_shopLocationBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _shopLocationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _shopLocationBtn.backgroundColor = [UIColor whiteColor];
        _shopLocationBtn.layer.cornerRadius = 5;
        _shopLocationBtn.layer.masksToBounds = YES;
    }
    return _shopLocationBtn;
}
@end
