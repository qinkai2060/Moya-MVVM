//
//  VipCenterViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipCenterViewController.h"
#import "WRNavigationBar.h"
#import "VipHeaderView.h"
#import "VipInformationModel.h"
#import "VipGiftBagViewController.h"
#import "VipGiftGetViewController.h"
@interface VipCenterViewController ()
@property (nonatomic, strong) VipInformationModel *vipModel;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) VipHeaderView *vipHeaderView;
@end

@implementation VipCenterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self requestVipInformation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviView];
    [self refrenshUI];

}

/**
 请求vip信息
 */
- (void)requestVipInformation{
    [SVProgressHUD show];
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/vip/member/queryVipQualification"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         [SVProgressHUD dismiss];
         if (Is_Kind_Of_NSDictionary_Class(request.responseJSONObject))
         {
             NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
             if (Is_Kind_Of_NSDictionary_Class([dict objectForKey:@"data"])) {
                 self.vipModel = [VipInformationModel modelWithJSON:[dict objectForKey:@"data"]];
                 self.vipLevel = self.vipModel.vipLevel;
                 self.imagePath = self.vipModel.headImagePath;
                 [self refrenshUI];
             }
             
         }
         
     }error:^(__kindof YTKBaseRequest * _Nonnull request) {
         [SVProgressHUD dismiss];
         [self showSVProgressHUDErrorWithStatus:@"网络异常请稍后重试！"];
     }];
}
- (void)refrenshUI{
    switch ([self.vipLevel integerValue]) {
        case 1:
        {
            self.bgView.image = [UIImage imageNamed:@"icon_vip_headerMF"];
            self.vipHeaderView.arrDate = [self mfJurisdictionDate];
        }
            break;
        case 2:
        {
            self.bgView.image = [UIImage imageNamed:@"icon_vip_headerYK"];
            self.vipHeaderView.arrDate = [self moreJurisdictionDate];

        }
            break;
        case 3:
        {
            self.bgView.image = [UIImage imageNamed:@"icon_vip_headerBJ"];
            self.vipHeaderView.arrDate = [self moreJurisdictionDate];

        }
            break;
        case 4:
        {
            self.bgView.image = [UIImage imageNamed:@"icon_vip_headerZS"];
            self.vipHeaderView.arrDate = [self moreJurisdictionDate];

        }
            break;
            
        default:
        {
            self.bgView.image = [UIImage imageNamed:@"icon_vip_headerMF"];
            self.vipHeaderView.arrDate = [self moreJurisdictionDate];

        }
            break;
    }
    self.vipHeaderView.vipLevel = self.vipLevel;
    [self.vipHeaderView refreshVipLevel];
    
    //按钮显示判断
    if (!CHECK_STRING_ISNULL(self.vipModel.unGetVipLevel) && ![self.vipModel.unGetVipLevel isEqual:@(0)]) {
        [self.vipHeaderView.escalateBtn setHidden:NO];
        [self.vipHeaderView.escalateBtn setTitle:@"立即领取" forState:(UIControlStateNormal)];
        switch ([self.vipModel.unGetVipLevel integerValue]) {
            case 1:
            {
                self.vipHeaderView.vipPrompt.text = @"恭喜您已获得免费会员资格！";
            }
                break;
            case 2:
            {
                self.vipHeaderView.vipPrompt.text = @"恭喜您已获得银卡会员资格！";
            }
                break;
            case 3:
            {
                self.vipHeaderView.vipPrompt.text = @"恭喜您已获得铂金会员资格！";
            }
                break;
            case 4:
            {
                self.vipHeaderView.vipPrompt.text = @"恭喜您已获得钻石会员资格！";
            }
                break;
                
            default:
                self.vipHeaderView.vipPrompt.text = @"";
                break;
        }
    } else if ([self.vipModel.unGetVipLevel isEqual:@(0)] && ![self.vipModel.vipLevel isEqual:@(4)]){
        [self.vipHeaderView.escalateBtn setHidden:NO];
        [self.vipHeaderView.escalateBtn setTitle:@"立即升级" forState:(UIControlStateNormal)];
        self.vipHeaderView.vipPrompt.text = @"";

    } else {
        [self.vipHeaderView.escalateBtn setHidden:YES];
        self.vipHeaderView.vipPrompt.text = @"";

    }
    

}
//立即领取
- (void)escalateBlockAction:(NSString *)title{

    if ([title isEqualToString:@"立即领取"]) {
        [self requestGainVipRole];
    } else if ([title isEqualToString:@"立即升级"]){
        if ([self.vipModel.vipRecommendFlag isEqualToString:@"1"]) {
            VipGiftBagViewController *vip = [[VipGiftBagViewController alloc] init];
            [self.navigationController pushViewController:vip animated:YES];
        } else {
            VipGiftGetViewController *vip = [[VipGiftGetViewController alloc] init];
            [self.navigationController pushViewController:vip animated:YES];
        }
    } else {
        //nothing
    }
}
/**
 立即领取
 */
