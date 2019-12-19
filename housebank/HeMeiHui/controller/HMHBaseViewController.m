//
//  BaseViewController.m
//  HeMeiHui
//
//  Created by 任为 on 2017/10/19.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHBaseViewController.h"
#import "SaveImageToAlbumTool.h"
#import "MainMineViewController.h"
#import "IMNewsCountManager.h"
#import "NTESSessionViewController.h"
#import "LocationManager.h"
//#import "QYPedometerManager.h"
#import "SelVideoViewController.h"
#import "SGAlertView.h"
#import "HMHRedPageQRcodeView.h"
#import "ContractDataSave.h"
#import "HFDBHandler.h"
@interface HMHBaseViewController ()<YCDownloadItemDelegate,UIAlertViewDelegate> // NetStateDelegete
{
    NSInteger processStatus;
}
@property(nonatomic,copy)NSString *HMH_latitude;
@property(nonatomic,copy)NSString *HMH_longitude;
@property(nonatomic,copy)NSString *HMH_LocationCallBack;

@property (nonatomic, strong) NSMutableArray *HMH_cacheVideoList;
@property (nonatomic, strong) NSMutableArray *HMH_jsonCacheArr;

@property (nonatomic, strong) NSDictionary *HMH_downLoadFileDic;

@property (nonatomic, strong) DownLoadAlertView *HMH_downLoadAlertView;

//@property (nonatomic, strong) NetStatTool *netTool;
//@property (nonatomic, strong) Reachability *reach;


@end

@implementation HMHBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewContifgArrary = @[@"jsCallOC",@"backToPath",@"openVideo",@"appShare",
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
                                          @"pauseDownloadTask",@"pedometerData",@"openExternalMap",@"openVideoHomeWindow",@"createQr"];
    
    self.HMH_cacheVideoList = [[NSMutableArray alloc] initWithCapacity:1];
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
    }
    
//    [self AccessToAlbum];
    
   // [self creatStatusBar];
    self.statusHeghit = 20;
    self.buttomBarHeghit = 0;
    if (IS_iPhoneX) {
        self.statusHeghit = 44;
        self.buttomBarHeghit = 34;
    }
        
    // 防止白屏的加载动画
    self.customHUD = [[HMHCustomHUDView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    __weak typeof(self) weakSelf = self;
    self.customHUD.hubBtnClick = ^{
        if (self.navigationController.viewControllers.count>1) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            return ;
        }
    };
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWeb:) name:@"refreshSelf" object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshself:) name:@"refreshSelfUrl" object:nil];

    // 下载时  监听网络变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChanged:) name:@"networkChangedWWANorNotRechable" object:nil];
    
  //[self initializeLocationService];
}

- (void)refreshWeb:(NSNotification*)Noti{
    NSArray *postUrlArrary =   Noti.object;
    if ([postUrlArrary isKindOfClass:[NSArray class]]&&postUrlArrary.count) {
        if ([postUrlArrary containsObject:self.pageTag]) {
              self.shouldRefresh = YES;
              [_webView reload];
        }
    }
}
- (void)refreshself:(NSNotification*)Noti{
    
    NSString*NotifiStr = Noti.object;
    if ([NotifiStr isEqualToString:self.urlStr]) {
        self.shouldRefresh = YES;
        [self.webView reload];
    }
}

