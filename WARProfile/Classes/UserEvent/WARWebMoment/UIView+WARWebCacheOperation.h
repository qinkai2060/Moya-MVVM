//
//  UIView+WARWebCacheOperation.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import <UIKit/UIKit.h>
#import "WARWebMomentOperation.h"

@interface UIView (WARWebCacheOperation)

- (void)war_setMomentLoadOperation:(nullable id<WARWebMomentOperation>)operation forKey:(nullable NSString *)key;
- (void)war_cancelMomentLoadOperationWithKey:(nullable NSString *)key;

@end
