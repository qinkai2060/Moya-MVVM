//
//  BasePrimaryViewController.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/23.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHNoContentView.h"
#import "PageUrlConfigModel.h"
#import "PopAppointViewControllerToos.h"
#import "HMHPopAppointViewController.h"
#import <JXCategoryView.h>

// 原生开发基于的base
@interface HMHBasePrimaryViewController : UIViewController<JXCategoryListContentViewDelegate>
// 暂无内容
@property (nonatomic, strong) HMHNoContentView *HMH_noContentView;

// 适配ipnone X
@property (nonatomic,assign)CGFloat HMH_buttomBarHeghit;
@property (nonatomic,assign)CGFloat HMH_statusHeghit;

@property (nonatomic,assign)CGFloat HMH_statusHeghit_wd;

// 显示或隐藏暂无内容
@property (nonatomic, strong) NSString *noContentImageName;
@property (nonatomic, strong) NSString *noContentText;
@property (nonatomic, strong) HMHPopAppointViewController *HMH_loginVC;

// 单纯的判断是否登录
- (BOOL)isJudgeLogin;
// 判断是否登录 如果没有登录 就跳登录页面
- (BOOL)isLogin;

//去登陆
- (void)gotoLogin;

// 返回用户的sid   
- (NSString *)getUserSidStr;
// 返回用户uid
- (NSString *)getUserUidStr;

// 显示或隐藏暂无内容
- (void)showNoContentView;
- (void)showNoContentViewWithPoint:(CGPoint)point;
- (void)hideNoContentView;
- (void)showNoContentView:(BOOL)isSendSubviewToBack;
// 当地图 电话 语音通话等时  打开app app会向下移动 从而返回状态的高度
- (CGFloat)statusChangedWithStatusBarH;

// json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