// 暂未调用
- (void)creatStatusBar{
    UIView *blackView  = [[UIView alloc]init];
    [self.view addSubview:blackView];
    self.statusHeghit = 44;
    self.buttomBarHeghit = 34;
    if (IS_iPhoneX) {
        self.statusHeghit = 44;
        self.buttomBarHeghit = 34;
    }
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);//使左边等于self.view的左边，间距为0
        make.top.equalTo(self.view.mas_top).offset(0);//使顶部与self.view的间距为0
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(self.statusHeghit));//设置高度为self.view高度的一半
    }];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)changeRotate:(NSNotification*)noti {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
//        CGSize size = [UIScreen mainScreen].bounds.size;
//         self.webView.frame = CGRectMake(0, self.statusHeghit, size.width, size.height-self.statusHeghit-self.buttomBarHeghit);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self loadViewIfNeeded];
        NSLog(@"竖屏");
    } else {
        //横屏
        NSLog(@"横屏");
//        CGSize size = [UIScreen mainScreen].bounds.size;
//        self.webView.frame = CGRectMake(0, self.statusHeghit, size.width, size.height-self.statusHeghit-self.buttomBarHeghit);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self loadViewIfNeeded];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
//    [self setStatusBarBackgroundColor:[UIColor blackColor]];
//    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGSize size = [UIScreen mainScreen].bounds.size;
   //  导航栏高度：横屏52 竖屏64
    CGFloat navbarH = size.width > size.height ? 44 : 44;
//    self.navigationController.navigationBar.frame = CGRectMake(0, 20, size.width, navbarH);
    self.navigationController.navigationBar.frame = CGRectMake(0, self.statusHeghit, size.width, navbarH);
    NSLog(@"%@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
}
-(BOOL)shouldAutorotater
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)downloadImage:(id)body{
    NSDictionary *dic = body;
    if (![dic isKindOfClass:[NSDictionary class]]) {
        
        return;
    }

    // 1. 获取当前App的相册授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    // 2. 判断授权状态
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        // 2.1 如果已经授权, 保存图片(调用步骤2的方法)
        if([dic[@"type"] isEqualToString:@"contract"]){
            if ([dic[@"url"] isKindOfClass:[NSArray class]]) {
                [self moreImagedown:dic[@"url"]];
            }
        }else{
            [self imagedown:dic[@"url"]];
        }

    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 在主线程中添做其他处理 防止弹出授权之后 没有弹出下载框
            dispatch_async(dispatch_get_main_queue(), ^{
                // 如果用户选择授权 则下载
                if (status == PHAuthorizationStatusAuthorized) {
                    if([dic[@"type"] isEqualToString:@"contract"]){
                        if ([dic[@"url"] isKindOfClass:[NSArray class]]) {
                            [self moreImagedown:dic[@"url"]];
                        }
                    }else{
                        [self imagedown:dic[@"url"]];
                    }
                }
            });
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请在设置界面, 授权访问相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

//        [SVProgressHUD showWithStatus:@"请在设置界面, 授权访问相册"];
    }
}

-(void)imagedown:(NSArray*) imageUrlArrary{
    if ([imageUrlArrary isKindOfClass:[NSArray class]]) {
        for (int i=0; i<imageUrlArrary.count; i++) {
            NSString * ImageUrl = imageUrlArrary[i];
            [SaveImageToAlbumTool svaeImageToassetCollectionName:@"合发" formUrl:ImageUrl];
        }
    }
}

-(void)moreImagedown:(NSArray*) imageUrlArrary{
    // 下载之前 清plist文件
    [ContractDataSave cleanAllContract];

    _HMH_downLoadAlertView = [[DownLoadAlertView alloc] initWithImageName:@"" title:@"" describeStr:@"" isLoading:YES];
    [_HMH_downLoadAlertView show];

    [SaveImageToAlbumTool downloadImages:_HMH_downLoadAlertView imageArr:imageUrlArrary completion:^(NSArray *resultArray, NSError * _Nullable error) {
        [_HMH_downLoadAlertView removeFromSuperview];
        if (error) {
            _HMH_downLoadAlertView = [[DownLoadAlertView alloc] initWithImageName:@"downLoadImageFail" title:@"下载失败" describeStr:@"(敬请谅解请稍后重试)" isLoading:NO];
            [_HMH_downLoadAlertView show];
        } else {
            _HMH_downLoadAlertView = [[DownLoadAlertView alloc] initWithImageName:@"downLoadImageSuccess" title:@"下载成功" describeStr:@"(请查看手机相册)" isLoading:NO];
            [_HMH_downLoadAlertView show];
           
            // 在主线程中添做其他处理 防止图片丢失 保存不全
            dispatch_async(dispatch_get_main_queue(), ^{
                for (int i = 0; i < resultArray.count; i++) {
                    [SaveImageToAlbumTool saveImage:resultArray[i] assetCollectionName:@"合发" isMoreImages:YES];
                }
            });
        }
    }];
}

