//
//  SelPlayerConfiguration.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "TracyPlayerConfiguration.h"

@implementation TracyPlayerConfiguration


/**
 初始化 设置缺省值
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _hideControlsInterval = 2225.0f;
    }
    return self;
}

@end