- (void)requestGainVipRole{
    [SVProgressHUD show];
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/vip/member/gainVipRole"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         [SVProgressHUD dismiss];
         if (Is_Kind_Of_NSDictionary_Class(request.responseJSONObject))
         {
             if ([[request.responseJSONObject objectForKey:@"state"] integerValue] == 1) {
                 [self showSVProgressHUDSuccessWithStatus:@"领取成功！"];
                 [self performSelector:@selector(requestVipInformation) withObject:nil afterDelay:1];
             } else {
                 [self showSVProgressHUDErrorWithStatus:@"领取失败！"];
             }
             
         } else {
             [self showSVProgressHUDErrorWithStatus:@"网络异常请稍后重试！"];
         }
         
     }error:^(__kindof YTKBaseRequest * _Nonnull request) {
         [SVProgressHUD dismiss];
         [self showSVProgressHUDErrorWithStatus:@"网络异常请稍后重试！"];
     }];
}
//银卡,铂金,钻石权限
-(NSArray *)moreJurisdictionDate{
    NSArray *arr = @[
                        @{
                            @"title":@"专享返利",
                            @"img":@"icon_vip_zsfl"
                         },
                        @{
                            @"title":@"购物专区",
                            @"img":@"icon_vip_gwzq"
                            },
                        @{
                            @"title":@"专属活动",
                            @"img":@"icon_vip_zshd"
                            },
                        @{
                            @"title":@"专属优惠券",
                            @"img":@"icon_vip_zsyhq"
                            },
                        @{
                            @"title":@"在线客服",
                            @"img":@"icon_vip_zxkf"
                            },
                        @{
                            @"title":@"退换无忧",
                            @"img":@"icon_vip_thwy"
                            }
                        ];
    return arr;
}
//f免费
-(NSArray *)mfJurisdictionDate{
    NSArray *arr = @[
                     @{
                         @"title":@"在线客服",
                         @"img":@"icon_vip_zxkf"
                         },
                     @{
                         @"title":@"退换无忧",
                         @"img":@"icon_vip_thwy"
                         }
                     ];
    return arr;
}
- (void)setNaviView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.bgView];
    
   
    [self.view addSubview:self.vipHeaderView];

    [self.vipHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.vipHeaderView refreshVipLevel];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(80, IPHONEX_SAFEAREA, ScreenW - 160, 44)];
    titleL.text = @"会员中心";
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    UIButton * lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setImage:[UIImage imageNamed:@"icon_vipback"] forState:UIControlStateNormal];
    lButton.frame = CGRectMake(0, IPHONEX_SAFEAREA, 44, 44);
    [lButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lButton];
    
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (VipHeaderView *)vipHeaderView{
    if (!_vipHeaderView) {
        _vipHeaderView = [[VipHeaderView alloc] init];
        _vipHeaderView.vipLevel = self.vipLevel;
        _vipHeaderView.imagePath = self.imagePath;
        WEAKSELF
        _vipHeaderView.escalateBlock = ^(NSString * _Nonnull title) {
            [weakSelf escalateBlockAction:title];
        };
    }
    return _vipHeaderView;
}

- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.frame = CGRectMake(0, 0, ScreenW, 265);
    }
    return _bgView;
}
@end
