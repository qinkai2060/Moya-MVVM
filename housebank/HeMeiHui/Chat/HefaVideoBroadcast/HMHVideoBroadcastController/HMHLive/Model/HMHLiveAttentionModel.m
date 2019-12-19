//
//  HMHLiveAttentionModel.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveAttentionModel.h"

@implementation HMHLiveAttentionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"wd_id" : @"id"
             };
}

- (NSString *)vno {
    //处理空格
    if (_vno) {
        return [_vno stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return nil;
}

@end
