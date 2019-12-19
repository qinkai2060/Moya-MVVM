//
//  NavigationContrl.m
//  HeMeiHui
//
//  Created by 任为 on 2017/12/8.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "NavigationContrl.h"
#import "HMHViewController.h"
#import "LocalLoginViewController.h"
#import "MainTabBarViewController.h"
@implementation NavigationContrl

/*
 closePageAfterLaunch = "<null>";
 id = 9;
 naviBg = "<null>";
 naviMaskHeight = 0;
 pageAnimType = 0;
 pageLaunchMode = 1;
 pageTag = "main_home";
 refreshPageAfterLaunch = "<null>";
 showNavi = 0;
 title = "\U9996\U9875";
 url = "https://m.heyoucloud.com/appstatic/appindex/in/index.html";
 */
/**
 0.判断url是否为空，是否合法,否-->return,是-->下一步
 1.判断是否为需要拦截的Scheme，mailto、tel,如果是reture,否-->下一步
 2.判断是否为reload或者刷新，是-->允许刷新，retun，否-->下一步
 3.根据url取出pageTage,过滤掉main——*，url_*（单独处理）,否--->下一步
 4.判断正则匹配，是否能匹配到，是否壳弹窗打开，否--->retun,允许加载，是--->下一步
 5.判断pageTag是否为fy_main*,是-->跳到对应tab,否--->下一步，
 6.判断该页面pageLaunchMode是否为栈内唯一，否--->弹新窗口，是--->下一步
 7.查找现在栈内是否有对应的页面，否--->弹出窗口，是--->下一步
 8.找到对应页面（将之上的页面出栈，刷新当前）
 9.关闭需要关闭的页面、刷新需要刷新的页面
 */
//查找栈内唯一的对象，并返回下标，没有返回-1
/**
 处理新开窗口后的一些处理，包括关闭某些页面、刷新某些页面
 
 @param model 当前新开页面的信息
 @param navigation 当前的导航
 */
