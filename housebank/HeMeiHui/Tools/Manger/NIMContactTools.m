//
//  NIMContactTools.m
//  HeMeiHui
//
//  Created by 任为 on 2017/11/15.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "NIMContactTools.h"

@implementation NIMContactTools
static NIMContactTools *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)shareTools
{
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

@end
