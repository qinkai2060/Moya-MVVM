//
//  PopAppointViewController.m
//  housebank
//
//  Created by 任为 on 2017/10/9.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHPopAppointViewController.h"
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
#import "UIViewController+BackButtonHandler.h"
#import "LocalLoginViewController.h"
#import "NIMContactTools.h"

#define adImageArraryName "adImageArraryName"
#define adImageArraryLink "adImageArraryLink"

@interface HMHPopAppointViewController ()<WKUIDelegate,WKNavigationDelegate,
WKScriptMessageHandler,
UIDocumentInteractionControllerDelegate,
BeeCloudDelegate,
UIAlertViewDelegate,
GuideScrollViewDeledate,
payToolDelegete,
ShareToolDelegete,ScanDelegate,NIMLoginManagerDelegate>
//@property (nonatomic, strong)WKWebView * webView;
//@property (nonatomic, strong) DetailViewController *MVPlayer;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, assign) NSUInteger loadCount;

@property (nonatomic,strong)  NSArray *UpDdArrary;
@property (nonatomic,strong)HMHADViewController *PayADViewController;
@property (nonatomic, strong)PayTools *payTool;
@property (nonatomic, strong)ShareTools *shareTool;
@property (nonatomic, assign)BOOL isCan;
@property (nonatomic, strong) UILabel *noticelabel;



@property (nonatomic, strong)  HMHGoodsPushAlertView *goodsAlertView;


@property (nonatomic, strong) NSString *scanCodeStr;
@property (nonatomic, strong) NSString *fromeSource;
@property (nonatomic, assign) BOOL isScancode;

@end

@implementation HMHPopAppointViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage: [UIImage imageNamed:@"back-b"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [btn addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
//    [self setNavBgColor:[UIColor blueColor]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HMH_back_light"] style:UIBarButtonItemStyleDone target:self action:@selector(navLeftBarButtonClick)];
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 44, 44);
//    [leftButton setImage:[UIImage imageNamed:@"HMH_back_light"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationController.navigationBarHidden = !self.isNavigationBarshow;
    self.navigationController.navigationBar.translucent = NO;
    [self supportedInterfaceOrientations];
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:UIColor.blueColor] forBarMetrics:UIBarMetricsCompactPrompt];
  
