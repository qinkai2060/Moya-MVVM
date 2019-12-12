//
//  WARMomentReword.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/26.
//

#import "WARMomentReword.h"
#import "ReactiveObjC.h"

@implementation WARMomentReword

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, rewordTp)] reduce:^id (NSString* rewordTp){
            WARMomentRewordType rewordTypeEnum = WARMomentRewordTypeJinBi;
            if ([rewordTp isEqualToString:WARMomentReword_JINBI]) {
                rewordTypeEnum = WARMomentRewordTypeJinBi;
            } else if ([rewordTp isEqualToString:WARMomentReword_EXP]){
                rewordTypeEnum = WARMomentRewordTypeExp;
            } else if ([rewordTp isEqualToString:WARMomentReword_HP]){
                rewordTypeEnum = WARMomentRewordTypeHp;
            } else if ([rewordTp isEqualToString:WARMomentReword_KAPIAN]){
                rewordTypeEnum = WARMomentRewordTypeKaPian;
            }  else{
                
            }
            return @(rewordTypeEnum);
        }] subscribeNext:^(NSNumber* rewordTypeEnum) {
            @strongify(self);
            self.rewordTypeEnum = rewordTypeEnum.integerValue;
        }];
    }
    return self;
}

@end