- (void)backPressed:(id)body{
//     if ([self.webView canGoBack]) {
//        [self.webView goBack];
//        return;
//    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isSelectMine"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshSelf" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshSelfUrl" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"networkChangedWWANorNotRechable" object:nil];
    if (self.progressView) {
        self.progressView.hidden = YES;
    }
}

/**
 调用JS存参数

 @param key 要存的key
 @param value 要存的value
 */
- (void)putIntoStorageWith:(NSString*)key and:(NSString*)value callBack:(NSString*)callback{
    
        NSString *jsonStr = [NSString stringWithFormat:@"%@('%@','%@')",callback,key,value];
        [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (!error) {//成功
                NSLog(@"保存success:%@",[self class]);
            }else{//失败
                NSLog(@"保存failed:%@",[self class]);
            }
        }];
}

/**
 js回调存储信息

 @param body js传参
 */
-(void)putIntoStorage:(id)body{
    
    NSDictionary *dic = body;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *callback = dic[@"callback"];
        NSString *key = dic[@"key"];
        NSString *val = dic[@"val"];
        UITabBarController * tab = self.navigationController.tabBarController;
        if ([tab isKindOfClass:[UITabBarController class]]) {
            NSArray *viewControllers = tab.viewControllers;
            for (int i=0; i<viewControllers.count; i++) {
                UINavigationController *navc = viewControllers[i];
                if ([navc isKindOfClass:[UINavigationController class]]) {
                    NSArray *naVCArrary = navc.viewControllers;
                    for (int j=0; j<naVCArrary.count; j++) {
                        HMHBaseViewController *baseVC = naVCArrary[j];
                        if ([baseVC isKindOfClass:[HMHBaseViewController class]]) {
                                if ([baseVC isKindOfClass:[HMHBaseViewController class]]) {
                                    [baseVC putIntoStorageWith:key and:val callBack:callback];
                                    if ([baseVC isKindOfClass:[MainMineViewController class]]) {
                                     //  [baseVC.webView reload];
                                    }
                                }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
}
/**
 js回调删除存储信息
 @param body js传参
 */
- (void)removeFromStorage:(id)body{
    NSDictionary *dic = body;



    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *callback = dic[@"callback"];
        NSString *key = dic[@"key"];
        NSString *jsonStr = [NSString stringWithFormat:@"%@('%@')",callback,key];        
        UITabBarController * tab = self.navigationController.tabBarController;
        if ([tab isKindOfClass:[UITabBarController class]]) {
            NSArray *viewControllers = tab.viewControllers;
            for (int i=0; i<viewControllers.count; i++) {
                UINavigationController *navc = viewControllers[i];
                if ([navc isKindOfClass:[UINavigationController class]]) {
                    NSArray *naVCArrary = navc.viewControllers;
                    
                    for (int j=0; j<naVCArrary.count; j++) {
                        HMHBaseViewController *baseVC = naVCArrary[j];
                        if ([baseVC isKindOfClass:[HMHBaseViewController class]]) {
                            if ([baseVC isKindOfClass:[HMHBaseViewController class]]) {
                                [baseVC.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                                    if (!error) {//成功
                                        
                                          NSLog(@"删除success:%@",[self class]);
                                    }else{//失败
                                        
                                          NSLog(@"删除failed:%@",[self class]);
                                    }
                                }];
                                
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
}


/**
 js调用，获取位置信息的方法
 @param body js返回的参数：回调的方法名
 */
- (void)getLocation:(id)body{
    NSString *callback = body;
    __weak typeof(self) weakSelf = self;
    if ([callback isKindOfClass:[NSString class]]) {
        if (callback) {
            self.HMH_LocationCallBack = callback;
            LocationManager *locationManager = [LocationManager shareTools];
            [locationManager initializeLocationService];
            [locationManager getlocationInfo:^(NSString *locationStr) {
                NSLog(@"%@",locationStr);
//                NSDictionary *dic ;
//            NSString *str=    [dic JSONString];
                NSString *jsonStr = [NSString stringWithFormat:@"%@('%@')",self.HMH_LocationCallBack,locationStr];
                [weakSelf.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    if (!error) {//成功
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
// var params = {qrType:"QR_TYPE_MY", title:"爱心红包_100",data: {avatar:"https://wwww.XXX.com/aa.jpg", url:location.href}};
- (void)createQr:(id)body{
    NSDictionary *callback = body;
    if ([callback isKindOfClass:[NSDictionary class]]) {
        NSString *nameStr = callback[@"title"];
        
        NSDictionary *dataDic = callback[@"data"];
        NSString *imageUrl = dataDic[@"url"]; // 用此生成二维码
        HMHRedPageQRcodeView *qrView = [[HMHRedPageQRcodeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) topName:nameStr QRCodeUrl:imageUrl bottomStr:@"下载二维码"];
        [qrView show];
    }
}

#pragma ****************************推送消息相关***********************

/**
 js获取IM消息和推送总数

 @param body 回调的callBack
 */
- (void)getBadgeCount:(id)body{
    NSString *callback = body;
    if ([callback isKindOfClass:[NSString class]]) {
       // NSString *mchId = dic[@"mchId"];
        IMNewsCountManager *manager =  [IMNewsCountManager shareIMNewsCountManager];
        NSInteger count =  [manager getBadgeCount];
        NSString *countStr = [NSString stringWithFormat:@"%ld",count];
        NSString *jsonStr = [NSString stringWithFormat:@"%@('%@')",callback,countStr];
        [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (!error) {//成功
                NSLog(@"success");
            }else{//失败
                
                NSLog(@"faild");

            }
        }];
    }
}

/**
 js获取IM消息(指定ID)
 
 @param body 回调的callBack 和 MchId
 */
- (void)getImBadgeCountByMchId:(id)body{
    NSDictionary *dic = body;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *callback = dic[@"callback"];
         NSString *mchId = dic[@"mchId"];
        IMNewsCountManager *manager =  [IMNewsCountManager shareIMNewsCountManager];
        NSInteger count =  [manager getImBadgeCountByMchId:mchId];
        NSString *countStr = [NSString stringWithFormat:@"%ld",count];
        NSString *jsonStr = [NSString stringWithFormat:@"%@('%@')",callback,countStr];
        [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (!error) {//成功
                NSLog(@"success");
            }else{//失败
                
                NSLog(@"faild");
                
            }
        }];
    }
}
/**
 js移除IM消息(指定ID)
 
 @param body 回调的callBack 和 MchId
 */
- (void)removeImBadgeByMchId:(id)body{
    NSDictionary *dic = body;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *callback = dic[@"callback"];
        NSString *mchId = dic[@"mchId"];
        IMNewsCountManager *manager =  [IMNewsCountManager shareIMNewsCountManager];
        [manager removeImBadgeByMchId:mchId];
        NSString *jsonStr = [NSString stringWithFormat:@"%@()",callback];
        [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (!error) {//成功
                NSLog(@"success");
            }else{//失败
                
                NSLog(@"faild");
                
            }
        }];
    }
}
 /**
 js移除推送消息
 
 @param body 回调的callBack
 */
- (void)removeNotifictionBadge:(id)body{
    IMNewsCountManager *manager =  [IMNewsCountManager shareIMNewsCountManager];
    [manager removeNotifictionBadge];
    NSString *callback = body;
    if ([callback isKindOfClass:[NSString class]]) {
        NSString *jsonStr = [NSString stringWithFormat:@"%@()",callback];
        [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (!error) {//成功
                NSLog(@"success");
            }else{//失败
                NSLog(@"faild");
            }
        }];
    }
 }
- (void)openImMsgWindow:(id)body{
    NSString *accid = body;
    if ([accid isKindOfClass:[NSString class]]) {
        if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[NTESSessionViewController class]]) {
            return;
        }
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *account = [ud objectForKey:@"account"];
        NSString *token = [ud objectForKey:@"token"];
        if (![[[NIMSDK sharedSDK]loginManager]isLogined]&&account.length&&token.length) {
            [[[NIMSDK sharedSDK]loginManager]login:account token:token completion:^(NSError * _Nullable error) {
                
            }];
        }else{
        NIMSession *session = [NIMSession session:body type:NIMSessionTypeP2P];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)changeEnv:(id)body{
    
    if ([body isKindOfClass:[NSString class]]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:body forKey:@"appMainEntrance"];
    }
}

- (void)pedometerData:(id)body{
   
}
#pragma mark ***********调用第三方地图***********
- (void)openExternalMap:(id)body{
    
    NSDictionary*dic = body;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString* lat = [(NSNumber*)dic[@"lat"] stringValue];
        NSString* lng = [(NSNumber*)dic[@"lng"] stringValue];
        NSArray *endLocationArrar = @[lat,lng];

        NSString* gd_lat = [(NSNumber*)dic[@"gd_lat"] stringValue];
        NSString* gd_lng = [(NSNumber*)dic[@"gd_lng"] stringValue];
        NSArray*GDEndLocationArrary = @[gd_lat,gd_lng];
        
        NSString *houseName = dic[@"destination"];

        
        [self doNavigationWithEndLocation:endLocationArrar andGDEndLocationArrary:GDEndLocationArrary andTargetName:houseName];
    }
    
}
//导航只需要目的地经纬度，endLocation为纬度、经度的数组
-(void)doNavigationWithEndLocation:(NSArray *)endLocation andGDEndLocationArrary:(NSArray*)GDEndLocationArrary andTargetName:(NSString*)houseName
{
    
    //NSArray * endLocation = [NSArray arrayWithObjects:@"26.08",@"119.28", nil];
    
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        if (endLocation.count<=1) {
            return;
        }
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name:%@&mode=driving&coord_type=gcj02",GDEndLocationArrary[0],GDEndLocationArrary[1],houseName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString * urlString= [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=&slon=&sname=%@&did=BGVIS2&dlat=%@&dlon=%@&dname=%@&dev=0&m=0&t=0",@"我的位置",GDEndLocationArrary[0],GDEndLocationArrary[1],houseName]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=%@&coord_type=1&policy=0",endLocation[0], endLocation[1],houseName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = maps.count;
    
    for (int i = 0; i < index; i++) {
        
        NSString * title = maps[i][@"title"];
        
        //苹果原生地图方法
        if (i == 0) {
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMap:GDEndLocationArrary and:houseName];
            }];
            [alert addAction:action];
            
            continue;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *urlString = maps[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        
        [alert addAction:action];
        
    }
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
       
    }];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
//苹果地图
- (void)navAppleMap:(NSArray*)GDendLocation and:(NSString*)name
{
    //    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:self.destinationCoordinate2D];
    
    //终点坐标
    double lat = [GDendLocation[0] doubleValue];
    double lng = [GDendLocation[1] doubleValue];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lng);
    
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    toLocation.name = name;
    
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    //第二个，都可以用
    //    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
}

- (void)showMBProgressHUD
{
    if (self.customHUD.superview) {
        [self.customHUD removeFromSuperview];
    }
    [self.view addSubview:self.customHUD];
    [self.customHUD bringSubviewToFront:self.view];
    [self.customHUD sendSubviewToBack:self.view];
    
    [self.customHUD showMBProgressHUD];
}
- (void)hideMBProgressHUD
{
    [self.customHUD hideMBProgressHUD];

    if (self.customHUD.superview) {
        [self.customHUD removeFromSuperview];
    }
}
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
          //  [[UIApplication sharedApplication] openURL:url];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - - - 从相册中读取照片
- (void)AccessToAlbum {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
//                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
//                        imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
//                        [self presentViewController:imagePicker animated:YES completion:^{
//                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//                        }]; // 显示相册
//                        NSLog(@"主线程 - - %@", [NSThread currentThread]);
//                    });
//                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
//
//                    // 用户第一次同意了访问相册权限
//                    NSLog(@"用户第一次同意了访问相册权限");
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相册");
                }
            }];
            
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
//            imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
//            [self presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
            
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"请去-> [设置 - 隐私 - 照片 - 合发] 打开访问开关" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
            [alertView show];
            
        } else if (status == PHAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
        
    } else {
        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"未检测到您的摄像头, 请在真机上测试" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alertView show];
    }
}

- (void)showProgress{
//    [SVProgressHUD showWithStatus:@"加载中....."];
}
-  (void)dissMissProgress{
    
//    [SVProgressHUD dismiss];
}

@end

