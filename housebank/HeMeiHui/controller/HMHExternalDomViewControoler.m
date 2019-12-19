//
//  ExternalDomViewControoler.m
//  testViewController
//
//  Created by Qianhong Li on 2017/10/26.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import "HMHExternalDomViewControoler.h"
#import "HMHADViewController.h"
#import "PayTools.h"
#import "SGScanningQRCodeVC.h"
#import "HMHPopWindowViewController.h"
#import "HMHPayPopWindowViewController.h"
#import "HMHPhoneBookViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "NIMSessionViewController.h"
#import "NTESSessionViewController.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "NTESDemoRegisterTask.h"
#import "HMHContactTabViewController.h"
#import "UIViewController+BackButtonHandler.h"

#define adImageArraryName "adImageArraryName"
#define adImageArraryLink "adImageArraryLink"

@interface HMHExternalDomViewControoler ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIDocumentInteractionControllerDelegate,BeeCloudDelegate,UIAlertViewDelegate,payToolDelegete,ShareToolDelegete,ScanDelegate,NIMLoginManagerDelegate>
//@property (nonatomic, strong)WKWebView * webView;
//@property (nonatomic, strong) DetailViewController *MVPlayer;
@property (nonatomic, strong) UIDocumentInteractionController *HMH_documentController;
@property (nonatomic, assign) NSUInteger HMH_loadCount;
@property (nonatomic, assign) BOOL HMH_hasNetWork;
@property (nonatomic, assign) BOOL HMH_isFristComeIN;
@property (nonatomic, assign) BOOL HMH_isKeyBoardsShow;
@property (nonatomic, copy)   NSString *HMH_currentUrl;
@property (nonatomic,strong)  NSArray *HMH_UpDdArrary;
@property (nonatomic,strong)HMHADViewController *HMH_PayADViewController;
@property (nonatomic, strong)ManagerTools *HMH_tools;
@property (nonatomic, strong)PayTools *HMH_payTool;
@property (nonatomic, strong)ShareTools *HMH_shareTool;
@property (nonatomic, assign)BOOL HMH_isCan;
@property (nonatomic, strong) UILabel *HMH_noticelabel;
@property (nonatomic, assign)BOOL HMH_isCanPopViewCurrentController;
@property (nonatomic, assign)BOOL HMH_isFristLoadWebView;

@end

@implementation HMHExternalDomViewControoler

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    if (self.isNavigationBarshow) {
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.navigationController.navigationBarHidden = YES;
    }

    [self supportedInterfaceOrientations];
//    [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//    [[self class]attemptRotationToDeviceOrientation];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithHexString:@"#ffffff"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#222222" ];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isNavigationBarshow) {
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = !self.isNavigationBarshow;
    if (self.isNavigationBarshow) {
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.navigationController.navigationBarHidden = YES;
    }

    self.HMH_isFristLoadWebView = YES;
    self.currentUrl = self.urlStr;
    self.HMH_isCanPopViewCurrentController = YES;
    
    _HMH_isFristComeIN     = YES;
    _HMH_payTool   = [[PayTools alloc]init];
    _HMH_payTool.delegete   = self;
    _HMH_shareTool = [[ShareTools alloc]init];
    _HMH_shareTool.delegete = self;
    [self initWebView];
   //  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    UIView *blackView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    [self.view addSubview:blackView];
//    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);//使左边等于self.view的左边，间距为0
//        make.top.equalTo(self.view.mas_top).offset(0);//使顶部与self.view的间距为0
//        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(@20);//设置高度为self.view高度的一半
//    }];
//    blackView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:blackView];
    [self regiserNotification];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"合美惠";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon-fh.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon-fh.png"] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(enterPersonInfoCard:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon-gb@2x"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon-gb@2x"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *popButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 15;
    self.navigationItem.leftBarButtonItems = @[backButtonItem,negativeSpacer,popButtonItem];
}

