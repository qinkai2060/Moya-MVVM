//
//  MainHomeViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/21.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "MainHomeViewController.h"
#import "InitIntroduceView.h"
#import "WRNavigationBar.h"

@interface MainHomeViewController ()<SpInitIntroduceViewDelegate>

@property (nonatomic, strong) InitIntroduceView *introlduceView;

@end

@implementation MainHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self removeCache];
    [self setIMBadge];
    
}
- (void)setIMBadge{
    
//        if ([[[NIMSDK sharedSDK]loginManager]isLogined]) {
//            NSInteger cout = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
//            UITabBarController *tab = self.navigationController.tabBarController;
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
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [self wr_setNavBarBarTintColor:[UIColor colorWithHexString:@"F3344A"]];
    [self wr_setNavBarBackgroundAlpha:1];
//    [self creataIntrolduceView];
}
- (void)removeCache
{
    NSString *version = [[UIDevice currentDevice]systemVersion];
    NSArray * versionArr = [version componentsSeparatedByString:@"."];
    NSInteger versionNum = [versionArr[0] integerValue];
    if (versionNum >=9) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else if(versionNum>=8){
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    }
}

- (void)creataIntrolduceView
{
    // 保证第一次进入app 显示一次
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"IsShowIntroV"] isEqualToString:@"yes"]){                // 数据请求成功之后 添加引导页
        if (_introlduceView == nil) {
            _introlduceView = [[InitIntroduceView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            _introlduceView.Delegate=self;
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            window.windowLevel = UIWindowLevelStatusBar;
//              [window addSubview:_introlduceView];
//            [[UIApplication sharedApplication].keyWindow addSubview:_introlduceView];
             self.tabBarController.tabBar.hidden=YES;
             [self.view addSubview:_introlduceView];
        }
    }

}
-(void)reSetTabBarHidden
{
   self.tabBarController.tabBar.hidden=NO;
}
@end
