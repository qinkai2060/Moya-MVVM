//
//  ChatConfiguration.m
//  Pods
//
//  Created by zhangwenchao on 16/12/1.
//
//

#import "ChatConfiguration.h"

@implementation ChatConfiguration

+ (instancetype)shared {
    static ChatConfiguration *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ChatConfiguration new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    _mainColor = [UIColor redColor];
    
    _tabBarSelectedImages = @[@"RecentChat_select", @"ChatContacts_select", @"ChatService_select"];
    
    _chatBarMoreItemOptionForSingleChat = DXChatBarMoreItemTypeBasic | DXChatBarMoreItemTypeRedPaper  | DXChatBarMoreItemTypeReceipt;
    _chatBarMoreItemOptionForGroupChat = _chatBarMoreItemOptionForSingleChat;
    
    return self;
}

- (void)setTabBarSelectedImages:(NSArray *)tabBarSelectedImages {
    if (tabBarSelectedImages && tabBarSelectedImages.count == 3) {
        _tabBarSelectedImages = [NSArray arrayWithArray:tabBarSelectedImages];
    }
}



@end
