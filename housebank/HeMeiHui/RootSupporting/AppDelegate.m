//
//  AppDelegate.m
//  HeMeiHui
//
//  Created by 任为 on 16/9/19.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "AppDelegate.h"

#import <NIMSDK/NIMSDK.h>

#import <AlipaySDK/AlipaySDK.h>

#import "IFlyMSC/IFlyMSC.h"
#import "HMHViewController.h"
#import "JPUSHService.h"
#import "HMHADViewController.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESDemoConfig.h"
#import "NIMKit.h"
#import "NTESCellLayoutConfig.h"
#import "NTESSubscribeManager.h"
#import "NTESLoginManager.h"

#import "HMHContactTabViewController.h"
#import "NIMContactTools.h"


//#import "HeFaCircleOfFriendViewController.h"
#import "MainTabBarViewController.h"


#import <UserNotifications/UserNotifications.h>
#import "SelVideoViewController.h"
//#import "RecordCameraViewController.h"
#import "NTESSessionViewController.h"
#import "WRNavigationBar.h"
#import "SpBaseNavigationController.h"
#import "SPayClient.h"
//崩溃日志管理
#import "MyUncaughtExceptionHandler.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import "HFDBManger.h"
#import <Bugly/Bugly.h>
#import "GSKeyChainDataManager.h"
#import "LocationManager.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#endif

BOOL isBeecloundPay;

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate,BuglyDelegate> // NetStateDelegete

@property (nonatomic,strong) MainTabBarViewController *tabVC;
@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [AMapServices sharedServices].apiKey = @"1dc85c8e38c1330effb16a4520fd2218";
    //   记录设备唯一标示
    NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [GSKeyChainDataManager saveUUID:deviceUUID];
    NSLog(@"%@",[GSKeyChainDataManager readUUID]);
    //    地址信息
    __weak typeof(self)weakSelf = self;
    LocationManager *locationManager = [LocationManager shareTools];
    [locationManager initializeLocationService];
    [locationManager start];
    [locationManager getlocationInfo:^(NSString *locationStr) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [weakSelf dictionaryWithJsonString:locationStr];
        //在这里处理省市区
        [weakSelf reverseGeocodeLatitude:dic[@"lat"] longitude:dic[@"lng"]];
        //        });
    }];
    //    启动记录
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"startUp"];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"startUp"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [Bugly startWithAppId:@"ba5aa06daf"];
//    NSArray *array = @[@(1), @(2), @(3)];
//    NSLog(@"array[3] = %zd", array[3]);
//    BuglyConfig *config = [[BuglyConfig alloc] init];
//    config.delegate = self;
//    [Bugly startWithAppId:@"ba5aa06daf" config:config];

//    初始化ShareSdk
    [self  ShareSDKRegister];

    //[self setStatusBarBackgroundColor:[UIColor blackColor]];
    [self updateUserAgent];//设置浏览器UserAgent
    [MyUncaughtExceptionHandler setDefaultHandler];//收集日志
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        [self postLog];
    }
    // 初始化SDK (请前往 联系UPYUN 获取您的 APP 开发密钥)
    /**
     *  初始化SDK，应用密钥是您的应用在 TuSDK 的唯一标识符。每个应用的包名(Bundle Identifier)、密钥、资源包(滤镜、贴纸等)三者需要匹配，否则将会报错。
     *
     *  @param appkey 应用秘钥 (请前往 http://tusdk.com 申请秘钥)
     */
//    [TuSDK initSdkWithAppKey:@"c96afe549111fe92-03-l5xkr1"];
    // 多 masterkey 方式启动方法
    /**
     *  指定开发模式,需要与lsq_tusdk_configs.json中masters.key匹配， 如果找不到devType将默认读取master字段
     *  如果一个应用对应多个包名，则可以使用这种方式来进行集成调试。
     */
    //    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.XXXXXXXX.XXXX"]) {
    //        [TuSDK initSdkWithAppKey:@"714f0a1265b39708-02-xie0p1" devType:@"release"];
    //    }
    // 开发时请打开调试日志输出
