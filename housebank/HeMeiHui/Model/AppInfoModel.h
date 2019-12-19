//
//  AppInfoModel.h
//  HeMeiHui
//
//  Created by 任为 on 2016/11/14.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "iosVersionCode": "2.0.2",
 "iosUpInfo": "1,修复未知bug",
 "forceUpgrade": 1
 
 */

@interface AppInfoModel : NSObject

@property (nonatomic,copy)NSString *iosVersionCode;
@property (nonatomic,copy)NSString *iosUpInfo;
@property (nonatomic,assign)NSInteger  forceUpgrade;
//空（不传）或者1：开启     其他值：关闭
@property (nonatomic, strong) NSString *momentsSwitch;

@property (nonatomic, strong) NSString *imageServerUrl;

@end
