//
//  HMHLiveMoreHeaderModel.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveMoreHeaderModel.h"

@implementation HMHLiveMoreHeaderModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"live_stream_header" : [HMHLiveMoreModel class],
             @"well_chosen_header" : [HMHLiveMoreModel class],
             @"short_video_header" : [HMHLiveMoreModel class],
             @"recommend_header" : [HMHLiveMoreModel class]
             };
}

@end
