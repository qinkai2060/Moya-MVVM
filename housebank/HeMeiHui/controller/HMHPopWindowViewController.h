//
//  PopWindowViewController.h
//  HeMeiHui
//
//  Created by 任为 on 2017/5/9.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBaseViewController.h"
#import "PopAppointViewControllerToos.h"
#import "HMHExternalDomViewControoler.h"
#import "HMHPopAppointViewController.h"

@interface HMHPopWindowViewController :HMHBaseViewController
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *naTitle;
@property (nonatomic,assign) BOOL isShowNaBar ;
@property (nonatomic, copy) NSString *BgColor;
@property (nonatomic, assign)BOOL naviMask;
@property (nonatomic, assign) CGFloat naviMaskHeight;
@property (nonatomic,strong) PopAppointViewControllerToos *popTool;


@end
