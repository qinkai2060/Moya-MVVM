//
//  WARWebCellManager.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif


#import "WARWebMomentManager.h"

@interface WARWebMomentCombinedOperation : NSObject <WARWebMomentOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (strong, nonatomic, nullable) WARWebMomentDownloadToken *downloadToken;
@property (strong, nonatomic, nullable) NSOperation *cacheOperation;
@property (weak, nonatomic, nullable) WARWebMomentManager *manager;

@end

@implementation WARWebMomentCombinedOperation

- (void)cancel {
     
}

@end


@interface WARWebMomentManager()

@property (strong, nonatomic, readwrite, nonnull) WARMomentCache *momentCache;
@property (strong, nonatomic, readwrite, nonnull) WARWebMomentDownloader *momentDownloader;
@property (strong, nonatomic, nonnull) NSMutableSet<NSString *> *failedURLs;
@property (strong, nonatomic, nonnull) NSMutableArray<WARWebMomentCombinedOperation *> *runningOperations;

@end

@implementation WARWebMomentManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    WARMomentCache *cache = [WARMomentCache sharedMomentCache];
    WARWebMomentDownloader *downloader = [WARWebMomentDownloader sharedDownloader];
    return [self initWithCache:cache downloader:downloader];
}

- (nonnull instancetype)initWithCache:(nonnull WARMomentCache *)cache downloader:(nonnull WARWebMomentDownloader *)downloader {
    if ((self = [super init])) {
        _momentCache = cache;
        _momentDownloader = downloader;
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (nullable NSString *)cacheKeyForMomentId:(nullable NSString *)momentId {
    if (!momentId) {
        return @"";
    }
    
//    if (self.cacheKeyFilter) {
//        return self.cacheKeyFilter(url);
//    } else {
        return momentId;
//    }
}


#pragma mark - load

- (id <WARWebMomentOperation>)loadMomentWithMomentId:(nullable NSString *)momentId
                                           completed:(nullable WARInternalCompletionBlock)completedBlock {
    
    if (![momentId isKindOfClass:[NSString class]]) {
        momentId = nil;
    }
    
    WARWebMomentCombinedOperation *operation = [WARWebMomentCombinedOperation new];
    operation.manager = self;
    
    BOOL isFailedUrl = NO;
    if (momentId) {
        @synchronized (self.failedURLs) {
            isFailedUrl = [self.failedURLs containsObject:momentId];
        }
    }
    
    if (momentId.length == 0 || isFailedUrl) {
        [self callCompletionBlockForOperation:operation completion:completedBlock moment:nil error:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil] cacheType:0 finished:YES momentId:momentId];
        return operation;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    NSString *key = [self cacheKeyForMomentId:momentId];
    
    __weak WARWebMomentCombinedOperation *weakOperation = operation;
    //缓存查找
    [self.momentCache queryCacheOperationForKey:key done:^(WARNewUserDiaryMoment * _Nullable cacheMoment, NSData * _Nullable data, WARMomentCacheType cacheType) {
        __strong __typeof(weakOperation) strongOperation = weakOperation;
        if (!strongOperation || strongOperation.isCancelled) {
            [self safelyRemoveOperationFromRunning:strongOperation];
            return;
        }
        
        BOOL shouldDownload = (cacheMoment == nil);
        //未命中缓存，去网络加载
        if (shouldDownload) {
            strongOperation.downloadToken = [self.momentDownloader downloadMomentWithMomentId:momentId completed:^(WARNewUserDiaryMoment * _Nullable moment, NSError * _Nullable error, BOOL finished, NSString *momentId) {
                if (moment && finished) {
                    //加入内存
                    [self.momentCache storeMoment:moment forKey:momentId completion:nil];
                }
                
                //返回结果
                if (completedBlock) {
                    [self callCompletionBlockForOperation:strongOperation completion:completedBlock moment:moment error:nil cacheType:cacheType finished:YES momentId:momentId];
                }
                
                if (finished) {
                    [self safelyRemoveOperationFromRunning:strongOperation];
                }
            }];
        } else {
            //命中缓存，直接返回
            [self callCompletionBlockForOperation:strongOperation completion:completedBlock moment:cacheMoment error:nil cacheType:cacheType finished:YES momentId:momentId];
            [self safelyRemoveOperationFromRunning:strongOperation];
        }
    }];
    
    return operation;
}

- (void)callCompletionBlockForOperation:(nullable WARWebMomentCombinedOperation*)operation
                             completion:(nullable WARInternalCompletionBlock)completionBlock
                                  moment:(nullable WARNewUserDiaryMoment *)moment
                                  error:(nullable NSError *)error
                              cacheType:(WARMomentCacheType)cacheType
                               finished:(BOOL)finished
                               momentId:(nullable NSString *)momentId {
    dispatch_main_async_safe(^{
        if (operation && !operation.isCancelled && completionBlock) {
            completionBlock(moment, error, cacheType, finished, momentId);
        }
    });
}

- (void)safelyRemoveOperationFromRunning:(nullable WARWebMomentCombinedOperation*)operation {
    @synchronized (self.runningOperations) {
        if (operation) {
            [self.runningOperations removeObject:operation];
        }
    }
}

@end
