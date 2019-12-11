//
//  WARMomentCacheConfig.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import <Foundation/Foundation.h>

@interface WARMomentCacheConfig : NSObject

@property (assign, nonatomic) BOOL shouldCacheMomentInMemory;

/**
 * The maximum length of time to keep an image in the cache, in seconds.
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

@end
