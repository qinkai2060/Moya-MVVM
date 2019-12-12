//
//  WARMomentVoice.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMomentVoice.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"

@implementation WARMomentVoice

- (instancetype)init{
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACObserve(self, voiceId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *voiceId) {
            @strongify(self);
            self.voiceURLStr = kVideoUrl(voiceId).absoluteString;
            self.voiceURL = kVideoUrl(voiceId);
        }];
    }
    return self;
}

@end
