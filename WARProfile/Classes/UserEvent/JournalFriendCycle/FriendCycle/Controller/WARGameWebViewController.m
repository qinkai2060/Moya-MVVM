//
//  WARGameWebViewController.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/24.
//

#import "WARGameWebViewController.h"
#import <WebKit/WebKit.h>

#import "WARMacros.h"
#import "Masonry.h"
#import "WAROrientationObserver.h"

#import "WARGameWebRightView.h"
#import "WARGameShareView.h"

@interface WARGameWebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
/** rightView */
@property (nonatomic, strong) WARGameWebRightView *rightView;
/** gameShareView */
@property (nonatomic, strong) WARGameShareView *gameShareView;

//@property (nonatomic, assign) UIInterfaceOrientationMask currentOrientationMask;
//@property (nonatomic, strong) WAROrientationObserver *orientationObserver;
@end

@implementation WARGameWebViewController

#pragma mark - Initial

- (instancetype)initWithUrlString:(NSString *)url {
    if (self = [super init]) {
        if ([self hasChinese:url]) {
            self.url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
            self.url = url;
        }
    }
    return self;
}

#pragma mark - System

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.currentOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor blackColor];
    
    /// progressView
//    [self.view addSubview:self.progressView];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(2);
//    }];
    
    /// webView
    /// 在懒加载中添加到视图中，因为外界可以将webview置空
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    /// rightView
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(kStatusBarHeight - 3);
        make.width.mas_equalTo(87);
        make.height.mas_equalTo(32);
    }];
    
    /// gameShareView
    [self.view addSubview:self.gameShareView];
    [self.gameShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
     
//     [self.orientationObserver addDeviceOrientationObserver];
//    [self.view bringSubviewToFront:self.progressView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
//    if (_webView != nil) {
//        [_webView removeObserver:self forKeyPath:@"canGoBack"];
//        [_webView removeObserver:self forKeyPath:@"title"];
//        [_webView removeObserver:self forKeyPath:@"canGoForward"];
//        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
//        
//        _webView = nil;
//    } 
}

////支持的方向
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}
//
////是否可以旋转
//-(BOOL)shouldAutorotate {
//    return YES;
//}

#pragma mark - Event Response

- (void)moreAction {
    [self.gameShareView showShareView];
}

#pragma mark - Delegate

#pragma mark - WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler

#pragma mark - WKUIDelegate
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (void)webViewDidClose:(WKWebView *)webView {
    NDLog(@"%s", __FUNCTION__);
}
#endif

/**
 // 创建一个新的WebView（标签带有 target='_blank' 时，导致WKWebView无法加载点击后的网页的问题。）
 
 @param webView webView description
 @param configuration configuration description
 @param navigationAction navigationAction description
 @param windowFeatures windowFeatures description
 @return return value description
 */
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // 接口的作用是打开新窗口委托
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - WKNavigationDelegate

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    self.url = navigationAction.request.URL.absoluteString;
    
    if ([self.url containsString:@"https://itunes.apple.com"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    NDLog(@"%s:url:%@", __FUNCTION__,self.url);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //允许webview内部跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NDLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NDLog(@"%s", __FUNCTION__);
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NDLog(@"%s", __FUNCTION__);
    self.progressView.hidden = YES;
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NDLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NDLog(@"%s", __FUNCTION__);
    self.progressView.hidden = YES;
}

/**
 // 导航失败时会回调
 
 @param webView webView description
 @param navigation navigation description
 @param error error description
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}

/**
 // 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
 // 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
 @param webView webView description
 @param challenge challenge description
 @param completionHandler completionHandler description
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NDLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}


/**
 9.0才能使用，web内容处理中断时会触发
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NDLog(@"%s", __FUNCTION__);
}
#endif

#pragma mark - Public


#pragma mark - Private

- (BOOL)hasChinese:(NSString *)string {
    for(int i=0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}


/**
 强制旋转屏幕

 @param orientation 旋转方向  （UIInterfaceOrientationLandscapeLeft：横屏）
 */
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation {
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - Setter And Getter

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 0;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
        webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        webView.backgroundColor = [UIColor blackColor];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
//        [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
//        [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
//        [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        _webView = webView;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc]init];
        progressView.progressTintColor = HEXCOLOR(0x2CBE61);
        progressView.hidden = YES;
        _progressView = progressView;
    }
    return _progressView;
}

- (WARGameWebRightView *)rightView {
    if (!_rightView) {
        _rightView = [[WARGameWebRightView alloc]init];
        __weak typeof(self) weakSelf = self;
        _rightView.moreBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf moreAction];
//            strongSelf.currentOrientationMask = UIInterfaceOrientationMaskLandscapeLeft;
//            [strongSelf forceChangeOrientation:UIInterfaceOrientationLandscapeLeft];
        };
        _rightView.closeBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _rightView;
}

- (WARGameShareView *)gameShareView {
    if (!_gameShareView) {
        _gameShareView = [[WARGameShareView alloc]init];
        [_gameShareView hideShareView];
    }
    return _gameShareView;
}

//- (WAROrientationObserver *)orientationObserver {
////    __weak typeof(self) weakSelf = self;
//    if (!_orientationObserver) {
//        _orientationObserver = [[WAROrientationObserver alloc] init];
//        _orientationObserver.orientationWillChange = ^(WAROrientationObserver * _Nonnull observer, BOOL isFullScreen) {
////            __strong typeof(weakSelf) strongSelf = weakSelf;
//            NDLog(@"orientationWillChange");
//        };
//        _orientationObserver.orientationDidChanged = ^(WAROrientationObserver * _Nonnull observer, BOOL isFullScreen) {
//            NDLog(@"orientationDidChanged");
//        };
//    }
//    return _orientationObserver;
//}

@end
