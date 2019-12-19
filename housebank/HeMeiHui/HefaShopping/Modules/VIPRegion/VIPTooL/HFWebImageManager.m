//
//  HFWebImageManager.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFWebImageManager.h"

@implementation HFWebImageManager


- (id)downloadImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue downloadProgress:(ASImageDownloaderProgress)downloadProgress completion:(ASImageDownloaderCompletion)completion{
    @autoreleasepool {
        PINRemoteImageManager *manager1 = [PINRemoteImageManager sharedImageManager];
        
        return     [manager1 downloadImageWithURL:URL completion:^(PINRemoteImageManagerResult * _Nonnull result) {
            completion(result.image,result.error,result.UUID);
        }];;
    }
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier {
    if (![downloadIdentifier isKindOfClass:[NSUUID class]]) {
        return;
    }
    [[PINRemoteImageManager sharedImageManager] cancelTaskWithUUID:downloadIdentifier];
}



- (void)cachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion {

    [[PINRemoteImageManager sharedImageManager] imageFromCacheWithURL:URL processorKey:nil options:PINRemoteImageManagerDownloadOptionsNone completion:^(PINRemoteImageManagerResult * _Nonnull result) {
        if (result.image) {
            dispatch_async(callbackQueue, ^{
                completion(result.image);
            });
        }else {
            dispatch_async(callbackQueue, ^{
                [[PINRemoteImageManager sharedImageManager] downloadImageWithURL:URL completion:^(PINRemoteImageManagerResult * _Nonnull result) {
                    completion(result.image);
                }];
            });
        }
        
    }];
}

@end
