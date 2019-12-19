//
//  HFModelProtocol.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol JXModelProtocol <NSObject>
@optional
- (NSString *)identifier;
- (CGFloat)height;
@end

NS_ASSUME_NONNULL_END
