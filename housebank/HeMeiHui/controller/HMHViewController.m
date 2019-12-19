////
//  ViewController.m
//  HeMeiHui
//
//  Created by 任为 on 16/9/19.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "HMHViewController.h"
#import "HMHADViewController.h"
#import "PayTools.h"
#import "JPUSHService.h"
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
#import "LocalLoginViewController.h"
#import "ChatMessageViewController.h"
#import "NIMContactTools.h"
// 视频直播
#import "HMHVideoHomeViewController.h"

#define adImageArraryName "adImageArraryName"
#define adImageArraryLink "adImageArraryLink"

@interface HMHViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIDocumentInteractionControllerDelegate,BeeCloudDelegate,UIAlertViewDelegate,payToolDelegete,ShareToolDelegete,ScanDelegate,NIMLoginManagerDelegate>
//@property (nonatomic, strong) DetailViewController *MVPlayer;
@property (nonatomic, strong) WDGuideScrollView *HMH_guideView;
@property (nonatomic, strong) UIDocumentInteractionController *HMH_documentController;
@property (nonatomic, assign) NSUInteger HMH_loadCount;
@property (nonatomic, assign) BOOL HMH_hasNetWork;
@property (nonatomic, assign) BOOL HMH_isFristComeIN;
@property (nonatomic, assign) BOOL HMH_isFresh;

@property (nonatomic,strong)  NSArray *HMH_UpDdArrary;
@property (nonatomic,strong)HMHADViewController *HMH_PayADViewController;
@property (nonatomic, strong)PayTools *HMH_payTool;
@property (nonatomic, strong)ShareTools *HMH_shareTool;
@property (nonatomic, assign)BOOL HMH_isCan;
@property (nonatomic, strong) UILabel *HMH_noticelabel;
@property (nonatomic, assign)BOOL HMH_isCanPopViewCurrentController;

@property (nonatomic, assign)BOOL HMH_isFristLoadWebView;

@property (nonatomic, strong) HMHGoodsPushAlertView *HMH_goodsAlertView;

@end

@implementation HMHViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self supportedInterfaceOrientations];
    [[self class]attemptRotationToDeviceOrientation];
    
    // 接收推送的文本消息 (当用户下单时 弹XX下单的框)。 下单推送
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
 }
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _HMH_isFristComeIN     = YES;
    _HMH_payTool   = [[PayTools alloc]init];
    _HMH_payTool.delegete   = self;
    _HMH_shareTool = [[ShareTools alloc]init];
    _HMH_shareTool.delegete = self;
    self.HMH_isCanPopViewCurrentController = YES;
    [super viewDidLoad];
    [self initWebView];
    [self regiserNotification];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSLog(@"userAgent :%@", result);
    }];
    
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
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    [self goodsInfoPushMessageWithDic:userInfo];
}

- (void)goodsInfoPushMessageWithDic:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        // 江苏省徐少2天前已下单
        NSString *content = [dic valueForKey:@"content"];
        // 6
        NSString *contentTypeStr = [dic valueForKey:@"content_type"];
        NSDictionary *extras = [dic valueForKey:@"extras"];
        //  /user/1528341538994/s579a4k1mdocljh6.jpg
        NSString *userAvatarStr = [extras valueForKey:@"userAvatar"];
        NSString *urlStr = [extras valueForKey:@"targetUrl"];
        NSString *uidStr = [extras valueForKey:@"uid"];
        NSString *pageTagsStr = [extras valueForKey:@"pageTags4DisplayMsg"];
        // 4  如果没有返回的话 就默认为3秒   此类型为毫秒
        NSNumber *showTimeNum = [extras valueForKey:@"duration"];

        PopAppointViewControllerModel*currentAppointModel = [NavigationContrl getModelFrom:self.mainUrlStr];
        
