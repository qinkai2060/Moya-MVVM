//
//  WARRecommendVideo.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import "WARRecommendVideo.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"

@implementation WARRecommendVideo

- (instancetype)init{
    self = [super init];
    if (self) {
  
        @weakify(self);
        [[RACObserve(self, url) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *videoId) {
            @strongify(self);
            self.videoURL = kVideoUrl(videoId);
        }];
    }
    return self;
}
@end
