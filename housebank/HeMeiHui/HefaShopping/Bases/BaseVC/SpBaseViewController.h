//
//  BaseViewController.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRCustomNavigationBar.h"
#import "HMHNoContentView.h"
#import "HMHPopAppointViewController.h"
#import "HMHGoodsPushAlertView.h"
@interface SpBaseViewController : UIViewController


// 适配ipnone X
@property (nonatomic,assign)CGFloat buttomBarHeghit;
@property (nonatomic,assign)CGFloat statusHeghit;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *navigationBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *pageTag;
@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@property (nonatomic, strong) HMHPopAppointViewController *HMH_loginVC;


// 暂无内容
@property (nonatomic, strong) HMHNoContentView *noContentView;

// 显示或隐藏暂无内容
@property (nonatomic, strong) NSString *noContentImageName;
@property (nonatomic, strong) NSString *noContentText;

@property (nonatomic, strong)  HMHGoodsPushAlertView *goodsAlertView;
- (void)showNoContentView;
- (void)showNoContentViewWithPoint:(CGPoint)point;
- (void)hideNoContentView;

// 单纯的判断是否登录
- (BOOL)isJudgeLogin;
// 判断是否登录 如果没有登录 就跳登录页面
- (BOOL)isLogin;
// 直接跳登录页面
- (void)gotoLogin;


//自定义导航条VIEW
//- (void)setTitle:(NSString *)title;
//- (void)showLeftBackButton;
//设置状态栏背景色
- (void)setStatusBarBackgroundColor:(UIColor *)color;

//系统导航条
- (void)setNavTitle:(NSString *)title;
- (void)setBackButton;
- (void)setBackButton:(NSString *)bgImageName;
- (void)backAction:(id)sender;
- (void)setNavBgColor:(UIColor *)bgColor;

// 当地图 电话 语音通话等时  打开app app会向下移动 从而返回状态的高度
- (CGFloat)statusChangedWithStatusBarH;

#pragma mark  json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (void)goodsInfoPushMessageWithDic:(NSDictionary *)dic;
@end
