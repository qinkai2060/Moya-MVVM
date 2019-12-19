//
//  CollectShopViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectShopViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;
- (RACSignal *)deleteProductCollectWithProuctID:(NSString *)productId projectId:(NSString *)projectId;
@end

NS_ASSUME_NONNULL_END
