//
//  UITableViewCell+WebCache.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import "WARUserDiaryBaseCell+WebCache.h"
#import "WARWebMomentManager.h"
#import "UIView+WARWebCacheOperation.h"

@implementation WARUserDiaryBaseCell (WebCache)

- (void)war_setMomentWithId:(nullable NSString *)momentId {
    [self war_setMomentWithId:momentId operationKey:nil];
}

- (void)war_setMomentWithId:(nullable NSString *)momentId operationKey:(nullable NSString *)operationKey{
    //取消cell上一次没完成的请求
    NSString *validOperationKey = operationKey ?: NSStringFromClass([self class]);
    [self war_cancelMomentLoadOperationWithKey:validOperationKey];
    
    //保存momentId
    self.momentId = momentId;
    
    if (momentId) {
        WARWebMomentManager *manager = [WARWebMomentManager sharedManager];
        __weak typeof(self) weakSelf = self;
        id <WARWebMomentOperation> operation = [manager loadMomentWithMomentId:momentId completed:^(WARNewUserDiaryMoment * _Nullable moment, NSError * _Nullable error, WARMomentCacheType cacheType, BOOL finished, NSString * _Nullable momentId) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) { return; }
            
            strongSelf.moment = moment;
        }];
        
        [self war_setMomentLoadOperation:operation forKey:validOperationKey];
    } else {
        self.moment = nil;
    }
}

@end
