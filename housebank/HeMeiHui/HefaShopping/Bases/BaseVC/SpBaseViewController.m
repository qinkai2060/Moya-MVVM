//
//  BaseViewController.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "SpBaseViewController.h"
#import "WRNavigationBar.h"
#import "HFLoginViewController.h"
UIColor *MainNavBarColor = nil;
UIColor *MainViewColor = nil;
@interface SpBaseViewController ()<UIGestureRecognizerDelegate>
{
    BOOL isTabBarHidden;
}
@end

@implementation SpBaseViewController
- (id)init {
    if (self = [super init]) {

        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        {
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)])
        {
            self.modalPresentationCapturesStatusBarAppearance = YES;
        }
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusHeghit = 20;
    self.buttomBarHeghit = 0;
    if (IS_iPhoneX) {
        self.statusHeghit = 44;
        self.buttomBarHeghit = 34;
    }
    self.view.backgroundColor =  [UIColor colorWithHexString:@"f0f4f7"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KBackgroundColor;
    [self setupNavBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.hidesBottomBarWhenPushed = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//   // [self setStatusBarBackgroundColor:[UIColor whiteColor]];
//    NSLog(@"----%ld",self.navigationController.viewControllers.count);
//    if(self.navigationController.viewControllers.count > 1) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if(self.navigationController.viewControllers.count > 1) {

        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
      [SVProgressHUD dismiss];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.customNavBar];//始终放在最上层
}
- (void)setupNavBar
{
    [self.view addSubview:self.customNavBar];
    
    // 设置自定义导航栏背景图片
    self.customNavBar.barBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithTitle:@"<<" titleColor:[UIColor whiteColor]];
    }
    self.customNavBar.hidden=YES;

}
- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

//- (void)setTitle:(NSString *)title
//{
//    [_navigationView addSubview:self.titleLabel];
//    _titleLabel.text = title;
//}
//
//- (UILabel *)titleLabel
//{
//    if (!_titleLabel) {
//
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_navigationView.frame.size.width/2 - 50, _navigationView.frame.size.height - 30, 100, 20)];
//        _titleLabel.font = SYSTEMFONT(16);
//        _titleLabel.textColor = KDarkTextColor;
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//    }
//
//    return _titleLabel;
//}

//- (void)showLeftBackButton
//{
//    _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _leftButton.frame = CGRectMake(15, StatusBarHeight + 5, 45, 35);
//    [_leftButton setImage:[UIImage imageNamed:@"back_btn"] forState:(UIControlStateNormal)];
//    [_leftButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [_navigationView addSubview:_leftButton];
//}


#pragma mark - action

- (void)backAction
{
     [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavTitle:(NSString *)title
{
    [self.navigationItem setTitle:title];
}

- (void)setBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 24, 24);
    [backBtn setImage:[UIImage imageNamed:@"1.index"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0,9);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)setBackButton:(NSString *)bgImageName
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 24, 24);
    [backBtn setImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0,9);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)backAction:(id)sender
{
     [SVProgressHUD dismiss];
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}


- (void)setNavBgColor:(UIColor *)bgColor
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageWithColor:bgColor]
                                                  forBarPosition:UIBarPositionAny
                                                      barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[UIImage new]];
    
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
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
}