//    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    

    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    MainTabBarViewController*tabBarVC = [[MainTabBarViewController alloc]init];
    self.tabVC = tabBarVC;
    [self.window setRootViewController:tabBarVC];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1],UITextAttributeFont:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#39b9ed"],UITextAttributeFont:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    [self launchAnimation];
    [self setupNIMSDK];
    [self JpushInit:launchOptions];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popHomeMe:) name:@"loadingHome" object:nil];
    //网络状况
    ManagerTools *tools = [ManagerTools ManagerTools];
    tools.netReachAbility=[Reachability reachabilityForInternetConnection];
    [tools.netReachAbility startNotifier];
    
//    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
//    wechatConfigModel.appScheme = @"wxf28ea333950a5eb4";
//    wechatConfigModel.wechatAppid = @"wxf28ea333950a5eb4";
//    wechatConfigModel.isEnableMTA =YES;
//
//    //配置微信APP支付
//    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
//
//    [[SPayClient sharedInstance] application:application
//               didFinishLaunchingWithOptions:launchOptions];
    
    
//    // 接收推送的文本消息
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    /** 科大讯飞语音*/
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5d63a6d4"];
    [IFlySpeechUtility createUtility:initString];
    [self NetWorkConfig];
    return YES;
}   

- (void)NetWorkConfig {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:@"1107995805" appkey:@"r6Lt4ijVvOi5PImr"];
        [platformsRegister setupSinaWeiboWithAppkey:@"2701599598" appSecret:@"d5b5bcfabeb644ad74c3c0d71192b577" redirectUrl:@"http://www.sharesdk.cn"];
//        [platformsRegister setupWeChatWithAppId:@"wxb372eb1c4a8e393f" appSecret:@"c8550aeff667cc745c6dc3eaeae52174" universalLink:@"https://applinks:a1fl.t4m.cn/"];
        [platformsRegister setupWeChatWithAppId:@"wxb372eb1c4a8e393f" appSecret:@"c8550aeff667cc745c6dc3eaeae52174"];
    }];
    [HFDBManger sharedDBManager];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl =  CurrentEnvironment;

    config.cdnUrl = CurrentEnvironment;
    [WRNavigationBar wr_widely];
    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
                                       @"TZPhotoPickerController",
                                       @"TZGifPhotoPreviewController",
                                       @"TZAlbumPickerController",
                                       @"TZPhotoPreviewController",
                                       @"TZVideoPlayerController",@"SpBaseNavigationController"]];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor blackColor]];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HFCarRequest navtiveSwitch];
    });
//    [[PINRemoteImageManager sharedImageManager] setProgressiveRendersMaxProgressiveRenderSize:CGSizeMake(2048, 2048) completion:nil];
    [[[ASPINRemoteImageDownloader sharedDownloader] sharedPINRemoteImageManager] setProgressiveRendersMaxProgressiveRenderSize:CGSizeMake(2048, 2048) completion:nil];
    
    
}
//#pragma mark - Bugly代理 - 捕获异常,回调(@return 返回需上报记录，随 异常上报一起上报)
//- (NSString *)attachmentForException:(NSException *)exception {
//
//#ifdef DEBUG // 调试
//    return [NSString stringWithFormat:@"我是携带信息:%@",[self redirectNSLogToDocumentFolder]];
//#endif
//
//    return nil;
//}
//
//#pragma mark - 保存日志文件
//- (NSString *)redirectNSLogToDocumentFolder{
//    //如果已经连接Xcode调试则不输出到文件
//    if(isatty(STDOUT_FILENO)) {
//        return nil;
//    }
//    UIDevice *device = [UIDevice currentDevice];
//    if([[device model] hasSuffix:@"Simulator"]){
//        //在模拟器不保存到文件中
//        return nil;
//    }
//    //获取Document目录下的Log文件夹，若没有则新建
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
//    if (!fileExists) {
//        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
//    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
//    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];
//    // freopen 重定向输出输出流，将log输入到文件
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
//
//    return [[NSString alloc] initWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
//
//}

