//
//  HFIMMessageController.m
//  HeMeiHui
//
//  Created by usermac on 2019/5/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFIMMessageController.h"
#import "WRNavigationBar.h"
@interface HFIMMessageController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (strong, nonatomic)   WKWebView                   *webView;
@property (copy, nonatomic)   NSArray              *webViewContifgArrary;
@end

@implementation HFIMMessageController
- (void)hh_addSubviews {
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden=NO;
    
    [self initWKWebView];
    
}
- (void)hh_layoutNavigation {
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HMH_back_light"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initWKWebView {
    
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
                                  @"pauseDownloadTask",@"pedometerData",@"openExternalMap",@"openVideoHomeWindow",@"createQr"];;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    configuration.preferences = preferences;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight) configuration:configuration];

    NSString *encodedString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:weburl]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    for (NSString *config in self.webViewContifgArrary) {
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:config];
    }
    [self.webView.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:self.webView];
    
    @weakify(self);
//    [RACObserve(self.webView, canGoBack)subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        if (self.webView.canGoBack == YES) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }else {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        }
//    }];
    
}
#pragma mark - private method

#pragma mark - WKUIDelegate
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//    
//}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
//    
//    
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
//#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"login"]) {
    }
}
//
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    NSLog(@"%s", __FUNCTION__);
//}
//// 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//}
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//}
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%s", __FUNCTION__);
//    
//}
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//}
//// 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    self.title =   self.webView.title ;
//    
//}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"失败");
//}
//
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
//    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//}
//
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//#pragma mark - WKUIDelegate
//- (void)webViewDidClose:(WKWebView *)webView
//{
//    NSLog(@"%s", __FUNCTION__);
//}
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



@end
