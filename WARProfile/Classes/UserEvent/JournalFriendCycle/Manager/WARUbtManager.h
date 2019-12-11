//
//  WARUbtManager.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/23.
//

#import <Foundation/Foundation.h>
#import "WARUbtParam.h"

/**
 行为采集管理
 */
@interface WARUbtManager : NSObject

+ (void)buryPointWithUbtParam:(WARUbtParam *)ubtParam compeletion:(void (^)(BOOL success, NSError *err))compeletion;;

@end
