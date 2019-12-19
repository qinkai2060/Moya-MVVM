//
//  HMHGloblehomeTabBarViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/11.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHGloblehomeTabBarViewController.h"

@interface HMHGloblehomeTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation HMHGloblehomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    [self creatSubNavController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self);
    self.GloblaHomeVC.appearblock = ^{
        @strongify(self);
        [self.navigationController.navigationBar setHidden:YES];
    };
    

    
    self.CollectionVC.appearblock = ^{
        @strongify(self);
        [self.navigationController.navigationBar setHidden:YES];
    };
    self.AirTicketVC.appearblock = ^{
            @strongify(self);
            [self.navigationController.navigationBar setHidden:YES];
        };
    self.OrderVC.appearblock = ^{
        @strongify(self);
        [self.navigationController.navigationBar setHidden:YES];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification) name:@"appearNo" object:nil];
}

//实现方法
-(void)notification{
   [self.navigationController.navigationBar setHidden:YES];
}
//初始化控制器
-(void)creatSubNavController
{
    //全球家首页
//    self.GloblaHomeNav =[[BaseNavigationController alloc] initWithRootViewController:self.GloblaHomeVC];
    self.GloblaHomeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    self.GloblaHomeNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self set:self.GloblaHomeVC TabarItemImage:@"index" selectedImage:@"Category_2"];
//    /html/home/#/global/hoteldetails 详情页
//    /html/home/#/global/collection 全球家收藏
//    html/home/#/my/orderlist?orderBizCategory=P_BIZ_CATEGORY_DD&orderState=-1 全球家订单
        self.AirTicketVC.isMore=YES;
    WEAKSELF
    //支付成功 酒店预订 和 更多酒店
    self.AirTicketVC.pushBlock = ^(GlobleHomePushBlockType pushBlockType, NSDictionary * _Nonnull dic) {
        [weakSelf globleHomePushBlockActionPushBlockType:pushBlockType dic:dic];
    };
        [self.AirTicketVC setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/html/home/#/plane?tabar=1"]];//

//        BaseNavigationController *airTicketNav = [[BaseNavigationController alloc] initWithRootViewController:self.AirTicketVC];

        self.AirTicketVC.tabBarItem.title=@"机票";
        [self set:self.AirTicketVC TabarItemImage:@"icon_fj_h" selectedImage:@"icon_fj_select"];

    
    
    /*收藏*/
    self.CollectionVC.fromeSource=@"globleOrderVC";
    self.CollectionVC.isMore=YES;
    [self.CollectionVC setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/html/home/#/global/collection"]];
    
    
//    BaseNavigationController *spCollectionNav = [[BaseNavigationController alloc] initWithRootViewController:self.CollectionVC];
    
    self.CollectionVC.tabBarItem.title=@"收藏";
    [self set:self.CollectionVC TabarItemImage:@"like" selectedImage:@"like_fill"];
    
    /*订单*/
    self.OrderVC.fromeSource=@"globleOrderVC";
    self.OrderVC.isMore=YES;
    //支付成功 酒店预订 和 更多酒店
    self.OrderVC.pushBlock = ^(GlobleHomePushBlockType pushBlockType, NSDictionary * _Nonnull dic) {
        [weakSelf globleHomePushBlockActionPushBlockType:pushBlockType dic:dic];
    };

    [self.OrderVC setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/html/home/#/global/order"]];
    

//    BaseNavigationController *spOrderNav = [[BaseNavigationController alloc] initWithRootViewController:self.OrderVC];
    self.OrderVC.tabBarItem.title=@"订单";
    [self set:self.OrderVC TabarItemImage:@"order" selectedImage:@"order_active"];
    
//     NSArray *viewControllers = @[self.GloblaHomeVC ,self.CollectionVC,self.OrderVC];
    NSArray *viewControllers = @[self.GloblaHomeVC, self.AirTicketVC,self.CollectionVC,self.OrderVC];
    self.viewControllers = viewControllers;
}
- (void)globleHomePushBlockActionPushBlockType:(GlobleHomePushBlockType)pushBlockType dic:(NSDictionary *)dic{
    switch (pushBlockType) {
        case GlobleHomePushBlockTypeHotel://酒店首页
        {
            self.selectedIndex = 0;
        }
            break;
        case GlobleHomePushBlockTypeHotelList://酒店列表
        {
            self.GloblaHomeVC.isPushList = YES;
            self.GloblaHomeVC.pushListDic = dic;
            self.selectedIndex = 0;
            
        }
            break;
        case GlobleHomePushBlockTypeOrderList://订单列表
        {
            self.selectedIndex = 3;
            [self.OrderVC refrensh];
            
        }
            break;
            
        default:
            break;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (void)set:(UIViewController*)VC TabarItemImage:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
     
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (@available(iOS 13.0, *)) {
         [[UITabBar appearance] setUnselectedItemTintColor:[UIColor grayColor]];
     }
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FF6600"]} forState:UIControlStateSelected];
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController{
//    UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
//    UINavigationController *selectNaVC = self.viewControllers[self.selectedIndex];
//    NSArray *arr = selectNaVC.viewControllers;

    UIViewController * NaVC = viewController;
    if ([viewController isKindOfClass:[HMHGloblaHomeViewController class]]) {//全球家首页
        self.GloblaHomeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.GloblaHomeVC.tabBarItem.title=@"";
        return YES;
    }
    else if (viewController == self.AirTicketVC) {
        NSLog(@"机票不登录");
        self.GloblaHomeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.GloblaHomeVC.tabBarItem.title=@"首页";
    }
    else
    {
        if (!self.isLogin) {//如果没登录则先去登陆
            
            return NO;
        }
        self.GloblaHomeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.GloblaHomeVC.tabBarItem.title=@"首页";
        return YES;
    }
    
    return YES;
}

#pragma mark -- lazy load
- (HMHGloblaHomeViewController *)GloblaHomeVC {
    if (!_GloblaHomeVC) {
        _GloblaHomeVC = [[HMHGloblaHomeViewController alloc]init];
    }
    return _GloblaHomeVC;
}

- (HFShouYinViewController *)CollectionVC {
    if (!_CollectionVC) {
        _CollectionVC = [[HFShouYinViewController alloc]init];
    }
    return _CollectionVC;
}

- (HFShouYinViewController *)OrderVC {
    if (!_OrderVC) {
        _OrderVC = [[HFShouYinViewController alloc]init];
    }
    return _OrderVC;
}

- (HFShouYinViewController *)AirTicketVC {
    if (!_AirTicketVC) {
        _AirTicketVC = [[HFShouYinViewController alloc]init];
    }
    return _AirTicketVC;
}
@end
