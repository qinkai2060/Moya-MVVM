//
//  UIView+WARWebCacheOperation.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import "UIView+WARWebCacheOperation.h"
#import <objc/runtime.h>

static char loadOperationKey;

typedef NSMapTable<NSString *, id<WARWebMomentOperation>> WAROperationsDictionary;

@implementation UIView (WARWebCacheOperation)

- (WAROperationsDictionary *)war_operationDictionary {
    @synchronized(self) {
        WAROperationsDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
        if (operations) {
            return operations;
        }
        operations = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
        objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return operations;
    }
}

- (void)war_setMomentLoadOperation:(nullable id<WARWebMomentOperation>)operation forKey:(nullable NSString *)key {
    if (key) {
        [self war_cancelMomentLoadOperationWithKey:key];
        if (operation) {
            WAROperationsDictionary *operationDictionary = [self war_operationDictionary];
            @synchronized (self) {
                [operationDictionary setObject:operation forKey:key];
            }
        }
    }
}

- (void)war_cancelMomentLoadOperationWithKey:(nullable NSString *)key {
    // Cancel in progress downloader from queue
    WAROperationsDictionary *operationDictionary = [self war_operationDictionary];
    id<WARWebMomentOperation> operation;
    @synchronized (self) {
        operation = [operationDictionary objectForKey:key];
    }
    if (operation) {
        if ([operation conformsToProtocol:@protocol(WARWebMomentOperation)]){
            [operation cancel];
        }
        @synchronized (self) {
            [operationDictionary removeObjectForKey:key];
        }
    }
}

- (void)war_removeMomentLoadOperationWithKey:(nullable NSString *)key {
    if (key) {
        WAROperationsDictionary *operationDictionary = [self war_operationDictionary];
        @synchronized (self) {
            [operationDictionary removeObjectForKey:key];
        }
    }
}

@end
