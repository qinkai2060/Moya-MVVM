//
//  PopWindowViewController.m
//  HeMeiHui
//
//  Created by 任为 on 2017/5/9.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHPopWindowViewController.h"
#import "SGScanningQRCodeVC.h"
#import "HMHADViewController.h"


@interface HMHPopWindowViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,ShareToolDelegete,ScanDelegate>

@property (nonatomic, strong)WKWebView *HMH_WebView;
@property (nonatomic, assign) NSUInteger HMH_loadCount;
@property (nonatomic, strong)ShareTools *HMH_shareTool;
@property (nonatomic, assign)BOOL isCan;


@end

@implementation HMHPopWindowViewController
- (instancetype)init {
    if (self = [super init]) {
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.barTintColor =[UIColor colorWithHexString:@"#ffffff"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#222222" ];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    _HMH_shareTool = [[ShareTools alloc]init];
    _HMH_shareTool.delegete = self;
    self.title = self.naTitle;
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self webView];
    
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

- (void)webView{

    if (self.HMH_WebView == nil) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        for (int i=0; i<self.webViewContifgArrary.count; i++) {
            [userContentController addScriptMessageHandler:self name:self.webViewContifgArrary[i]];
        }
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        
        self.HMH_WebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        [self.view addSubview:self.HMH_WebView];
        self.HMH_WebView.UIDelegate = self;
        self.HMH_WebView.navigationDelegate = self;
        NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('%@')", [HFUserDataTools loginSuccess]];
//        [self.webView evaluateJavaScript:jsString completionHandler:^(NSString  *result, NSError *error) {
//            
//            
//        }];
        //
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:noneSelectScript];
                
        // 适配iPhone X
        CGFloat topy = self.statusHeghit;
        CGFloat bottom = self.buttomBarHeghit;

        [self.HMH_WebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(topy);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);
        }];
        NSString *url=[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.HMH_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [_HMH_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];

        //    注释web加载进度
//        [self.HMH_WebView addSubview:self.progressView];
        self.progressView.backgroundColor = [UIColor clearColor];
        self.progressView.tintColor = [UIColor redColor];
      //  _WebView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
    }
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    } else {
        //NSLog(@"未实行方法：%@", methods);
    }
    
}
#pragma Mark#######################分享##########################
- (void)appShare:(id)body
{
    
    if (!_isCan) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        _isCan = !_isCan;
    }else{
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        _isCan = !_isCan;
        
    }
     [ShareTools  shareWithContent:body];
//    [_HMH_shareTool doShare:body];
}

- (void)sendShareState:(NSString *)state{
    
    [self.HMH_WebView evaluateJavaScript:state
                   completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
}
- (void)shareResultState:(NSString *)state{
    
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
- (void)ToAdViewController:(id)body{
    NSDictionary *dic = body;
    NSString *url = dic[@"url"];
    HMHADViewController *ad = [[HMHADViewController alloc]init];
    ad.HMH_urlStr = url;
    [self.navigationController pushViewController:ad animated:YES];
}
- (void)closePopupWindow:(id)body{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma #######################扫描二维码#######################
- (void)scanningCode:(id)body{
    
    SGScanningQRCodeVC *svc = [[SGScanningQRCodeVC alloc]init];
    svc.body = body;
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
    
}
- (void)afterScan:(NSString *)ScanStr funcName:(NSString *)funName{
    
    
    NSString *fuctionN = funName;
    NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,ScanStr];
    [self.HMH_WebView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable data,
                                       NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"错误:%@", error.localizedDescription);
                       }
                   }];
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
  
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    self.popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if ([self.popTool isPopNewWindowWithcheckUrl:urlStr]&&![urlStr isEqualToString:@"about:blank"]&&navigationAction.targetFrame.isMainFrame==YES&&![scheme isEqualToString:@"mailto"]&&![scheme isEqualToString:@"tel"]) {
        if ([self.popTool.currentPopModle.pageTag isEqualToString:@"fy_external_domain"]) {
            HMHExternalDomViewControoler *evc = [[HMHExternalDomViewControoler alloc]init];
            evc.title = self.popTool.currentPopModle.title;
            evc.naviBg = self.popTool.currentPopModle.naviBg;
            evc.isNavigationBarshow = self.popTool.currentPopModle.showNavi;
            // evc.naviMask = self.popTool.currentPopModle.naviMask;
            //evc.naviMaskHeight = self.popTool.currentPopModle.naviMaskHeight;
            evc.urlStr = urlStr;
            [self.navigationController pushViewController:evc animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
        pvc.title = self.popTool.currentPopModle.title;
        pvc.naviBg = self.popTool.currentPopModle.naviBg;
        pvc.isNavigationBarshow = self.popTool.currentPopModle.showNavi;
        pvc.naviMask = self.popTool.currentPopModle.naviMask;
        pvc.naviMaskHeight = self.popTool.currentPopModle.naviMaskHeight;
        pvc.urlStr = urlStr;
        [self.navigationController pushViewController:pvc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([urlStr containsString:@"https://itunes.apple.com/cn/app/he-fa-fang-yin/id1447851000"]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1447851000"]];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    if ([scheme isEqualToString:@"tel"]) {
        
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)backButtonClick:(UIButton*)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary* )change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.HMH_WebView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.HMH_WebView.estimatedProgress;
    }
    
    if (object == self.HMH_WebView && [keyPath isEqualToString:@"estimatedProgress"]) {
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)dealloc{

    [_HMH_WebView removeObserver:self forKeyPath:@"estimatedProgress"];

}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
