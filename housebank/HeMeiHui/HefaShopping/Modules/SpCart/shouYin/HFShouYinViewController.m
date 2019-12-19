#import "HFShouYinViewController.h"
#import "LocationManager.h"
#import "HMHExternalDomViewControoler.h"
#import "JPUSHService.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "HFDBHandler.h"
#import "HMHPayPopWindowViewController.h"
#import "PayTools.h"
#import "SGScanningQRCodeVC.h"
#import "HFLoginViewController.h"
#import "MyOrderViewController.h"
#import "HFVIPViewController.h"
#import "CustomPasswordAlter.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HMHGloblehomeTabBarViewController.h"
#import "HMHLiveVideoHomeViewController.h"
#import "WRNavigationBar.h"
/// iOS 9的新框架
#import <ContactsUI/ContactsUI.h>

#define Is_up_Ios_9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0

@interface HFShouYinViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,ScanDelegate,UIGestureRecognizerDelegate,HFLoginViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@property (strong, nonatomic)   WKWebView                   *webView;
@property (strong, nonatomic)   UIProgressView              *progressView;
@property (copy, nonatomic)   NSArray              *webViewContifgArrary;
@property (nonatomic, strong)PayTools *HMH_payTool;
@property(nonatomic,copy)NSString *locationCallBack;

@end

@implementation HFShouYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _HMH_payTool   = [[PayTools alloc]init];
    [self regiserNotification];
    [self initWKWebView];
    self.webView.hidden = YES;
    [SVProgressHUD show];
    self.webView.userInteractionEnabled = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initProgressView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detialEnter) name:@"detial" object:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
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
- (void)detialEnter {
    self.fromeSource = @"detial";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor=[UIColor whiteColor];
    if (self.appearblock) {
        self.appearblock();
    }
    self.navigationController.navigationBar.translucent = NO;
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HMH_back_light"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self wr_setNavBarTintColor:[UIColor blackColor]];
}
- (void)backClick {
    if ([self.webView canGoBack]) {
        [self.webView goBack];

    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)willMoveToParentViewController:(nullable UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
//    for (NSString *config in self.webViewContifgArrary) {
//          [self.webView.configuration.userContentController removeScriptMessageHandlerForName:config];
//    }
//    // 因此这里要记得移除handlers
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"postReceiveAddress"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"backToPath"];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        NSLog(@"执行了");
        return NO;
    }
    return YES;
    
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

    NSLog(@"⭐️⭐️⭐️%@",self.shareUrl);
  
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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shareUrl]]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    for (NSString *config in self.webViewContifgArrary) {
         [self.webView.configuration.userContentController addScriptMessageHandler:self name:config];
    }
    [self clearWebCache];
  //  [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"backToPath"];
}

- (void)initProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 2)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor lightGrayColor];

//    注释web加载进度
//    [self.view addSubview:progressView];
    self.progressView = progressView;
}

- (void)rightClick
{
    [self goBack];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didReceiveRemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"aliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WX_PayResp" object:nil];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    for (NSString *config in self.webViewContifgArrary) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:config];
    }
}

#pragma mark - private method




- (void)shakeAction {
    
}

- (void)goBack
{
    [self.webView goBack];
}

- (void)playSound:(NSString *)fileName
{
    if (![fileName isKindOfClass:[NSString class]]) {
        return;
    }
}

#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1447851000"]];
        completionHandler ();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    completionHandler();
  
}
// 拦截
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    NSLog(@"⭐️⭐️⭐️%ld--",navigationAction.navigationType);
    // 提升展示界面的体验 区分H5 不换链接该参数 不走完成和失败回调
    
