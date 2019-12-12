//
//  WARMomentCacheConfig.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import "WARMomentCacheConfig.h"

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@implementation WARMomentCacheConfig

- (instancetype)init {
    if (self = [super init]) { 
        _shouldCacheMomentInMemory = YES;
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        _maxCacheSize = 0;
    }
    return self;
}


@end
