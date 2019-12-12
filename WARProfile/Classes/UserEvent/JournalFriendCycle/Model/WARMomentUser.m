//
//  WARMomentUser.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMomentUser.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"
#import "MJExtension.h"

@implementation WARMomentUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACObserve(self, headId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *headId) {
            @strongify(self);
            self.headUrl = kPhotoUrl(headId); 
        }];
    }
    return self;
}


@end
