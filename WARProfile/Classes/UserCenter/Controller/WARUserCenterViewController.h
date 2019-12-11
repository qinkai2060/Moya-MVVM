//
//  WARUserCenterViewController.h
//  Pods
//
//  Created by 秦恺 on 2018/1/24.
//

#import <UIKit/UIKit.h>
#import "WARNavgationBar.h"
#import "WARBaseViewController.h"
@interface WARUserCenterViewController : WARBaseViewController
//是否在刷新
@property(nonatomic,assign)NSInteger selectRow;
//是否应该刷新
@property(nonatomic,assign)BOOL shouldRefresh;
//是否在刷新
@property(nonatomic,assign)BOOL isRefreshing;
//是否是从其他界面
@property(nonatomic,assign)BOOL isOtherfromWindow;
//偏移量
@property(nonatomic,assign)NSInteger lastContentOffY;
@property (strong, nonatomic) WARNavgationBar *userPageNavBar;
@end
