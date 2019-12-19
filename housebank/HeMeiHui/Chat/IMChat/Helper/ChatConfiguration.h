//
//  ChatConfiguration.h
//  Pods
//
//  Created by zhangwenchao on 16/12/1.
//
//

#import <Foundation/Foundation.h>
//#import "ChatUserModel.h"
#import "DXChatBarMoreView.h"

@protocol MCChatConfigurationDataSource, MCChatConfigurationDelegate;

@interface ChatConfiguration : NSObject

@property (nonatomic, weak) id<MCChatConfigurationDataSource> configDataSource;
@property (nonatomic, weak) id<MCChatConfigurationDelegate> configDelegate;

@property (nonatomic, strong) UIColor* mainColor;
@property (nonatomic, strong) NSArray* tabBarSelectedImages;

@property (nonatomic, assign) DXChatBarMoreItemOption chatBarMoreItemOptionForSingleChat;
@property (nonatomic, assign) DXChatBarMoreItemOption chatBarMoreItemOptionForGroupChat;

+ (instancetype)shared;

@end

@protocol MCChatConfigurationDataSource <NSObject>

- (NSArray<UIViewController*>*)businessViewControllersForShop;
- (NSArray<NSString*>*)businessViewControllerTitlesForShop;

@end

@protocol MCChatConfigurationDelegate <NSObject>
@optional

@end


