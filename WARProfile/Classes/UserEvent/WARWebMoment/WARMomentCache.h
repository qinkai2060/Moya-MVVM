//
//  WARMomentCache.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import <Foundation/Foundation.h>
#import "WARMomentCacheConfig.h"
#import "WARNewUserDiaryModel.h"

typedef NS_ENUM(NSInteger, WARMomentCacheType) {
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    WARMomentCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    WARMomentCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    WARMomentCacheTypeMemory
};


typedef NS_OPTIONS(NSUInteger, WARMomentCacheOptions) {
    /**
     * By default, we do not query disk data when the image is cached in memory. This mask can force to query disk data at the same time.
     */
    WARMomentCacheQueryDataWhenInMemory = 1 << 0,
    /**
     * By default, we query the memory cache synchronously, disk cache asynchronously. This mask can force to query disk cache synchronously.
     */
    WARMomentCacheQueryDiskSync = 1 << 1
};



typedef void(^WARCacheQueryCompletedBlock)(WARNewUserDiaryMoment * _Nullable moment, NSData * _Nullable data, WARMomentCacheType cacheType);
typedef void(^WARWebMomentCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);
typedef void(^WARCacheQueryNoParamsBlock)(void);

@interface WARMomentCache : NSObject

+ (nonnull instancetype)sharedMomentCache;

@property (nonatomic, nonnull, readonly) WARMomentCacheConfig *config;

- (NSOperation *)queryCacheOperationForKey:(NSString *)key done:(WARCacheQueryCompletedBlock)doneBlock; 

- (void)storeMoment:(nullable WARNewUserDiaryMoment *)moment
             forKey:(nullable NSString *)key
         completion:(nullable WARCacheQueryNoParamsBlock)completionBlock;
@end
