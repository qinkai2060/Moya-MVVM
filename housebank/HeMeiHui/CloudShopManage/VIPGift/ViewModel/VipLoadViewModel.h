//
//  VipLoadViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipLoadViewModel : NSObject
- (RACSignal *)loadRequest_getUserInfoByLoginNameWithPhone:(NSString *)phone;
- (RACSignal *)loadRequest_getUserDefinWithPhone:(NSString *)phone;
- (RACSignal *)loadRequest_VipAlert;
@end

NS_ASSUME_NONNULL_END
