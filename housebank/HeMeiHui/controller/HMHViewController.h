//
//  ViewController.h
//  HeMeiHui
//
//  Created by 任为 on 16/9/19.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBaseViewController.h"
#import "PopAppointViewControllerToos.h"
#import "HMHPopAppointViewController.h"
#import <MJRefresh.h>

@class MainTabBarViewController;
@interface HMHViewController : HMHBaseViewController
@property (nonatomic,copy)NSString *mainUrlStr;
@property (nonatomic,copy)NSString *naTitle;
@property (nonatomic,assign) BOOL isNavigationBarHidden ;
@property (nonatomic,strong) PopAppointViewControllerToos *popTool;

- (void)webViewLoadDatafromMainUrl:(NSString*)mainUrlStr;
- (void)afterScan:(NSString *)ScanStr funcName:(NSString *)funName;
@end