//    if ([[NSString stringWithFormat:@"%@",[[self.shareUrl componentsSeparatedByString:@"?"] firstObject]] isEqualToString:[NSString stringWithFormat:@"%@",[[urlStr componentsSeparatedByString:@"?"] firstObject]]]&&![self.shareUrl isEqualToString:urlStr]) {
//        self.webView.hidden = NO;
//        [SVProgressHUD dismiss];
//        self.webView.userInteractionEnabled = YES;
//    }else {
//        self.webView.hidden = YES;
//        [SVProgressHUD show];
//        self.webView.userInteractionEnabled = NO;
//    }

    if ([urlStr containsString:@"http://webchat.7moor.com"]) {
        self.webView.frame = CGRectMake(0, 0, ScreenW, ScreenH - KTopHeight);
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
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
    if (self.isMore&&type!=external_domain) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
      
        if (appointModel&&![pageUrlModel.pageTag isEqualToString:@"fy_login"]&&![pageUrlModel.pageTag isEqualToString:@"fy_quick_login"]) {
            //对于本页面来说，只有两种状态，1是要开新窗口。2.是要加载
            
            if (type==main_home||type==main_mine) { //||type==main_mall||type==main_globalhome||type==main_moments
                //导航切换tab
                [NavigationContrl changeTabIndexWith:type and:self.navigationController and:urlStr and:pageUrlModel];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
             if (type==openNewPop) {
                self.webView.frame = CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
                [self.navigationController setNavigationBarHidden:YES];
                [self.navigationController.navigationBar setHidden:YES];
             }
            
            
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    CGFloat statusHeghit = 20;
    CGFloat buttomBarHeghit = 0;
    if (IS_iPhoneX) {
        statusHeghit = 44;
        buttomBarHeghit = 34;
    }
    PopAppointViewControllerToos *popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if ([popTool isPopNewWindowWithcheckUrl:urlStr]&&![urlStr isEqualToString:@"about:blank"]&&navigationAction.targetFrame.isMainFrame==YES&&![scheme isEqualToString:@"mailto"]&&![scheme isEqualToString:@"tel"]) {
          if ([popTool.currentPopModle.pageTag isEqualToString:@"fy_external_domain"]) {

//            HMHExternalDomViewControoler *evc = [[HMHExternalDomViewControoler alloc]init];
//            if ([popTool.currentPopModle.title isEqualToString:@"合发"]) {
//                evc.title = @"合美惠";
//            }else
//            {
//               evc.title = popTool.currentPopModle.title;
//            }
//            evc.naviBg = popTool.currentPopModle.naviBg;
//            evc.isNavigationBarshow = popTool.currentPopModle.showNavi;
//            evc.naviMask = popTool.currentPopModle.naviMask;
//            evc.naviMaskHeight = popTool.currentPopModle.naviMaskHeight;
//            evc.urlStr = urlStr;
//            evc.hidesBottomBarWhenPushed = YES;
//            if (![self.webView canGoBack]) {
//                    [self.navigationController popViewControllerAnimated:NO];
//            }
//            [self.navigationController pushViewController:evc animated:NO];
//            decisionHandler(WKNavigationActionPolicyCancel);
//              [self.navigationController setNavigationBarHidden:NO];
//              [self.navigationController.navigationBar setHidden:NO];

            if (popTool.currentPopModle.showNavi ==NO) {
                self.webView.frame = CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
            }else{
                self.webView.frame = CGRectMake(0, 0, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
            }
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
//            HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
//            pvc.title = popTool.currentPopModle.title;
//            pvc.naviBg = popTool.currentPopModle.naviBg;
//            pvc.isNavigationBarshow = popTool.currentPopModle.showNavi;
//            pvc.naviMask = popTool.currentPopModle.naviMask;
//            pvc.naviMaskHeight = popTool.currentPopModle.naviMaskHeight;
//            pvc.urlStr = urlStr;
//            [self.navigationController pushViewController:pvc animated:YES];
//            decisionHandler(WKNavigationActionPolicyCancel);
//        [self.navigationController setNavigationBarHidden:NO];
//        [self.navigationController.navigationBar setHidden:NO];
        // 展示导航栏
        if (popTool.currentPopModle.showNavi ==NO) {
            self.webView.frame = CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
        }else{
            self.webView.frame = CGRectMake(0, 0, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
        }
    
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
       
    }
//    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setHidden:YES];
    if(![popTool.currentPopModle.pageTag isEqualToString:@"fy_external_domain"])
    self.webView.frame = CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
    decisionHandler(WKNavigationActionPolicyAllow);
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
- (void)closeController {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)changeEnv:(id)body{
    
    if ([body isKindOfClass:[NSString class]]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:body forKey:@"appMainEntrance"];
    }
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
                           // NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}
- (void)jsCallOC:(id)body {
    
    [_HMH_payTool doPayWith:body];
    
}
- (void)getDeviceInfo:(id)body{
    NSString *fuctionN = body;
    NSDictionary *currentVersion = [VersionTools InfoDic];
    NSString *JsonStr = [currentVersion  modelToJSONString];
    NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,JsonStr];
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data,
                                       NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}
#pragma #######################扫描二维码#######################
- (void)scanningCode:(id)body{
    
    SGScanningQRCodeVC *svc = [[SGScanningQRCodeVC alloc]init];
    svc.body = body;
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
    
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
        if([ScanStr containsString:@"h/o/s.html"]||[ScanStr containsString:@"h/o/p.html"]||[ScanStr containsString:@"shorturl"]){
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
        }else {
            [SVProgressHUD showErrorWithStatus:@"该二维码暂不支持"];
//            [SVProgressHUD dismiss];
        }


    }
    
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
- (void)closePopupWindow:(id)body{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSDictionary *) JSONStringToDictionaryWithData:(NSString *)data{
    if (CHECK_STRING_ISNULL(data)) {
        NSDictionary *dic = [NSDictionary dictionary];
        return dic;
    }
    NSError * error;
    NSData * m_data = [data  dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:m_data options:NSJSONReadingMutableContainers error:&error];
    return dict;
}
- (void)refrensh{
    [self.webView reload];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"openMapNavigation"]) {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f&mode=riding&src=%@", [[message.body valueForKey:@"lat"] floatValue], [[message.body valueForKey:@"lng"] floatValue],[message.body valueForKey:@"title"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else {
                [MBProgressHUD showAutoMessage:@"暂未安装该地图"];
            }


        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
            {

                    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=2",@"刷哪儿",[[message.body valueForKey:@"lat"] floatValue], [[message.body valueForKey:@"lng"] floatValue],[message.body valueForKey:@"title"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

                    NSLog(@"%@",urlString);

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];



            }else {
                [MBProgressHUD showAutoMessage:@"暂未安装该地图"];
            }

        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            NSLog(@"点击取消");

        }]];

        [self presentViewController:alertController animated:YES completion:nil];
    }

    //飞机票查询
    if ([message.name isEqualToString:@"planeSearch"]) {
        HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
        newsView.isMore=YES;
        newsView.fromeSource=@"airTicket";
        newsView.isPushNewHF = YES;
        newsView.pushBlock = ^(GlobleHomePushBlockType pushBlockType, NSDictionary * _Nonnull dic) {
            if (self.pushBlock) {
              
                self.pushBlock(pushBlockType, dic);
            
            }
        };
        NSString *json = [NSString stringWithFormat:@"%@",[message.body valueForKey:@"urlParams"]];
       NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self JSONStringToDictionaryWithData:json]];
        
        NSString *url = [NSString stringWithFormat:@"%@/html/home/#/plane/search?deptName=%@&arrName=%@&departureTime=%@&cabinClass=%@&passengerType=%@",fyMainHomeUrl,[dic[@"deptName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[dic[@"arrName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],dic[@"departureTime"],dic[@"cabinClass"],dic[@"passengerType"]];
        [newsView setShareUrl:url];
        newsView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsView animated:YES];
    }
    //机票订单详情
    if ([message.name isEqualToString:@"planeOrderDetail"]) {
        HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
        newsView.isMore=YES;
        newsView.isPushNewHF = YES;
        NSString *json = [NSString stringWithFormat:@"%@",[message.body valueForKey:@"urlParams"]];
        NSString *url = [NSString stringWithFormat:@"%@/html/home/#/plane/orderDetail?orderNo=%@",fyMainHomeUrl,json];
        [newsView setShareUrl:url];
        newsView.pushBlock = ^(GlobleHomePushBlockType pushBlockType, NSDictionary * _Nonnull dic) {
            if (self.pushBlock) {

                self.pushBlock(pushBlockType, dic);

            }
        };
        newsView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsView animated:YES];
    }
    
    if([message.name isEqualToString:@"skipToNative"]&&[[message.body valueForKey:@"name"] isEqualToString:@"hotelHome"]) { // 全球家首页
        HMHGloblehomeTabBarViewController *globalHome = [[HMHGloblehomeTabBarViewController alloc] init];
         [self.navigationController pushViewController:globalHome animated:YES];
    }
        if([message.name isEqualToString:@"skipToNative"]&&[[message.body valueForKey:@"name"] isEqualToString:@"live"]) { // 直播首页
        HMHLiveVideoHomeViewController *globalHome1 = [[HMHLiveVideoHomeViewController alloc] init];
        globalHome1.view.backgroundColor = [UIColor whiteColor];
        [HMHLiveCommendClassTools shareManager].nvController = self.navigationController;
         [self.navigationController pushViewController:globalHome1 animated:YES];
    }

    //机票订单跳转支付
    if ([message.name isEqualToString:@"planeCashier"]) {
        HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
        newsView.isMore=YES;
        NSString *json = [NSString stringWithFormat:@"%@",[message.body valueForKey:@"urlParams"]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self JSONStringToDictionaryWithData:json]];
        NSString *url = [NSString stringWithFormat:@"%@/html/home/#/plane/cashier?orderNo=%@&from=%@",fyMainHomeUrl,[dic objectForKey:@"orderNo"] ?: @"",[dic objectForKey:@"from"] ?: @"" ];
        [newsView setShareUrl:url];
        newsView.isPushNewHF = YES;
        newsView.pushBlock = ^(GlobleHomePushBlockType pushBlockType, NSDictionary * _Nonnull dic) {
            if (self.pushBlock) {
                
                self.pushBlock(pushBlockType, dic);
                
            }
        };
        newsView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsView animated:YES];
    }
    
  
    
    if ([message.name isEqualToString:@"openContact"]) {
        NSLog(@"打开通讯录");
        [self JudgeAddressBookPower];
    }
    if ([message.name isEqualToString:@"changeEnv"]) {
        [self changeEnv:message.body];
    }
    if ([message.name isEqualToString:@"closePopupWindow"]) {
        
        [self closePopupWindow:message.body];
    }
    if ([message.name isEqualToString:@"getDeviceInfo"]) {
        
        [self getDeviceInfo:message.body];
    }
    if ([message.name isEqualToString:@"scanningCode"]) {
        [self scanningCode:message.body];
    }
    //打开支付宝支付
    if ([message.name isEqualToString:@"jsCallOC"]) {
        [self jsCallOC:message.body];
    }
    //打开快银支付
    if ([message.name isEqualToString:@"openPopupPayWindow"]) {
        [self openPopupPayWindow:message.body];
    }
    if ([message.name isEqualToString:@"login"]) {

        [HFUserDataTools login:message.body];
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
                               NSLog(@"错误:%@", error.localizedDescription);
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
    if ([message.name isEqualToString:@"getLocation"]) {
        [self getLocation:message.body];
    }
    if ([message.name isEqualToString:@"putIntoStorage"]) {
        [self putIntoStorage:message.body];
    }
    if ([message.name isEqualToString:@"backPressed"]) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([message.name isEqualToString:@"skipToVipHome"]) {
        HFVIPViewController *vc = [[HFVIPViewController alloc] initWithViewModel:nil];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([message.name isEqualToString:@"postReceiveAddress"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            if ([self.delegate respondsToSelector:@selector(backMangeAddress:)]) {
                [self.delegate backMangeAddress:(NSDictionary*)message.body];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([message.name isEqualToString:@"backToPath"]) {
        
        //飞机票支付成功点击返回 跳转 酒店首页
        if ([[message.body valueForKey:@"backPath"] isEqualToString:@"qqj_hotel_home"]) {
            NSLog(@"酒店预订");
            if (self.pushBlock) {
                NSDictionary *dic = @{};
                
                self.pushBlock(GlobleHomePushBlockTypeHotel,dic);
                if (self.isPushNewHF) {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
            return;
        }
        
        //飞机票支付成功点击酒店预订 更多 跳转 酒店列表
        if ([[message.body valueForKey:@"backPath"] isEqualToString:@"qqj_hotel_search"]) {
            NSLog(@"酒店列表");
            if (self.pushBlock) {
                NSDictionary *dic = @{@"city":([NSString stringWithFormat:@"%@",[message.body valueForKey:@"city"]] ?: @""),
                                      @"cityId":([NSString stringWithFormat:@"%@",[message.body valueForKey:@"cityId"]] ?: @"")};
                
                if (self.isPushNewHF) {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                self.pushBlock(GlobleHomePushBlockTypeHotelList,dic);
            }
            return;
        }
        
        
        //飞机票支付成功点击酒店预订 更多 跳转 订单列表
        if ([[message.body valueForKey:@"backPath"] isEqualToString:@"plane_order_list"]) {
            NSLog(@"订单列表");
            if (self.pushBlock) {
                
                if (self.isPushNewHF) {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                NSDictionary *dic;
                self.pushBlock(GlobleHomePushBlockTypeOrderList,dic);
            }
            return;
        }
        
        
        
        
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            if ([[message.body valueForKey:@"backPath"] isEqualToString:@"finish"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if ([[message.body valueForKey:@"backPath"] isEqualToString:@"qqj_list"]) {
                [self.navigationController popViewControllerAnimated:NO];
                
            } if ([[message.body valueForKey:@"backPath"] isEqualToString:@"qqj_order_list"]) {
                UITabBarController *tab = self.navigationController.tabBarController;
        
                [self.navigationController popToRootViewControllerAnimated:NO];
                
                tab.tabBar.hidden = NO;
                tab.selectedIndex = 2;
                
            }
            else {
                if ([self.fromeSource isEqualToString:@"globleOrderVC"]) {//全球家订单返回|全球家收藏
                    HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
                    newsView.isMore=YES;
                    newsView.fromeSource=@"globleOrderVC";
//                    newsView.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:newsView animated:YES];
                    NSArray *subArray = [[message.body valueForKey:@"backPath"] componentsSeparatedByString:@"_"];
                    if ([[message.body valueForKey:@"backPath"] containsString:@"qqj_details"])//收藏-酒店详情
                    {
                        if (subArray.count==3) {
                            NSString *hotelId=[subArray objectAtIndex:2];
                           [newsView setShareUrl:[NSString stringWithFormat:@"%@%@%@",fyMainHomeUrl,@"/html/home/#/global/hoteldetails?hotelId=",hotelId]];
                            newsView.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:newsView animated:YES];
                            return;
                        }
                        if (subArray.count==5) {
                            NSString *hotelId=[subArray objectAtIndex:2];
                            NSString *start=[subArray objectAtIndex:3];
                            NSString *end=[subArray objectAtIndex:4];
                             [newsView setShareUrl:[NSString stringWithFormat:@"%@%@?hotelId=%@&startDate=%@&endDate=%@",fyMainHomeUrl,@"/html/home/#/global/hoteldetails",hotelId,start,end]];
                            newsView.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:newsView animated:YES];
                            return;
                        }
                    
                    }
                    if ([[message.body valueForKey:@"backPath"] containsString:@"hotel_details"])//订单-酒店详情
                    {
                        if (subArray.count==5) {
                            NSString *hotelId=[subArray objectAtIndex:2];
                            NSString *start=[subArray objectAtIndex:3];
                            NSString *end=[subArray objectAtIndex:4];
                              [newsView setShareUrl:[NSString stringWithFormat:@"%@%@?hotelId=%@&startDate=%@&endDate=%@",fyMainHomeUrl,@"/html/home/#/global/hoteldetails",hotelId,start,end]];
                            newsView.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:newsView animated:YES];
                            return;
                        }
                    }
                    if ([[message.body valueForKey:@"backPath"] containsString:@"order_detail"])//订单-订单详情
                    {
                        if (subArray.count==4) {
                            NSString *orderNo=[subArray objectAtIndex:2];
                            NSString *hotelId=[subArray objectAtIndex:3];
                            [newsView setShareUrl:[NSString stringWithFormat:@"%@%@?orderNo=%@&hotelId=%@",fyMainHomeUrl,@"/html/home/#/global/hotelorderinfo",orderNo,hotelId]];
                            newsView.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:newsView animated:YES];
                            return;
                        }
                    }
                    if ([[message.body valueForKey:@"backPath"] containsString:@"hotel_pay"])//订单-收银台
                    {
                        if (subArray.count==3) {
                         NSString *orderNo=[subArray objectAtIndex:2];
                             [newsView setShareUrl:[NSString stringWithFormat:@"%@%@?orderNo=%@",fyMainHomeUrl,@"/html/home/#/pay/order/hotel/cashier",orderNo]];
                            newsView.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:newsView animated:YES];
                            return;
                    }
                        
                    }
                    if ([[message.body valueForKey:@"backPath"] containsString:@"make_comment"])//订单-评论
                    {
                        if (subArray.count==3) {
                            NSString *orderNo=[subArray objectAtIndex:2];
                            [newsView setShareUrl:[NSString stringWithFormat:@"%@%@?orderNo=%@",fyMainHomeUrl,@"/html/home/#/global/makeComment",orderNo]];
                            newsView.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:newsView animated:YES];
                            return;
                        }

                    }
                    
                    [self.tabBarController.navigationController popViewControllerAnimated:YES];
                    return;
                }
                if ([self.fromeSource isEqualToString:@"globleNewsVC"]) {//全球家消息
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                if ([self.fromeSource isEqualToString:@"address"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    if ([self.fromeSource isEqualToString:@"detial"]) {
                        [self.navigationController popToViewController:[SpGoodsDetailViewController new] animated:YES];
                    }else {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShopCar" object:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        
                    }
                    
                }
            }
            
        }

    }
}
- (void)getLocation:(id)body{
    NSString *callback = body;
    __weak typeof(self) weakSelf = self;
    if ([callback isKindOfClass:[NSString class]]) {
        if (callback) {
           self.locationCallBack = callback;
            LocationManager *locationManager = [LocationManager shareTools];
            [locationManager initializeLocationService];
            [locationManager getlocationInfo:^(NSString *locationStr) {
                NSLog(@"%@",locationStr);
                //                NSDictionary *dic ;
                //            NSString *str=    [dic JSONString];
                NSString *jsonStr = [NSString stringWithFormat:@"%@('%@')",self.locationCallBack,locationStr];
                [weakSelf.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    if (!error) {//成功
//                        [self.webView reload];
//                         NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        NSLog(@"传输位置成功:%@",[self class]);
                    }else{//失败
                        NSLog(@"传输位置失败:%@",[self class]);
                    }
                }];
            }];
            [locationManager start];
        }
    }
}
- (void)login:(id)body{
    NSLog(@"%@",body);
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
                NSLog(@"保存success:%@",[self class]);
            }else{//失败
                NSLog(@"保存failed:%@",[self class]);
            }
            
         }];
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
    self.webView.userInteractionEnabled = YES;
    self.webView.hidden =  NO;
    [SVProgressHUD dismiss];
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.progressView.hidden = YES;
    if(webView.title.length == 0) {
        self.navigationItem.title = @"合美惠";
    }else {
        self.navigationItem.title = webView.title;
    }
    PopAppointViewControllerToos *popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    NSString *scheme   = [webView.URL scheme];
//    [UIView animateWithDuration:0.1 animations:^{
//        if (popTool.currentPopModle.showNavi ==NO) {
//            self.webView.frame = CGRectMake(0, StatusBarHeight, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
//        }else{
//            self.webView.frame = CGRectMake(0, 0, ScreenW, ScreenH - StatusBarHeight-KBottomSafeHeight);
//        }
//    }];

    if ([popTool isPopNewWindowWithcheckUrl:webView.URL.absoluteString]&&![webView.URL.absoluteString isEqualToString:@"about:blank"]&&![scheme isEqualToString:@"mailto"]&&![scheme isEqualToString:@"tel"]) {
        if ([popTool.currentPopModle.pageTag isEqualToString:@"fy_external_domain"]) {
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController.navigationBar setHidden:NO];
            return;
        }

    }
    if ([webView.URL.absoluteString containsString:@"http://webchat.7moor.com"]) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController.navigationBar setHidden:NO];
        return;
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    self.webView.userInteractionEnabled = YES;
    self.webView.hidden =  NO;
    [SVProgressHUD dismiss];
    
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

