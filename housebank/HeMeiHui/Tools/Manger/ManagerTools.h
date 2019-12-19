//
//  ManagerTools.h
//  HeMeiHui
//
//  Created by 任为 on 2016/10/8.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <SDWebImageDownloaderOperation.h>
#import <BeeCloud.h>
#import "AppInfoModel.h"
#import "DownLoaderHelp.h"
#import "VersionTools.h"
#import "PopAppointViewControllerToos.h"
#import <Reachability.h>
#import "HMHNoContentView.h"
// appstore
#ifdef TEST
// 开发环境1
static NSString *CurrentEnvironment =@"https://mall-api.ijiuyue.com";
static NSString *CloudeEnvironment = @"https://mall-api.ijiuyue.com";
static NSString *fyMainHomeUrl = @"https://m.ijiuyue.com";
static NSString *SharePictureUrl =@"https://static.fybanks.cn";//分享图片域名

//开发环境2
//static NSString *CurrentEnvironment =@"https://mall-api.hfqqjia.com";
//static NSString *CloudeEnvironment =@"https://mall-api.hfqqjia.com";
//static NSString *fyMainHomeUrl = @"https://m.hfqqjia.com";
//static NSString *SharePictureUrl =@"https://static.fybanks.cn";//分享图片域名

//开发环境 不知道是几
//static NSString *CurrentEnvironment =@"https://mall-api.heimh.com";
//static NSString *CloudeEnvironment =@"https://retail-api.heimh.com";
//static NSString *fyMainHomeUrl = @"https://m.heimh.com";


//////测试环境1
//static NSString *CurrentEnvironment =@"https://mall-api.fybanks.cn";
//static NSString *CloudeEnvironment =@"https://mall-api.fybanks.cn";
//
//static NSString *fyMainHomeUrl = @"https://m.fybanks.cn";//测试环境H5页面1
//static NSString *SharePictureUrl =@"https://static.fybanks.cn";//分享图片域名
//测试环境2
//static NSString *CurrentEnvironment =@"https://mall-api.9yuekj.com";
//static NSString *CloudeEnvironment =@"https://mall-api.9yuekj.com";
//static NSString *fyMainHomeUrl = @"https://m.9yuekj.com";//测试2环境H5页面1
//static NSString *SharePictureUrl =@"https://static.9yuekj.com";//分享图片域名

//测试环境3
//https://m.hfjyuan.com
//static NSString *CurrentEnvironment =@"https://mall-api.hfjyuan.com";
//static NSString *CloudeEnvironment =@"https://mall-api.hfjyuan.com";
//static NSString *fyMainHomeUrl = @"https://m.hfjyuan.com";//测试环境H5页面1
//static NSString *SharePictureUrl =@"https://static.hfjyuan.com";//分享图片域名

static NSString *CurrentUpYunImageSpace = @"fybanks-img-test";
static NSString *CurrentUpYunImageOperater = @"testimg";
static NSString *CurrentUpYunImagePassword = @"hefa2017";

static NSString *NIMSDKCertificateName = @"HeMeiHuiAppDev";// NIM证书名称  // Adhot 正式   测试DEV
static NSString *NIMAppKey = @"d547963031b2c42a378f4ff9521b85f8";//测试APPKey
static NSString *JPUSHAppKey = @"2c69a19ff1fbb207a46edbbc";//推送测试APPKey
static BOOL apsForProduction = 0;// 推送参数


static NSString *AleartString =@"微店优化";
#elif PREONLINE
//// 当前环境  预生产 Debug(PreOnline)
static NSString *CurrentEnvironment =@"https://mall-api.heyoucloud.com";
static NSString *CloudeEnvironment = @"https://mall-api.heyoucloud.com";
static NSString *fyMainHomeUrl = @"https://m.heyoucloud.com";
static NSString *SharePictureUrl =@"https://static.heyoucloud.com";

static NSString *CurrentUpYunImageSpace = @"fybanks-img-online";
static NSString *CurrentUpYunImageOperater = @"adminprd";
static NSString *CurrentUpYunImagePassword = @"Hefaadmin";