//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    /*
//     {
//     content = "sdsdsdsd1230\U79d2\U524d\U5df2\U4e0b\U5355"; // sdsdsdsd1230秒前已下单
//     "content_type" = 6;
//     extras =     {
//     showTime = 4;
//     url = "https://m.fybanks.cm/html/goods/main/details_r.html";
//     userAvatar = "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIxib2nFl6tIWPswXHqLgITLMpkepH6RliboK5XoMOb3fUoBAZWIlEdShpj64MkoM34IrDXdnZphqkg/132";
//     };
//     }
//     */
//    
//    
//    NSDictionary * userInfo = [notification userInfo];
//    
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSString *content_type = [userInfo valueForKey:@"content_type"];
//
//
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//
//    NSString *userAvatarStr = [extras valueForKey:@"userAvatar"];
//    NSString *urlStr = [extras valueForKey:@"url"];
//    NSNumber *showTimeNum = [extras valueForKey:@"showTime"];
//
//}

- (void)postLog{
//    /log/client/app
    ManagerTools *tools = [ManagerTools ManagerTools];
    [tools postCrashInfo:@""];
    
}
-(void)updateUserAgent{
    // 获取默认User-Agent
    NSString *version = [VersionTools appVersion ];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 给User-Agent添加额外的信息
    NSString *custom = [NSString stringWithFormat:@"%@ iOS/fybanks/%@ com.supply.mall",oldAgent,version];
    // 设置global User-Agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:custom, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

#pragma mark #######################加载广告图########################
- (void)launchAnimation {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *adimageArrary = [defaults objectForKey:@"adImageArraryName"];
    NSMutableArray *adimageMutableArry = [NSMutableArray arrayWithArray:adimageArrary];
    if (adimageArrary!=nil&&adimageArrary.count>0) {
        for (int i=0; i<adimageArrary.count; i++) {
            NSString *imageFilePath = [path stringByAppendingPathComponent:adimageArrary[i]];
            [adimageMutableArry replaceObjectAtIndex:i withObject:imageFilePath];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingHome" object:nil];
    }else{
        for (UINavigationController *nav in self.tabVC.viewControllers) {
            if (![nav isKindOfClass:[SpBaseNavigationController class]]) {
                if ([nav.topViewController isKindOfClass:[SpMainHomeViewController class]]) {
                    SpMainHomeViewController *vc = (SpMainHomeViewController*)nav.topViewController;
                    [vc popHomeMe:nil];
                }
                
            }
        }
        NSLog(@"%@",self.tabVC.viewControllers);
        return;
    }
    [self.guideView scrollViewWithImageArray:adimageMutableArry];
    self.guideView.deledate =self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//  window.windowLevel = UIWindowLevelAlert;
    [window addSubview:self.guideView];
//  [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
}

-(WDGuideScrollView *)guideView
{
    if (_guideView == nil) {
        _guideView = [[WDGuideScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _guideView;
}

- (void)ClickUIImageViewOnIndex:(NSInteger)num{
    NSArray *linkArrary=[[NSUserDefaults standardUserDefaults]objectForKey:@"adImageArraryLink"];
    if (linkArrary) {
        if (linkArrary.count>=num) {
            NSString *url = linkArrary[num];
            if (url.length>6) {
                HMHADViewController *ad = [[HMHADViewController alloc]init];
                ad.HMH_urlStr = linkArrary[num];
               // [self.navigationController pushViewController:ad animated:YES];
            }
        }
    }
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
}
//客户端注册 APNS，并在获取到 APNS Token 时将值传给 SDK
- (void)setupNIMSDK
{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    // 此方法为请取消app角标的未读个数
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = [[NTESDemoConfig sharedConfig] appKey];
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = [[NTESDemoConfig sharedConfig] apnsCername];
    option.pkCername        = [[NTESDemoConfig sharedConfig] pkCername];
    [[NIMSDK sharedSDK] registerWithOption:option];
    //注册自定义消息的解析器
    //    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
    //发布要换成正式的Key
    //正式证书名称Adhot、测试证书名称DEV
    [[NIMSDK sharedSDK] registerWithAppID:appKey cerName:NIMSDKCertificateName];
    [self registerAPNs];
    // 自动登录
    [self autoLoginIM];
}

- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}
- (void)popHomeMe:(NSNotification*)noti {
//    SpMainHomeViewController *vc = [[SpMainHomeViewController alloc] init];
//    [vc popHomeMe:noti];
    
}
// 自动登录
- (void)autoLoginIM{
//    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
//    NSString *account = [data account];
//    NSString *token = [data token];
    //如果有缓存用户名密码推荐使用自动登录
//    if ([account length] && [token length])
//    {
//        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
//        loginData.account = account;
//        loginData.token = token;
//        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
//        [[NTESServiceManager sharedManager] start];
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:account forKey:@"account"];
//        [ud setObject:token forKey:@"token"];
//        [ud synchronize];
//        [self setIMBage];
//    }else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *account = [ud objectForKey:@"account"];
        NSString *token = [ud objectForKey:@"token"];
        if (account.length>0&&token.length>0) {
            [self loginMIWithLoginAccount:account wihtToken:token];
        }
    //}
}
- (void)setIMBage{
    
//        NSInteger cout = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
//        UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//        if ([tab isKindOfClass:[UITabBarController class]]) {
//            UINavigationController *navc = tab.viewControllers[3];
//            if ([navc isKindOfClass:[UINavigationController class]]) {
//                UIViewController *vc = navc.viewControllers[0];
//                if (cout>0) {
//                    vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",cout];
//                }else{
//
//                    vc.tabBarItem.badgeValue = nil;
//
//                }
//            }
//        }
    
}
- (void)loginMIWithLoginAccount:(NSString *)account wihtToken:(NSString *)token{
    if (account&&token) {
        __weak typeof(self) weakSelf = self;
        [[[NIMSDK sharedSDK] loginManager] login:account
                                           token:token
                                      completion:^(NSError *error) {
                                          if (error == nil)
                                          {
                                              LoginData *sdkData = [[LoginData alloc] init];
                                              sdkData.account   = account;
                                              sdkData.token     = token;
                                              [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                              [[NTESServiceManager sharedManager] start];
                                              NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                              [ud setObject:account forKey:@"account"];
                                              [ud setObject:token forKey:@"token"];
                                              [ud synchronize];
                                              [weakSelf setIMBage];
                                          }
                                          else
                                          {
//                                              NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];

                                          }
                                          
                                      }];
    }
}
- (void)initContactTab{
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSString* accid =[defa objectForKey:@"accid"];
    NSString* token =[defa objectForKey:@"token"];
    NSString* uid =[defa objectForKey:@"uid"];
    NSString* mobilephone =[defa objectForKey:@"mobilephone"];
    if (accid&&token&&uid&&mobilephone) {
        NSDictionary *infoDic = @{
                                  @"accid":[defa objectForKey:@"accid"],
                                  @"token":[defa objectForKey:@"token"],
                                  @"uid":[defa objectForKey:@"uid"],
                                  @"mobilephone":[defa objectForKey:@"mobilephone"],
                                  };
        NIMContactTools *NIMTools = [NIMContactTools  shareTools];
        if (!NIMTools.contactTab) {
            HMHContactTabViewController *conVC = [[HMHContactTabViewController alloc]init];
            HMHPhoneBookViewController *phoneVC = [[HMHPhoneBookViewController alloc]init];
            conVC.phoneVC = phoneVC;
            conVC.automaticallyAdjustsScrollViewInsets = NO;
            conVC.infoDic = infoDic;
            NIMTools.contactTab = conVC;
        }
    }
}
- (void)JpushInit:(NSDictionary *)launchOptions{

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //0642dd6549939b9e4d0773c4   正式环境证书key
    //39fed178d99672ed33f9135e测试徐业鼎
    //224eb6829969f1c7475ff11d RW
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppKey
                          channel:nil
                 apsForProduction:apsForProduction    //正式环境 改为1
            advertisingIdentifier:nil];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
//    [JPUSHService setTags:[NSSet setWithObjects:@"abc", nil] aliasInbackground:@"任为的iPhone"];
    //[JPUSHService setTags:[NSSet setWithObjects:@"abc", nil] callbackSelector:@selector(jpushSeletor) object:self];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSString *nim = userInfo[@"nim"];
    if ([nim isEqualToString:@"1"]) {//来自云信推送
        
    }else {//来自极光推送
        
        NSString *count = [NSString stringWithFormat:@"%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber] ;
        if (count) {
            NSInteger countbage = [count integerValue];
            if (countbage >=0) {
                countbage = countbage+1;
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)countbage] forKey:@"BageCount"];
            }
        }
    }
   // [self postNotificationWithUserInfoDic:userInfo];
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSString *nim = userInfo[@"nim"];
    if ([nim isEqualToString:@"1"]) {//来自云信推送
        if (self.window.rootViewController) {
            /*
            云信推送：
             1.判断是否登录成功，否-->去登录
             2.导航中是否有通讯录窗口-->有-->找到、打开
             3.没有通讯录则直接打开聊天窗口
             */
            MainTabBarViewController *tabbar = (MainTabBarViewController*)self.window.rootViewController;
            NSArray *naVCArray = tabbar.viewControllers;
            for (int i=0; i<naVCArray.count; i++) {//遍历导航栈中是否有通讯录单利
                UINavigationController *navc = naVCArray[i];
                if ([navc isKindOfClass:[UINavigationController class]]) {
                    for (int j=0; j<navc.viewControllers.count; j++) {
                        UIViewController *vc = navc.viewControllers[j];
                        if ([vc isKindOfClass:[HMHContactTabViewController class]]) {
                            HMHContactTabViewController *cvc = (HMHContactTabViewController*)vc;
                            [cvc butonCilck:cvc.contactListButton];
                            tabbar.selectedIndex = i;
                            [navc popToViewController:vc animated:YES];
                            NSString *sessionID = userInfo[@"sessionID"];
                            if (sessionID.length>3) {
                                NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeP2P];
                                NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                                vc.hidesBottomBarWhenPushed = YES;
                                [navc pushViewController:vc animated:YES];
                            }
                            completionHandler();
                            return;
                        }
                    }
                }
        }
            UINavigationController*navc = tabbar.viewControllers[tabbar.selectedIndex];
            if ([navc isKindOfClass:[UINavigationController class]]) {
                NSString *sessionID = userInfo[@"sessionID"];
                if (sessionID.length>3) {
                    if ([[[NIMSDK sharedSDK]loginManager]isLogined]) {
                        NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeP2P];
                        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                        vc.hidesBottomBarWhenPushed = YES;
                        [navc pushViewController:vc animated:YES];
                    }else{
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        NSString *account = [ud objectForKey:@"account"];
                        NSString *token = [ud objectForKey:@"token"];
                        if (account.length>0&&token.length>0) {
                            [self loginMIWithLoginAccount:account wihtToken:token];
                        }
                        NIMContactTools *tools = [NIMContactTools shareTools];
                        if (tools.contactTab) {
                            [navc pushViewController:tools.contactTab animated:YES];
                            [tools.contactTab butonCilck:tools.contactTab.contactListButton];
                        }else{
                            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
                            NSString* accid =[defa objectForKey:@"accid"];
                            NSString* token =[defa objectForKey:@"token"];
                            NSString* uid =[defa objectForKey:@"uid"];
                            NSString* mobilephone =[defa objectForKey:@"mobilephone"];
                            if (accid&&token&&uid&&mobilephone) {
                                NSDictionary *infoDic = @{
                                                          @"accid":[defa objectForKey:@"accid"],
                                                          @"token":[defa objectForKey:@"token"],
                                                          @"uid":[defa objectForKey:@"uid"],
                                                          @"mobilephone":[defa objectForKey:@"mobilephone"],
                                                          };
                                if (!tools.contactTab) {
                                    HMHContactTabViewController *conVC = [[HMHContactTabViewController alloc]init];
                                    HMHPhoneBookViewController *phoneVC = [[HMHPhoneBookViewController alloc]init];
                                    conVC.phoneVC = phoneVC;
                                    conVC.automaticallyAdjustsScrollViewInsets = NO;
                                    conVC.infoDic = infoDic;
                                    tools.contactTab = conVC;
                                }
                            }
                            tools.contactTab.hidesBottomBarWhenPushed = YES;
                            [navc pushViewController:tools.contactTab animated:YES];
                            [tools.contactTab butonCilck:tools.contactTab.contactListButton];
                        }
                    }
                }
       }
    }
    }else{//非云信推送，暂时只有极光推送
        NSLog(@"极光推送");
        NSString*jpushUrl = userInfo[@"url"];
        if (jpushUrl.length>5) {
            if ([self.window.rootViewController isKindOfClass:[MainTabBarViewController class]]) {
                MainTabBarViewController *tab = (MainTabBarViewController*)self.window.rootViewController;
                UINavigationController *homeNavi = tab.viewControllers[tab.selectedIndex];
                HMHBaseViewController *base = [homeNavi.viewControllers lastObject];
                if ([base isKindOfClass:[HMHBaseViewController class]]) {
                    [base.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:jpushUrl]]];
                }else{
                    HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
                    pvc.urlStr = jpushUrl;
                    [homeNavi pushViewController:pvc animated:YES];
                }
            }
        }
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"1234");
    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"24566");

    // Required,For systems with less than or equal to iOS6
   // [JPUSHService handleRemoteNotification:userInfo];
}


