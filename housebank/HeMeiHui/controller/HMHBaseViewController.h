//
//  BaseViewController.h
//  HeMeiHui
//
//  Created by 任为 on 2017/10/19.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NavigationContrl.h"
#import "SVProgressHUD.h"
#import "VersionTools.h"
#import "HMHCustomHUDView.h"

//#import <CoreLocation/CoreLocation.h>

@interface HMHBaseViewController : UIViewController <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>// <CLLocationManagerDelegate>
{
  WKWebView * _webView;
//    CLLocationManager *_locationManager;//定位服务管理类
//    CLGeocoder * _geocoder;//初始化地理编码器
}
@property (nonatomic,assign)CGFloat buttomBarHeghit;
@property (nonatomic,assign)CGFloat statusHeghit;
@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, strong)NSArray *webViewContifgArrary;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *currentUrl;
@property (nonatomic,copy)NSString *LastPageUrl;
@property (nonatomic,copy)NSString *pageTag;
@property (nonatomic,assign)BOOL shouldRefresh;

// 防止白屏的加载动画
@property (nonatomic, strong) HMHCustomHUDView *customHUD;


- (void)getBadgeCount:(id)body;
- (void)getImBadgeCountByMchId:(id)body;
- (void)creatStatusBar;
- (void)showProgress;
- (void)dissMissProgress;
- (WKWebView *)webView;

- (void)showMBProgressHUD;
- (void)hideMBProgressHUD;

@end
