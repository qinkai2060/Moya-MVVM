//
//  ManagerTools.m
//  HeMeiHui
//
//  Created by 任为 on 2016/10/8.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "ManagerTools.h"


#define kAppleUrlTocheckWifi @"http://captive.apple.com"

@implementation ManagerTools

+ (id)ManagerTools {
    
    static ManagerTools *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
+ (NSString*)imageURL:(NSString*)urlStr sizeSignStr:(NSString*)signStr{
    ManagerTools *manageTools =  [ManagerTools ManagerTools];
    return  [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,urlStr,signStr];
}
- (BOOL)isHasNetWork{
    
    NSString *urlString = @"https://www.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (response) {
        return YES;
    }
    return NO;
}
- (void)judgeAPPVersion
{
    
    if (_imageViewNotFound) {
        [_imageViewNotFound removeFromSuperview];
        _imageViewNotFound = nil;
    }
    if (self.HMH_noContentView.superview) {
        [self.HMH_noContentView removeFromSuperview];
        self.HMH_noContentView = nil;
    }

    if (![self isHasNetWork]) {
      //  [self performSelector:@selector(faileWithNetWorkConnectivity) withObject:nil afterDelay:1 ];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *appMainEntrance = [[NSUserDefaults standardUserDefaults]objectForKey:@"appMainEntrance"];
    NSString*appStandbyEntrance = [[NSUserDefaults standardUserDefaults]objectForKey:@"appStandbyEntrance"];
    NSString *url;
    if (appMainEntrance) {
        //走主
         NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/getIndexUrl"];
        url = [NSString stringWithFormat:@"%@%@",appMainEntrance,utrl];
        
    }else if(appStandbyEntrance){//走备份
       NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/getIndexUrl"];
       url = [NSString stringWithFormat:@"%@%@",appStandbyEntrance,utrl];
    
    }else{//走本地写死
     //   NSString *LIUrl =@"http://192.168.0.135:10200";//  祥达本地
        
//        NSString *xuUrl = @"http://192.168.0.77:10200";
        NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/getIndexUrl"];
        url = utrl; //[NSString stringWithFormat:@"%@/index/getIndexUrl",CurrentEnvironment];
         
    }
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/getIndexUrl"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[VersionTools InfoDic] success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf processingData:request.responseObject];
       // CurrentEnvironment = [[url componentsSeparatedByString:@"/index"]firstObject];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (appMainEntrance) {//主存在
            
            [weakSelf appStandbyEntrance];
            
        }else if(appStandbyEntrance&&!appMainEntrance){//主不存在，备份存在
            
            [weakSelf appStandbyEntrance];
            
        }else{//主、备份都不存在
            
            [weakSelf appLocalEntrance];
            
        }
    }];
}
- (void)postCrashInfo:(NSString *)info{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:dataPath];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData                                                        options:NSJSONReadingMutableContainers
                                                        error:&err];
    
    NSString *deviceIdStr = [NSString stringWithFormat:@"%@",dic[@"deviceId"]];
    if (deviceIdStr.length > 0) { // 在有设备号的时候才发送请求
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./log/client/app"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:dataPath];
            if (bRet) {
                NSError *err;
                [fileMgr removeItemAtPath:dataPath error:&err];
            }
        } error:^(__kindof YTKBaseRequest * _Nonnull request) {
  
        }];
    }
}
- (void)appMainEntrance{
    __weak typeof(self) weakSelf = self;
    NSString *getVerionUrl  = [[NSUserDefaults standardUserDefaults]objectForKey:@"appMainEntrance"];
    if (!getVerionUrl) {
        [self appStandbyEntrance];
        return;
    }

    [HFCarRequest requsetUrl:getVerionUrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[VersionTools InfoDic] success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf processingData:request.responseObject];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf appStandbyEntrance];
    }];

}
- (void)appStandbyEntrance{

    __weak typeof(self) weakSelf = self;
    NSString *getVerionUrl  = [[NSUserDefaults standardUserDefaults]objectForKey:@"appStandbyEntrance"];
    if (!getVerionUrl) {
        [self appLocalEntrance];
        return;
    }
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/getIndexUrl"];
   NSString * url = [NSString stringWithFormat:@"%@%@",getVerionUrl,utrl];

    [HFCarRequest requsetUrl:url withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[VersionTools InfoDic] success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf processingData:request.responseObject];
        CurrentEnvironment = [[url componentsSeparatedByString:@"/"]firstObject];
    
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf appStandbyEntrance];
    }];
}
- (void)appLocalEntrance{

    __weak typeof(self) weakSelf = self;
  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/getIndexUrl"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[VersionTools InfoDic] success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf processingData:request.responseObject];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf appStandbyEntrance];
    }];

}

