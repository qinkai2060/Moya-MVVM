//
//  HFWDHeaderView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFWDHeaderView.h"
#import "HFYDDetialViewModel.h"
#import "HFAlertView.h"

@interface HFWDHeaderView()
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)HFYDDetialDataModel *model;
@property(nonatomic,strong)UIImageView *bgImageV;
@property(nonatomic,strong)UIImageView *iconImageV;
@property(nonatomic,strong)UILabel *shopTitleLb;
@property(nonatomic,strong)UILabel *allTitleLb;
@property(nonatomic,strong)UIButton *favriteBtn;
@property(nonatomic,strong)UILabel *expenditureLb;// 人均消费
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *loctionImgV;
@property(nonatomic,strong)UILabel *locationLb;
@property(nonatomic,strong)UIButton *telPhoneBtn;
@property(nonatomic,strong)UIButton *dingWeiBtn;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UILabel *distanceLb;
@property(nonatomic,strong)UIView *lineView3;
@end
@implementation HFWDHeaderView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {

    [self addSubview:self.bgImageV];
    [self addSubview:self.iconImageV];
    [self addSubview:self.favriteBtn];
    [self addSubview:self.shopTitleLb];
    [self addSubview:self.expenditureLb];
    [self addSubview:self.lineView];
    [self addSubview:self.telPhoneBtn];
    [self addSubview:self.lineView2];
    [self addSubview:self.loctionImgV];
    [self addSubview:self.locationLb];
    [self addSubview:self.distanceLb];
    [self addSubview:self.dingWeiBtn];
    [self addSubview:self.lineView3];
    [self addSubview:self.allTitleLb];
    [self doMessageRendering];
}

