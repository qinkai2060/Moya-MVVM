//
//  WARWebCellManager.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import <Foundation/Foundation.h>
#import "WARMomentCache.h"
#import "WARWebMomentDownloader.h"
#import "WARWebMomentOperation.h"
#import "WARNewUserDiaryModel.h"

typedef void(^WARInternalCompletionBlock)(WARNewUserDiaryMoment * _Nullable moment, NSError * _Nullable error, WARMomentCacheType cacheType, BOOL finished, NSString * _Nullable momentId);


@interface WARWebMomentManager : NSObject

+ (nonnull instancetype)sharedManager;
 
@property (strong, nonatomic, readonly, nullable) WARMomentCache *momentCache;
@property (strong, nonatomic, readonly, nullable) WARWebMomentDownloader *momentDownloader;

#pragma mark - load

- (id <WARWebMomentOperation>)loadMomentWithMomentId:(nullable NSString *)momentId
                                           completed:(nullable WARInternalCompletionBlock)completedBlock ;
@end