/**
 程序即将获取焦点
 @param application  单利
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
    application.applicationIconBadgeNumber  = -1;

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

/**
 程序即将进入后台
 @param application  单利
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
   // application.applicationIconBadgeNumber  = 0;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/**
 程序即将从后台回到前台
 
 @param application  单利
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
  
    
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//    //让屏幕方向与设备方向统一
//    [UIViewController attemptRotationToDeviceOrientation];
   // application.applicationIconBadgeNumber  = 0;
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}
/**
 程序即将获取焦点
 @param application  单利
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSString *count = [NSString stringWithFormat:@"%ld",application.applicationIconBadgeNumber];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (def) {
        [def setObject:count forKey:@"BageCount"];
    }

  //  application.applicationIconBadgeNumber  = -1;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/**
 程序即将推出

 @param application  单利
 */
- (void)applicationWillTerminate:(UIApplication *)application {
  //  application.applicationIconBadgeNumber  = 0;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {

    NSString * str = [NSString stringWithFormat:@"%@",url];
    if ([str containsString:@"fybanks-app://"]) {
        NSArray *urlArr = [str componentsSeparatedByString:@"="];
        NSString *webUrl ;
        if (urlArr.count>1) {
            webUrl = urlArr[1];
        }else{
            
            return YES;
        }
        if (![webUrl containsString:@"http://"]&&![webUrl containsString:@"https://"]) {
            if ([webUrl containsString:@"http//"]) {
              webUrl = [webUrl stringByReplacingOccurrencesOfString:@"http//" withString:@"http://"];
            }else if ([webUrl containsString:@"https//"]) {
               webUrl = [webUrl stringByReplacingOccurrencesOfString:@"https//" withString:@"https://"];
            }
        }
        HMHADViewController *SFViewController = [[HMHADViewController alloc]init];
        SFViewController.HMH_urlStr            = webUrl;
        UITabBarController*tabVC = (UITabBarController*)self.window.rootViewController;
        UINavigationController *navc = tabVC.viewControllers[0];
        [navc pushViewController:SFViewController animated:YES];
    }
    if (isBeecloundPay) {
        if (![BeeCloud handleOpenUrl:url]) {
            //handle其他类型的url
            NSLog(@"不是从beeClound过来的");
        }
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSNotification *notifi = [[NSNotification alloc]initWithName:@"aliPayResult" object:resultDic userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notifi];
        }];
    }
    if([[url absoluteString] rangeOfString:@"wx3edec7e4066c145c://pay"].location == 0) //你的微信开发者appid
    {
        NSString *str = [url absoluteString];
        NSArray *arr = [str componentsSeparatedByString:@"&"];
        if (arr.count>0&&[arr.lastObject isEqualToString:@"ret=0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PayResp" object:@"0"];
        }else if(arr.count>0&&[arr.lastObject isEqualToString:@"ret=-2"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PayResp" object:@"-2"];
        }else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PayResp" object:@"-1"];
            
        }
        NSLog(@"%@",[url absoluteString]);
    }
    
    return YES;
    
}

