//
//  PersonCenterSetingViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "PersonCenterSetingViewController.h"
#import "PersonCenterSetingView.h"
#import "CustomPasswordAlter.h"
#import "MyJumpHTML5ViewController.h"
#import "WRNavigationBar.h"
#import "HFAdreesListViewController.h"
#import "HFAddressListViewModel.h"
#import "HFIMMessageController.h"
#import "HFShouYinViewController.h"
@interface PersonCenterSetingViewController ()

@property (nonatomic, strong) PersonCenterSetingView *settingvView;

@end

@implementation PersonCenterSetingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    self.navigationController.navigationBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setUI];
}
//- (void)leftBarButtonItemAction{
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//}
- (void)setUI{
    self.view.backgroundColor = HEXCOLOR(0xF5F5F5);
    
    [self.view addSubview:self.settingvView];
    NSMutableArray *arr = [@[
                             [@[@{
                                    @"title":@"我的二维码",
                                    @"logo":@"icon_qrcode",
                                    @"class":@"MyQrcodeViewController"
                                    },
                       
                                @{
                                    @"title":@"常用人维护",
                                    @"logo":@"icon_topcontacts",
                                    @"class":@"TopContactsViewController"
                                    },
                                @{
                                    @"title":@"账户与安全",
                                    @"logo":@"icon_lock",
                                    @"class":@"MyUSersSecurityViewController"
                                    },
                                @{
                                    @"title":@"我的收货地址",
                                    @"logo":@"icon_address",
                                    @"class":@"HFAdreesListViewController"
                                    },
                                @{
                                    @"title":@"银行卡管理",
                                    @"logo":@"icon_set_bank",
                                    @"class":@"MyJumpHTML5ViewController"
                                    }] mutableCopy],
                             @[@{
                                   @"title":@"关于我们",
                                   @"logo":@"icon_aboutus",
                                   @"class":@"HFIMMessageController"
                                   }]
                             ] mutableCopy];
    if (self.RMGrade != 1) {
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr[0]];
        [arr1 insertObject:@{
                             @"title":@"我的名片",
                             @"logo":@"icon_mycard",
                             @"class":@"MyIdcardViewController"
                             } atIndex:1];
        
        arr[0] = arr1;
    }
    self.settingvView.arrDateSoure = [NSArray arrayWithArray:arr];
    __weak typeof (self) weakself = self;
    self.settingvView.setttinBlock = ^(NSString * _Nonnull detail, PersonCenterSetingViewClickType type) {
        switch (type) {
            case PersonCenterSetingViewClickTypeLoginOut:
            {
                //退出登录
                [weakself LoginOut];
            }
                break;
            case PersonCenterSetingViewClickTypeCellClick:
            {
                //cell点击
                [weakself cellClickForStr:detail];
            }
                break;
                
            default:
                break;
        }
    };
    
}
- (PersonCenterSetingView *)settingvView{
    if (!_settingvView) {
        _settingvView = [[PersonCenterSetingView alloc] init];
        _settingvView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
    }
    return _settingvView;
}

/**
 cell点击
 
 @param str 通过传过的str来判断跳转
 */
- (void)cellClickForStr:(NSString *)str{

    if ([str isEqualToString:@"HFAdreesListViewController"]) {
        HFAdreesListViewController *vc = [[HFAdreesListViewController alloc] init];
        vc.viewModel.fromeSource = HFAddressListViewModelSourceMine;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:@"MyJumpHTML5ViewController"]){//银行卡管理
        NSString *strUrl = [NSString stringWithFormat:@"/html/bankcard.html?parent=1&sid=%@", (USERDEFAULT(@"sid")?:@"")];
        MyJumpHTML5ViewController * HtmlVC = [[MyJumpHTML5ViewController alloc] init];
        HtmlVC.webUrl = strUrl;
        [self.navigationController pushViewController:HtmlVC animated:YES];
        
    }else if ([str isEqualToString:@"HFIMMessageController"]){//关于我们
        NSString *strUrl = [NSString stringWithFormat:@"%@/html/aboutHeFa.html?hideTitle=1", fyMainHomeUrl];
        HFIMMessageController* HtmlVC = [[HFIMMessageController alloc] init];
//        HtmlVC.isMore = YES;
        HtmlVC.title = @"关于我们";
        HtmlVC.url = strUrl;
        [self.navigationController pushViewController:HtmlVC animated:YES];
        
    }
    else {
        Class class = NSClassFromString(str);
        UIViewController *vc = [[class alloc] init];
        
        NSDictionary *parameter = @{@"imagePath": self.imagePath ?: @""} ;
        [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // 在属性赋值时，做容错处理，防止因为后台数据导致的异常
            if ([vc respondsToSelector:NSSelectorFromString(key)]) {
                [vc setValue:obj forKey:key];
            }
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 退出登录
 */
- (void)LoginOut{
    NSLog(@"退出登录");
    [CustomPasswordAlter showCustomPasswordAlterViewViewIn:self.view title:@"确定退出登录？" suret:@"确认" closet:@"取消" sureblock:^{
        [self requestLoginOut];
    } closeblock:^{
        
    }];
    
}
- (void)requestLoginOut{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./logout"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseObject);
        NSInteger state = [[request.responseObject objectForKey:@"state"] integerValue];
        switch (state) {
            case 1:
            {
                //退出成功
                [HFUserDataTools logout];
                [self.tabBarController setSelectedIndex:0];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
                break;
                
            default:
                //退出失败
                [self showSVProgressHUDErrorWithStatus:@"退出失败!"];
                break;
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseString);
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
        
    }];
}

@end