// 返回
- (void)enterTeamCard:(UIButton *)btn{
    
    if ([self.webView canGoBack]) { // 页内跳转
        [self.webView goBack];
    }else{
        if(self.isPushFromVideoWeb){//如果是来自视频直播 防止跳转到空白页popAppointvc
            for (int i = 0;i < self.navigationController.viewControllers.count;i++) {
                
                UIViewController *temp = self.navigationController.viewControllers[i];
                if ([temp isKindOfClass:[HMHPopAppointViewController class]]) {
                    
                    [self.navigationController popToViewController:self.navigationController.viewControllers[i-1] animated:YES];
                }
            }
            return;
        }
        // 如果不是来自视频直播的跳转 就直接pop
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//关闭
- (void)enterPersonInfoCard:(UIButton *)btn{
    if (self.isPushFromVideoWeb) { // 如果是来自视频直播
        for (int i = 0;i < self.navigationController.viewControllers.count;i++) {

            UIViewController *temp = self.navigationController.viewControllers[i];
            if ([temp isKindOfClass:[HMHPopAppointViewController class]]) {

                [self.navigationController popToViewController:self.navigationController.viewControllers[i-1] animated:YES];
            }

        }
        return;
    }
    // 如果不是来自视频直播的跳转 就直接pop
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark ##############################webView初始化相关##################################

- (WKWebView *)configwebView {
    if (_webView == nil){
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.javaScriptEnabled = YES;
        configuration.preferences = preferences;
        if (_isNavigationBarshow) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - KTopHeight-KBottomSafeHeight) configuration:configuration];
        }else
        {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight) configuration:configuration];
        }
        
        
        [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString  *result, NSError *error) {
            //1）获取默认userAgent：
            NSString *oldUA = result;  //直接获取为nil
            NSLog(@"result-----%@",oldUA);
            //2）设置userAgent：添加额外的信息
            NSString *newUA = [NSString stringWithFormat:@"%@", oldUA];
            
            NSDictionary *dictNU = [NSDictionary dictionaryWithObjectsAndKeys:newUA.length == 0 ? @"":newUA, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictNU];
            
            //        __weak typeof(self) weakSelf = self;
            //        weakSelf.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        }];
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        self.progressView.tintColor = [UIColor redColor];

//    注释web加载进度
//        [_webView addSubview:self.progressView];
        _webView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        _webView.UIDelegate = self; // 设置WKUIDelegate代理
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)initWebView{
    self.webView = [self configwebView];
    [self.view addSubview:self.webView];
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:wkUserScript];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
//    [self webView];
//    NSString *encodedString=[self.currentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    //监听加载进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];

}
- (void)removeCache
{
    NSString *version = [[UIDevice currentDevice]systemVersion];
    NSArray * versionArr = [version componentsSeparatedByString:@"."];
    NSInteger versionNum = [versionArr[0] integerValue];
    if (versionNum >=9) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
        
    }else if(versionNum>=8){
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    }
}

#pragma mark ##########WKNavigationDelegate  代理相关协议方法################
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    // .*/html/order/main/placeorder_r.html.*
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    self.HMH_isFristLoadWebView = NO;
    if (![self.webView canGoBack]) {
        self.HMH_isCanPopViewCurrentController = YES;
    }else{
        
        self.HMH_isCanPopViewCurrentController = NO;
    }
    self.currentUrl    = urlStr;
    self.HMH_isFristComeIN =NO;
    if ([scheme isEqualToString:@"mailto"]) {
        
        [[UIApplication sharedApplication] openURL:URL];
        
    }if([urlStr rangeOfString:@"downLoad=0"].location!= NSNotFound){
        
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }else if(([urlStr rangeOfString:@"/download/"].location !=NSNotFound&&[urlStr rangeOfString:@"downLoad=0"].location== NSNotFound)||[urlStr rangeOfString:@"downLoad=1"].location!= NSNotFound){
        [self downloadFileWithUrl:urlStr];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([scheme isEqualToString:@"tel"]) {
        
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if ([urlStr containsString:@"https://itunes.apple.com/cn/app/he-fa-fang-yin/id1447851000"]) {
        
        [self presentOtherViewController:urlStr];
        //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id934245416"]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //注册极光
    NSLog(@"didFinishNavigation");
    
}

//失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailNavigation");
    
    if([error code] == NSURLErrorCancelled)
        
    {
        
        return;
        
    }
    self.HMH_loadCount --;
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.HMH_loadCount ++;
    
}

// 内容返回时

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.HMH_loadCount --;
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%@",error);
    
    
}
#pragma Mark 监听进度###############################
- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary* )change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        //  self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress >= 0.5) {
            [self hideMBProgressHUD];
        }
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
- (void)setHMH_LoadCount:(NSUInteger)HMH_loadCount {
    _HMH_loadCount = HMH_loadCount;
    if (HMH_loadCount == 0) {
        [self hideMBProgressHUD];
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        [self showMBProgressHUD];
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (HMH_loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        if (newP >= 0.5) {
            [self hideMBProgressHUD];
        }
        
        [self.progressView setProgress:newP animated:YES];
    }
}
#pragma mark ###########- 重写导航back的 协议方法###############
- (BOOL)navigationShouldPopOnBackButton{
    if (self.HMH_isCanPopViewCurrentController) {
        if (self.isPushFromVideoWeb) { // 如果是来自视频直播
            for (int i = 0;i < self.navigationController.viewControllers.count;i++) {
                
                UIViewController *temp = self.navigationController.viewControllers[i];
                if ([temp isKindOfClass:[HMHPopAppointViewController class]]) {
                    
                    [self.navigationController popToViewController:self.navigationController.viewControllers[i-1] animated:YES];
                }
            }
            return YES;
        }
        
        return YES;
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
        return NO;
    }
}

#pragma mark ###########- WKScriptMessageHandler 协议方法###############

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    } else {
        
    }
}
#pragma mark #####################JS OC交互的一些方法######################
#pragma mark##############调通讯录#################
- (void)openContactsWindow:(id)body{
    
    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    BOOL islogin =  [[[NIMSDK sharedSDK]loginManager] isLogined];
    //如果有缓存用户名密码推荐使用自动登录
    if (!islogin){ // 如果登录失败 重新登录
        if (!data) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            account = [ud objectForKey:@"account"];
            token = [ud objectForKey:@"token"];
        }
        if (account&&token) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[account,token] forKeys:@[@"accid",@"token"]];
            [self loginAtNetease:dic];
        }
        
    }
    if (body) {
        
        [self openChatWithAccidInfo:body];
    }
}

