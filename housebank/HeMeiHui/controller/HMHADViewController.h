//
//  ADViewController.h
//  HeMeiHui
//
//  Created by 任为 on 2016/10/28.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBaseViewController.h"

@interface HMHADViewController : UIViewController
@property (nonatomic,copy)NSString *HMH_urlStr;
@property (nonatomic, copy) NSString *HMH_color;
@property (nonatomic, assign) BOOL HMH_isShowNavi;
@property (nonatomic, copy) NSString *HMH_uid;
@property (nonatomic, copy)NSString *HMH_name;

@end
