//
//  PayPopWindowViewController.m
//  HeMeiHui
//
//  Created by 任为 on 2017/8/9.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHPayPopWindowViewController.h"


@interface HMHPayPopWindowViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong)WKWebView *HMH_WebView;
@property (nonatomic, assign) NSUInteger HMH_loadCount;
@end

@implementation HMHPayPopWindowViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
      [self supportedInterfaceOrientations];
    
    self.navigationController.navigationBarHidden = !self.isShowNaBar;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ffffff"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#222222"];
     self.navigationController.navigationBar.translucent = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"back-b"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = !self.isShowNaBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.title = self.naTitle;
  
    [self cratWebView];
    self.StateValue = -2;
   
//   [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cratWebView{
    
    if (self.HMH_WebView == nil) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        for (int i=0; i<self.webViewContifgArrary.count; i++) {
            
            [userContentController addScriptMessageHandler:self
                                                      name:self.webViewContifgArrary[i]];
        }
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        self.HMH_WebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        [self.view addSubview:self.HMH_WebView];
        self.HMH_WebView.UIDelegate = self;
        self.HMH_WebView.navigationDelegate = self;
//        self.webView.backgroundColor = [UIColor redColor];
        
        //
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:noneSelectScript];
        

        
    
        
        // 适配iPhone X
        CGFloat topy = self.statusHeghit;
        CGFloat bottom = self.buttomBarHeghit;
//        if (self.naviMaskHeight>0) {
//            NSString *version = [UIDevice currentDevice].systemVersion;
//            double ver = version.doubleValue;
//            if (version.doubleValue < 11.0) {
//                topy = 64-self.naviMaskHeight;
//            } else {
//                topy = -self.naviMaskHeight;
//            }
//        }

        [self.HMH_WebView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset(topy);
//            make.left.equalTo(self.view.mas_left).offset(0);
//            make.width.equalTo(self.view.mas_width);
//            make.bottom.equalTo(self.view.mas_bottom).offset(bottom);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);

        }];
        NSString *url = self.urlStr;
        [self.HMH_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [_HMH_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        self.progressView.tintColor = [UIColor redColor];

        //    注释web加载进度
//        [self.HMH_WebView addSubview:self.progressView];
        _HMH_WebView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
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
- (void)closePopupPayWindow:(id)body{
    
    [self backButtonClick:nil];
    
}
- (void)updatePopupPayWindow:(id)body{
    
    self.StateValue = 0;
}


- (void)backButtonClick:(UIButton*)button{
   
    if (self.StateValue != 0&&self.StateValue != -2) {
        self.StateValue = -1;
    }
    if (self.pass) {

        self.pass(self.StateValue);
    }
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
    if (HMH_loadCount == 0){
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
        if (newP>=0.5) {
            [self hideMBProgressHUD];
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)dealloc{
    
      [_HMH_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    NSURL *url = navigationAction.request.URL;
    return;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
@end
