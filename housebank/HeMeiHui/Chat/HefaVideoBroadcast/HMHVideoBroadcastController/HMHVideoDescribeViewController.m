//
//  HMHVideoDescribeViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoDescribeViewController.h"
#import "HMHVideoIntroductionTableViewCell.h"
#import "HMHVideoStartTimeTableViewCell.h"
#import "HMHExternalDomViewControoler.h"
#import "LocalLoginViewController.h"
#import "HFDBHandler.h"
#import "HFLoginViewController.h"
@interface HMHVideoDescribeViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,HFLoginViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *HMH_footView;

@property (nonatomic, assign) CGFloat HMH_footViewH;
@end

@implementation HMHVideoDescribeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.HMH_listModel = [[HMHVideoListModel alloc] init];
    [self HMH_createtableView];
    [self loadData];
}
- (void)loginViewController:(HFLoginViewController*)viewcontroller loginFinsh:(NSDictionary*)loginData {
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
    [self.webView reload];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    PopAppointViewControllerModel*appointModel = [NavigationContrl getModelFrom:urlStr];
    PageUrlConfigModel *pageUrlModel = [NavigationContrl getPageurlModelFrom:urlStr];
    //不是以main_*或者url_开头
    if (appointModel&&([appointModel.pageTag isEqualToString:@"fy_login"]||[appointModel.pageTag isEqualToString:@"fy_quick_login"] )) {
        [HFLoginViewController showViewController:self];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    // 修复_blank的bug
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    } else {
        
    }
}
// 视频数据请求
- (void)loadData{
    if (self.videoNum.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/video-info/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,self.videoNum,sidStr];
        }
            
        [self requestData:nil withUrl:getUrlStr withRequestName:@"" withRequestType:@"get"];
    }
}

