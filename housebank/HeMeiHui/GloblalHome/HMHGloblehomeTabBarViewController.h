//
//  HMHGloblehomeTabBarViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/11.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpBaseTabBarViewController.h"
#import "SpBaseNavigationController.h"
#import "BaseNavigationController.h"
#import "HMHGloblaHomeViewController.h"
#import "HFShouYinViewController.h"
#import "LocalLoginViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMHGloblehomeTabBarViewController :SpBaseTabBarViewController
@property (nonatomic, strong)BaseNavigationController *GloblaHomeNav;
@property (nonatomic, strong)HMHGloblaHomeViewController *GloblaHomeVC;
@property (nonatomic, strong)HFShouYinViewController *CollectionVC;
@property (nonatomic, strong)HFShouYinViewController *OrderVC;
@property (nonatomic, strong)HFShouYinViewController *AirTicketVC;

@end

NS_ASSUME_NONNULL_END