//        NSLog(@"%@,%@",pageTagsStr,currentAppointModel.pageTag);
        if ([pageTagsStr containsString:currentAppointModel.pageTag]) {
            // 比如XXX省XX人3分钟前已下单
            NSString *contentStr = content;
            CGFloat w = [CommonManagementTools getWidthWithFontSize:14.0 height:35 text:contentStr];
            if (_HMH_goodsAlertView) {
                [_HMH_goodsAlertView hide];
            }
            self.statusHeghit = 20;
            
            if (IS_iPhoneX) {
                self.statusHeghit = 44;
            }
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];

            if ([contentTypeStr longLongValue] == 1) {
                // uid相等 表示是自己下的单 所以就不用通知
                if ([uidStr isEqualToString:[self getUserUidStr]]) {
                    return;
                }
                [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
            } else if ([contentTypeStr longLongValue] == 2){
                // 针对登录的用户  登录用户可以收到
                if (sidStr.length > 6) {
                    [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
                }
            } else if ([contentTypeStr longLongValue] == 3){
                // 针对没有登录的用户   未登录用户可以收到
                if (sidStr.length <= 6) {
                    [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
                }
            } else if ([contentTypeStr longLongValue] == 4){
                // 针对所有的用户
                [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
            }
        }
    }
}
- (void)createGoodsViewWithWidth:(CGFloat)w userIconUrl:(NSString *)userAvatarStr contentStr:(NSString *)contentStr showTime:(NSNumber *)showTimeNum urlStr:(NSString *)urlStr{
    CGFloat f = 0.0;
    if (userAvatarStr.length > 6) {
        f = 40;
    } else {
        f = 0;
    }
    _HMH_goodsAlertView = [[HMHGoodsPushAlertView alloc] initWithFrame:CGRectMake(0, self.statusHeghit + 44 + 60, w + 10 + f, 35) userIconUrl:userAvatarStr contentStr:contentStr isShowTime:[showTimeNum integerValue] / 1000];
    [_HMH_goodsAlertView show];
    
    __weak typeof(self)weakSelf = self;
    _HMH_goodsAlertView.goodsClickBlock = ^{
        [weakSelf goodsInfoWithUrl:urlStr];
    };
}
// 跳转商品详情页面
- (void)goodsInfoWithUrl:(NSString *)url{
    PopAppointViewControllerModel *model = [NavigationContrl getModelFrom:url];
    
    HMHPopAppointViewController *goodsVC = [[HMHPopAppointViewController alloc]init];
    goodsVC.title = model.title;
    goodsVC.urlStr = url;
    if (model) {
        goodsVC.title = model.title;
        goodsVC.naviBg = model.naviBg;
        goodsVC.isNavigationBarshow = model.showNavi;
        goodsVC.naviMask = model.naviMask;
        goodsVC.naviMaskHeight = model.naviMaskHeight;
        goodsVC.pageTag = model.pageTag;
    }
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}
// 返回用户uid
- (NSString *)getUserUidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"uid"]];
    if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) { //已经登录
        return uidStr;
    }
    return @"";
}

- (void)webViewLoadDatafromMainUrl:(NSString *)mainUrlStr{
    
    if (self.webView) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mainUrlStr]]];
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
#pragma mark ##############################webView初始化相关##################################

- (WKWebView *)congigWebView {
   
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        for (int i=0; i<self.webViewContifgArrary.count; i++) {
            
            [userContentController addScriptMessageHandler:self
                                   name:self.webViewContifgArrary[i]];
        }
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
       WKWebView * configWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        [self.view addSubview:configWebView];
//    NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('%@')", [HFUserDataTools loginSuccess]];
//    [self.webView evaluateJavaScript:jsString completionHandler:^(NSString  *result, NSError *error) {
//        
//        
//    }];
    //
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:noneSelectScript];
    
    
    [configWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(self.statusHeghit);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-self.buttomBarHeghit);
    }];
    configWebView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
    configWebView.UIDelegate = self; // 设置WKUIDelegate代理
    configWebView.navigationDelegate = self;
    self.automaticallyAdjustsScrollViewInsets = YES;
    return configWebView;
    
}
- (void)initWebView{
    self.webView = [self congigWebView];
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 2)];
    self.progressView.tintColor = [UIColor redColor];

    //    注释web加载进度
