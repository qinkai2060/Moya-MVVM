//
//  MainTabBarViewController.h
//  UPYUNShortVideo
//
//  Created by Qianhong Li on 2017/11/30.
//  Copyright © 2017年 upyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHomeViewController.h"
#import "MainMallViewController.h"
#import "MainMomentsViewController.h"
#import "MainMineViewController.h"
#import "MainGlobalHomeViewController.h"
#import "RootViewController.h"
#import "ManagerTools.h"
#import "LocalLoginViewController.h"
#import "NIMContactTools.h"

#import "HMHVideoHomeViewController.h"


@interface MainTabBarViewController : UITabBarController
@property (nonatomic,copy)NSString *main_home_url;
@property (nonatomic,copy)NSString *main_mall_url;
@property (nonatomic,copy)NSString *main_globalhome_url;
@property (nonatomic,copy)NSString *main_moments_url;
@property (nonatomic,copy)NSString *main_mine;
@property (nonatomic,copy)NSString *url_login;
//VideoHomeViewController.h
//@property (nonatomic, strong)VideoHomeViewController *homeVC;

@property (nonatomic, strong)MainHomeViewController *homeVC;
@property (nonatomic, strong)MainMallViewController *mallVC;
@property (nonatomic, strong)MainGlobalHomeViewController *GlobalHomeVC;
@property (nonatomic, strong)MainMineViewController *MineVC;
@property (nonatomic, strong)MainMomentsViewController *MainMomentVC;

@end
