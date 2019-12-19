//
//  HFDBHandler.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFDBHandler : NSObject
+ (void)cacheData:(NSDictionary*)dict;
+ (void)cacheLoginData:(NSDictionary*)dict;
+ (NSDictionary*)selectData;
+ (NSDictionary*)selectLoginData;
@end

NS_ASSUME_NONNULL_END