//
- (void)HMH_createtableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenW, ScreenH -self.view.frame.size.width*9/16- self.statusHeghit - self.buttomBarHeghit) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [self tableViewFootView];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (UIView *)tableViewFootView{
    _HMH_footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1000)];
    _HMH_footView.backgroundColor = [UIColor whiteColor];
    self.webViewContifgArrary = @[@"jsCallOC",@"backToPath",@"openVideo",@"postReceiveAddress",@"backPath",@"appShare",
                                   @"postVersionInfo",
                                   @"videoPlay",@"getDeviceInfo",
                                   @"put2bridge",@"scanningCode",@"goLogin",
                                   @"openPopupWindow",@"closePopupWindow",@"log"
                                   ,@"openPopupPayWindow",@"updatePopupPayWindow",
                                   @"closePopupPayWindow",
                                   @"openContactsWindow",
                                   @"checkUpgrade",@"loginAtNetease",@"logoutAtNetease",
                                   @"downLoadFile",@"openMsgWindow",
                                   @"downloadImage",@"loginAtMsg",@"backPressed",
                                   @"login",@"logout",
                                   @"putIntoStorage",@"removeFromStorage",
                                   @"getLocation",@"getBadgeCount",
                                   @"getImBadgeCountByMchId",
                                   @"removeImBadgeByMchId",
                                   @"removeNotifictionBadge",
                                   @"openImMsgWindow",@"changeEnv",
                                   @"getFileDownloadStatus",@"startFileDownload",
                                   @"deleteDownloadTask",@"playLocalVideo",
                               @"pauseDownloadTask",@"pedometerData",@"openExternalMap",@"openVideoHomeWindow",@"createQr",@"planeSearch",@"openContact",@"planeOrderDetail",@"planeCashier",@"skipToNative",@"openMapNavigation"];
     WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
     
     WKPreferences *preferences = [WKPreferences new];
     preferences.javaScriptCanOpenWindowsAutomatically = YES;
     preferences.javaScriptEnabled = YES;
     configuration.preferences = preferences;

    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(10, 10, ScreenW - 20,_HMH_footView.frame.size.height - 30) configuration:configuration];
    self.webView.navigationDelegate = self;
     self.webView.UIDelegate = self; // 设置WKUIDelegate代理
    self.isFromVideoWebView = YES;
    
    [_HMH_footView addSubview:self.webView];
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
        }else
        {
            NSString *jsString1 = [NSString stringWithFormat:@"localStorage.setItem('userCenterInfo','%@')",[HFUserDataTools convertToJsonData:@{}]];
            WKUserScript *wkUserScript1 = [[WKUserScript alloc] initWithSource:jsString1 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            NSString *jsString2 = [NSString stringWithFormat:@"localStorage.setItem('sid','%@')",@""];
            WKUserScript *wkUserScript2 = [[WKUserScript alloc] initWithSource:jsString2 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            NSString *jsString3 = [NSString stringWithFormat:@"localStorage.setItem('codeValue','%@')",@""];
            WKUserScript *wkUserScript3 = [[WKUserScript alloc] initWithSource:jsString3 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            NSString *jsString4 = [NSString stringWithFormat:@"localStorage.setItem('loginAreacode','%@')",@""];
            WKUserScript *wkUserScript4 = [[WKUserScript alloc] initWithSource:jsString4 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            NSString *jsString5 = [NSString stringWithFormat:@"localStorage.setItem('loginName','%@')",@""];
            WKUserScript *wkUserScript5 = [[WKUserScript alloc] initWithSource:jsString5 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            NSString *jsString6 = [NSString stringWithFormat:@"localStorage.setItem('teminal','%@')",@""];
            WKUserScript *wkUserScript6 = [[WKUserScript alloc] initWithSource:jsString6 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            //        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"orderStatus"] options:NSJSONReadingMutableContainers error:nil];
            //    NSString *jsString7 = [NSString stringWithFormat:@"localStorage.setItem('orderStatus','%@')",[HFUserDataTools convertToJsonData:dictionary]];
            //    WKUserScript *wkUserScript7 = [[WKUserScript alloc] initWithSource:jsString7 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
            NSString *jsString8 = [NSString stringWithFormat:@"localStorage.setItem('secPwd','%@')",@""];
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
        
    for (NSString *config in self.webViewContifgArrary) {
         [self.webView.configuration.userContentController addScriptMessageHandler:self name:config];
    }
    // 实现webView页内跳转
    __weak typeof(self) weakSelf = self;
    self.popVCCallBack = ^(id popVC) {
        if (weakSelf.myBlock) {
            weakSelf.myBlock(popVC);
        }
    };
    
    return _HMH_footView;
}
- (void)backToPath:(id)body {
    __weak typeof(self) weakSelf = self;
    if (weakSelf.myPopBlock) {
        weakSelf.myPopBlock(weakSelf);
    }
    
}
- (void)initWKWebView
{
   self.webViewContifgArrary = @[@"jsCallOC",@"backToPath",@"openVideo",@"postReceiveAddress",@"backPath",@"appShare",
                                  @"postVersionInfo",
                                  @"videoPlay",@"getDeviceInfo",
                                  @"put2bridge",@"scanningCode",@"goLogin",
                                  @"openPopupWindow",@"closePopupWindow",@"log"
                                  ,@"openPopupPayWindow",@"updatePopupPayWindow",
                                  @"closePopupPayWindow",
                                  @"openContactsWindow",
                                  @"checkUpgrade",@"loginAtNetease",@"logoutAtNetease",
                                  @"downLoadFile",@"openMsgWindow",
                                  @"downloadImage",@"loginAtMsg",@"backPressed",
                                  @"login",@"logout",
                                  @"putIntoStorage",@"removeFromStorage",
                                  @"getLocation",@"getBadgeCount",
                                  @"getImBadgeCountByMchId",
                                  @"removeImBadgeByMchId",
                                  @"removeNotifictionBadge",
                                  @"openImMsgWindow",@"changeEnv",
                                  @"getFileDownloadStatus",@"startFileDownload",
                                  @"deleteDownloadTask",@"playLocalVideo",
                              @"pauseDownloadTask",@"pedometerData",@"openExternalMap",@"openVideoHomeWindow",@"createQr",@"planeSearch",@"openContact",@"planeOrderDetail",@"planeCashier",@"skipToNative",@"openMapNavigation"];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    configuration.preferences = preferences;
  
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight) configuration:configuration];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('%@')", [HFUserDataTools loginSuccess]];
//    [self.webView evaluateJavaScript:jsString completionHandler:^(NSString  *result, NSError *error) {
//
//
//    }];
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString  *result, NSError *error) {
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

//    NSLog(@"⭐️⭐️⭐️%@",self.shareUrl);
  
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
    }else
    {
        NSString *jsString1 = [NSString stringWithFormat:@"localStorage.setItem('userCenterInfo','%@')",[HFUserDataTools convertToJsonData:@{}]];
        WKUserScript *wkUserScript1 = [[WKUserScript alloc] initWithSource:jsString1 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString2 = [NSString stringWithFormat:@"localStorage.setItem('sid','%@')",@""];
        WKUserScript *wkUserScript2 = [[WKUserScript alloc] initWithSource:jsString2 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString3 = [NSString stringWithFormat:@"localStorage.setItem('codeValue','%@')",@""];
        WKUserScript *wkUserScript3 = [[WKUserScript alloc] initWithSource:jsString3 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString4 = [NSString stringWithFormat:@"localStorage.setItem('loginAreacode','%@')",@""];
        WKUserScript *wkUserScript4 = [[WKUserScript alloc] initWithSource:jsString4 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString5 = [NSString stringWithFormat:@"localStorage.setItem('loginName','%@')",@""];
        WKUserScript *wkUserScript5 = [[WKUserScript alloc] initWithSource:jsString5 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString6 = [NSString stringWithFormat:@"localStorage.setItem('teminal','%@')",@""];
        WKUserScript *wkUserScript6 = [[WKUserScript alloc] initWithSource:jsString6 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        //        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"orderStatus"] options:NSJSONReadingMutableContainers error:nil];
        //    NSString *jsString7 = [NSString stringWithFormat:@"localStorage.setItem('orderStatus','%@')",[HFUserDataTools convertToJsonData:dictionary]];
        //    WKUserScript *wkUserScript7 = [[WKUserScript alloc] initWithSource:jsString7 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        NSString *jsString8 = [NSString stringWithFormat:@"localStorage.setItem('secPwd','%@')",@""];
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
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:wkUserScript];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shareUrl]]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    for (NSString *config in self.webViewContifgArrary) {
         [self.webView.configuration.userContentController addScriptMessageHandler:self name:config];
    }
//    [self clearWebCache];
  //  [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"backToPath"];
}

- (NSURLRequest*)addRefree:(NSString*)url{

    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:self.LastPageUrl forHTTPHeaderField: @"Referer"];
    NSDictionary *headerDic=   [request allHTTPHeaderFields];
    
    return request;
}


- (void)refreshFootViewWithString:(HMHVideoListModel *)listModel{
    
        PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
        if (tools.popWindowUrlsArrary.count) {
            
            for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
                if([model.pageTag isEqualToString:@"fy_video_intro"]) {
                    
                    self.urlStr = [NSString stringWithFormat:@"%@?vno=%@",model.url,listModel.vno];
                    
                    [_webView loadRequest:[self addRefree:self.urlStr]];
                }
            }
        }
//    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isFromVodPlay) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HMHVideoIntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[HMHVideoIntroductionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell refreshWithText:_HMH_listModel.videoAbstract];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        HMHVideoStartTimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"time"];
        if (timeCell == nil) {
            timeCell = [[HMHVideoStartTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"time"];
        }
        [timeCell refreshTabelViewCellWithTime:_HMH_listModel.liveStartTime];
        timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return timeCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [HMHVideoIntroductionTableViewCell cellHeightWithText:_HMH_listModel.videoAbstract];
    }
    if (self.isFromVodPlay) {
        return 0.0;
    }
    return 40.0;
}

#pragma mark 数据请求 =====get put=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName withRequestType:(NSString *)requestType{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestTypeMethod;
    if ([requestType isEqualToString:@"get"]){
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
    }
    
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        //        [weakSelf getPrcessdata:request.responseObject];
        [weakSelf getPrcessdata:request.responseObject];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

// 获取视频信息
- (void)getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        
        if ([dataDic isKindOfClass:[NSNull class]]) {
            return;
        }
        
        [self.HMH_listModel setValuesForKeysWithDictionary:dataDic];
        if (self.isFromVodPlay) {
            _HMH_footView.frame = CGRectMake(0, 0, ScreenW, self.tableView.height-[HMHVideoIntroductionTableViewCell cellHeightWithText:_HMH_listModel.videoAbstract]-20);
          
        }else {

            _HMH_footView.frame = CGRectMake(0, 0, ScreenW, self.tableView.height-[HMHVideoIntroductionTableViewCell cellHeightWithText:_HMH_listModel.videoAbstract]-40-20);
            
        }
          self.webView.frame = CGRectMake(10, 10, ScreenW - 20,_HMH_footView.frame.size.height - 30);
        [self.tableView reloadData];
        [self refreshFootViewWithString:self.HMH_listModel];
        
        
//        if (self.HMH_listModel.videoContent.length == 0 && self.HMH_listModel.videoAbstract.length == 0 && self.HMH_listModel.liveStartTime.length == 0) {
//            [self showNoContentView];
//        } else {
//            [self hideNoContentView];
//        }
    }
}


@end
