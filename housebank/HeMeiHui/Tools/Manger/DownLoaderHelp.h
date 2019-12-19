//
//  DownLoaderHelp.h
//  HeMeiHui
//
//  Created by 任为 on 2016/12/27.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <SDWebImageDownloaderOperation.h>

#define adImageArraryName "adImageArraryName"
#define adImageArraryLink "adImageArraryLink"

@interface DownLoaderHelp : NSObject
+ (void)saveADImageWithUrlStr:(NSArray*)urlArr;

@end