static NSString *NIMSDKCertificateName = @"HeMeiHuiAppDev";// NIM证书名称
static NSString *NIMAppKey = @"d547963031b2c42a378f4ff9521b85f8";//测试APPKey
static NSString *JPUSHAppKey = @"2c69a19ff1fbb207a46edbbc";//推送测试APPKey
static BOOL apsForProduction = 0;// 推送参数
static NSString *AleartString =@"微店优化";
#elif ONLINE
// 当前环境  生产 Release(Online)
static NSString *CurrentEnvironment = @"https://mall-api.hfhomes.cn";
static NSString *CloudeEnvironment = @"https://mall-api.hfhomes.cn";
static NSString *fyMainHomeUrl = @"https://m.hfhomes.cn";
static NSString *SharePictureUrl =@"https://static.hfhomes.cn";

static NSString *CurrentUpYunImageSpace = @"fybanks-img-online";
static NSString *CurrentUpYunImageOperater = @"adminprd";
static NSString *CurrentUpYunImagePassword = @"Hefaadmin";


static NSString *NIMSDKCertificateName = @"HeMeiHuiAppProd";// NIM证书名称
static NSString *NIMAppKey = @"43d2923e3f44adc41ccb63e9ab52f9f8";//生产appkey
static NSString *JPUSHAppKey = @"6fa217e60491a44f5ae15ff3";//推送正式APPKey
static BOOL apsForProduction = 1;// 推送参数
static NSString *AleartString =@"生产";

#elif RELEASE

static NSString *CurrentEnvironment = @"https://mall-api.hfhomes.cn";
static NSString *CloudeEnvironment = @"https://mall-api.hfhomes.cn";

static NSString *fyMainHomeUrl = @"https://m.hfhomes.cn";

static NSString *SharePictureUrl =@"https://static.hfhomes.cn";

#endif


#ifdef TEST    //测试环境


#elif PREONLINE  // 预生产


#elif ONLINE// 正式环境


#elif RELEASE// 正式环境

static NSString *CurrentUpYunImageSpace = @"fybanks-img-online";
static NSString *CurrentUpYunImageOperater = @"imgupload";
static NSString *CurrentUpYunImagePassword = @"Hefa2018!@#";

// NIM证书名称
static NSString *NIMSDKCertificateName = @"HeMeiHuiAppProd";
//生产appkey
static NSString *NIMAppKey = @"43d2923e3f44adc41ccb63e9ab52f9f8";
//推送正式APPKey
static NSString *JPUSHAppKey = @"6fa217e60491a44f5ae15ff3";

// 推送参数
static BOOL apsForProduction = 1;

#endif

@protocol ManagerToolsDelegate <NSObject>

@optional

- (void)refreshSelfWithUrl:(NSString*)url;
- (void)show:(UIViewController*)viewController;
- (void)setUrlForViewCntrollers;
@end
@interface ManagerTools : NSObject
@property (nonatomic, strong)AppInfoModel*appInfoModel;
@property (nonatomic, strong)UIImageView* imageViewNotFound;
@property (nonatomic, weak) id<ManagerToolsDelegate>  delegate;
@property (nonatomic,strong)PopAppointViewControllerToos* popTool;
@property (nonatomic, assign)BOOL isSigned;
@property (nonatomic, strong) HMHNoContentView *HMH_noContentView;

// 网络
@property(nonatomic,strong)Reachability *netReachAbility;

+ (NSString*)imageURL:(NSString*)urlStr sizeSignStr:(NSString*)signStr;
+ (id)ManagerTools;
- (void)judgeAPPVersion;
//+ (void)postData:(NSDictionary*)dic toUrl:(NSString*)Url;
- (void)goAheadAppSrore:(NSString *)message;
//+ (void)postDataWithUrlStr:(NSString *)urlStr parametersDic:(NSDictionary *)reqestDic isJsonReqeust:(BOOL)isJsonRequest;
- (void)postCrashInfo:(NSString*)info;
@end