+ (void)postData:(NSDictionary*)dic toUrl:(NSString*)Url{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; 
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"application/x-javascript", nil];
    manager.requestSerializer.timeoutInterval = 3.f;
    NSString *UrlStr = [NSString stringWithFormat:@"%@",Url];
    
    [manager POST:UrlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        
    }];
}
+ (void)postDataWithUrlStr:(NSString *)urlStr parametersDic:(NSDictionary *)reqestDic isJsonReqeust:(BOOL)isJsonRequest{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (isJsonRequest) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"application/x-javascript", nil];
    manager.requestSerializer.timeoutInterval = 3.f;
    NSString *UrlStr = [NSString stringWithFormat:@"%@",urlStr];
    
    [manager POST:UrlStr parameters:reqestDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}

- (void)processingData:(id)responseObject{
    
    self.appInfoModel = [[AppInfoModel alloc]init];
    NSDictionary *resDic = responseObject;
    if ([resDic isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = resDic[@"data"];
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            self.isSigned = [dataDic[@"isSigned"] boolValue];
            NSArray*guidArry =dataDic[@"guide"];
            
            //保存广告
            NSDictionary *iosVersionDic = dataDic[@"iosVersionInfo"];
            NSString*appMainEntrance;
        if (dataDic[@"appMainEntrance"]&&dataDic[@"appMainEntrance"]!=[NSNull null]) {
            
            appMainEntrance = dataDic[@"appMainEntrance"];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"appMainEntrance"];

        }
        NSString*appStandbyEntrance;
        if (dataDic[@"appStandbyEntrance"]&&dataDic[@"appStandbyEntrance"]!=[NSNull null]) {
            
            appStandbyEntrance = dataDic[@"appStandbyEntrance"];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"appStandbyEntrance"];
        }
        
        //设置主、备份地址
        if (appMainEntrance&&appMainEntrance.length>0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:appMainEntrance forKey:@"appMainEntrance"];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"appMainEntrance"];
        }
        if (appStandbyEntrance&&appStandbyEntrance.length>0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:appStandbyEntrance forKey:@"appStandbyEntrance"];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"appStandbyEntrance"];
            
        }
            NSArray *pageConfigArrary = dataDic[@"pageConfig"];//页面配置数组
            if (pageConfigArrary.count) {
                _popTool = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
                _popTool.popWindowUrlsArrary = [NSMutableArray array];
                _popTool.pageUrlConfigArrary = [NSMutableArray array];

                for (int i=0; i<pageConfigArrary.count; i++) {
                    PopAppointViewControllerModel *model = [[PopAppointViewControllerModel alloc]init];
                    if ([pageConfigArrary[i] isKindOfClass:[NSDictionary class]]) {
                        [model setValuesForKeysWithDictionary:pageConfigArrary[i]];
                        [_popTool.popWindowUrlsArrary addObject:model];
                    }
                }
            }
            NSArray *pageUrlConfigArrary = dataDic[@"pageUrlConfig"];//页面配置数组
            for (NSDictionary *dic  in pageUrlConfigArrary) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    PageUrlConfigModel *model = [[PageUrlConfigModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
//                    if ([model.pageTag  isEqualToString:@"fy_main_home"]) {
//                        // 重新给首页赋值
//                        model.url = [NSString stringWithFormat:@"%@/%@",fyMainHomeUrl,@"html/home/home.html"];
//                    }
                    [_popTool.pageUrlConfigArrary addObject:model];
                }
            }
            [self.appInfoModel setValuesForKeysWithDictionary:iosVersionDic];
            self.appInfoModel.momentsSwitch = dataDic[@"momentsSwitch"];
            self.appInfoModel.imageServerUrl = dataDic[@"imageServerUrl"];
            [self goToUpdate];
            if ([self.delegate performSelector:@selector(setUrlForViewCntrollers)]) {
                [self.delegate setUrlForViewCntrollers];
            }
            [DownLoaderHelp saveADImageWithUrlStr:guidArry];
        }
        
    }
}