- (void)doMessageRendering {
    [self Fuvalue];
    @weakify(self)
    [self.viewModel.wdDataSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFYDDetialDataModel class]]) {
            
            HFYDDetialDataModel *model = (HFYDDetialDataModel*)x;
            self.model = model;
            self.loctionImgV.image = [UIImage imageNamed:@"yd_location_light"];
            self.shopTitleLb.text = model.shopsBaseInfo.shopsName;
            self.expenditureLb.text = model.shopsBaseInfo.concernedCount;
            self.locationLb.text = model.shopsBaseInfo.address;
            self.favriteBtn.selected =model.shopsBaseInfo.hasConcerned;
            if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//                    [HFAlertView showAlertViewType:0 title:@"你尚未开启定位服务" detailString:@"建议您开启服务" cancelTitle:@"不开启" cancelBlock:^(HFAlertView *view) {
//
//                    } sureTitle:@"去开启" sureBlock:^(HFAlertView *view) {
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        if([[UIApplication sharedApplication] canOpenURL:url]) {
//                            [[UIApplication sharedApplication] openURL:url];
//                        }
//                    }];
                }else {
                    [self.locationManger requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                        if (!error) {
                            double f = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:[model.shopsBaseInfo.pointLat floatValue] longitude:[model.shopsBaseInfo.pointLng floatValue]]]/1000;
                            self.viewModel.usercoordinate =CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
                            self.distanceLb.text = [NSString stringWithFormat:@"距您%.01fkm",f];
                        }else {
                            self.distanceLb.text = @"获取失败";
                        }
                        
                    }];
                }
                
            }else {
                self.distanceLb.text = @"暂无详细距离";
                [MBProgressHUD showAutoMessage:@"网络已断开"];
            }
            self.distanceLb.text = @"距您4.5km";
            [self.bgImageV sd_setImageWithURL:[NSURL URLWithString:self.model.shopsBaseInfo.bgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.shopsBaseInfo.shopLogoUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];//SpTypes_default_image
            self.bgImageV.frame = CGRectMake(0, 0, ScreenW, 120);
            self.iconImageV.frame = CGRectMake(15, 80, 60, 60);
            self.favriteBtn.frame = CGRectMake(ScreenW-44-8, self.bgImageV.bottom+27, 44, 44);
            self.favriteBtn.imageEdgeInsets =  UIEdgeInsetsMake(0, 0, 20, 0);
            CGFloat height =   [HFUntilTool boundWithStr:model.shopsBaseInfo.shopsName blodfont:20 maxSize:CGSizeMake(ScreenW-15-44-10, 56)].height;
            self.shopTitleLb.frame = CGRectMake(15, self.iconImageV.bottom+5, ScreenW-15-44-10,height);
            self.expenditureLb.frame = CGRectMake(15, self.shopTitleLb.bottom+8, ScreenW-15-44-10, 16);
            self.lineView.frame = CGRectMake(15, self.expenditureLb.bottom+10, ScreenW-30, 0.5);
            self.telPhoneBtn.frame = CGRectMake(ScreenW-15-20, self.lineView.bottom+20, 20, 20);
            self.lineView2.frame = CGRectMake(self.telPhoneBtn.left-15-0.5, self.lineView.bottom+17, 0.5, 25);
            self.loctionImgV.frame = CGRectMake(15, self.lineView.bottom+10, 20, 20);
            self.locationLb.frame = CGRectMake(self.loctionImgV.right+8, self.lineView.bottom+10, ScreenW-self.loctionImgV.right-8-56,   [HFUntilTool boundWithStr:model.shopsBaseInfo.address font:16 maxSize:CGSizeMake(ScreenW-self.loctionImgV.right-8-56, 40)].height);
            self.distanceLb.frame = CGRectMake(self.loctionImgV.right+8, self.locationLb.bottom+5, ScreenW-self.loctionImgV.right-8-56, 18);
            self.dingWeiBtn.frame = CGRectMake(0, self.lineView.bottom, ScreenW-self.lineView2.left-10,( self.distanceLb.bottom- self.lineView.bottom)+10);
            self.lineView3.frame = CGRectMake(0, self.dingWeiBtn.bottom, ScreenW, 10);
            self.allTitleLb.frame = CGRectMake(15, self.lineView3.bottom+10, ScreenW-30, 20);

        }else {
             [MBProgressHUD showAutoMessage:@"暂无数据"];
        }
       
    }];
    
}
- (void)Fuvalue {

}
- (UIButton *)dingWeiBtn {
    if (!_dingWeiBtn) {
        _dingWeiBtn = [[UIButton alloc] init];
    }
    return _dingWeiBtn;
}
- (UIButton *)telPhoneBtn {
    if (!_telPhoneBtn) {
        _telPhoneBtn = [HFUIkit image:@"yd_Bitmap" selectImage:@""];
    }
    return _telPhoneBtn;
}
- (UILabel *)distanceLb {
    if (!_distanceLb) {
        _distanceLb = [HFUIkit textColor:@"999999" font:13 numberOfLines:1];
    }
    return _distanceLb;
}
- (UILabel *)locationLb {
    if (!_locationLb) {
        _locationLb = [HFUIkit textColor:@"333333" font:16 numberOfLines:1];
    }
    return _locationLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView;
}
- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _lineView3;
}
- (UIImageView *)loctionImgV {
    if(!_loctionImgV) {
        _loctionImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    }
    return _loctionImgV;
}
- (UIImageView *)bgImageV {
    if(!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _bgImageV.contentMode = UIViewContentModeScaleToFill;
        _bgImageV.clipsToBounds = YES;
    }
    return _bgImageV;
}
- (UIImageView *)iconImageV {
    if(!_iconImageV) {
        _iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _iconImageV.layer.cornerRadius = 5;
        _iconImageV.layer.masksToBounds = YES;
    }
    return _iconImageV;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView2;
}
- (UIButton *)favriteBtn {
    if (!_favriteBtn) {
        _favriteBtn = [HFUIkit image:@"yd_like_none" selectImage:@"yd_like"];
    }
    return _favriteBtn;
}
- (UILabel *)expenditureLb {
    if (!_expenditureLb) {
        _expenditureLb = [HFUIkit textColor:@"494949" font:12 numberOfLines:1];
    }
    return _expenditureLb;
}
- (UILabel *)shopTitleLb {
    if (!_shopTitleLb) {
        _shopTitleLb = [HFUIkit textColor:@"333333" blodfont:20 numberOfLines:2];
    }
    return _shopTitleLb;
}
- (UILabel *)allTitleLb {
    if (!_allTitleLb) {
        _allTitleLb = [HFUIkit textColor:@"333333" blodfont:16 numberOfLines:2];
        _allTitleLb.text = @"全部商品";
    }
    return _allTitleLb;
}
- (AMapLocationManager *)locationManger {
    if (!_locationManger) {
        _locationManger = [[AMapLocationManager alloc] init];
        [_locationManger setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManger.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        _locationManger.reGeocodeTimeout = 2;
    }
    return _locationManger;
}
@end
