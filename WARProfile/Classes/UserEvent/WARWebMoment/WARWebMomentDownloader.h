//
//  WARWebMomentDownloader.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//


#import <Foundation/Foundation.h>
#import "WARNewUserDiaryModel.h"
#import "WARWebMomentOperation.h"

#import "WARNetwork.h"
#import "WARMacros.h"

typedef void(^WARWebMomentDownloaderCompletedBlock)(WARNewUserDiaryMoment * _Nullable moment, NSError * _Nullable error, BOOL finished, NSString *momentId);

@interface WARWebMomentDownloadToken : NSObject <WARWebMomentOperation>

@property (nonatomic, strong, nullable) NSString *momentId;
@property (nonatomic, strong, nullable) id downloadOperationCancelToken;

@end


@interface WARWebMomentDownloader : NSObject

+ (nonnull instancetype)sharedDownloader;

- (nullable WARWebMomentDownloadToken *)downloadMomentWithMomentId:(nullable NSString *)momentId
                                                         completed:(nullable WARWebMomentDownloaderCompletedBlock)completedBlock;

@end
