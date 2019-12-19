//
//  CollectViewModel+loadData.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectViewModel (loadData)
- (RACSignal *)loadRequest_collectProduct;

- (RACSignal *)deleteProductCollectWithProuctID:(NSString *)productId projectId:(NSString *)projectId;
@end

NS_ASSUME_NONNULL_END
