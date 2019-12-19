//
//  IMNewsCountManager.h
//  HeMeiHui
//
//  Created by 任为 on 2017/12/25.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMKit.h"

/**
 消息和推送管理类
 */
@interface IMNewsCountManager : NSObject
+ (instancetype)shareIMNewsCountManager;

/**
 获取IM和推送Badage

 @return 消息条数
 */
- (NSInteger)getBadgeCount;

/**
 获取IMBadage
 @return 消息条数
 */
- (NSInteger)getImBadgeCountByMchId:(NSString*)accid;

/**
 移除IM消息
 @param accid 用户ID
 */
- (void)removeImBadgeByMchId:(NSString*)accid;

/**
 移除通知消息
 */
- (void)removeNotifictionBadge;


@end
