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
static NSString *productionEnvironment = @"https://mall-api.fybanks.com";//生产
static NSString *testEnvironment = @"https://mall-api.fybanks.cn";//测试
static NSString *preEnvironment = @"https://mall-api.heyoucloud.com";//预生产
static NSString *XUEnvironment = @"http://192.168.0.77:10200";//徐业鼎
static NSString *NewproductionEnvironment = @"https://mall-api.fybanks.cn";//新的域名

#ifdef TEST
// 当前环境  测试 Debug(Test)
//接口环境域名
//开发2环境
//static NSString *CurrentEnvironment =@"https://mall-api.hfqqjia.com";
//测试二环境
//static NSString *CurrentEnvironment =@"https://mall-api.9yuekj.com";
//测试二环境
//static NSString *fyMainHomeUrl = @"https://m.9yuekj.com";
//测试环境1
static NSString *CurrentEnvironment =@"https://mall-api.fybanks.cn";
//测试一环境
static NSString *fyMainHomeUrl = @"https://m.fybanks.cn";
//分享图片域名
static NSString *SharePictureUrl =@"https://static.fybanks.cn";

#elif PREONLINE
// 当前环境  预生产 Debug(PreOnline)
static NSString *CurrentEnvironment =@"https://mall-api.heyoucloud.com";
//static NSString *CurrentEnvironment =@"http://192.168.0.77:10200";

static NSString *fyMainHomeUrl = @"https://m.heyoucloud.com";

static NSString *SharePictureUrl =@"https://static.heyoucloud.com";

#elif ONLINE
// 当前环境  生产 Release(Online)
static NSString *CurrentEnvironment = @"https://mall-api.fybanks.com";

static NSString *CurrentVersion = @"1.0.2";

static NSString *fyMainHomeUrl = @"https://m.fybanks.com";

static NSString *SharePictureUrl =@"https://static.fybanks.com";
#elif RELEASE

static NSString *CurrentEnvironment = @"https://mall-api.fybanks.com";

static NSString *fyMainHomeUrl = @"https://m.fybanks.com";

static NSString *SharePictureUrl =@"https://static.fybanks.com";
#endif


#ifdef TEST    //测试环境
static NSString *CurrentUpYunImageSpace = @"fybanks-img-test";
static NSString *CurrentUpYunImageOperater = @"testimg";
static NSString *CurrentUpYunImagePassword = @"hefa2017";
static NSString *CurrentUpYunImageBase_Url = @"img-test1.fybanks.com";

static NSString *MyCardYunImageBase_Url = @"https://static.fybanks.cn";

static NSString *CurrentUpYunVideoSpace = @"fybanks-video-test";
static NSString *CurrentUpYunVideoOperater = @"videotest";
static NSString *CurrentUpYunVideoPassword = @"hefa8888";
static NSString *CurrentUpYunVideoBase_Url = @"v-test.fybanks.com";
// NIM证书名称  // Adhot 正式   测试DEV
static NSString *NIMSDKCertificateName = @"HeMeiHuiAppDev";
//测试APPKey
static NSString *NIMAppKey = @"d547963031b2c42a378f4ff9521b85f8";
//e283ad8b621f4567b0884aca499f703f 合美惠

//0642dd6549939b9e4d0773c4   正式环境证书key
//39fed178d99672ed33f9135e   测试徐业鼎
//[JPUSHService setupWithOption:launchOptions appKey:@"0642dd6549939b9e4d0773c4"//测试环境key
//                      channel:nil
//             apsForProduction:1    //正式环境 改为1
//        advertisingIdentifier:nil];
//推送测试APPKey
static NSString *JPUSHAppKey = @"2c69a19ff1fbb207a46edbbc";
//6fa217e60491a44f5ae15ff3 合美惠
// 推送参数
static BOOL apsForProduction = 0;

#elif PREONLINE  // 预生产

static NSString *CurrentUpYunImageSpace = @"fybanks-img-test";
static NSString *CurrentUpYunImageOperater = @"testimg";
static NSString *CurrentUpYunImagePassword = @"hefa2017";
static NSString *CurrentUpYunImageBase_Url = @"img-test1.fybanks.com";

static NSString *MyCardYunImageBase_Url = @"https://static.heyoucloud.com";


static NSString *CurrentUpYunVideoSpace = @"fybanks-video-test";
static NSString *CurrentUpYunVideoOperater = @"videotest";
static NSString *CurrentUpYunVideoPassword = @"hefa8888";
static NSString *CurrentUpYunVideoBase_Url = @"v-test.fybanks.com";
// NIM证书名称  // Adhot 正式   测试DEV
static NSString *NIMSDKCertificateName = @"HeMeiHuiAppDev";
//测试APPKey
static NSString *NIMAppKey = @"d547963031b2c42a378f4ff9521b85f8";
//e283ad8b621f4567b0884aca499f703f 合美惠

