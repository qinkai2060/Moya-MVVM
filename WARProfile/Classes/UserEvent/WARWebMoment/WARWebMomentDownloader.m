//
//  WARWebMomentDownloader.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import "WARWebMomentDownloader.h"
#import "MJExtension.h"

#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"
#import "WARNewUserDiaryMomentLayout.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@implementation WARWebMomentDownloadToken

- (void)cancel {
    
}

@end

@interface WARWebMomentDownloader()

@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;
@property (weak, nonatomic, nullable) NSOperation *lastAddedOperation;
@property (assign, nonatomic, nullable) Class operationClass;
//@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, SDWebImageDownloaderOperation *> *URLOperations;
@property (strong, nonatomic, nonnull) dispatch_semaphore_t operationsLock; // a lock to keep the access to `URLOperations` thread-safe
// The session in which data tasks will run
@property (strong, nonatomic) NSURLSession *session;


@end

@implementation WARWebMomentDownloader

+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration {
    if ((self = [super init])) {
//        _operationClass = [SDWebImageDownloaderOperation class];
//        _shouldDecompressImages = YES;
//        _executionOrder = SDWebImageDownloaderFIFOExecutionOrder;
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _downloadQueue.name = @"com.wanlan.WARWebMomentDownloader";
//        _URLOperations = [NSMutableDictionary new];
        _operationsLock = dispatch_semaphore_create(1);
//        _downloadTimeout = 15.0;
        
//        [self createNewSessionWithConfiguration:sessionConfiguration];
    }
    return self;
}
- (nullable WARWebMomentDownloadToken *)downloadMomentWithMomentId:(nullable NSString *)momentId
                                                 completed:(nullable WARWebMomentDownloaderCompletedBlock)completedBlock {
 
    if (momentId == nil) {
        if (completedBlock) {
            completedBlock(nil,nil,YES,momentId);
        }
    }
    
    LOCK(self.operationsLock);
    /** ======================================================= */
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/list/specify", kDomainNetworkUrl];
    [WARNetwork postDataFromURI:uri params:@[momentId] completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        
        if (!err) {
            if (completedBlock) {
                //(WARNewUserDiaryMoment * _Nullable moment, NSError * _Nullable error, BOOL finished);
                NSArray <WARNewUserDiaryMoment *> *momentArray = [WARNewUserDiaryMoment mj_objectArrayWithKeyValuesArray:responseObj];
                if (momentArray.count > 0) {
                    WARNewUserDiaryMoment *moment = momentArray.firstObject;
  
                    WARNewUserDiaryMomentLayout <WARFeedModelProtocol>* momentLayout = [[WARNewUserDiaryMomentLayout alloc] init];
                    
                    NSMutableArray *pageLayouts = [NSMutableArray array];
                    NSMutableArray *limitFeedLayoutArr = [NSMutableArray array];
                    for (WARFeedPageModel *pageM in moment.pageContents) {
                        WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                        [layout configComponentLayoutsWithPage:pageM
                                                  contentScale:kContentScale
                                                    momentShowType:WARMomentShowTypeUserDiary
                                                  isMultilPage:moment.pageContents.count > 1];
                        [pageLayouts addObject:layout];
                        
                        if (limitFeedLayoutArr.count < 3){
                            [limitFeedLayoutArr addObject:layout];
                        }
                    }
                    momentLayout.limitFeedLayoutArr = limitFeedLayoutArr;
                    momentLayout.feedLayoutArr = pageLayouts;
                    moment.momentLayout = momentLayout;
                    
                    momentLayout.currentPageIndex = 0;
                    momentLayout.moment = moment;
                    
                    completedBlock(moment,nil,YES,momentId);
                } else {
                    completedBlock(nil,nil,YES,momentId);
                }
            }
        } else {
            if (completedBlock) {
                //(WARNewUserDiaryMoment * _Nullable moment, NSError * _Nullable error, BOOL finished);
                completedBlock(nil,err,YES,momentId);
            }
        }
    }];
    /** ======================================================= */
    UNLOCK(self.operationsLock);
    
    WARWebMomentDownloadToken *token = [WARWebMomentDownloadToken new];
//    token.downloadOperation = operation;
    token.momentId = momentId;
//    token.downloadOperationCancelToken = downloadOperationCancelToken;
     
    return token;
}

- (void)analysisMoment:(WARNewUserDiaryMoment *)moment {
    WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [[WARFriendMomentLayout alloc] init];
    
    NSMutableArray *pageLayouts = [NSMutableArray array];
    for (WARFeedPageModel *pageM in moment.pageContents) {
        WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
        layout.page = pageM;
        [pageLayouts addObject:layout];
    }
    friendMomentLayout.feedLayoutArr = pageLayouts;
    moment.friendMomentLayout = friendMomentLayout;
    
    friendMomentLayout.currentPageIndex = 0;
    friendMomentLayout.moment = moment;
}

@end
