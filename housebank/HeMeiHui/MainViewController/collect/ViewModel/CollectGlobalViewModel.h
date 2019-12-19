//
//  CollectGlobalViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectGlobalViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;
- (RACSignal *)deleteProductCollectWithHotelld:(NSString *)hotelld;
- (RACSignal *)loadRequest_GlobalHome ;
- (RACSignal *)loadMoreRequest_GlobalHome;
@end

NS_ASSUME_NONNULL_END