////  [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.naviBg]}];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString: self.naviBg];
////    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#222222"];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:self.naviBg];
    
    self.getNowCurrentUrl = self.urlStr;
    
    // 接收推送的文本消息 (当用户下单时 弹XX下单的框)
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
}
-(void)navLeftBarButtonClick
{
    [self.navigationController  popViewControllerAnimated:YES];
}
- (void)setNavBgColor:(UIColor *)bgColor
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageWithColor:bgColor]
                                                  forBarPosition:UIBarPositionAny
                                                      barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[UIImage new]];
    
}
- (void)loginSuccess {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)viewDidLoad
{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.isFristLoadWebView = YES;
    self.currentUrl = self.urlStr;
    self.getNowCurrentUrl = self.urlStr;
    self.isCanPopViewCurrentController = YES;
    self.navigationController.navigationBarHidden = !self.isNavigationBarshow;
    _payTool   = [[PayTools alloc]init];
    _payTool.delegete   = self;
    _shareTool = [[ShareTools alloc]init];
    _shareTool.delegete = self;
    
    [super viewDidLoad];
    [self initWebView];
    [self regiserNotification];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detialEnter) name:@"detial" object:nil];
    //[(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
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
        

        PopAppointViewControllerModel*currentAppointModel = [NavigationContrl getModelFrom:self.getNowCurrentUrl];
        
        NSLog(@"%@,%@",pageTagsStr,currentAppointModel.pageTag);
        if ([pageTagsStr containsString:currentAppointModel.pageTag]) {
            // 比如XXX省XX人3分钟前已下单
            NSString *contentStr = content;
            CGFloat w = [CommonManagementTools getWidthWithFontSize:14.0 height:35 text:contentStr];
            if (_goodsAlertView) {
                [_goodsAlertView hide];
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
                // 针对没有登录的用户  未登录用户可以收到
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
    
    _goodsAlertView = [[HMHGoodsPushAlertView alloc] initWithFrame:CGRectMake(0, self.statusHeghit + 44 + 60, w + 10 + f, 35) userIconUrl:userAvatarStr contentStr:contentStr isShowTime:[showTimeNum integerValue] / 1000];
    [_goodsAlertView show];
    
    __weak typeof(self)weakSelf = self;
    _goodsAlertView.goodsClickBlock = ^{
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

- (void)regiserNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayResult:) name:@"aliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXPayResult:) name:@"WX_PayResp" object:nil];
}



#pragma mark ##############################webView初始化相关##################################

- (WKWebView *)webView {
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (_webView == nil){
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        for (int i=0; i<self.webViewContifgArrary.count; i++) {
            [userContentController addScriptMessageHandler:self
                                                      name:self.webViewContifgArrary[i]];
        }
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        configuration.userContentController = userContentController;
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        [self.view addSubview:_webView];
        
//        NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('%@')", [HFUserDataTools loginSuccess]];
//        [self.webView evaluateJavaScript:jsString completionHandler:^(NSString  *result, NSError *error) {
//
//
//        }];
        //
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:noneSelectScript];
        CGFloat  topy=0;
         self.statusHeghit=StatusBarHeight;
        self.buttomBarHeghit=KBottomSafeHeight;
        if (self.isNavigationBarshow) {
            self.statusHeghit=StatusBarHeight;
            self.naviMaskHeight=KNavBarHeight;
            topy=0;
        }else
        {
            topy = self.statusHeghit;
        }
        // 适配iPhone X
        
        CGFloat bottom = self.buttomBarHeghit;
//        if (self.naviMaskHeight>0) {
//            NSString *version = [UIDevice currentDevice].systemVersion;
//            double ver = version.doubleValue;
//            if (version.doubleValue < 11.0) {
//                topy = 64-self.naviMaskHeight;
//            } else {
//                topy = -self.naviMaskHeight;
//            }
//        }else
//        {
//            topy=StatusBarHeight;
//        }
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.top.equalTo(self.view.mas_top).offset(topy);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);
        }];
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        self.progressView.hidden = NO;
        self.progressView.backgroundColor = [UIColor redColor];
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
    [self webView];
    // [self removeCache];
    // NSString * encodedString =[self.currentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_webView loadRequest:[self addRefree:self.currentUrl]];
    //监听加载进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [_webView loadRequest:[self addRefree:self.currentUrl]];
    //        self.isFresh = YES;
    //    }];
    //  [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
}
- (NSURLRequest*)addRefree:(NSString*)url{
    
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            dispatch_async(dispatch_get_main_queue(), ^{
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:self.LastPageUrl forHTTPHeaderField: @"Referer"];
    //            });
    //        });
    
    NSDictionary *headerDic=   [request allHTTPHeaderFields];
    
    return request;
}
#pragma mark ##########WKNavigationDelegate  代理相关协议方法################
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSDictionary *header = [navigationAction.request allHTTPHeaderFields];
    
    // .*/html/order/main/placeorder_r.html.*
    /**
     0.判断url是否为空，是否合法,否-->return,是-->下一步
     1.判断是否为需要拦截的Scheme，mailto、tel,如果是reture,否-->下一步
     2.判断是否为reload或者刷新，是-->允许刷新，retun，否-->下一步
     3.根据url取出pageTage,过滤掉main——*，url_*（单独处理）,否--->下一步
     4.判断正则匹配，是否能匹配到，是否壳弹窗打开，否--->retun,允许加载，是--->下一步
     5.判断pageTag是否为fy_main*,是-->跳到对应tab,否--->下一步，
     6.判断该页面pageLaunchMode是否为栈内唯一，否--->弹新窗口，是--->下一步
     7.查找现在栈内是否有对应的页面，否--->弹出窗口，是--->下一步
     8.找到对应页面（将之上的页面出栈，刷新当前）
     9.关闭需要关闭的页面、刷新需要刷新的页面
     */
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    
    self.getNowCurrentUrl = urlStr;
    // 判断是否是来自原生视频直播中的webView的跳转
    if (self.isPushFromVideoWeb) {
        self.isFristLoadWebView = NO;
    }
    
    //1.判断是否为第一次加载、是否为主，是否为空页面
    if (self.isFristLoadWebView||[urlStr isEqualToString:@"about:blank"]||!navigationAction.targetFrame.isMainFrame==YES) {
        decisionHandler(WKNavigationActionPolicyAllow);
        self.isFristLoadWebView = NO;
        if (![self.webView canGoBack]) {
            
            self.isCanPopViewCurrentController = YES;
            
        }else{
            
            self.isCanPopViewCurrentController = NO;
            
        }
        self.isFristComeIN =NO;
        return;
    }
    /*
     2.拦截当前的URL，判断当前是否是goback方法、reload、刷新
     */
    if (navigationAction.navigationType ==WKNavigationTypeBackForward||navigationAction.navigationType ==WKNavigationTypeReload) {
        self.currentUrl    =  urlStr;
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if (self.isFresh||self.shouldRefresh) {
        self.isFresh = NO;
        self.shouldRefresh = NO;
        self.currentUrl    =  urlStr;
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    /*
     是否为要拦截的scheme
     */
    if ([scheme isEqualToString:@"mailto"]) {
        
        [[UIApplication sharedApplication] openURL:URL];
        
    }if([urlStr rangeOfString:@"downLoad=0"].location!= NSNotFound){
        decisionHandler(WKNavigationActionPolicyAllow);
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
        return;
    }
    self.popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    //根据url取 PopAppointViewControllerToos中的配置model
    PopAppointViewControllerModel*appointModel = [NavigationContrl getModelFrom:urlStr];
    PageUrlConfigModel *pageUrlModel = [NavigationContrl getPageurlModelFrom:urlStr];
    //不是以main_*或者url_开头
    if (appointModel&&![pageUrlModel.pageTag isEqualToString:@"fy_login"]&&![pageUrlModel.pageTag isEqualToString:@"fy_quick_login"]) {
        //对于本页面来说，只有两种状态，1是要开新窗口。2.是要加载
        mianTab_type type = [self.popTool isPopNewWindowWithcheckUrl:urlStr];
        if (type==main_home||type==main_mine) { //||type==main_mall||type==main_globalhome||type==main_moments
            //导航切换tab
            [NavigationContrl changeTabIndexWith:type and:self.navigationController and:urlStr and:pageUrlModel];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else if(type==loadByWebView){//不开新窗口，网页自己加载
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }else if (type ==external_domain){
            HMHExternalDomViewControoler *evc = [[HMHExternalDomViewControoler alloc]init];
            evc.title = appointModel.title;
            evc.naviBg = appointModel.naviBg;
            evc.isNavigationBarshow = appointModel.showNavi;
            evc.urlStr = urlStr;
            // 是否来自视频直播  默认为No
            evc.isPushFromVideoWeb = self.isPushFromVideoWeb;
            evc.hidesBottomBarWhenPushed = YES;
            if (self.isFromVideoWebView) { // 是否是来自视频直播中的简介
                //                evc.isNavigationBarshow = YES;
                if (self.popVCCallBack) {
                    self.popVCCallBack(evc);
                }
            } else {
                [self.navigationController pushViewController:evc animated:YES];
            }
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else if(type == openNewPop){//新开窗口
            // 7.查找现在栈内是否有对应的页面，否--->弹出窗口，是--->下一步
            // 8.找到对应页面（将之上的页面出栈，刷新当前）
            // 9.关闭需要关闭的页面、刷新需要刷新的页面
            decisionHandler(WKNavigationActionPolicyCancel);
            [NavigationContrl dealCloseOrRefreshPagesAfterOpenNewPage:appointModel url:urlStr Navigation:self.navigationController lastPageUrl:self.currentUrl];
            return;
        }
    }else if([pageUrlModel.pageTag isEqualToString:@"fy_login"]||[pageUrlModel.pageTag isEqualToString:@"fy_quick_login"]){//登陆成功后关闭订单界面（待优化） fy_login
        LocalLoginViewController *LVC = [[LocalLoginViewController alloc]init];
        LVC.mainUrlStr =  urlStr;
        LVC.hidesBottomBarWhenPushed = YES;
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers addObject:LVC];
        [self.navigationController setViewControllers:viewControllers animated:YES];
        if ([self.pageTag isEqualToString:@"fy_mall_goods_order"]||![urlStr containsString:@"checkBefore"]) {
            
            if (viewControllers.count>=3){
                [viewControllers removeObject:viewControllers[viewControllers.count-2]];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    self.isFristLoadWebView = NO;
    if (![self.webView canGoBack]) {
        self.isCanPopViewCurrentController = YES;
    }else{
        
        self.isCanPopViewCurrentController = NO;
    }
    self.isFristComeIN =NO;
    if ([urlStr containsString:@"https://itunes.apple.com/cn/app/he-fa-fang-yin/id934245416"]) {
        [self presentOtherViewController:urlStr];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (navigationAction.targetFrame.isMainFrame==YES) {
        self.currentUrl = urlStr;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //注册极光
    NSLog(@"didFinishNavigation");
    if (self.progressView) {
        self.progressView.hidden = YES;
    }
    [self endRefresh];
    [self dissMissProgress];
    
}

//失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailNavigation");
    
    if([error code] == NSURLErrorCancelled)
        
    {
        return;
    }
    [self endRefresh];
    self.loadCount --;
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.loadCount ++;
    if (self.progressView) {
        
        self.progressView.hidden = NO;
        
    }
}

// 内容返回时

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%@",error);
    if (self.progressView) {
        
        self.progressView.hidden = YES;
        
    }
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
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        [self hideMBProgressHUD];
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        [self showMBProgressHUD];
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
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
    
    if (self.isCanPopViewCurrentController) {
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

- (void)backToPath:(id)body {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SpGoodsDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShopCar" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}
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

#pragma mark #############新登录##################
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
    // 视频页面判断是否登录
    if (self.judgeIsLoginBack) {
        self.judgeIsLoginBack(sid);
    }
    // 判断是否是模态进入的
    if (self.isPresentJump) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.bCallBackBlock) {
        self.bCallBackBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self loginAtMsg:<#(id)#>]
}
- (void)logout:(id)body{
    UITabBarController *tab = self.navigationController.tabBarController;
    if ([tab isKindOfClass:[UITabBarController class]]) {
        for (int i=0; i<tab.viewControllers.count; i++) {
            UINavigationController *navc = tab.viewControllers[i];
            if ([navc isKindOfClass:[UINavigationController class]]) {
                UIViewController *vc = navc.viewControllers[0];
                UITabBarItem * item = vc.tabBarItem;
                item.badgeValue = nil;
                NSLog(@"%@",item.badgeValue);
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"ture" forKey:@"isLogout"];
    NIMContactTools *NIMTools = [NIMContactTools  shareTools];
    NIMTools.contactTab = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobilephone"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    // 移出合法直播中下载时 是否使用4G的状态
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kIsAllowCellar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"playBackUrl"];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"%@----%ld",iAlias,iResCode);
    } seq:2];
    
    //    [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //
    //    } seq:2];
    // [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [_payTool doPayWith:body];
    
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
- (void)backPressed:(id)body {
    if (self.isPresentJump) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//快钱支付、畅捷支付
- (void)openPopupPayWindow:(id)body{
//    快捷支付
    NSDictionary *dic = body;
    HMHPayPopWindowViewController *pvc = [[HMHPayPopWindowViewController alloc]init];
    NSString * url = dic[@"url"];
    pvc.urlStr = url;
    if (dic[@"title"]) {
        pvc.naTitle = dic[@"title"];
        pvc.isShowNaBar = dic[@"showNavi"];
        pvc.BgColor = dic[@"naviBg"];
        
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

- (void)loginAtMsg:(id)body{
    /*{
     accid = 160395;
     appId = 3ac6ee77676a8456748589fe98b10bcb;
     description = "<null>";
     id = 75614;
     insertTime = "2017-09-30 10:49:04";
     insertUser = 160395;
     loginId = 160395;
     mobilephone = 13524647085;
     naviBg = "#ffb100";
     nextUrl = "https://m.fybanks.cn/html/order/circle/logistics_r.html";
     showNavi = 1;
     status = 1;
     timestamp = "2017-09-30 10:49:04";
     title = "\U5408\U53d1\U623f\U94f6-\U901a\U8baf\U5f55";
     token = 1bfe0f0cf23e65b790ba1a6da0d7e4e3;
     uid = 160395;
     updateTime = "<null>";
     updateUser = "<null>";
     }
     */
    [self loginAtNetease:body];
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = body;
        NSString *nextUrl = dic[@"nextUrl"];
        NSString *uidStr = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        NSString *phoneStr = [NSString stringWithFormat:@"%@",dic[@"mobilephone"]];
        
        NSString *mobilePhoneStr = [NSString stringWithFormat:@"%@",dic[@"mobilephone"]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:mobilePhoneStr forKey:@"NIMmobilephone"];
        [ud synchronize];
        
        if (nextUrl.length > 0) { // 物流
            if (self.wuLiuUrl) {
                [self.navigationController popViewControllerAnimated:NO];
                
                self.wuLiuUrl(nextUrl);
            }
        } else { // 通讯录
            
            if (self.acontactCallBack) {
                [self.navigationController popViewControllerAnimated:NO];
                
                self.acontactCallBack(phoneStr, uidStr);
            }
        }
    }
    
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
    if (!_isCan) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        _isCan = !_isCan;
    }else{
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        _isCan = !_isCan;
        
    }
     [ShareTools  shareWithContent:body];
//    [_shareTool doShare:body];
    
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
        _documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        _documentController.delegate = self;
        [self.documentController presentPreviewAnimated:YES];
        
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
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end

