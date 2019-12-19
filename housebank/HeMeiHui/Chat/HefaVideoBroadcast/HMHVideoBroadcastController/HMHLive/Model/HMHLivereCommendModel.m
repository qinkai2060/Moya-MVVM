//
//  HMHLivereCommendModel.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLivereCommendModel.h"
#import "HMHliveParamsModel.h"

@implementation HMHLivereCommendModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"wd_id" : @"id"
             };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"params" : [HMHliveParamsModel class],
             
             };
}

- (NSString *)wd_id {
    //处理空格
    if (_wd_id) {
        return [_wd_id stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return nil;
}



@end
