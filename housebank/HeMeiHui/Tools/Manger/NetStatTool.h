//
//  NetStatTool.h
//  HeMeiHui
//
//  Created by 任为 on 2016/12/27.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol NetStateDelegete <NSObject>

@required

- (void)NetStateChanged:(NSInteger)state;

@end

@interface NetStatTool : NSObject

@property(nonatomic,weak)id <NetStateDelegete>delegete;

- (void)NetWorkReachablity;


@end
