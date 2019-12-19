//
//  IMNewsCountManager.m
//  HeMeiHui
//
//  Created by 任为 on 2017/12/25.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "IMNewsCountManager.h"


static IMNewsCountManager * manager;

@implementation IMNewsCountManager

-(NSInteger)getBadgeCount{
    
    NSString *count = [[NSUserDefaults standardUserDefaults]objectForKey:@"BageCount"];
    if (count) {
        NSInteger countBage = [count integerValue];
        if (countBage>0) {
            return countBage;
        }
    }
    return 0;

}
- (NSInteger)getImBadgeCountByMchId:(NSString*)accid{

  NIMRecentSession *currentSession =  [[[NIMSDK sharedSDK]conversationManager] recentSessionBySession:[NIMSession session:accid type:NIMSessionTypeP2P]];

    if (currentSession.unreadCount>0) {
        return currentSession.unreadCount;

    }else{
    return 0;
    }
}

- (void)removeImBadgeByMchId:(NSString *)accid{
    
    NIMRecentSession *currentSession =  [[[NIMSDK sharedSDK]conversationManager] recentSessionBySession:[NIMSession session:accid type:NIMSessionTypeP2P]];
    if (currentSession.session) {
        
        [[[NIMSDK sharedSDK]conversationManager] markAllMessagesReadInSession:currentSession.session];
    }
}

- (void)removeNotifictionBadge{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
    
}
+(instancetype)shareIMNewsCountManager
{
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return manager;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return manager;
}
@end
