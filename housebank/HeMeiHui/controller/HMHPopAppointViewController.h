//
//  PopAppointViewController.h
//  HeMeiHui
//
//  Created by 任为 on 2017/10/9.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopAppointViewControllerToos.h"
#import "HMHBaseViewController.h"

@class HMHPopAppointViewController;

typedef void(^contacTableViewCallBack)(NSString * phoneNum,NSString *uid);
typedef void(^wuLiuCallBack)(NSString *wuLiuUrl);

typedef void(^videoJudgeIsLoginCallBack)(NSString *sidStr);
typedef void(^backCallBack)();
typedef void(^videoWebViewVC)(id popVC);

@interface HMHPopAppointViewController : HMHBaseViewController
// 为商品详情中的 XX已下单而用的url
@property (nonatomic, strong) NSString *getNowCurrentUrl;
@property (nonatomic, assign)BOOL isFristLoadWebView;
@property (nonatomic, assign)BOOL isCanPopViewCurrentController;
@property (nonatomic, assign) BOOL isFristComeIN;
@property (nonatomic, assign) BOOL isFresh;
@property (nonatomic,copy)NSString *naTitle;
@property (nonatomic,assign) BOOL isNavigationBarshow ;
@property (nonatomic, strong)NSString *naviBg;
@property (nonatomic,strong) PopAppointViewControllerToos *popTool;
@property (nonatomic, assign)BOOL naviMask;
@property (nonatomic, assign) CGFloat naviMaskHeight;
@property (nonatomic, copy) contacTableViewCallBack acontactCallBack;
@property (nonatomic, copy) wuLiuCallBack wuLiuUrl;
@property (nonatomic, copy) backCallBack bCallBackBlock;

@property (nonatomic, copy) videoJudgeIsLoginCallBack judgeIsLoginBack;

@property (nonatomic, copy) videoWebViewVC popVCCallBack;
// 判断是否是模态进入的页面
@property (nonatomic, assign) BOOL isPresentJump;

// 是否是来自视频直播中的webView (简介 内容简介)
@property (nonatomic, assign) BOOL isFromVideoWebView;
// 是否是来自视频直播的web跳转
@property (nonatomic, assign) BOOL isPushFromVideoWeb;

- (void)backToPath:(id)body;
- (void)openContactsWindow:(id)body;
- (void)login:(id)body;
- (void)logout:(id)body;
- (void)loginAtNetease:(id)body;
- (void)openChatWithAccidInfo:(id)infoDic;
- (void)jsCallOC:(id)body;
- (void)checkUpgrade:(id)body;
- (void)onBeeCloudResp:(BCBaseResp *)resp;
- (void)aliPayResult:(NSNotification*)result;
- (void)WXPayResult:(NSNotification*)result;
- (void)callBack:(NSString*)str;
- (void)videoPlay:(id)body;
- (void)presentOtherViewController:(NSString*)url;
- (void)openPopupWindow:(id)body;
- (void)closePopupWindow:(id)body;
- (void)backPressed:(id)body;
- (void)openPopupPayWindow:(id)body;
- (void)postVersionInfo:(id)body;
- (void)getDeviceInfo:(id)body;
- (void)loginAtMsg:(id)body;
- (void)log:(id)body;
- (void)appShare:(id)body;
- (void)sendShareState:(NSString *)state;
- (void)callPhoneNum:(id)body;
-(void)put2bridge:(id)body;
- (void)scanningCode:(id)body;

@end
