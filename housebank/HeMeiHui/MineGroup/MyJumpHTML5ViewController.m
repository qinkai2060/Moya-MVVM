//
//  MyJumpHTML5ViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/30.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyJumpHTML5ViewController.h"
#import "JPUSHService.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "HFDBHandler.h"
#import "PayTools.h"
#import "HMHPayPopWindowViewController.h"
#import "HFVIPViewController.h"
#import "SGScanningQRCodeVC.h"
#import "MyOrderViewController.h"
#import "WRNavigationBar.h"
#import "ResetSecondaryPasswordViewController.h"
#import "HMHExternalDomViewControoler.h"
#import "HFLoginViewController.h"

@interface MyJumpHTML5ViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,ScanDelegate>
@property (strong, nonatomic)   WKWebView                   *webView;
@property (copy, nonatomic)   NSArray              *webViewContifgArrary;
@property (nonatomic, strong)PayTools *HMH_payTool;

@end

@implementation MyJumpHTML5ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self wr_setNavBarBackgroundAlpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:!self.isShowNA animated:NO];
    [self.navigationController.navigationBar setHidden:!self.isShowNA];
    if (self.isShowNA) {
        [self addLeftBtn];
    }else {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    @weakify(self);
    [RACObserve(self.webView, canGoBack)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.webView.canGoBack == YES) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }];
}

- (void)addLeftBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 24, 24);
    [backBtn setImage:[UIImage imageNamed:@"back_light"] forState:UIControlStateNormal];
    @weakify(self);
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0,9);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _HMH_payTool   = [[PayTools alloc]init];
    _HMH_payTool.delegete   = self;
//    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self regiserNotification];
    [self initWKWebView];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