#pragma mark 显示暂无内容
- (void)showNoContentView{
    
    if (self.noContentView.superview) {
        [self.noContentView removeFromSuperview];
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
    self.noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:noImageStr] title:noTextStr subTitle:@""];
    [self.noContentView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    
    [self.view addSubview:self.noContentView];
    
}
#pragma mark 显示暂无内容 可设置坐标
- (void)showNoContentViewWithPoint:(CGPoint)point
{
    if (self.noContentView.superview) {
        [self.noContentView removeFromSuperview];
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
    self.noContentView = [[HMHNoContentView alloc] initWithImg:[UIImage imageNamed:noImageStr] title:noTextStr subTitle:@""];
    
    [self.noContentView setCenter:point];
    [self.view addSubview:self.noContentView];
    
}
#pragma mark 隐藏暂无内容
- (void)hideNoContentView{
    if (self.noContentView.superview) {
        [self.noContentView removeFromSuperview];
    }
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
//    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
//    if (tools.pageUrlConfigArrary.count) {
//
//        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
//
//            if([model.pageTag isEqualToString:@"fy_login"]) {
//                _HMH_loginVC = [[HMHPopAppointViewController alloc]init];
//                _HMH_loginVC.urlStr = model.url;
//                _HMH_loginVC.isNavigationBarshow = NO;
//                _HMH_loginVC.hidesBottomBarWhenPushed = YES;
//                //                __weak  typeof (self)weakSelf = self;
////                                _loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
//                //                    weakSelf.sidStr = sidStr;
////                                };
//
//                [self.navigationController pushViewController:_HMH_loginVC animated:YES];
//
//            }
//        }
//    }
    [HFLoginViewController showViewController:self];
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
    if(err){
        //        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)goodsInfoPushMessageWithDic:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        // 江苏省徐少2天前已下单
        NSString *content = [dic valueForKey:@"content"];
        // 6
        NSString *contentTypeStr = [dic valueForKey:@"content_type"];
        NSDictionary *extras = [dic valueForKey:@"extras"];
        //  /user/1528341538994/s579a4k1mdocljh6.jpg
        NSString *userAvatarStr = [extras valueForKey:@"userAvatar"];
        NSString *urlStr = [extras valueForKey:@"targetUrl"];
        NSString *uidStr = [extras valueForKey:@"uid"];
        NSString *pageTagsStr = [extras valueForKey:@"pageTags4DisplayMsg"];
        // 4  如果没有返回的话 就默认为3秒   此类型为毫秒
        NSNumber *showTimeNum = [extras valueForKey:@"duration"];
        
        
//        PopAppointViewControllerModel*currentAppointModel = [NavigationContrl getModelFrom:self.getNowCurrentUrl];
//
//        NSLog(@"%@,%@",pageTagsStr,currentAppointModel.pageTag);
//        if ([pageTagsStr containsString:currentAppointModel.pageTag]) {
            // 比如XXX省XX人3分钟前已下单
            NSString *contentStr = content;
            CGFloat w = [CommonManagementTools getWidthWithFontSize:14.0 height:35 text:contentStr];
            if (_goodsAlertView) {
                [_goodsAlertView hide];
            }
            self.statusHeghit = 20;
            if (IS_iPhoneX) {
                self.statusHeghit = 44;
            }
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
            
            if ([contentTypeStr longLongValue] == 1) {
                // uid相等 表示是自己下的单 所以就不用通知
                if ([uidStr isEqualToString:[self getUserUidStr]]) {
                    return;
                }
                [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
            } else if ([contentTypeStr longLongValue] == 2){
                // 针对登录的用户  登录用户可以收到
                if (sidStr.length > 6) {
                    [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
                }
            } else if ([contentTypeStr longLongValue] == 3){
                // 针对没有登录的用户  未登录用户可以收到
                if (sidStr.length <= 6) {
                    [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
                }
            } else if ([contentTypeStr longLongValue] == 4){
                // 针对所有的用户
                [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
            }
        }
//    }
}
- (void)createGoodsViewWithWidth:(CGFloat)w userIconUrl:(NSString *)userAvatarStr contentStr:(NSString *)contentStr showTime:(NSNumber *)showTimeNum urlStr:(NSString *)urlStr{
    CGFloat f = 0.0;
    if (userAvatarStr.length > 6) {
        f = 40;
    } else {
        f = 0;
    }
    
    _goodsAlertView = [[HMHGoodsPushAlertView alloc] initWithFrame:CGRectMake(0, self.statusHeghit + 44 + 60, w + 10 + f, 35) userIconUrl:userAvatarStr contentStr:contentStr isShowTime:[showTimeNum integerValue] / 1000];
    [_goodsAlertView show];
    
    __weak typeof(self)weakSelf = self;
//    先注释点击方法
//    _goodsAlertView.goodsClickBlock = ^{
//        [weakSelf goodsInfoWithUrl:urlStr];
//    };
}
// 跳转商品详情页面
- (void)goodsInfoWithUrl:(NSString *)url{
    PopAppointViewControllerModel *model = [NavigationContrl getModelFrom:url];
    
    HMHPopAppointViewController *goodsVC = [[HMHPopAppointViewController alloc]init];
    goodsVC.title = model.title;
    goodsVC.urlStr = url;
    if (model) {
        goodsVC.title = model.title;
        goodsVC.naviBg = model.naviBg;
        goodsVC.isNavigationBarshow = model.showNavi;
        goodsVC.naviMask = model.naviMask;
        goodsVC.naviMaskHeight = model.naviMaskHeight;
        goodsVC.pageTag = model.pageTag;
    }
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}
// 返回用户uid
- (NSString *)getUserUidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"uid"]];
    if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) { //已经登录
        return uidStr;
    }
    return @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
