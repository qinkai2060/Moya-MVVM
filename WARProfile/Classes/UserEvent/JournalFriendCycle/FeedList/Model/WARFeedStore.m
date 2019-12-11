//
//  WARFeedStoreComponent.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARFeedStore.h"
#import "ReactiveObjC.h"
#import "MJExtension.h"

@implementation WARFeedStore

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, edition)] reduce:^id (NSString* edition){
            WARFeedComponentIntegrityType editionEnum = WARFeedComponentIntegrityTypeSimple;
            if ([edition isEqualToString:WARIntegrity_M_SIMPLE]) {
                editionEnum = WARFeedComponentIntegrityTypeSimple;
            }else if ([edition isEqualToString:WARIntegrity_M_COMPLETE]){
                editionEnum = WARFeedComponentIntegrityTypeComplete;
            }else{
                
            }
            return @(editionEnum);
        }] subscribeNext:^(NSNumber* editionEnum) {
            @strongify(self);
            self.editionEnum = editionEnum.integerValue;
        }];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"images" : @"NSString"};//前边，是属性数组的名字，后边就是类名
}

@end
