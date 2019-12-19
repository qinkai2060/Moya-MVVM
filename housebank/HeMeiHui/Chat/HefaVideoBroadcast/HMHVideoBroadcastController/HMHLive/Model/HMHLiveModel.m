//
//  HMHLiveModel.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveModel.h"
#import "HMHLivereCommendModel.h"

@implementation HMHLiveModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banner" : [HMHLivereCommendModel class],
             @"modules_news":[HMHLiveModules_newsModel class],
             @"recommend" : [HMHLivereCommendModel class],
             @"modules_4":[HMHLiveModules_4Model class],
             @"short_video" : [HMHLivereCommendModel class],
             @"well_chosen" : [HMHLivereCommendModel class],
             @"live_stream" : [HMHLivereCommendModel class]
             };
}

@end
