//
//  LocalLoginViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/23.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "LocalLoginViewController.h"
#import "NIMKit.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "NIMContactTools.h"
#import "JPUSHService.h"


@interface LocalLoginViewController ()

@end

@implementation LocalLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.mj_header = nil;
    @weakify(self);
    [RACObserve(self.webView, canGoBack)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.webView.canGoBack == YES) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }];

//    self.mainUrlStr = @"http://192.168.0.77:7080/html/house/login/land.html";
}
#pragma mark ##########WKNavigationDelegate  代理相关协议方法################
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    PopAppointViewControllerModel*model = [NavigationContrl getModelFrom:urlStr];
    if ([model.pageTag isEqualToString:@"fy_kefu" ]) {
        HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
        pvc.title = model.title;
        pvc.naviBg = model.naviBg;
        pvc.isNavigationBarshow = model.showNavi;
        pvc.naviMask = model.naviMask;
        pvc.naviMaskHeight = model.naviMaskHeight;
        pvc.urlStr = urlStr;
        pvc.pageTag = model.pageTag;
        pvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pvc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
#pragma mark #############新登录##################
- (void)login:(id)body{
    NSLog(@"%@",body);
    NSDictionary *dic = body;
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *accid = [NSString stringWithFormat:@"%@",dic[@"accid"]];
    NSString *userCenterInfo = [NSString stringWithFormat:@"%@",dic[@"userCenterInfo"]];
    NSString *token = [NSString stringWithFormat:@"%@",dic[@"token"]];
    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"sid"]];
    NSString *mobilephone = [NSString stringWithFormat:@"%@",dic[@"mobilephone"]];
//
//    if (sid) {
//        [self setAllWebViewObjectWitKey:@"sid" Value:sid];
//    }
//    if (userCenterInfo) {
//        [self setAllWebViewObjectWitKey:@"userCenterInfo" Value:userCenterInfo];
//
//    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (accid.length > 0) {
        [ud setObject:accid forKey:@"accid"];
    }
    if (token.length > 0) {
        [ud setObject:token forKey:@"token"];
    }
    if (uid.length > 0) {
        [ud setObject:uid forKey:@"uid"];
    }
    if (mobilephone.length > 0) {
        [ud setObject:mobilephone forKey:@"mobilephone"];
        [ud setObject:mobilephone forKey:@"NIMmobilephone"];
    }
    if (sid.length>0) {
        [ud setObject:sid forKey:@"sid"];
    }
    [ud synchronize];

    __weak typeof(self) weakSelf = self;
    [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) { // 表示绑定成功
            NSDictionary *reqDic = @{@"uid":uid,@"sid":sid};
            
            NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.notification-push/user-notification/repush"];
            if (getUrlStr) {
                getUrlStr = getUrlStr;
            }
            
            [weakSelf requestData:reqDic withUrl:getUrlStr];
        }
    } seq:2];
  //  [JPUSHService setAlias:uid callbackSelector:nil object:nil];
    
    
    
    //调IM聊天登录
//      [self loginAtNetease:@{
//                             @"accid":accid,
//                             @"token":token
//                             }];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isSelectMine"]) {
        UITabBarController *tab = self.navigationController.tabBarController;
        tab.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isSelectMine"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
//     [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)set:(UIViewController*)VC TabarItemImage:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
    
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)logout:(id)body{
    [self logoutAtNetease:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobilephone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [self setIMBage];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
  //  [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"ture" forKey:@"isLogout"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setIMBage{
    
//    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([tab isKindOfClass:[UITabBarController class]]) {
//        UINavigationController *navc = tab.viewControllers[3];
//        if ([navc isKindOfClass:[UINavigationController class]]) {
//            UIViewController *vc = navc.viewControllers[0];
//                vc.tabBarItem.badgeValue = nil;
//        }
//    }
    
}
- (void)setIMBageAfterLogin{
//    NSInteger count =    [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
//    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([tab isKindOfClass:[UITabBarController class]]) {
//        UINavigationController *navc = tab.viewControllers[3];
//        if ([navc isKindOfClass:[UINavigationController class]]) {
//            UIViewController *vc = navc.viewControllers[0];
//            if (count>0) {
//                
//                vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];;
//
//            }else{
//            vc.tabBarItem.badgeValue = nil;
//            }
//        }
//    }
    
}
- (void)loginAtNetease:(id)body{/*
                                 "accid":"99477", "token":"e7b315a9979b3bfdf8eb79081cdd9ba0"
                                 */
    NIMContactTools *NIMTools = [NIMContactTools  shareTools];
    NIMTools.contactTab = nil;
    NSDictionary *dic = body;
    // 徐少
    NSString *accid = dic[@"accid"];
    NSString *token = dic[@"token"];
    //    NSString *accid = @"99477";//dic[@"accid"];
    //    NSString *token = @"3758588408fff41f97ac64533c7101a9";//dic[@"token"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:accid forKey:@"account"];
    [ud setObject:token forKey:@"token"];
    [ud synchronize];
    if (accid&&token) {
        __weak typeof(self) weakSelf = self;

        [[[NIMSDK sharedSDK] loginManager] login:accid
                                           token:token
                                      completion:^(NSError *error) {
                                          //                                      [SVProgressHUD dismiss];
                                          if (error == nil)
                                          {
                                              LoginData *sdkData = [[LoginData alloc] init];
                                              sdkData.account   = accid;
                                              sdkData.token     = token;
                                              [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                              [[NTESServiceManager sharedManager] start];
                                              
                                              
                                              NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                              [ud setObject:accid forKey:@"account"];
                                              [ud setObject:token forKey:@"token"];
                                              [ud synchronize];
                                              [weakSelf setIMBageAfterLogin];
                                          } else {
                                              //                                              NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                          }
                                      }];
    }
    
}
- (void)logoutAtNetease:(id)info{
    NIMContactTools *NIMTools = [NIMContactTools  shareTools];
    NIMTools.contactTab = nil;
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
}

#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url {
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

- (void)dealloc{
    
    if (self.loginSucc) {
        self.loginSucc();
    }
}

@end
