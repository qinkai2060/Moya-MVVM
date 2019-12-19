//
//  MainTabBarViewController.m
//  UPYUNShortVideo
//
//  Created by Qianhong Li on 2017/11/30.
//  Copyright © 2017年 upyun. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "SpBaseNavigationController.h"
#import "BaseNavgationViewController.h"
#import "SpMainHomeViewController.h"
#import "SpMainMineViewController.h"
#import "HFUserDataTools.h"
#import "HFLoginViewController.h"
#import "SunbathCircleViewController.h"
@interface MainTabBarViewController ()<ManagerToolsDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong)ManagerTools *tools;



@end

@implementation MainTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChildViewControllers];
    _tools    = [ManagerTools ManagerTools];
    _tools.delegate= self;
    self.delegate = self;
    [[UITabBar appearance] setTranslucent:NO];
    [_tools judgeAPPVersion];
//    [self addObserver:self forKeyPath:@"selectedViewController"options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
  
}
//- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
//
//    if([keyPath isEqualToString:@"selectedViewController"]) {
//
//        if(nil != change[@"old"]) {//记录前一个tab}
//
//        }
//
//    }
//}
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    if (3== selectedIndex) {
        [self tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:3]];
    }
 
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSUInteger index = [tabBar.items indexOfObject:item];
//    if (index != self.selectedIndex) {
//
//    }
//}


- (void)show:(UIViewController *)viewController{
    
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}
/**
 设置子视图控制器

 */
