//
//  PrefixHeader.h
//  housebank
//
//  Created by Qianhong Li on 2017/11/8.
//  Copyright © 2017年 hefa. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import "ManagerTools.h"
#import "UIView+NIM.h"
#import "UIView+NTES.h"
#import <UIImageView+WebCache.h>
#import "UIColor+Hex.h"
#import "AppDelegate.h"

#define productionEnvironment @"https://mall-api.fybanks.com"
#define testEnvironment  @"https://mall-api.fybanks.cn"
#define preEnvironment @"https://mall-api.heyoucloud.com"
#define XUEnvironment  @"http://192.168.0.77:10200"
#define NewproductionEnvironment @"https://mall-api.hfbing.com" // 新的域名

/** 屏幕宽度 */
#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define kSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
/** RGB颜色 */
#define kRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kAppdelegate (AppDelegate *)([UIApplication sharedApplication].delegate)


#endif /* PrefixHeader_h */
