//
//  JXEventProtocol.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JXEventProtocol <NSObject>
// 用于传递事件（identifier用于标记是哪一个事件， params为需传参数）
- (void)handleEvent:(void(^)(NSDictionary *params, NSString *identifier))event;
@end

NS_ASSUME_NONNULL_END