#pragma mark ##############IM相关##################
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
- (void)logoutAtNetease:(id)info{
    
    
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    
}
- (void)openChatWithAccidInfo:(id)infoDic{
    
    HMHContactTabViewController *conVC = [[HMHContactTabViewController alloc]init];
    HMHPhoneBookViewController *phoneVC = [[HMHPhoneBookViewController alloc]init];
    phoneVC.InviteClick = ^(NSString*PhoneNum){
        
        NSDictionary *dic =@{
                             @"requestCode" : @(1),
                             @"phoneNo"     :PhoneNum
                             };
        NSString *JsonStr = [dic modelToJSONString];
        NSString *jsStr   = [NSString stringWithFormat:@"inviteCallback('%@')",JsonStr];
        [self.webView evaluateJavaScript:jsStr
                       completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                           if (error) {
                               // NSLog(@"错误:%@", error.localizedDescription);
                           }
                       }];
        
    };
    conVC.phoneVC = phoneVC;
    conVC.automaticallyAdjustsScrollViewInsets = NO;
    conVC.infoDic = infoDic;
    [self.navigationController pushViewController:conVC animated:YES];
    
}
- (void)ToAdViewController:(id)body{
    NSDictionary *dic = body;
    NSString *url = dic[@"url"];
    HMHADViewController *ad = [[HMHADViewController alloc]init];
    ad.HMH_urlStr = url;
    
    [self.navigationController pushViewController:ad animated:YES];
}
#pragma Mark##################支付相关###################
- (void)jsCallOC:(id)body {
    
    [_HMH_payTool doPayWith:body];
    
}
#pragma Mark ######################打开APPStore########################
- (void)checkUpgrade:(id)body{
    NSString *message;
    BOOL isUpdate;
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = body;
        message = dic[@"msg"];
        isUpdate = dic[@"upgrade"];
    }
    if (isUpdate) {
        [_HMH_tools goAheadAppSrore:message];
    }
    
}

