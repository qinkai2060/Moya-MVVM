//
//  HFLoginH5WebViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/30.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLoginH5WebViewController.h"
#import "HFDBHandler.h"
#import "WRNavigationBar.h"
@interface HFLoginH5WebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (strong, nonatomic)   WKWebView                   *webView;
@property (copy, nonatomic)   NSArray              *webViewContifgArrary;
@end

@implementation HFLoginH5WebViewController

- (void)hh_addSubviews {
    self.view.backgroundColor = [UIColor clearColor];
    [self initWKWebView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)hh_layoutNavigation {
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self wr_setNavBarShadowImageHidden:NO];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)initWKWebView {

    self.webViewContifgArrary = @[];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    configuration.preferences = preferences;
    if (self.isBottomButton == YES) {
        [self.view addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, ScreenH-60-KTopHeight, ScreenW, 60);
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight-60) configuration:configuration];

    }else {
       self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, ScreenW, ScreenH-KTopHeight) configuration:configuration];
    }
    NSString *injectionJSString = @"";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:wkUserScript];
    NSURL *weburl = [NSURL URLWithString:self.url];

    [self.webView loadRequest:[NSURLRequest requestWithURL:weburl]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    @weakify(self);
    [RACObserve(self.webView, canGoBack)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.webView.canGoBack == YES) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }];
//    if (@available(iOS 11.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
 
}
#pragma mark - private method

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"login"]) {
    }
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s", __FUNCTION__);
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"%s", __FUNCTION__);
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    if ([self.webView.title isEqualToString:@"合发平台会员注册协议"]) {
//        self.webView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
//    }else {
//        CGFloat nav = IS_iPhoneX ? -(20+44):-44;
//        self.webView.frame = CGRectMake(0, nav, ScreenW, ScreenH);
//    }
    self.title =  self.webView.title;
    if (self.isBottomButton == YES) {
        self.title =  @"微店商户服务协议";
    }
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"失败");
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
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

- (CloudBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [CloudBottomView new];
    }
    return _bottomView;
}
@end