+ (void)dealCloseOrRefreshPagesAfterOpenNewPage:(PopAppointViewControllerModel *)model url:(NSString *)url Navigation:(UINavigationController *)navigation lastPageUrl:(NSString *)lastPageUrl{
    
    if ([self findUniPage:url and:navigation]) {//要求栈内唯一，并且已经有该对象
        
        if ([self getpopControllersIndex:model from:navigation]!=-1) {//找到了
            [self removeViewControllers:[self getpopControllersIndex:model from:navigation] navigation:navigation newUrl:url];
        }
    }else{//不要求栈内唯一或者要求栈内唯一，但是栈内没有该对象
        HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
        pvc.title = model.title;
        pvc.naviBg = model.naviBg;
        pvc.isNavigationBarshow = model.showNavi;
        pvc.naviMask = model.naviMask;
        pvc.naviMaskHeight = model.naviMaskHeight;
        pvc.urlStr = url;
        pvc.pageTag = model.pageTag;
        pvc.LastPageUrl = lastPageUrl;
        pvc.hidesBottomBarWhenPushed = YES;
        pvc.hidesBottomBarWhenPushed = YES;
        
//        pvc.isFromVideoWebView = YES;
//        if (self.isFromVideoWebView) { // 是否是来自视频直播中的简介
//            evc.isNavigationBarshow = YES;
//
//            if (self.popVCCallBack) {
//                self.popVCCallBack(evc);
//            }
//        } else {
//            [self.navigationController pushViewController:evc animated:YES];
//        }

        [navigation pushViewController:pvc animated:YES];
    }
    ////关闭相关页面
    NSArray *closeArrary = [model.closePageAfterLaunch componentsSeparatedByString:@","];
    [self navigation:navigation removeViewControllerFromClosePage:closeArrary];
    //刷新相关页面
    NSArray *refreshArrary = [model.refreshPageAfterLaunch componentsSeparatedByString:@","];
    [self refreshPagesAfterLunchPage:refreshArrary and:navigation];
    
/**
 切换tab

 @return 无返回值
 */
}
+ (void)changeTabIndexWith:(mianTab_type)tabType and:(UINavigationController*)navigation and:(NSString *)urlStr and:(PageUrlConfigModel *)pageUrlModel{
   
//    if (![pageUrlModel.url isEqualToString:urlStr]) {
//        BaseViewController *baVC =navigation.viewControllers[0];
//        if ([baVC isKindOfClass:[BaseViewController class]]) {
//            baVC.shouldRefresh = YES;
//            [baVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
//        }
//    }
    switch (tabType) {
        case main_home://首页
            {
                UITabBarController *tab = navigation.tabBarController;
                if (tab.selectedIndex ==0) {
                    [navigation popToRootViewControllerAnimated:YES];
                }else{
                    [navigation popToRootViewControllerAnimated:NO];
                }
                tab.tabBar.hidden = NO;
                tab.selectedIndex = 0;
            }
            break;
        case main_mall://合发购
        {
         
            UITabBarController *tab = navigation.tabBarController;
            if (tab.selectedIndex ==1) {
                [navigation popToRootViewControllerAnimated:YES];
            }else{
                [navigation popToRootViewControllerAnimated:NO];
            }
            tab.tabBar.hidden = YES;
            tab.selectedIndex = 1;
          
        }
            break;
        case main_globalhome://全球家
        {
            UITabBarController *tab = navigation.tabBarController;
            if (tab.selectedIndex ==2) {
                [navigation popToRootViewControllerAnimated:YES];
                tab.tabBar.hidden = NO;
                tab.selectedIndex = 2;
            }else{
                
                [navigation popToRootViewControllerAnimated:NO];
                tab.tabBar.hidden = NO;
                tab.selectedIndex = 2;
            }
            
        }
            break;
        case main_moments://OTO
        {
            UITabBarController *tab = navigation.tabBarController;
            if (tab.selectedIndex == 3) {
                [navigation popToRootViewControllerAnimated:YES];
                tab.tabBar.hidden = NO;
                tab.selectedIndex = 3;
            }else {
                [navigation popToRootViewControllerAnimated:NO];
                tab.tabBar.hidden = NO;
                tab.selectedIndex = 3;
            }
          
        }
            break;
        case main_mine://我的
        {
            MainTabBarViewController *tab =(MainTabBarViewController*) navigation.tabBarController;
            if (tab.selectedIndex ==3) { // 4
                [navigation popToRootViewControllerAnimated:YES];
            }else{
                [navigation popToRootViewControllerAnimated:NO];
            }
            tab.tabBar.hidden = NO;
            NSString *sid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
            if (sid&&sid.length>5) {
                
                tab.selectedIndex = 3;

            }else if (navigation&&navigation.viewControllers.count) {
                tab.selectedIndex = 0;
                UINavigationController *navigation = [tab.viewControllers firstObject];
                LocalLoginViewController *LVC = [[LocalLoginViewController alloc]init];
                LVC.mainUrlStr =  tab.url_login;
                LVC.hidesBottomBarWhenPushed = YES;
                [navigation pushViewController:LVC animated:YES];//用选中的
            }
        }
            break;

        default:
            break;
    }
    
/**
 页面打开后刷新相关页面

 @return 无返回
 */
}
+ (void)refreshPagesAfterLunchPage:(NSArray*)arrary and:(UINavigationController*)navigation{
    NSArray *viewControllers = navigation.viewControllers;
    for (int i=0; i<viewControllers.count; i++) {
        HMHBaseViewController *VC = viewControllers[i];
        if (![VC isKindOfClass:[HMHBaseViewController class]]) {
            continue;
        }
        for (int j=0; j<arrary.count; j++) {
            if ([VC.pageTag isEqualToString:arrary[j]]) {
                
                [VC.webView reload];
            }
            
        }
    }
    
}
+(void)closeLastPage:(UINavigationController*)navigation{
    //fy_mall_goods_order
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:navigation.viewControllers];
    UIViewController *VC = [viewControllers lastObject];
    if ([VC isKindOfClass:[LocalLoginViewController class]]&&viewControllers.count>=3) {
        [viewControllers removeObjectAtIndex:viewControllers.count-2];
        [navigation setViewControllers:viewControllers animated:YES];
    }
}
+ (NSInteger)getpopControllersIndex:(PopAppointViewControllerModel *)model from:(UINavigationController *)navigationController{
    for (int i=0;i<navigationController.viewControllers.count;i++) {
        if([navigationController.viewControllers[i] isKindOfClass:[HMHBaseViewController class]]){
        HMHBaseViewController *baseVC =navigationController.viewControllers[i];
            if (baseVC.pageTag&&[baseVC.pageTag isEqualToString:model.pageTag]) {
                return i;
            }
            if (baseVC.urlStr) {
                PopAppointViewControllerModel *currentmodel = [self getModelFrom:baseVC.urlStr];
                if (currentmodel.pageTag&&[currentmodel.pageTag isEqualToString:model.pageTag]){
                        return i;
                }
            }
        }
    }
    return -1;
}

/**
 根据url获取栈内唯一

 @param urlStr 地址
 @param navigationController 导航
 @return 是否要求栈内唯一，并且栈内是否已经有对象   如果是要求栈内唯一并且有该类的对象return yes,其他return NO
 */
