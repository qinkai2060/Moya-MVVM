//
//  MyUncaughtExceptionHandler.h
//  HeMeiHui
//
//  Created by 任为 on 2018/1/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUncaughtExceptionHandler : NSObject
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;
@end
