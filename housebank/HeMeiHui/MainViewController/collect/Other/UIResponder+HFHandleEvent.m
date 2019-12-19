//
//  UIResponder+HFHandleEvent.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "UIResponder+HFHandleEvent.h"

@implementation UIResponder (HFHandleEvent)
- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [[self nextResponder]rounterEventWithName:eventName userInfo:userInfo];
}
@end
