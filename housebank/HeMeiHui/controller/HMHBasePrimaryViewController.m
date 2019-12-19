//
//  BasePrimaryViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/23.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHBasePrimaryViewController.h"


@interface HMHBasePrimaryViewController ()
@property (nonatomic, strong) NSString *sidStr;

@end

@implementation HMHBasePrimaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HMH_statusHeghit = 0;
    self.HMH_buttomBarHeghit = 0;
    self.HMH_statusHeghit_wd = 20;
    if (IS_iPhoneX) {
        self.HMH_statusHeghit = 44;
        self.HMH_statusHeghit_wd = 44;
        self.HMH_buttomBarHeghit = 34;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
#pragma mark 显示暂无内容
- (void)showNoContentView{
    
    if (self.HMH_noContentView.superview) {
        [self.HMH_noContentView removeFromSuperview];
    }
    
    NSString *noImageStr;
    if (self.noContentImageName.length > 0) {
        noImageStr = self.noContentImageName;
    } else {
        noImageStr = @"video_noContent";
    }
    NSString *noTextStr;
    if (self.noContentText.length > 0) {
        noTextStr = self.noContentText;
    } else {
        noTextStr = @"暂无内容";
    }
    self.HMH_noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:noImageStr] title:noTextStr subTitle:@""];
    [self.HMH_noContentView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [self.view addSubview:self.HMH_noContentView];
}
- (void)showNoContentView:(BOOL)isSendSubviewToBack{
    
    if (self.HMH_noContentView.superview) {
        [self.HMH_noContentView removeFromSuperview];
    }
    
    NSString *noImageStr;
    if (self.noContentImageName.length > 0) {
        noImageStr = self.noContentImageName;
    } else {
        noImageStr = @"SpType_search_noContent";
    }
    NSString *noTextStr;
    if (self.noContentText.length > 0) {
        noTextStr = self.noContentText;
    } else {
        noTextStr = @"暂无内容";
    }
    self.HMH_noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:noImageStr] title:noTextStr subTitle:@""];
    [self.HMH_noContentView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0 - WScale(55))];
    [self.view addSubview:self.HMH_noContentView];
    if (isSendSubviewToBack) {
        [self.view sendSubviewToBack:self.HMH_noContentView];
    }
}
#pragma mark 显示暂无内容 可设置坐标
- (void)showNoContentViewWithPoint:(CGPoint)point
{
    if (self.HMH_noContentView.superview) {
        [self.HMH_noContentView removeFromSuperview];
    }
    NSString *noImageStr;
    if (self.noContentImageName.length > 0) {
        noImageStr = self.noContentImageName;
    } else {
        noImageStr = @"video_noContent";
    }
    NSString *noTextStr;
    if (self.noContentText.length > 0) {
        noTextStr = self.noContentText;
    } else {
        noTextStr = @"暂无内容";
    }
    self.HMH_noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:noImageStr] title:noTextStr subTitle:@""];
    
    [self.HMH_noContentView setCenter:point];
    [self.view addSubview:self.HMH_noContentView];
    
}
#pragma mark 隐藏暂无内容
- (void)hideNoContentView{
    if (self.HMH_noContentView.superview) {
        [self.HMH_noContentView removeFromSuperview];
    }
}

#pragma mark 当地图 电话 语音通话等时  打开app app会向下移动 从而返回状态的高度
- (CGFloat)statusChangedWithStatusBarH{
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusH = 0.0;
    if (statusRect.size.height > 20) {
        statusH = 20.0;
    }
    
    return statusH;
}

#pragma mark  json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark 单纯的判断是否登录
- (BOOL)isJudgeLogin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    if (sidStr.length > 6 && ![sidStr isEqualToString:@"(null)"]) { //已经登录
        return YES;
    }
    return NO;
}

#pragma mark 判断是否登录 如果没有登录 就跳登录页面
- (BOOL)isLogin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    if (sidStr.length > 6 && ![sidStr isEqualToString:@"(null)"]) { //已经登录
        return YES;
    }
    [self gotoLogin];
    return NO;
}

- (void)gotoLogin{
    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if (tools.pageUrlConfigArrary.count) {
        
        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
            
            if([model.pageTag isEqualToString:@"fy_login"]) {
                _HMH_loginVC = [[HMHPopAppointViewController alloc]init];
                _HMH_loginVC.urlStr = model.url;
                _HMH_loginVC.isNavigationBarshow = NO;
                _HMH_loginVC.hidesBottomBarWhenPushed = YES;
                //                __weak  typeof (self)weakSelf = self;
                //                _loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
                //                    weakSelf.sidStr = sidStr;
                //                };
                
                [self.navigationController pushViewController:_HMH_loginVC animated:YES];
            }
        }
    }
}

#pragma mark 返回用户的sid
- (NSString *)getUserSidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (sidStr.length > 6 && ![sidStr isEqualToString:@"(null)"]) { //已经登录
        return sidStr;
    }
    return @"";
}

#pragma mark 返回用户uid
- (NSString *)getUserUidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"uid"]];
    if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) { //已经登录
        return uidStr;
    }
    return @"";
}

#pragma <打印控制器名字>
- (void)dealloc {
    NSLog(@"当前销毁的控制器：%@",NSStringFromClass([self class]));
}

#pragma mark

/**
 如果列表是VC，就返回VC.view
 如果列表是View，就返回View自己
 
 @return 返回列表视图
 */
- (UIView *)listView {
    return self.view;
}


/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear {
    
}

/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear {
    
    
}

@end
