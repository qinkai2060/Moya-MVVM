//
//  ExternalDomViewControoler.h
//  testViewController
//
//  Created by Qianhong Li on 2017/10/26.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopAppointViewControllerToos.h"
#import "HMHBaseViewController.h"

@interface HMHExternalDomViewControoler : HMHBaseViewController
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *naTitle;
@property (nonatomic,assign) BOOL isNavigationBarshow ;
@property (nonatomic, strong)NSString *naviBg;
@property (nonatomic,strong) PopAppointViewControllerToos *popTool;
@property (nonatomic, assign)BOOL naviMask;
@property (nonatomic, assign) CGFloat naviMaskHeight;

// 是否是来自视频直播的web跳转
@property (nonatomic, assign) BOOL isPushFromVideoWeb;

@end
