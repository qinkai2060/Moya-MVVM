//
//  ManageLogisticsViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageLogisticsViewModel : NSObject<JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;
- (RACSignal *)loadRequest_logisticsDetailSource:(NSString *)logisticsID;
@end

NS_ASSUME_NONNULL_END
