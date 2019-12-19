//
//  HFCarRequest.m
//  HeMeiHui
//
//  Created by usermac on 2019/2/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCarRequest.h"
#import "GSKeyChainDataManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "RememberVCInstance.h"
@implementation HFCarRequest {
    NSString *_sid;
    NSString *_terminal;
    NSDictionary *_parmes;
    NSString *_url;
    YTKRequestMethod _requestType;
    YTKRequestSerializerType _requestSerializerType;
    NSDictionary *_headerparams;
}
- (NSString *)requestUrl {
    return _url;
}
- (YTKRequestMethod)requestMethod {
    return _requestType;
}
- (NSTimeInterval)requestTimeoutInterval
{
    return 30.f;
}
- (YTKRequestSerializerType)requestSerializerType
{
    return _requestSerializerType;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}
- (id)initWithUsername:(NSString *)sid terminal:(NSString *)terminal {
    self = [super init];
    if (self) {
        _sid = sid;
        _terminal = terminal;
    }
    return self;
}
- (id)initWithDict:(NSDictionary *)prames withRequstUrl:(NSString*)requestUrl{
    self = [super init];
    if (self) {
        _parmes = prames;
        _url = requestUrl;//;
    }
    return self;
}
- (id)requestArgument {
    return _parmes;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    self.referer=@"";
    self.urlTitle=@"";
    NSString *packageName = [VersionTools appBoundleID];
    NSString *versionName = [VersionTools appVersion];
    NSString *versionCode = [versionName stringByReplacingOccurrencesOfString:@"." withString:@""];
    //    系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    分辨率
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenX = screenSize.width * scale;
    CGFloat screenY = screenSize.height * scale;
    NSString *resolutionRatio=[NSString stringWithFormat:@"%f*%f",screenX,screenY];
    //    网络类型
    NSString *networkType=[self internetStatus];
    //启动 异常。正常
    NSString * lifecycle=@"6";
    [[NSUserDefaults standardUserDefaults]objectForKey:@"startUp"];
    [[NSUserDefaults standardUserDefaults]objectForKey:@"NSException"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"NSException"]) {
        lifecycle=@"2";
    }else
    {
        if ( [[NSUserDefaults standardUserDefaults]objectForKey:@"startUp"]) {
            lifecycle=@"1";
        }else
        {
            lifecycle=@"6";
        }
    }
    //    国家省市区
    NSString *Country=@"";NSString *State=@"";NSString *City=@"";NSString *SubLocality=@"";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Country"]) {
        Country=[[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"State"]) {
        State=[[NSUserDefaults standardUserDefaults] objectForKey:@"State"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"City"]) {
        City=[[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SubLocality"]) {
        SubLocality=[[NSUserDefaults standardUserDefaults] objectForKey:@"SubLocality"];
    }
    //    捕获当前页面
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * topviewNow=nil;
        UIViewController * viewNow = [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        UIViewController * instanceVC=[RememberVCInstance sharedInstance].goOutVC;
        if ([RememberVCInstance sharedInstance].count>viewNow.navigationController.viewControllers.count) {
            //        出栈
            topviewNow=instanceVC;
        }else
        {
            //        入栈
            if (viewNow.navigationController.viewControllers.count>=2) {
                topviewNow=[viewNow.navigationController.viewControllers objectAtIndex:viewNow.navigationController.viewControllers.count-2];
            }
        }
        [RememberVCInstance sharedInstance].goOutVC=viewNow;
        [RememberVCInstance sharedInstance].count=viewNow.navigationController.viewControllers.count;
        [self setRefererAndUrlTitle:topviewNow urlTitle:viewNow];
    });

    //    SpMainHomeViewController首页
    //    NSDictionary *StatisticsDic
    _headerparams=@{
                    @"type":@"3",////类型，数据采集类型，页面数据(h5)，埋点数据，app数据 App:3
                    @"deviceId":[GSKeyChainDataManager readUUID],//设备号，App必传
                    @"channel":@"1",////渠道，从app/微信/qq打开应用 App：1
                    @"sid":[HFCarShoppingRequest sid],//(如已登录必传)
                    @"cookid":[GSKeyChainDataManager readUUID],//用户唯一标识(如果是app，传deviceId，如果是h5，传cookieid)
                    @"url":[NSString stringWithFormat:@"%@%@",CurrentEnvironment,_url],//如不是埋点,则必传???????????
                    @"urlType":@"2",//ajax接口1，页面跳转2
                    @"referer":[self.referer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//如果是页面跳转，则必传????
                    @"urlTitle":[self.urlTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//功能汉字说明
                    @"terminal":@"1",//IOS:1/ Android:2
                    @"terminalVer":phoneVersion,//IOS1/android终端版本号(1.1.1/1.0.0)
                    @"appVer":versionName,//合美惠app版本，app必传
                    @"terminalBrand":[@"苹果" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//品牌(苹果/vivo/oppo)
                    @"terminalResolutionRatio":resolutionRatio,//分辨率
                    @"country":[Country stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//国家定位???
                    @"province":[State stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//省定位???
                    @"city": [City stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//市定位???
                    @"area":[SubLocality stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//区定位????
                    @"networkType":networkType,//联网方式2G=1 3G=2,4G=3,wifi=4???
                    @"lifecycle":lifecycle,//App必传,App所处理的阶段。启动1，异常2，暂停3，恢复4，退出5,运行6???
                    @"userAgent":@"",//H5必传,App原生/h5调用
                    @"packageName":packageName,
                    @"versionName":versionName,
                    @"platformName":@"ios",
                    @"versionCode":versionCode
                    };
    
    return _headerparams;
}
+ (NSDictionary*)sid {
 
    NSString *sid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"];

    return  @{@"sid": (sid.length == 0 ? @"":sid)} ;
}
+ (NSString *)terminal {
    return @"P_TERMINAL_MOBILE" ;
}
+  (instancetype)requsetUrl:(NSString*)requestURL withRequstType:(YTKRequestMethod)requestType requestSerializerType:(YTKRequestSerializerType)requestSerializerType  params:(NSDictionary*)params success:(YTKRequestCompletionBlock)success error:(YTKRequestCompletionBlock)failure {
    return [[self alloc] initWithRequestURL:requestURL withRequstType:requestType requestSerializerType:requestSerializerType params:params success:success error:failure];
}
- (instancetype)initWithRequestURL:(NSString*)requestURL  withRequstType:(YTKRequestMethod)requestType requestSerializerType:(YTKRequestSerializerType)requestSerializerType  params:(NSDictionary*)params success:(YTKRequestCompletionBlock)success error:(YTKRequestCompletionBlock)failure{
    if (self = [super init]) {
        NSMutableDictionary *mutableParames = [[NSMutableDictionary alloc] initWithDictionary:params];
        if (_requestType == YTKRequestMethodGET) {
            //        [mutableParames setObject:[HFCarShoppingRequest sid] forKey:@"sid"];
            //[mutableParames setObject:@"P_TERMINAL_MOBILE" forKey:@"terminal"];
        }
        
        _parmes = mutableParames;
        _requestType = requestType;
        _requestSerializerType = requestSerializerType;
        _url = [NSString stringWithFormat:@"%@",requestURL];
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"成功");
            success(request);
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"失败");
             if (!request.cancelled) {
                 failure(request);
             }
            
        }];
        
    }
    return  self;
}
+ (void)updateClickNumber:(NSString*)adID {
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./Advertising/updateClickNumber"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:@{@"id":adID} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (RACSignal *)rac_requestSignal
{
    [self stop];
    @weakify(self);
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 请求起飞
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [subscriber sendNext:[request responseJSONObject]];
            [subscriber sendCompleted];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [subscriber sendError:[request error]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            if (!self.isCancelled) {
                [self stop];
            }
        }];
    }] takeUntil:[self rac_willDeallocSignal]];
    
    //设置名称 便于调试
    return signal;
}
//字典转换为json
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//获取网络状态
-(NSString *)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"";
    switch (internetStatus) {
        case ReachableViaWiFi:// @"WIFI"
            net = @"4";
            break;
            
        case ReachableViaWWAN:
            net = [self getNetType ];   //判断具体类型
            break;
            
        case NotReachable:
            net = @"0";
            
        default:
            break;
    }
    
    return net;
}
- (NSString *)getNetType
{
    NSString *netconnType=@"";
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        netconnType = @"1";//@"2G"
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        netconnType = @"2";//@"3G"
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        netconnType = @"3";//@"4G"
    }
    return netconnType;
}
//捕获页面
-(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController

{
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        
        return [self topViewControllerWithRootViewController: presentedViewController];
        
    } else {
        
        return rootViewController;
        
    }
    
}
+ (void)navtiveSwitch {
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./page/controlAppPageShow"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
            if ([[[request.responseObject valueForKey:@"data"] valueForKey:@"result"] isEqualToString:@"0"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:nativeSwitch];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:nativeSwitch];
            }
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:nativeSwitch];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
  
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:nativeSwitch];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}
//设置页面值
-(void)setRefererAndUrlTitle:(UIViewController *)referer urlTitle:(UIViewController *)urlTitle
{
    if ([urlTitle isKindOfClass:[SpMainHomeViewController class]]) {
        self.urlTitle=@"首页";
    }
    if ([urlTitle isKindOfClass:[SpAssembleViewController class]]) {
        self.urlTitle=@"拼团列表";
    }
    if ([urlTitle isKindOfClass:[AssembleGoodDetailViewController class]]) {
        self.urlTitle=@"拼团详情";
    }
    if ([urlTitle isKindOfClass:[SpSpikeViewController class]]) {
        self.urlTitle=@"秒杀列表";
    }
    if ([urlTitle isKindOfClass:[SpGoodsDetailViewController class]]) {
        self.urlTitle=@"商品详情";
    }
    if ([urlTitle isKindOfClass:[ShopListViewController class]]) {
        self.urlTitle=@"商铺列表";
    }
    if ([urlTitle isKindOfClass:[SpCartViewController class]]) {
        self.urlTitle=@"购物车列表";
    }
    if ([urlTitle isKindOfClass:[HFPayMentViewController class]]) {
        self.urlTitle=@"填写订单页";
    }
    if ([urlTitle isKindOfClass:[SpTypesSearchListViewController class]]) {
        self.urlTitle=@"搜索列表";
    }
    if ([urlTitle isKindOfClass:[SpTypesViewController class]]) {
        self.urlTitle=@"分类列表";
    }
    if ([urlTitle isKindOfClass:[AssembleSearchListViewController class]]) {
        self.urlTitle=@"拼团搜索列表";
    }
    if ([urlTitle isKindOfClass:[HFEveryDayViewController class]]) {
        self.urlTitle=@"每日上新列表";
    }
    if ([urlTitle isKindOfClass:[ZJCityViewControllerOne class]]) {
        self.urlTitle=@"发货地址页";
    }
    if ([urlTitle isKindOfClass:[HMHVideosListViewController class]]) {
        self.urlTitle=@"直播列表";
    }
    if ([urlTitle isKindOfClass:[HFHightEndGoodsViewController class]]) {
        self.urlTitle=@"直供精品列表";
    }
    if ([urlTitle isKindOfClass:[HFCrazyGoodsViewController class]]) {
        self.urlTitle=@"9.9疯抢列表";
    }
    if ([urlTitle isKindOfClass:[HFFamousGoodsViewController class]]) {
        self.urlTitle=@"名品折扣列表";
    }
    
    
    
    if ([referer isKindOfClass:[SpMainHomeViewController class]]) {
        self.referer=@"首页";
    }
    if ([referer isKindOfClass:[SpAssembleViewController class]]) {
        self.referer=@"拼团列表";
    }
    if ([referer isKindOfClass:[AssembleGoodDetailViewController class]]) {
        self.referer=@"拼团详情";
    }
    if ([referer isKindOfClass:[SpSpikeViewController class]]) {
        self.referer=@"秒杀列表";
    }
    if ([referer isKindOfClass:[SpGoodsDetailViewController class]]) {
        self.referer=@"商品详情";
    }
    if ([referer isKindOfClass:[ShopListViewController class]]) {
        self.referer=@"商铺列表";
    }
    if ([referer isKindOfClass:[SpCartViewController class]]) {
        self.referer=@"购物车列表";
    }
    if ([referer isKindOfClass:[HFPayMentViewController class]]) {
        self.referer=@"填写订单页";
    }
    if ([referer isKindOfClass:[SpTypesSearchListViewController class]]) {
        self.referer=@"搜索列表";
    }
    if ([referer isKindOfClass:[SpTypesViewController class]]) {
        self.referer=@"分类列表";
    }
    if ([referer isKindOfClass:[AssembleSearchListViewController class]]) {
        self.referer=@"拼团搜索列表";
    }
    if ([referer isKindOfClass:[HFEveryDayViewController class]]) {
        self.referer=@"每日上新列表";
    }
    if ([referer isKindOfClass:[ZJCityViewControllerOne class]]) {
        self.referer=@"发货地址页";
    }
    if ([referer isKindOfClass:[HMHVideosListViewController class]]) {
        self.referer=@"直播列表";
    }
    if ([referer isKindOfClass:[HFHightEndGoodsViewController class]]) {
        self.referer=@"直供精品列表";
    }
    if ([referer isKindOfClass:[HFCrazyGoodsViewController class]]) {
        self.referer=@"9.9疯抢列表";
    }
    if ([referer isKindOfClass:[HFFamousGoodsViewController class]]) {
        self.referer=@"名品折扣列表";
    }
    
}
@end

