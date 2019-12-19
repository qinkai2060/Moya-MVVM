//
//  JXViewProtocol.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
#import "JXEventProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JXViewProtocol <NSObject, JXEventProtocol>
@optional
- (void)customViewWithData:(id<JXModelProtocol>)data;
- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath*)path;
@end

NS_ASSUME_NONNULL_END
