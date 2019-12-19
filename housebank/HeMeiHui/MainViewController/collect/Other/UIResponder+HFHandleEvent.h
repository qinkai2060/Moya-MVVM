//
//  UIResponder+HFHandleEvent.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (HFHandleEvent)
- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