//0642dd6549939b9e4d0773c4   正式环境证书key
//39fed178d99672ed33f9135e测试徐业鼎
//[JPUSHService setupWithOption:launchOptions appKey:@"0642dd6549939b9e4d0773c4"//测试环境key
//                      channel:nil
//             apsForProduction:1    //正式环境 改为1
//        advertisingIdentifier:nil];
//推送测试APPKey
static NSString *JPUSHAppKey = @"2c69a19ff1fbb207a46edbbc";
//6fa217e60491a44f5ae15ff3 合美惠
// 推送参数
static BOOL apsForProduction = 0;

#elif ONLINE// 正式环境
/*
 打包注意
 在预生产和测试环境  选择第四个Development 然后证书选择不带type的 （heft_development_20180627）
 打生产包  打包App Store 需要修改Signing(release) 中profile 改为不带type的   即打Ad Hoc 选择证书带type的(heft_adhoc_20180627Type)
 */

//#if 1   // 打包App Store 需要修改Signing(release) 中profile 改为带type 的
static NSString *CurrentUpYunImageSpace = @"fybanks-img-online";
static NSString *CurrentUpYunImageOperater = @"imgupload";
static NSString *CurrentUpYunImagePassword = @"Hefa2018!@#";
static NSString *CurrentUpYunImageBase_Url = @"img0.fybanks.com";

static NSString *MyCardYunImageBase_Url = @"https://static.fybanks.com";


static NSString *CurrentUpYunVideoSpace = @"fybanks-video-prod";
static NSString *CurrentUpYunVideoOperater = @"imgupload";
static NSString *CurrentUpYunVideoPassword = @"Hefa2018!@#";
static NSString *CurrentUpYunVideoBase_Url = @"v.fybanks.com";
// NIM证书名称
//static NSString *NIMSDKCertificateName = @"Adhot";
static NSString *NIMSDKCertificateName = @"HeMeiHuiAppProd";
//生产appkey
//static NSString *NIMAppKey = @"44ec9c8c5db77eea8d3f2d04ca2841de";
static NSString *NIMAppKey = @"43d2923e3f44adc41ccb63e9ab52f9f8";
//e283ad8b621f4567b0884aca499f703f 合美惠

//e283ad8b621f4567b0884aca499f703f
//推送正式APPKey
//static NSString *JPUSHAppKey = @"0642dd6549939b9e4d0773c4";
//static NSString *JPUSHAppKey = @"997e7eb776f470d13de445da";
static NSString *JPUSHAppKey = @"6fa217e60491a44f5ae15ff3";
//6fa217e60491a44f5ae15ff3 合美惠
// 推送参数
static BOOL apsForProduction = 1;

#elif RELEASE// 正式环境
/*
 打包注意
 在预生产和测试环境  选择第四个Development 然后证书选择不带type的 （heft_development_20180627）
 打生产包  打包App Store 需要修改Signing(release) 中profile 改为不带type的   即打Ad Hoc 选择证书带type的(heft_adhoc_20180627Type)
 */
//#if 1   // 打包App Store 需要修改Signing(release) 中profile 改为带type 的
static NSString *CurrentUpYunImageSpace = @"fybanks-img-online";
static NSString *CurrentUpYunImageOperater = @"imgupload";
static NSString *CurrentUpYunImagePassword = @"Hefa2018!@#";
static NSString *CurrentUpYunImageBase_Url = @"img0.fybanks.com";

static NSString *CurrentUpYunVideoSpace = @"fybanks-video-prod";
static NSString *CurrentUpYunVideoOperater = @"imgupload";
static NSString *CurrentUpYunVideoPassword = @"Hefa2018!@#";
static NSString *CurrentUpYunVideoBase_Url = @"v.fybanks.com";
// NIM证书名称
//static NSString *NIMSDKCertificateName = @"Adhot";
static NSString *NIMSDKCertificateName = @"HeMeiHuiAppProd";
//生产appkey
static NSString *NIMAppKey = @"43d2923e3f44adc41ccb63e9ab52f9f8";
//e283ad8b621f4567b0884aca499f703f 合美惠
//推送正式APPKey
//static NSString *JPUSHAppKey = @"0642dd6549939b9e4d0773c4";
static NSString *JPUSHAppKey = @"6fa217e60491a44f5ae15ff3";
//6fa217e60491a44f5ae15ff3 合美惠

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
