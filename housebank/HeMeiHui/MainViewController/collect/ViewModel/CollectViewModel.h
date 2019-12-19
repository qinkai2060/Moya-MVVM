//
//  collectViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;
@end

NS_ASSUME_NONNULL_END
