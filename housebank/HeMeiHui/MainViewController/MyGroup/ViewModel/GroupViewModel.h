//
//  GroupViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;

- (RACSignal *)loadRequest_GroupPurchaseWithType:(NSString *)type pageNo:(NSInteger)pageNo;

- (RACSignal *)loadMoreRequest_GroupPurchaseWithType:(NSString *)type pageNo:(NSInteger)pageNo;

@end

NS_ASSUME_NONNULL_END
