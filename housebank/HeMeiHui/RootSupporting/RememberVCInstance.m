//
//  RememberVC.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "RememberVCInstance.h"

@implementation RememberVCInstance
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static RememberVCInstance *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[RememberVCInstance alloc] init];
        instance.goOutVC=nil;
    });
    return instance;
}

@end
