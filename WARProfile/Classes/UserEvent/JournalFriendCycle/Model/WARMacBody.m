//
//  WARMacBody.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMacBody.h"
#import "ReactiveObjC.h"

@implementation WARMacBody

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, contentType)] reduce:^id (NSString* contentType){
            WARMacBodyContentType contentTypeEnum = WARMacBodyContentTypeText;
            if ([contentType isEqualToString:WARMacBody_M_TEXT]) {
                contentTypeEnum = WARMacBodyContentTypeText;
            }else if ([contentType isEqualToString:WARMacBody_M_VIDEO]){
                contentTypeEnum = WARMacBodyContentTypeVideo;
            }else if ([contentType isEqualToString:WARMacBody_M_SINGLEIMG]){
                contentTypeEnum = WARMacBodyContentTypeSingleImg;
            }else if ([contentType isEqualToString:WARMacBody_M_TRIPLEIMG]){
                contentTypeEnum = WARMacBodyContentTypeTripleImg;
            }else{
                
            }
            return @(contentTypeEnum);
        }] subscribeNext:^(NSNumber* contentTypeEnum) {
            @strongify(self);
            self.contentTypeEnum = contentTypeEnum.integerValue;
        }];
    }
    return self;
}

@end