//    [_webView addSubview:self.progressView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mainUrlStr]]];
    //监听加载进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]]];
        
    }];
    //解决ios10 webview下移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark ##########WKNavigationDelegate  代理相关协议方法################
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // .*/html/order/main/placeorder_r.html.*
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    /*
     1.拦截当前的URL，判断是否在当前需要开新窗口的列表，在且不是第一次加载就弹窗
     */
    /*
     1.拦截当前的URL，判断当前是否是goback方法
     */
    if (self.HMH_isFristLoadWebView||[urlStr isEqualToString:@"about:blank"]||!navigationAction.targetFrame.isMainFrame==YES) {
        decisionHandler(WKNavigationActionPolicyAllow);
        [self showProgress];
        self.HMH_isFristLoadWebView = NO;
        if (![self.webView canGoBack]) {
            
            self.HMH_isCanPopViewCurrentController = YES;
            
        }else{
            
            self.HMH_isCanPopViewCurrentController = NO;
            
        }
        self.HMH_isFristComeIN =NO;
        return;
    }
    if (navigationAction.navigationType ==WKNavigationTypeBackForward||navigationAction.navigationType ==WKNavigationTypeReload) {
        if (navigationAction.targetFrame.isMainFrame==YES) {
            self.currentUrl = urlStr;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        [self showProgress];

        return;
    }
    if (self.HMH_isFresh||self.shouldRefresh) {
        self.HMH_isFresh = NO;
        self.shouldRefresh = NO;
        self.currentUrl    =  urlStr;
        decisionHandler(WKNavigationActionPolicyAllow);
        [self showProgress];
        
        return;
    }
    self.popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    //新开弹窗------验证要关闭的窗口
    
    PopAppointViewControllerModel*appointModel = [NavigationContrl getModelFrom:urlStr];
    PageUrlConfigModel *pageUrlmodel =  [NavigationContrl getPageurlModelByPageTag:appointModel.pageTag];
    //不是以main_*或者url_开头
    if (appointModel&&![pageUrlmodel.pageTag isEqualToString:@"fy_login"]&&![pageUrlmodel.pageTag isEqualToString:@"fy_quick_login"]) {
        //对于本页面来说，只有两种状态，1是要开新窗口。2.是要加载
        mianTab_type type = [self.popTool isPopNewWindowWithcheckUrl:urlStr];
        // ||type==main_globalhome   ||type==main_moments ||type==main_mall
        // 切换tab 目前只留 首页和我的
        if (type==main_home||type==main_mine) {
            //导航切换tab
            if ([urlStr isEqualToString:self.mainUrlStr]) {
                decisionHandler(WKNavigationActionPolicyAllow);
                [self showProgress];
                if (navigationAction.targetFrame.isMainFrame==YES) {
                    self.currentUrl = urlStr;
                }
                return;
            }
            [NavigationContrl changeTabIndexWith:type and:self.navigationController and:urlStr and:pageUrlmodel];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else if(type==loadByWebView){//不开新窗口，网页自己加载
            [self showProgress];
            self.currentUrl = urlStr;
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }else if (type ==external_domain){
            HMHExternalDomViewControoler *evc = [[HMHExternalDomViewControoler alloc]init];
            evc.title = appointModel.title;
            evc.naviBg = appointModel.naviBg;
            evc.isNavigationBarshow = appointModel.showNavi;
            evc.hidesBottomBarWhenPushed = YES;
            evc.urlStr = urlStr;
            [self.navigationController pushViewController:evc animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else if (type == openNewPop||type==main_globalhome||type==main_moments){//新开窗口  此处全球家和新零售也新开窗口 因为修改了原有的tabBar  此处的main_moments对应的main_OTO 新零售
            
            
            // 7.查找现在栈内是否有对应的页面，否--->弹出窗口，是--->下一步
            // 8.找到对应页面（将之上的页面出栈，刷新当前）
            // 9.关闭需要关闭的页面、刷新需要刷新的页面
            if ([self.mainUrlStr isEqualToString:urlStr]) {
                decisionHandler(WKNavigationActionPolicyAllow);
                [self showProgress];
                self.currentUrl = urlStr;
                return;
            }
            decisionHandler(WKNavigationActionPolicyCancel);
            [NavigationContrl dealCloseOrRefreshPagesAfterOpenNewPage:appointModel url:urlStr Navigation:self.navigationController lastPageUrl:self.currentUrl];
            return;
        }
    }else if([pageUrlmodel.pageTag isEqualToString:@"fy_login"]||[pageUrlmodel.pageTag isEqualToString:@"fy_quick_login"]){
        
        LocalLoginViewController *LVC = [[LocalLoginViewController alloc]init];
        LVC.hidesBottomBarWhenPushed = YES;
        LVC.mainUrlStr =  urlStr;
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (![self.pageTag isEqualToString:@"fy_main_mine"]) {
            [viewControllers addObject:LVC];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
        if ([self.pageTag isEqualToString:@"fy_mall_goods_order"]||![urlStr containsString:@"checkBefore"]) {
            if (viewControllers.count>=3){
                [viewControllers removeObject:viewControllers[viewControllers.count-2]];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    self.HMH_isFristLoadWebView = NO;
    if (![self.webView canGoBack]) {
        self.HMH_isCanPopViewCurrentController = YES;
    }else{
        
        self.HMH_isCanPopViewCurrentController = NO;
    }
    self.HMH_isFristComeIN =NO;
    if ([scheme isEqualToString:@"mailto"]) {
        
        [[UIApplication sharedApplication] openURL:URL];
        
    }if([urlStr rangeOfString:@"downLoad=0"].location!= NSNotFound){
        
        decisionHandler(WKNavigationActionPolicyAllow);
        [self showProgress];

        self.currentUrl    =  urlStr;
        
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
        [self showProgress];

        return;
    }
    if ([urlStr containsString:@"https://itunes.apple.com/cn/app/he-fa-fang-yin/id1447851000"]) {
        [self presentOtherViewController:urlStr];
        //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id934245416"]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (navigationAction.targetFrame.isMainFrame==YES) {
        self.currentUrl = urlStr;
    }
    decisionHandler(WKNavigationActionPolicyAllow);

    [self showProgress];

    return;

}
- (BOOL)navigationShouldPopOnBackButton{
    
    if (self.HMH_isCanPopViewCurrentController) {
        return YES;
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
        return NO;
    }
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //注册极光
    [self dissMissProgress];
}

//失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if([error code] == NSURLErrorCancelled)
        
    {
        
        return;
        
    }
    self.HMH_loadCount --;
    [self dissMissProgress];

}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.HMH_loadCount ++;
    [self showProgress];
    
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.HMH_loadCount --;
    [self endRefresh];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{

    NSLog(@"%@",error);
    [self endRefresh];
    [self dissMissProgress];


}
- (void)endRefresh{
    
    //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    [self.webView.scrollView.mj_header endRefreshing];
    [self.webView.scrollView.mj_footer endRefreshing];
    
}
#pragma Mark 监听进度###############################
- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary* )change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
       // self.title = self.webView.title;
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
        // 默认不显示加载动画中的返回按钮
        self.customHUD.backBtn.hidden = YES;

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
        if (self.HMH_isFresh||self.shouldRefresh) {
            [self hideMBProgressHUD];
        }
        
        [self.progressView setProgress:newP animated:YES];
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
#pragma mark##############首页消息#################
- (void)openMsgWindow:(id)body{

    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = body;
      /*
       {
       mobilephone = 13524647086;
       naviBg = "#ffb100";
       showNavi = 1;
       title = "\U6d88\U606f";
       uid = 146429;
       url = "/html/shopping/news/news.html";
       }
       */
        if ([[self.navigationController.viewControllers lastObject]isKindOfClass:[ChatMessageViewController class]]) {
            return;
        }
        ChatMessageViewController *chatVC = [[ChatMessageViewController alloc]init];
        NSString * url = dic[@"url"];
        if (url.length > 0) {
            chatVC.urlStr = url;
        }
        if ([dic[@"title"] length] > 0) {
            chatVC.naTitle = dic[@"title"];
            chatVC.isShowNaBar = dic[@"showNavi"];
            chatVC.BgColor = dic[@"naviBg"];
        }
        NSString *uidStr = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        chatVC.uid = uidStr;
        chatVC.mobilephone = dic[@"mobilephone"];
        if (dic[@"appMsgUrl"]) {
            chatVC.appMsgUrl = dic[@"appMsgUrl"];
        }
        if (dic[@"expressRouterMsgUrl"]){
            chatVC.expressRouterMsgUrl = dic[@"expressRouterMsgUrl"];
        }
        if (dic[@"loginUrl"]) {
            chatVC.loginUrl = dic[@"loginUrl"];
        }
        chatVC.systemMsgCount = [dic[@"appMsgCount"] integerValue];
        chatVC.expRouterMsgCount = [dic[@"expRouterMsgCount"] integerValue];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}
#pragma mark##############调通讯录#################
- (void)openContactsWindow:(id)body{
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary*dic = body;
        if (dic[@"mobilephone"]) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:dic[@"mobilephone"] forKey:@"NIMmobilephone"];
            [ud synchronize];
        }
    }
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

#pragma mark ############# 合发直播入口##################
- (void)openVideoHomeWindow:(id)body{
    HMHVideoHomeViewController *vc = [[HMHVideoHomeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark #############新登录##################
- (void)login:(id)body{
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
    [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
     
//    [JPUSHService setAlias:uid callbackSelector:nil object:nil];
    [self loginAtNetease:body];
    
}
- (void)logout:(id)body{
    NIMContactTools *NIMTools = [NIMContactTools  shareTools];
    NIMTools.contactTab = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobilephone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
//    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:@"ture" forKey:@"isLogout"];
}
#pragma mark ##############IM相关##################
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
//                                              NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
//                                              [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
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
- (void)openChatWithAccidInfo:(id)infoDic{
   
//    ChatMessageViewController *vc = [[ChatMessageViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//
   NIMContactTools *NIMTools = [NIMContactTools  shareTools];
    if (!NIMTools.contactTab) {
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
        NIMTools.contactTab = conVC;
        NIMTools.contactTab.hidesBottomBarWhenPushed = YES;
    }
   
    [self.navigationController pushViewController:NIMTools.contactTab animated:YES];

}
- (void)ToAdViewController:(id)body{
    NSDictionary *dic = body;
    NSString *url = dic[@"url"];
    HMHADViewController *ad = [[HMHADViewController alloc]init];
    ad.HMH_urlStr = url;
    ad.hidesBottomBarWhenPushed = YES;
    
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
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
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
    adViewController.hidesBottomBarWhenPushed = YES;
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
    if (dic[@"showNavi"]) {
        pvc.naTitle =dic[@"title"];
        pvc.isShowNaBar = dic[@"showNavi"];
        pvc.BgColor = dic[@"naviBg"];
        if (dic[@"naviMaskHeight"]) {
            pvc.naviMaskHeight = [dic[@"naviMaskHeight"] floatValue];
        }
        pvc.naviMaskHeight = 64;
    }
    pvc.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:pvc animated:YES];
}
#pragma Mark#################获取版本号#####################

- (void)postVersionInfo:(id)body{
    NSString *fuctionN = body;
    NSString *currentVersion = [VersionTools appVersion];//_tools.appInfoModel.iosVersionCode;
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
           // [ManagerTools postData:mutabelDic toUrl:@"/log/js"];
            
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
    svc.hidesBottomBarWhenPushed = YES;
    NSLog(@"%p",self.navigationController);
    [self.navigationController pushViewController:svc animated:YES];
    
}
- (void)afterScan:(NSString *)ScanStr funcName:(NSString *)funName{
    
    NSLog(@"扫描结果：%@",ScanStr);
    NSString *fuctionN = funName;
    
    NSString *jsStr   = [NSString stringWithFormat:@"%@('%@')",fuctionN,ScanStr];
    __block HMHViewController/*主控制器*/ *weakSelf = self;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.webView evaluateJavaScript:jsStr
                       completionHandler:^(id _Nullable data,
                                           NSError * _Nullable error) {
                           if (error) {
                               NSLog(@"错误:%@", error.localizedDescription);
                           }
                       }];
//    });
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
