//
//  WARFriendMessageListVC.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARBaseViewController.h"
#import "WARMomentRemindEnum.h"

@class WARMomentUser;

typedef void(^WARFriendMessageListVCPushToUserProfileBlock)(WARMomentUser *user);

@interface WARFriendMessageListVC : WARBaseViewController

- (instancetype)initWithNotificationType:(WARNotificationType)notificationType;

/** 跳转到用户个人页 */
@property (nonatomic, copy) WARFriendMessageListVCPushToUserProfileBlock pushToUserProfileBlock;

@end