-(void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            //SendMessageToWXResp *resp1 = (SendMessageToWXResp *)resp;
            NSLog(@"分享成功");
        }else{
            NSLog(@"分享失败");
        }
    }
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;// 微信终端返回给第三方的关于支付结果的结构体
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PayResp" object:resp];

    }
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url{
    
    return  [[SPayClient sharedInstance] application:application handleOpenURL:url];
    
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    [[SPayClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return YES;
}

#pragma mark 本地通知代理方法和实现方法 ==================
-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{

}

// 本地推送  ios8.0之后 10.0之前
//程序处于前台或后台时调用  程序在前台或后台，未被杀死，点击通知栏调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *notificationInfo=notification.userInfo;
    
    [self receiveLocalNotificationWithDic:notificationInfo];
}

// 本地推送  ios10之后
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    // 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UIUserNotificationTypeBadge);
}

// 这个方法是在后台或者程序被杀死的时候，点击通知栏调用的，在前台的时候不会被调用
// 点击通知是 被调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *notificationInfo = content.userInfo;
    
    // 根据传的视频信息 做相应的处理
    NSString *taskId = notificationInfo[@"taskId"];
    if (!taskId.length) {
        [self jpushNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:^{
            
        }];
    }else{
        [self receiveLocalNotificationWithDic:notificationInfo];
    }
    
    completionHandler();
}