- (void)showNoContentView{
    
    if (self.HMH_noContentView.superview) {
        [self.HMH_noContentView removeFromSuperview];
    }
    
//    NSString *noImageStr;
//    if (self.noContentImageName.length > 0) {
//        noImageStr = self.noContentImageName;
//    } else {
//        noImageStr = @"SpType_search_noContent";
//    }
//    NSString *noTextStr;
//    if (self.noContentText.length > 0) {
//        noTextStr = self.noContentText;
//    } else {
//        noTextStr = @"暂无内容";
//    }
//    self.HMH_noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:@"SpType_search_noContent"] title:@"网络加载失败" subTitle:@"请再次刷新或检查网络"];
//    [self.HMH_noContentView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
//
//    [self.view addSubview:self.HMH_noContentView];
}

- (void)faileWithUrl{
    
    UIViewController* vc     = (UIViewController*)self.delegate;
//    _imageViewNotFound       = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    _imageViewNotFound.image = [UIImage imageNamed:@"sh01.png"];
    
    self.HMH_noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:@"SpType_search_noContent"] title:@"网络加载失败" subTitle:@"请再次刷新或检查网络"];
//    self.HMH_noContentView.frame = [UIScreen mainScreen].bounds;
    [self.HMH_noContentView setCenter:CGPointMake(vc.view.frame.size.width/2.0, ((vc.view.frame.size.height - 20) / 2)/2.0)];

    [vc.view addSubview:self.HMH_noContentView];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"网络不佳,请打开网络后重试"
                                                            preferredStyle:              UIAlertControllerStyleAlert];
    UIAlertAction *action1   = [UIAlertAction actionWithTitle:@"退出"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action){
        exit(0);
    }];
    UIAlertAction *action2   = [UIAlertAction actionWithTitle:@"重试"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self judgeAPPVersion];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.delegate show:alert];
    
}
- (void)faileWithNetWorkConnectivity{
    
    UIViewController* vc     = (UIViewController*)self.delegate;
//    _imageViewNotFound       = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    _imageViewNotFound.image = [UIImage imageNamed:@"sh01.png"];
    self.HMH_noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:@"SpType_search_noContent"] title:@"网络加载失败" subTitle:@"请再次刷新或检查网络"];
//    self.HMH_noContentView.frame = [UIScreen mainScreen].bounds;
    [self.HMH_noContentView setCenter:CGPointMake(vc.view.frame.size.width/2.0, ((vc.view.frame.size.height - 20) / 2)/2.0)];

    [vc.view addSubview:self.HMH_noContentView];

//    [vc.view addSubview:_imageViewNotFound];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"网络无连接,请打开网络后重试"
                                                            preferredStyle:              UIAlertControllerStyleAlert];
    UIAlertAction *action1   = [UIAlertAction actionWithTitle:@"退出"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action){
                                                          exit(0);
                                                      }];
    UIAlertAction *action2   = [UIAlertAction actionWithTitle:@"重试"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self judgeAPPVersion];
                                                      }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.delegate show:alert];
   // [self.delegate show:alert];
}
//版本更新
- (void)goToUpdate{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if ([self.appInfoModel.iosVersionCode compare:currentVersion] == NSOrderedDescending){
     
        [self goAheadAppSrore:self.appInfoModel.iosUpInfo];
    }
}
- (void)goAheadAppSrore:(NSString *)message{
    UIAlertController * alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                               message:message preferredStyle:UIAlertControllerStyleAlert];
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alertController.view];
    
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[1];
        messageLb.textAlignment = NSTextAlignmentLeft;
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"style:
                               UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                   dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1447851000"]];
                                       [self.delegate show:alertController];
                                   });
                               }];
    [alertController addAction:okAction];
    if (self.appInfoModel.forceUpgrade==0 ){
        NSString *str=  [[NSUserDefaults standardUserDefaults]objectForKey:[VersionTools appVersion]];
        if (str.length>3) {
            return;
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cancelAction];
        
        UIAlertAction *NoticeAction = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"forceUpgrade" forKey:[VersionTools appVersion]];
        }];
        [alertController addAction:NoticeAction];
        
    }else if(self.appInfoModel.forceUpgrade==-1){
        
        return;
    }
    
    [self.delegate show:alertController];
}
- (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            return view;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}
@end