#pragma Mark ######################支付回调########################
- (void)onBeeCloudResp:(BCBaseResp *)resp{
    
    NSDictionary *dic =@{
                         @"result_code" : [NSString stringWithFormat:@"%ld",(long)resp.resultCode],
                         @"msg" : resp.resultMsg,
                         
                         };
    NSString *JsonStr = [dic modelToJSONString];
    NSString *jsStr   = [NSString stringWithFormat:@"payCallBack('%@')",JsonStr];
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                       if (error) {
                           // NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
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
                           // NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}

#pragma 下载文件
- (void)downLoadFile:(id)dic{
    
    if ([dic isKindOfClass:[NSString class]]) {
        
        [self downloadFileWithUrl:dic];
        
    }
    
}
#pragma Mark###################视频播放###########################
- (void)videoPlay:(id)body{
    
    NSDictionary *dic    = (NSDictionary*)body;
    if (!dic) {
        return;
    }
    NSString *urlStr     =dic[@"url"];
    if (!urlStr) {
        
        return;
    }
    HMHADViewController *adViewController = [[HMHADViewController alloc]init];
    adViewController.HMH_urlStr            = dic[@"url"];
    adViewController.HMH_color = dic[@"naviBg"];
    adViewController.HMH_isShowNavi = dic[@"showNavi"];
    adViewController.HMH_name = dic[@"title"];
    [self.navigationController pushViewController:adViewController animated:YES];
    
}
- (void)presentOtherViewController:(NSString*)url{
    
    HMHADViewController *adViewController = [[HMHADViewController alloc]init];
    adViewController.HMH_urlStr            = url;
    
    [self.navigationController pushViewController:adViewController animated:YES];
    
}
- (void)openPopupWindow:(id)body{
    
    NSDictionary *dic = body;
    HMHPopWindowViewController *pvc = [[HMHPopWindowViewController alloc]init];
    NSString * url = dic[@"url"];
    pvc.urlStr = url;
    if (dic[@"showTitle"]) {
        pvc.naTitle = @"title";
        pvc.isShowNaBar = !dic[@"showTitle"];
    }
    [self.navigationController pushViewController:pvc animated:YES];
}
- (void)closePopupWindow:(id)body{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backPressed:(id)body{
    
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma Mark#################获取版本号#####################

- (void)postVersionInfo:(id)body{
    NSString *fuctionN = body;
    NSString *currentVersion = [VersionTools appVersion];//_tools.appInfoModel.iosVersionCode;
    NSString *JsonStr = [currentVersion modelToJSONString];
    NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')", fuctionN,JsonStr];
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data,
                                       NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}
- (void)getDeviceInfo:(id)body{
    NSString *fuctionN = body;
    NSDictionary *currentVersion = [VersionTools InfoDic];
    NSString *JsonStr = [currentVersion modelToJSONString];
    NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,JsonStr];
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data,
                                       NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}
#pragma Mark#######################Log日志##########################

- (void)log:(id)body {
    
    NSString *UUIDStr = [VersionTools UUIDString];
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = body;
        NSMutableDictionary *mutabelDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (mutabelDic&&UUIDStr) {
            [mutabelDic setObject:UUIDStr forKey:@"deviceId"];
            [mutabelDic setObject:@"iOS" forKey:@"module"];
//            [ManagerTools postData:mutabelDic toUrl:@"/log/js"];
            
        }else{
            
            return;
        }
        
    }else{
        
        return;
        
    }
    
}

#pragma Mark#######################分享##########################
- (void)appShare:(id)body
{
    if (!_HMH_isCan) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        _HMH_isCan = !_HMH_isCan;
    }else{
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        _HMH_isCan = !_HMH_isCan;
    }
    [ShareTools  shareWithContent:body];
//    [_HMH_shareTool doShare:body];
    
}
- (void)sendShareState:(NSString *)state{
    
    [self.webView evaluateJavaScript:state
                   completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}

- (void)shareResultState:(NSString *)state{
    
}
#pragma Mark#######################拨打电话########################
- (void)callPhoneNum:(id)body
{
    //    NSString * phoneNum = [NSString stringWithFormat:@"%@",body];;
    //    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
-(void)put2bridge:(id)body{
    //设置tag
    NSLog(@"设置tag");
    
}
#pragma #######################扫描二维码#######################
- (void)scanningCode:(id)body{
    
    SGScanningQRCodeVC *svc = [[SGScanningQRCodeVC alloc]init];
    svc.body = body;
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
    
}
- (void)afterScan:(NSString *)ScanStr funcName:(NSString *)funName{
    
    NSLog(@"扫描结果：%@",ScanStr);
    NSString *fuctionN = funName;
    NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,ScanStr];
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data,
                                       NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
    
}

- (void)downloadFileWithUrl:(NSString*)urlStr{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了
        NSURL *fileURL = filePath;
        //NSLog(@"%@",filePath);
        _HMH_documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        _HMH_documentController.delegate = self;
        [self.HMH_documentController presentPreviewAnimated:YES];
        
    }];
    [downloadTask resume];
}

- (void)show:(UIViewController *)viewController{
    
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didReceiveRemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"aliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WX_PayResp" object:nil];
}



@end