- (void)setChildViewControllers{
   
    /*首页*/
//    self.homeVC = [[MainHomeViewController alloc]init];
//    UINavigationController *homeNaVC = [[RootViewController alloc]initWithRootViewController:self.homeVC];
//    self.homeVC.title = @"首页";
//    [self set:self.homeVC TabarItemImage:@"tab_index_UnActive" selectedImage:@"tab_index_active"];
//    首页改版页面
    UINavigationController *MainHomeNav = [[UINavigationController alloc] initWithRootViewController:[[SpMainHomeViewController alloc] init]];
//    MainHomeNav.navigationBarHidden = YES;//
    MainHomeNav.title=@"首页";
    [self set:MainHomeNav TabarItemImage:@"DefatHomeBar" selectedImage:@"SelectHomeBar"];
//    DefatCarBar  DefatGlyphBar DefatHomeBar DefatMineBar DefatTypeBar SelectCarBar SelectGlyphBar SelectHomeBar SelectMineBar SelectTypeBar
    /*分类*/
    SpBaseNavigationController *spTypesNav = [[SpBaseNavigationController alloc] initWithRootViewController:[[SpTypesViewController alloc] initWithType:1]];
    spTypesNav.navigationBarHidden = YES;
    spTypesNav.title=@"分类";
    [self set:spTypesNav TabarItemImage:@"DefatTypeBar" selectedImage:@"SelectTypeBar"];
    /*晒宝圈*/
    SpBaseNavigationController *SunbathCircleNav = [[SpBaseNavigationController alloc] initWithRootViewController:[[SunbathCircleViewController alloc] init]];
    SunbathCircleNav.navigationBarHidden = YES;
    SunbathCircleNav.title=@"晒宝圈";
    [self set:SunbathCircleNav TabarItemImage:@"DefatGlyphBar" selectedImage:@"SelectGlyphBar"];
    /*购物车*/
    SpBaseNavigationController *spOrderNav = [[SpBaseNavigationController alloc] initWithRootViewController:[[SpCartViewController alloc] initWithType:SpCartViewControllerEnterTypeNone]];
    spOrderNav.title=@"购物车";
    [self set:spOrderNav TabarItemImage:@"DefatCarBar" selectedImage:@"SelectCarBar"];

    /*合发购*/
//    self.mallVC = [[MainMallViewController alloc]init];
//    UINavigationController *mallNaVC = [[RootViewController alloc]initWithRootViewController:self.mallVC];
//    self.mallVC.title = @"商城";
//    [self set:self.mallVC TabarItemImage:@"tab_main_mall" selectedImage:@"tab_main_mall_on"];
    
    /*全球家*/

//   self.GlobalHomeVC = [[MainGlobalHomeViewController alloc]init];
//    UINavigationController *globalNaVC = [[RootViewController alloc]initWithRootViewController:self.GlobalHomeVC];
//    self.GlobalHomeVC.title = @"全球家";
//    [self set:self.GlobalHomeVC TabarItemImage:@"tab_main_globalhome" selectedImage:@"tab_main_globalhome_on"];
  
   /*OTO*/
//    self.MainMomentVC = [[MainMomentsViewController alloc]init];
//    UINavigationController *MainMomentNaVC = [[RootViewController alloc]initWithRootViewController:self.MainMomentVC ];
//    self.MainMomentVC.title = @"OTO";
//    [self set:self.MainMomentVC TabarItemImage:@"tab_main_OTO" selectedImage:@"tab_main_OTO-ON"];
   
    /*我的*/
//    self.MineVC = [[MainMineViewController alloc]init];
//    SpBaseNavigationController *mineNaVC = [[SpBaseNavigationController alloc]initWithRootViewController:self.MineVC];
//    self.MineVC.title = @"我的";
//    [self set:self.MineVC TabarItemImage:@"tab_mine_UnActive" selectedImage:@"tab_mine_active"];
    SpBaseNavigationController *mineNaVC = [[SpBaseNavigationController alloc]initWithRootViewController:[[SpMainMineViewController alloc]init]];
    mineNaVC.title = @"我的";
    mineNaVC.navigationBarHidden = YES;
    [self set:mineNaVC TabarItemImage:@"DefatMineBar" selectedImage:@"SelectMineBar"];
    NSArray *viewControllers = @[MainHomeNav,spTypesNav,SunbathCircleNav,spOrderNav,mineNaVC];
    self.viewControllers = viewControllers;
    self.selectedViewController = [self.viewControllers objectAtIndex:2];
  
    
}
#pragma 代理方法
- (void)setUrlForViewCntrollers{
    ManagerTools *manageTools =  [ManagerTools ManagerTools];
    if (manageTools.appInfoModel) {
        if (!manageTools.isSigned) {
            [self removeLocalData];
        }
    }
    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if (tools.popWindowUrlsArrary.count) {
        
        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
        
            if ([model.pageTag isEqualToString:@"fy_main_home"]) {//首页
                self.homeVC.mainUrlStr = model.url;
                self.homeVC.pageTag = model.pageTag;
                [self.homeVC webViewLoadDatafromMainUrl:self.homeVC.mainUrlStr];
            }else if([model.pageTag isEqualToString:@"fy_main_mall"]){//合发购
                    self.mallVC.mainUrlStr = model.url;
                    self.main_mall_url = model.url;
                    self.mallVC.pageTag = model.pageTag;
                
//            }else if([model.pageTag isEqualToString:@"fy_main_globalhome"]){//全球家
//
//                self.GlobalHomeVC.mainUrlStr = model.url;
//                self.GlobalHomeVC.pageTag = model.pageTag;
//
////                    BOOL result = [model.pageTag caseInsensitiveCompare:@"fy_main_OTO"] == NSOrderedSame;
//            // 不区分大小写 fy_main_OTO  与 fy_main_oto 都可
//            }else if([model.pageTag caseInsensitiveCompare:@"fy_main_OTO"] == NSOrderedSame){//OTO
//
//                self.MainMomentVC.mainUrlStr = model.url;
//                self.main_moments_url = model.url;
//                self.MainMomentVC.pageTag = model.pageTag;
//
            }
else if([model.pageTag isEqualToString:@"fy_main_mine"]){//我的
                
                self.MineVC.mainUrlStr = model.url;
                
                self.main_mine = model.url;
                
                self.MineVC.pageTag = model.pageTag;
                
            }else if([model.pageTag isEqualToString:@"fy_login"])
               
                self.url_login = model.url;
             
        }
        
    }
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isSelectMine"];
    UINavigationController *selectNaVC = self.viewControllers[self.selectedIndex];
    NSArray *arr = selectNaVC.viewControllers;
    NSLog(@"%@",arr);
    if ([viewController isKindOfClass:[RootViewController class]]) {
        UINavigationController * NaVC = (UINavigationController*) viewController;
        if ([NaVC.viewControllers[0] isKindOfClass:[MainMineViewController class]]) {//我的/个人中心处理

            NSString *sid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
           NSString *isLogout = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogout"];
            if (sid.length>3&&!isLogout) {//有accid 表示已经登录，可以选中

                return YES;

            }else if(sid.length<=3){//未登录不可以选中，直接跳转登录页面

                LocalLoginViewController *LVC = [[LocalLoginViewController alloc]init];
                LVC.mainUrlStr =  self.url_login;
                LVC.mineUrl = self.main_mine;
                LVC.hidesBottomBarWhenPushed = YES;
                [selectNaVC pushViewController:LVC animated:YES];//用选中的
                return NO;
            }else{//登陆  但是可能会不成功
                MainMineViewController*MainMineVC = [[MainMineViewController alloc]init];
                MainMineVC.title = @"我的";
                MainMineVC.mainUrlStr = self.main_mine;
                [self set:MainMineVC TabarItemImage:@"tab_main_mine" selectedImage:@"tab_main_mine_on"];
                UINavigationController*navc = [self.viewControllers lastObject];
                navc.viewControllers = @[MainMineVC];
                self.selectedIndex = self.viewControllers.count-1;
                [MainMineVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.main_mine]]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogout"];
            }
        }else if([NaVC.viewControllers[0] isKindOfClass:[MainMallViewController class]]){//合发购处理
            self.tabBar.hidden = YES;
            return YES;
        }
    }else {
        if ([viewController isKindOfClass:[SpBaseNavigationController class]] || [viewController isKindOfClass:[BaseNavgationViewController class]]) {
            UINavigationController * NaVC = (UINavigationController*) viewController;
            if ([NaVC.viewControllers[0] isKindOfClass:[SpCartViewController class]] || [NaVC.viewControllers[0] isKindOfClass:[SpMainMineViewController
                                                                                                                                class]]) {
                if (![HFUserDataTools isLogin]) {
//                    HFLoginViewController *vc  = [[HFLoginViewController alloc] init];
//                    vc.delegate = self;
//                    BaseNavgationViewController *nav = [[BaseNavgationViewController alloc] initWithRootViewController:vc];
//                    [self presentViewController:nav animated:YES completion:^{
//
//                    }];
                    [HFLoginViewController showViewController:self];
                    return NO;
                }
 
            }
        }
    }
    return YES;
}
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isSelectMine"];
//    UINavigationController *selectNaVC = self.viewControllers[self.selectedIndex];
//    NSArray *arr = selectNaVC.viewControllers;
//    NSLog(@"%@",arr);
//    if ([viewController isKindOfClass:[RootViewController class]]) {
//        UINavigationController * NaVC = (UINavigationController*) viewController;
//        if ([NaVC.viewControllers[0] isKindOfClass:[MainMineViewController class]]) {//我的/个人中心处理
//
//            NSString *sid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
//           NSString *isLogout = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogout"];
//            if (sid.length>3&&!isLogout) {//有accid 表示已经登录，可以选中
//
//                return YES;
//
//            }else if(sid.length<=3){//未登录不可以选中，直接跳转登录页面
//
//                LocalLoginViewController *LVC = [[LocalLoginViewController alloc]init];
//                LVC.mainUrlStr =  self.url_login;
//                LVC.mineUrl = self.main_mine;
//                LVC.hidesBottomBarWhenPushed = YES;
//                [selectNaVC pushViewController:LVC animated:YES];//用选中的
//                return NO;
//            }else{//登陆  但是可能会不成功
//                MainMineViewController*MainMineVC = [[MainMineViewController alloc]init];
//                MainMineVC.title = @"我的";
//                MainMineVC.mainUrlStr = self.main_mine;
//                [self set:MainMineVC TabarItemImage:@"tab_main_mine" selectedImage:@"tab_main_mine_on"];
//                UINavigationController*navc = [self.viewControllers lastObject];
//                navc.viewControllers = @[MainMineVC];
//                self.selectedIndex = self.viewControllers.count-1;
//                [MainMineVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.main_mine]]];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogout"];
//            }
//        }else if([NaVC.viewControllers[0] isKindOfClass:[MainMallViewController class]]){//合发购处理
//            self.tabBar.hidden = YES;
//            return YES;
//        }
//    }else {
//        if ([viewController isKindOfClass:[SpBaseNavigationController class]] || [viewController isKindOfClass:[BaseNavgationViewController class]]) {
//            UINavigationController * NaVC = (UINavigationController*) viewController;
//            if ([NaVC.viewControllers[0] isKindOfClass:[SpCartViewController class]] || [NaVC.viewControllers[0] isKindOfClass:[MainMineViewController class]]||[NaVC.viewControllers[0] isKindOfClass:[SpOrderViewController class]]) {
//                HMHBasePrimaryViewController *loginVC = [[HMHBasePrimaryViewController alloc] init];
//                if (![loginVC isLogin]) {
//
//                    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
//                    if (tools.pageUrlConfigArrary.count) {
//                        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
//                            if([model.pageTag isEqualToString:@"fy_login"]) {
//
//                                HMHPopAppointViewController *loginVC = [[HMHPopAppointViewController alloc]init];
//                                UINavigationController *MainHomeNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//                                loginVC.urlStr = model.url;
//                                loginVC.isNavigationBarshow = NO;
//                                loginVC.hidesBottomBarWhenPushed = YES;
//                                loginVC.isPresentJump = YES;
//                                if ([NaVC.viewControllers[0] isKindOfClass:[SpCartViewController class]]) {
//                                    loginVC.bCallBackBlock = ^{
//                                        [tabBarController setSelectedIndex:2];
//                                    };
//                                } else if ([NaVC.viewControllers[0] isKindOfClass:[SpOrderViewController class]]){
//                                    loginVC.bCallBackBlock = ^{
//                                        [tabBarController setSelectedIndex:3];
//                                    };
//                                }
//
//                                [self presentViewController:MainHomeNav animated:YES completion:^{
//                                    // [tabBarController setSelectedIndex:2];
//                                }];
//                                return NO;
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    return YES;
//}
- (void)removeLocalData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobilephone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
}
- (void)set:(UIViewController*)VC TabarItemImage:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
    
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (@available(iOS 13.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor grayColor]];
    }
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} forState:UIControlStateSelected];

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    if (!IS_IPHONEX) {
//        UIView *containView = [self.rootView viewWithTag:kContainViewTag];
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             if (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) > 20) {
//                                 self.rootView.height = ScreenH - 20;
//                                 containView.height = ScreenH - _rootView.tab_dock.frame.size.height - 20;
//                             } else {
//                                 self.rootView.height = ScreenH;
//                                 containView.height = ScreenH - _rootView.tab_dock.frame.size.height;
//                             }
//                         }];
   // }
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
