//
//  HFWebImageManager.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYWebImageManager.h>
#import <PINRemoteImage/PINRemoteImage.h>
NS_ASSUME_NONNULL_BEGIN



@interface HFWebImageManager : PINRemoteImageManager<ASImageCacheProtocol, ASImageDownloaderProtocol>

@end

NS_ASSUME_NONNULL_END