+ (BOOL)findUniPage:(NSString *)urlStr and:(UINavigationController *)navigationController{
    PopAppointViewControllerModel*model = [self getModelFrom:urlStr];
    if (!model) {
        return nil;
    }
    NSArray *viewControllers = navigationController.viewControllers;
    if ([model.pageLaunchMode isEqualToNumber:[NSNumber numberWithInt:1]]){
        for (HMHBaseViewController*VC in viewControllers) {
            if (![VC isKindOfClass:[HMHBaseViewController class]]) {
                continue;
            }
            PopAppointViewControllerModel*BVCmodel = [self getModelFrom:VC.urlStr];
            if ([model.pageTag isEqualToString:BVCmodel.pageTag]) {
                return YES;
            }
        }
    }
    return NO;
}
/**
 根据url获取对应的Model
 
 @param url 页面的url
 @return 对应的model
 */
+ (PopAppointViewControllerModel*)getModelFrom:(NSString*)url{
    PopAppointViewControllerToos*toos = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    for (int i = 0; i<toos.popWindowUrlsArrary.count; i++) {
        PopAppointViewControllerModel*model = toos.popWindowUrlsArrary[i];
        if ([self validateCustomRegex:model.url TargetString:url]) {
       
            return model;
        }
    }
    return nil;
}
+ (PageUrlConfigModel*)getPageurlModelFrom:(NSString *)url{
    if ([url containsString:@"?"]) {
        url = [url componentsSeparatedByString:@"?"][0];
    }
    PopAppointViewControllerToos*toos = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    for (int i = 0; i<toos.pageUrlConfigArrary.count; i++) {
        PageUrlConfigModel*model = toos.pageUrlConfigArrary[i];
        if ([self validateCustomRegex:model.url TargetString:url]) {
            
            return model;
        }
    }
    return nil;
    
}
+ (PageUrlConfigModel *)getPageurlModelByPageTag:(NSString*)pageTag{
    
    PopAppointViewControllerToos*toos = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    for (int i = 0; i<toos.pageUrlConfigArrary.count; i++) {
        PageUrlConfigModel*model = toos.pageUrlConfigArrary[i];
        if ([model.pageTag isEqualToString:pageTag]) {
            return model;
        }
    }
    return nil;
    
}

//查找
+(NSInteger)getTargetViewControllerIndex:(NSString*)tag fromArrary:(NSArray*)viewControllers{
    for (int i=0; i<viewControllers.count; i++) {
        NSString *url = viewControllers[i];
        if ([self validateCustomRegex:tag TargetString:url]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSelfUrl" object:url userInfo:nil];
            return i;
        }
    }
    return -1;
}
//出栈    找到栈内唯一的，移除上面的页面
+(void)removeViewControllers:(NSInteger)index navigation:(UINavigationController*)navigationController newUrl:(NSString*)newUrl{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:navigationController.viewControllers];
    [viewControllers removeObjectsInRange:NSMakeRange(index+1, viewControllers.count-index-1)];
    if (viewControllers.count ==1 ) {
        navigationController.tabBarController.tabBar.hidden = NO;
    }
    HMHBaseViewController *topVC = [viewControllers lastObject];
    if ([topVC isKindOfClass:[HMHBaseViewController class]]) {//出栈到指定页面，并刷新
      //  topVC.webView.
        topVC.shouldRefresh = YES;//不能省略
        [topVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newUrl]]];
    }
    [navigationController setViewControllers:viewControllers animated:YES];
}
//根据closePage出栈
+(void) navigation:(UINavigationController*)NaVC removeViewControllerFromClosePage:(NSArray*)closePage  {
    NSMutableArray *viewControllers =[NSMutableArray arrayWithArray:NaVC.viewControllers] ;
    NSMutableArray *deleteArrary = [NSMutableArray array];
    for (int i=0;i<closePage.count;i++) {//移除需要出栈的页面
        NSString *closeUrl = closePage[i];
        for (HMHBaseViewController*baseVC in viewControllers) {
            if (![baseVC isKindOfClass:[HMHBaseViewController class]]) {
                continue;
            }
            if ([baseVC.pageTag isEqualToString:closeUrl]) {
                [deleteArrary addObject:baseVC];
            }
        }
    }
    [viewControllers removeObjectsInArray:deleteArrary];
    if (viewControllers.count ==1 ) {
        NaVC.tabBarController.tabBar.hidden = NO;
    }
    [NaVC setViewControllers:viewControllers animated:YES];
}
//正则匹配
+ (BOOL)validateCustomRegex:(NSString *)customRegex TargetString:(NSString *)targetString{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",customRegex];
    return [predicate evaluateWithObject:targetString];
}
+(void)postNoticefy:(NSString*)url{
    if ([url isEqualToString:@"NSNULL"]) {
        return;
    }
    NSArray * postArrary = [url componentsSeparatedByString:@","];
    if (postArrary.count) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSelf" object:postArrary];
    }
}
@end
