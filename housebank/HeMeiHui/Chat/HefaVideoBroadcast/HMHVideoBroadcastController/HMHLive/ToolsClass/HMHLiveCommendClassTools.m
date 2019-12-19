//
//  HMHLiveCommendClassTools.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveCommendClassTools.h"

@implementation HMHLiveCommendClassTools

+ (instancetype)shareManager {
    static id _manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manger = [self new];
    });
    return (HMHLiveCommendClassTools *)_manger;
}

@end