#pragma mark ---- 调用系统通讯录
- (void)JudgeAddressBookPower {
    ///获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
            [self callAddressBook:isUp_ios_9];
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }];
}

- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else if (!granted) {
                    block(NO,YES);
                } else {
                    block(YES,YES);
                }
            }];
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES,YES);
        } else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();

        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    } else if (!granted) {
                        block(NO,NO);
                    } else {
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized) {
            block(YES,NO);
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}

- (void)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    } else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self presentViewController:peoplePicker animated:YES completion:nil];
    }
}

#pragma mark -- CNContactPickerDelegate  进入系统通讯录页面 --9以后
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *text2 = [self removeSpaceAndNewline:phoneNumber.stringValue];
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSDictionary *dic =@{
                             @"name" : text1,
                             @"phone": text2
                             };
        NSString *JsonStr = [dic modelToJSONString];
        NSString *jsStr   = [NSString stringWithFormat:@"selectContact('%@')",JsonStr];
        [self.webView evaluateJavaScript:jsStr
                       completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                           if (error) {
                                NSLog(@"错误:%@", error.localizedDescription);
                           }
                       }];
        
    }];
}
- (NSString *)removeSpaceAndNewline:(NSString *)str{
    
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

#pragma mark -- ABPeoplePickerNavigationControllerDelegate   进入系统通讯录页面 9之前
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@",anFullName];
        /// 电话
        NSString *text2 = [self removeSpaceAndNewline:(__bridge NSString*)value];
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSDictionary *dic =@{
                             @"name" : text1,
                             @"phone": text2
                             };
        NSString *JsonStr = [dic modelToJSONString];
        
        NSString *jsStr   = [NSString stringWithFormat:@"selectContact('%@')",JsonStr];
        [self.webView evaluateJavaScript:jsStr
                       completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                           if (error) {
                                NSLog(@"错误:%@", error.localizedDescription);
                           }
                       }];
    }];
}
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
//    //    DLOG(@"msg = %@ frmae = %@",message,frame);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}
@end
