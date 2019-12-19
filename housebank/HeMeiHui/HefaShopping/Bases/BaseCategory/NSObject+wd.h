//
//  NSObject+wd.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (wd)

/**
 *创建一个Image
 */
- (UIImage *)imageWithImageName:(NSString *)imageName;


/**
 发送通知

 @param notificationName notification  name
 @param notificationObject notification object
 */
- (void)sendNotificationName:(NSString *)notificationName Object:(id)notificationObject;

/**
 这个是发送带字典的通知


 @param notificationName notification  name

 @param notificationObject notification object
 @param useInfo NSDictionary
 */
- (void)sendNotificationName:(NSString *)notificationName object:(id)notificationObject useInfo:(id )useInfo ;

+ (ManagerTools *)shareManagerTools;

@end

NS_ASSUME_NONNULL_END
