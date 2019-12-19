//
//  PageUrlConfigModel.h
//  HeMeiHui
//
//  Created by 任为 on 2018/1/16.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 pageTag = "fy_main_home";
 tabbarName = main;
 url = "https://m.fybanks.cn/appstatic/appindex/in/index.html";
 */
@interface PageUrlConfigModel : NSObject
@property (nonatomic,copy)NSString *pageTag;
@property (nonatomic,copy)NSString *tabbarName;
@property (nonatomic,copy)NSString *url;
@end