- (void)regiserNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWebView:) name:@"didReceiveRemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayResult:) name:@"aliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXPayResult:) name:@"WX_PayResp" object:nil];
}
- (void)reloadWebView:(NSNotification*)notification{
    
    NSDictionary *userInfo = notification.object;
    if (_webView) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[userInfo valueForKey:@"URL"]]]];
    }
    NSLog(@"%@",notification.userInfo);
}
- (void)initWKWebView
{
    self.webViewContifgArrary = @[@"jsCallOC",@"backToPath",@"openVideo",@"postReceiveAddress",@"backPath",@"appShare",
                                  @"postVersionInfo",@"callPhoneNum"
                                  ,@"destroyFromPay",
                                  @"videoPlay",@"getDeviceInfo",
                                  @"put2bridge",@"scanningCode",
                                  @"openPopupWindow",@"closePopupWindow",@"log"
                                  ,@"openPopupPayWindow",@"updatePopupPayWindow",
                                  @"closePopupPayWindow",
                                  @"openContactsWindow",
                                  @"checkUpgrade",@"loginAtNetease",@"logoutAtNetease",
                                  @"downLoadFile",@"openMsgWindow",
                                  @"downloadImage",@"loginAtMsg",@"backPressed",
                                  @"login",@"logout",@"getFromStorage",
                                  @"putIntoStorage",@"removeFromStorage",
                                  @"getLocation",@"getBadgeCount",
                                  @"getImBadgeCountByMchId",
                                  @"removeImBadgeByMchId",
                                  @"removeNotifictionBadge",
                                  @"openImMsgWindow",@"changeEnv",
                                  @"getFileDownloadStatus",@"startFileDownload",
                                  @"deleteDownloadTask",@"playLocalVideo",
                                  @"pauseDownloadTask",@"pedometerData",@"openExternalMap",@"openVideoHomeWindow",@"createQr",@"skipToVipHome",@"skipToNative"];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    configuration.preferences = preferences;

    CGFloat height = (self.isShowNA)? STATUSBAR_NAVBAR_HEIGHT:StatusBarHeight;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, height, ScreenW, ScreenH - height-KBottomSafeHeight) configuration:configuration];
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString *result, NSError *error) {
        //1）获取默认userAgent：
        NSString *oldUA = result; //直接获取为nil
//        NSLog(@"result-----%@",oldUA);
        //2）设置userAgent：添加额外的信息
        NSString *newUA = [NSString stringWithFormat:@"%@", oldUA];
        NSDictionary *dictNU = [NSDictionary dictionaryWithObjectsAndKeys:newUA.length == 0 ? @"":newUA, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictNU];
        
        //        __weak typeof(self) weakSelf = self;
        //        weakSelf.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    }];
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
   
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    if ([HFUserDataTools isLogin]) {
        NSString *jsString1 = [NSString stringWithFormat:@"localStorage.setItem('userCenterInfo','%@')",[HFUserDataTools convertToJsonData:[HFDBHandler selectLoginData]]];
        WKUserScript *wkUserScript1 = [[WKUserScript alloc] initWithSource:jsString1 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString2 = [NSString stringWithFormat:@"localStorage.setItem('sid','%@')",[[NSUserDefaults standardUserDefaults] objectForKey:@"sid"]];
        WKUserScript *wkUserScript2 = [[WKUserScript alloc] initWithSource:jsString2 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString3 = [NSString stringWithFormat:@"localStorage.setItem('codeValue','%@')",[[NSUserDefaults standardUserDefaults]  objectForKey:@"codeValue"]];
        WKUserScript *wkUserScript3 = [[WKUserScript alloc] initWithSource:jsString3 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString4 = [NSString stringWithFormat:@"localStorage.setItem('loginAreacode','%@')",[[NSUserDefaults standardUserDefaults]  objectForKey:@"loginAreacode"]];
        WKUserScript *wkUserScript4 = [[WKUserScript alloc] initWithSource:jsString4 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString5 = [NSString stringWithFormat:@"localStorage.setItem('loginName','%@')",[[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"]];
        WKUserScript *wkUserScript5 = [[WKUserScript alloc] initWithSource:jsString5 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString6 = [NSString stringWithFormat:@"localStorage.setItem('teminal','%@')",@"P_TERMINAL_MOBILE_B"];
        WKUserScript *wkUserScript6 = [[WKUserScript alloc] initWithSource:jsString6 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"orderStatus"] options:NSJSONReadingMutableContainers error:nil];
        //    NSString *jsString7 = [NSString stringWithFormat:@"localStorage.setItem('orderStatus','%@')",[HFUserDataTools convertToJsonData:dictionary]];
        //    WKUserScript *wkUserScript7 = [[WKUserScript alloc] initWithSource:jsString7 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString8 = [NSString stringWithFormat:@"localStorage.setItem('secPwd','%@')",[[NSUserDefaults standardUserDefaults] objectForKey:@"secPwd"]];
        WKUserScript *wkUserScript8 = [[WKUserScript alloc] initWithSource:jsString8 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [self.webView.configuration.userContentController addUserScript:wkUserScript1];
        [self.webView.configuration.userContentController addUserScript:wkUserScript2];
        [self.webView.configuration.userContentController addUserScript:wkUserScript3];
        [self.webView.configuration.userContentController addUserScript:wkUserScript4];
        [self.webView.configuration.userContentController addUserScript:wkUserScript5];
        [self.webView.configuration.userContentController addUserScript:wkUserScript6];
        //    [self.webView.configuration.userContentController addUserScript:wkUserScript7];
        [self.webView.configuration.userContentController addUserScript:wkUserScript8];
    }
    
    
    [self.webView.configuration.userContentController addUserScript:wkUserScript];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,self.webUrl]]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
//    for (NSString *config in self.webViewContifgArrary) {
//        [self.webView.configuration.userContentController addScriptMessageHandler:self name:config];
//    }

    
        for (NSString *config in self.webViewContifgArrary) {
            [self.webView.configuration.userContentController addScriptMessageHandler:self name:config];
        }
        [self clearWebCache];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didReceiveRemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"aliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WX_PayResp" object:nil];
//    NSLog(@"%s",__FUNCTION__);
    for (NSString *config in self.webViewContifgArrary) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:config];
    }
}
#pragma #######################扫描二维码#######################
- (void)scanningCode:(id)body{
    
    SGScanningQRCodeVC *svc = [[SGScanningQRCodeVC alloc]init];
    svc.body = body;
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
    
}
-(NSDictionary *) parameterWithURL:(NSURL *) url {
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    
    return parm;
}
- (void)afterScan:(NSString *)ScanStr funcName:(NSString *)funName{
    
    NSURL *urlTest =  [NSURL URLWithString:[ScanStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([ScanStr containsString:@"oto-orderVerification-hand.html"]) {
        NSDictionary *Dic = [self parameterWithURL:[NSURL URLWithString:[ScanStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSData * data = [[Dic valueForKey:@"c"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *sid = USERDEFAULT(@"sid")?:@"";
        
        NSDictionary *dic = @{
                              @"sid":sid,
                              @"code":[Dic valueForKey:@"c"],
                              @"orderNo":[dataDic valueForKey:@"rughuQr"]
                              };
        NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/otoCertification"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",request.responseObject);
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
            if ([[dic objectForKey:@"state"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"核销成功"];
                [SVProgressHUD dismissWithDelay:1];
                MyOrderViewController *order = [[MyOrderViewController alloc] init];
                [self.navigationController pushViewController:order animated:YES];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"核销码失效"];
                [SVProgressHUD dismissWithDelay:1];
            }
        } error:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD showErrorWithStatus:@"核销码失效"];
            [SVProgressHUD dismissWithDelay:1];
        }];
        
    }else {
//        if([ScanStr containsString:@"h/o/s.html"]||[ScanStr containsString:@"h/o/p.html"]||[ScanStr containsString:@"shorturl"]){
            NSLog(@"扫描结果：%@----%@",ScanStr,funName);
            NSString *fuctionN = funName;
            NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,ScanStr];
            [self.webView evaluateJavaScript:jsStr
                           completionHandler:^(id _Nullable data,
                                               NSError * _Nullable error) {
                               if (error) {
                                   NSLog(@"错误:%@", error.localizedDescription);
                               }
                           }];
//        }else {
//            [SVProgressHUD showErrorWithStatus:@"该二维码暂不支持"];
//            //            [SVProgressHUD dismiss];
//        }
        
        
    }
    
}

#pragma mark #####################JS OC交互的一些方法######################
#pragma mark##############调通讯录#################

- (void)backToPath:(id)body {

}
#pragma mark - private method

#pragma mark - WKUIDelegate
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    
//    
//    
//}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    if ([scheme isEqualToString:@"tel"]) {
        
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    //根据url取 PopAppointViewControllerToos中的配置model
    PopAppointViewControllerModel*appointModel = [NavigationContrl getModelFrom:urlStr];
    PageUrlConfigModel *pageUrlModel = [NavigationContrl getPageurlModelFrom:urlStr];
    //不是以main_*或者url_开头
    if (appointModel&&([appointModel.pageTag isEqualToString:@"fy_login"]||[appointModel.pageTag isEqualToString:@"fy_quick_login"] )) {
        [HFLoginViewController showViewController:self];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([urlStr containsString:@"https://itunes.apple.com/cn/app/he-fa-fang-yin/id1447851000"]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1447851000"]];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    mianTab_type type = [[PopAppointViewControllerToos sharePopAppointViewControllerToos] isPopNewWindowWithcheckUrl:urlStr];
    if (type!=external_domain) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        if (appointModel&&![pageUrlModel.pageTag isEqualToString:@"fy_login"]&&![pageUrlModel.pageTag isEqualToString:@"fy_quick_login"]) {
            //对于本页面来说，只有两种状态，1是要开新窗口。2.是要加载
            
            if (type==main_home||type==main_mine) { //||type==main_mall||type==main_globalhome||type==main_moments
                //导航切换tab
                [NavigationContrl changeTabIndexWith:type and:self.navigationController and:urlStr and:pageUrlModel];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    PopAppointViewControllerToos *popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if ([popTool isPopNewWindowWithcheckUrl:urlStr]&&![urlStr isEqualToString:@"about:blank"]&&navigationAction.targetFrame.isMainFrame==YES&&![scheme isEqualToString:@"mailto"]&&![scheme isEqualToString:@"tel"]) {
        if ([popTool.currentPopModle.pageTag isEqualToString:@"fy_external_domain"]) {
            //        if ([popTool.currentPopModle.pageTag isEqualToString:@"fy_external_domain"]) {
            HMHExternalDomViewControoler *evc = [[HMHExternalDomViewControoler alloc]init];
            if ([popTool.currentPopModle.title isEqualToString:@"合发"]) {
                evc.navigationItem.title = @"合美惠";
            }else
            {
                evc.navigationItem.title = popTool.currentPopModle.title;
            }
            evc.naviBg = popTool.currentPopModle.naviBg;
            evc.isNavigationBarshow = popTool.currentPopModle.showNavi;
            evc.naviMask = popTool.currentPopModle.naviMask;
            evc.naviMaskHeight = popTool.currentPopModle.naviMaskHeight;
            evc.urlStr = urlStr;
            evc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController pushViewController:evc animated:NO];
//            [NavigationContrl changeTabIndexWith:type and:self.navigationController and:urlStr and:pageUrlModel];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
            //            [self.navigationController pushViewController:evc animated:YES];
            //            decisionHandler(WKNavigationActionPolicyCancel);
            //            return;
        }
        HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
        pvc.title = popTool.currentPopModle.title;
        pvc.naviBg = popTool.currentPopModle.naviBg;
        pvc.isNavigationBarshow = popTool.currentPopModle.showNavi;
        pvc.naviMask = popTool.currentPopModle.naviMask;
        pvc.naviMaskHeight = popTool.currentPopModle.naviMaskHeight;
        pvc.urlStr = urlStr;
        [self.navigationController pushViewController:pvc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)openPopupPayWindow:(id)body{
    
    NSDictionary *dic = body;
    HMHPayPopWindowViewController *pvc = [[HMHPayPopWindowViewController alloc]init];
    NSString * url = dic[@"url"];
    pvc.urlStr = url;
    if (dic[@"title"]) {
        pvc.naTitle = dic[@"title"];
        pvc.isShowNaBar = dic[@"showNavi"];
        pvc.BgColor = dic[@"naviBg"];
        //        pvc.naviMaskHeight =
    }
    __weak  typeof (self)weakSelf = self;
    
    pvc.pass = ^(NSInteger state){
        
        [weakSelf callBack:[NSString stringWithFormat:@"%ld",state]];
        
    };
    [self.navigationController pushViewController:pvc animated:YES];
    
}
- (void)aliPayResult:(NSNotification*)result{
    
    NSDictionary*dic = result.object;
    NSString *resoultStr = dic[@"resultStatus"];
    //NSString *reslut = dic[@"resultStatus"];
    if ([resoultStr isEqualToString:@"9000"]) {
        
        [self callBack:@"0"];
        
    }else if ([resoultStr isEqualToString:@"6001"]){
        
        [self callBack:@"-2"];
        
    }else {
        
        [self callBack:@"-1"];
        
    }
    
}
- (void)WXPayResult:(NSNotification*)result{
    /*
     WXSuccess           = 0,    *< 成功
     WXErrCodeCommon     = -1,   *< 普通错误类型
     WXErrCodeUserCancel = -2,   *< 用户点击取消并返回
     WXErrCodeSentFail   = -3,   *< 发送失败
     WXErrCodeAuthDeny   = -4,   *< 授权失败
     WXErrCodeUnsupport  = -5,   *< 微信不支持
     */
    if ([result.object isKindOfClass:[NSString class]]) {
        [self callBack:result.object];
        return;
    }
    if ([result.object isKindOfClass:[PayResp class]]) {
        PayResp*response=result.object;
        NSString *message;
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                message = @"支付成功";
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                message = @"支付失败";
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                message = @"用户取消成功";
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                message = @"发送失败";
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                message = @"微信不支持";
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                message = @"授权失败";
            }
                break;
            default:
                break;
        }
        
        [self callBack:[NSString stringWithFormat:@"%d",response.errCode]];
        return;
    }
    
}
- (void)callBack:(NSString*)str{
    
    NSDictionary *dic =@{
                         @"result_code" : str,
                         
                         };
    NSString *JsonStr = [dic modelToJSONString];
    NSString *jsStr   = [NSString stringWithFormat:@"payCallBack('%@')",JsonStr];
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                       if (error) {
                            NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}
- (void)jsCallOC:(id)body {
    
    [_HMH_payTool doPayWith:body];
    
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //rm礼包跳转二级密码
    if ([message.name isEqualToString:@"skipToNative"]) {

        if ([[message.body valueForKey:@"args"] isEqualToString:@"reset"]) {
            //重置
            ResetSecondaryPasswordViewController *vc = [[ResetSecondaryPasswordViewController alloc] init];
            vc.isNavigation = YES;
            vc.ntitle = @"二级密码重置";
            [self.navigationController pushViewController:vc animated:YES];
           
        } else if ([[message.body valueForKey:@"args"] isEqualToString:@"set"]){
            //设置
            ResetSecondaryPasswordViewController *vc = [[ResetSecondaryPasswordViewController alloc] init];
            vc.isNavigation = YES;
            vc.ntitle = @"二级密码设置";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //走到这找刘彩云
        }
    }
    
    
    if ([message.name isEqualToString:@"skipToVipHome"]) {
        HFVIPViewController *vc = [[HFVIPViewController alloc] initWithViewModel:nil];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([message.name isEqualToString:@"jsCallOC"]) {
        [self jsCallOC:message.body];
    }
    if ([message.name isEqualToString:@"openPopupPayWindow"]) {
        [self openPopupPayWindow:message.body];
    }
    if ([message.name isEqualToString:@"login"]) {
        [self  login:message.body];
    }
    if ([message.name isEqualToString:@"putIntoStorage"]) {
        [self putIntoStorage:message.body];
    }
    if ([message.name isEqualToString:@"scanningCode"]) {
        [self scanningCode:message.body];
    }
    if ([message.name isEqualToString:@"getDeviceInfo"]) {
        NSString *fuctionN = message.body;
        NSDictionary *currentVersion = [VersionTools InfoDic];
        NSString *JsonStr = [currentVersion modelToJSONString];
        NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,JsonStr];
        [self.webView evaluateJavaScript:jsStr
                       completionHandler:^(id _Nullable data,
                                           NSError * _Nullable error) {
                           if (error) {
//                               NSLog(@"错误:%@", error.localizedDescription);
                           }
                       }];
    }
    if ([message.name isEqualToString:@"appShare"]) {
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            [ShareTools shareWithContent:[ShareTools dict:message.body]];
        }else {
            [MBProgressHUD showAutoMessage:@"分享失败"];
        }
    }

    if ([message.name isEqualToString:@"backPressed"]) {
             if ([self.webView canGoBack]) {
                [self.webView goBack];
                return;
            }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([message.name isEqualToString:@"backToPath"]) {
//        user_center
        
        if ([[message.body valueForKey:@"backPath"] isEqualToString:@"hmh_home"]) {
            //注册rm返回首页
            UITabBarController *tab = self.navigationController.tabBarController;
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            tab.tabBar.hidden = NO;
            tab.selectedIndex = 0;
            
        } else {
          [self.navigationController popViewControllerAnimated:NO];
        }
    }
}
-(void)putIntoStorage:(id)body{
    
    NSDictionary *dic = body;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *callback = dic[@"callback"];
        NSString *key = dic[@"key"];
        NSString *val = dic[@"val"];
        NSString *jsonStr = [NSString stringWithFormat:@"%@('%@','%@')",callback,key,val];
        [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (!error) {//成功
                //                [self.webView reload];
//                NSLog(@"保存success:%@",[self class]);
            }else{//失败
//                NSLog(@"保存failed:%@",[self class]);
            }
            
        }];
    }
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {

        decisionHandler(WKNavigationResponsePolicyAllow);
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
    [SVProgressHUD show];
    [self performSelector:@selector(fiveHiddenSV) withObject:nil afterDelay:4];

}
- (void)fiveHiddenSV{
    [SVProgressHUD dismiss];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%s", __FUNCTION__);
    [SVProgressHUD dismiss];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView
{
//    NSLog(@"%s", __FUNCTION__);
}
- (void)delloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"postReceiveAddress"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"backToPath"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clearWebCache];
}
- (void)clearWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                //WKWebsiteDataTypeLocalStorage,
                                
                                //WKWebsiteDataTypeCookies,
                                
                                //WKWebsiteDataTypeSessionStorage,
                                
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                
                                //WKWebsiteDataTypeWebSQLDatabases
                                ]];
        
        //// All kinds of data
        
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (void)login:(id)body{
//    NSLog(@"%@",body);
    /*
     accid = 160395;
     mobilephone = 13524647085;
     token = 1bfe0f0cf23e65b790ba1a6da0d7e4e3;
     uid = 160395;
     */
    NSDictionary *dic = body;
    NSString *accid = [NSString stringWithFormat:@"%@",dic[@"accid"]];
    NSString *token = [NSString stringWithFormat:@"%@",dic[@"token"]];
    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
    NSString *mobilephone = [NSString stringWithFormat:@"%@",dic[@"mobilephone"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"sid"]];
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
    }
    if (sid.length>0) {
        
        [ud setObject:sid forKey:@"sid"];
        
    }
    [ud synchronize];
    //    [JPUSHService setAlias:uid callbackSelector:nil object:nil];
    [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
    
    [self loginAtNetease:body];
    if (self.navigationController.viewControllers.count>2) {
        HMHBaseViewController *BVC =self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
        if ([BVC isKindOfClass:[HMHBaseViewController class]]) {
            [BVC.webView reload];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self loginAtMsg:<#(id)#>]
}
- (void)loginAtNetease:(id)body{/*
                                 "accid":"99477", "token":"e7b315a9979b3bfdf8eb79081cdd9ba0"
                                 */
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
                                              
                                          }
                                          else
                                          {
                                              // NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                              // [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                          }
                                          
                                      }];
    }
    
}

@end