// 点击推送消息时 获取到视频的相关信息后 做跳转视频的操作 （8.0  和  10.0 都调用此方法）
- (void)receiveLocalNotificationWithDic:(NSDictionary *)notificationInfo{
    NSString *savePathStr = notificationInfo[@"savePath"];
    NSString *fileNameStr = notificationInfo[@"fileName"];
    NSString *fileIdStr = notificationInfo[@"fileId"];
    NSString *downloadUrlStr = notificationInfo[@"downloadUrl"];
    
    NSString *taskId = notificationInfo[@"taskId"];
    NSString *thumbImageUrl = notificationInfo[@"thumbImageUrl"];
    NSInteger fileSize = [notificationInfo[@"fileSize"] integerValue];
    NSInteger downloadedSize = [notificationInfo[@"downloadedSize"] integerValue];
    YCDownloadStatus downloadStatus = notificationInfo[@"downloadStatus"];
    NSString *saveName = notificationInfo[@"saveName"];
    NSString *compatibleKey = notificationInfo[@"compatibleKey"];
    //YCDownloadItem *item = [[YCDownloadItem alloc] initWithUrl:downloadUrlStr fileId:fileIdStr];
    YCDownloadItem *item = [[YCDownloadItem alloc] init];
    item.savePath = savePathStr;
    item.fileId = fileIdStr;
    item.fileName = fileNameStr;
    item.downloadUrl = downloadUrlStr;
    
    item.taskId = taskId;
    item.thumbImageUrl = thumbImageUrl;
    item.fileSize = fileSize;
    item.downloadedSize = downloadedSize;
    item.downloadStatus = downloadStatus;
    item.saveName = saveName;
    item.compatibleKey = compatibleKey;
    
    MainTabBarViewController *tabbar = (MainTabBarViewController*)self.window.rootViewController;
    
    NSArray *naVCArray = tabbar.viewControllers;
    for (int i=0; i<naVCArray.count; i++) {//遍历导航栈中是否有通讯录单利
        UINavigationController *navc = naVCArray[i];
        if ([navc isKindOfClass:[UINavigationController class]]) {
            for (int j=0; j<navc.viewControllers.count; j++) {
                UIViewController *vc = navc.viewControllers[j];
                if ([vc isKindOfClass:[SelVideoViewController class]]) {
                    SelVideoViewController *cvc = (SelVideoViewController*)vc;
                    cvc.playerItem = item;
                    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
                    configuration.shouldAutoPlay = YES;
                    configuration.supportedDoubleTap = YES;
                    configuration.shouldAutorotate = YES;
                    configuration.repeatPlay = NO;
                    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
                    configuration.videoGravity = SelVideoGravityResizeAspect;
                    
                    //    configuration.sourceUrl = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
                    
                    //保存路径需要转换为url路径，才能播放
                    NSURL *url = [NSURL fileURLWithPath:item.savePath];
                    configuration.sourceUrl = [NSURL URLWithString:url.absoluteString];

                    [cvc refreshVideoPlayer:configuration];
//                    [navc popToViewController:vc animated:YES];
                    return;
                }
            }
        }
    }
    
    UINavigationController*navc = tabbar.viewControllers[tabbar.selectedIndex];
    if ([navc isKindOfClass:[UINavigationController class]]) {
        SelVideoViewController *videoVC = [[SelVideoViewController alloc]init];
        videoVC.playerItem = item;
        videoVC.hidesBottomBarWhenPushed = YES;

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *backUrlStr = [ud objectForKey:@"playBackUrl"];

        NSString *playBackStr = [NSString stringWithFormat:@"%@&locationId=%@",backUrlStr,item.fileId];

        HMHPopAppointViewController *popVC = [[HMHPopAppointViewController alloc]init];
        popVC.urlStr = playBackStr;
        popVC.hidesBottomBarWhenPushed = YES;
        [navc pushViewController:popVC animated:NO];
        [navc pushViewController:videoVC animated:NO];
    }
}
-(void)ShareSDKRegister
{
    NSArray *SharePlatformArrary = @[
                                     @(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformTypeWechat),
                                     @(SSDKPlatformTypeQQ),
                                     ];
    [ShareSDK registerActivePlatforms:SharePlatformArrary
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
             SSDKPlatformTypeSinaWeibo: [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2701599598"
                                           appSecret:@"d5b5bcfabeb644ad74c3c0d71192b577"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb372eb1c4a8e393f"
                                       appSecret:@"c8550aeff667cc745c6dc3eaeae52174"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1107995805"
                                      appKey:@"r6Lt4ijVvOi5PImr"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
}
// ======================================================
//逆向地址编码
- (void)reverseGeocodeLatitude:(NSString *)latitude longitude:(NSString *)longitude { // 先给一个经纬度
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        for (CLPlacemark *place in array) {
            // NSLog(@"addressDictionary,%@",place.addressDictionary);//地址的所有信息
            // NSString *FormattedAddressLines=[place.addressDictionary objectForKey:@"FormattedAddressLines"];//地址全信息
            NSString *Country=[place.addressDictionary objectForKey:@"Country"];//国家
            NSString *State=[place.addressDictionary objectForKey:@"State"];//省。
            NSString *City=[place.addressDictionary objectForKey:@"City"];//市
            NSString *SubLocality=[place.addressDictionary objectForKey:@"SubLocality"];//区
            // NSString *Street=[place.addressDictionary objectForKey:@"Street"];//街道
            // NSString *subThoroughfare=[place.addressDictionary objectForKey:@"subThoroughfare"];//子街道
            // NSString *Name=[place.addressDictionary objectForKey:@"Name"];//小区名称
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Country"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"State"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"City"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubLocality"];
            
            [[NSUserDefaults standardUserDefaults]setObject:Country forKey:@"Country"];
            [[NSUserDefaults standardUserDefaults]setObject:State forKey:@"State"];
            [[NSUserDefaults standardUserDefaults]setObject:City forKey:@"City"];
            [[NSUserDefaults standardUserDefaults]setObject:SubLocality forKey:@"SubLocality"];
        }
    }];
    
}
#pragma mark  json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (self.isFull) {
    
        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }

}


@end
