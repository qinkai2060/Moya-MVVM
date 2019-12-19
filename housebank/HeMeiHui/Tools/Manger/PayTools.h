//
//  PayTools.h
//  HeMeiHui
//
//  Created by 任为 on 2016/12/28.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <BeeCloud.h>
#import "BeeModel.h"
#import "appIDModel.h"
#import "WXApi.h"
@protocol payToolDelegete <NSObject>
- (void)show:(UIViewController*)viewController;


@end


@interface PayTools : NSObject
@property (nonatomic,strong)BeeModel* model;
@property (nonatomic,strong)appIDModel* appIdmodel;

@property (nonatomic, strong)NSDictionary *optional;
@property (nonatomic, strong)id  <payToolDelegete,BeeCloudDelegate>delegete;
- (void)doPayWith:(id)body;

@end
