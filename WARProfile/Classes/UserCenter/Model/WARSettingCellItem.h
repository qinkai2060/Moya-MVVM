//
//  WARSettingCellItem.h
//  Pods
//
//  Created by huange on 2017/8/3.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageSwitchType) {
    MessageSwitchSound = 0,
    MessageSwitchShake,
    MessageSwitchDotDisTurb,
    MessageSwitchReceiveNewMessageType,
    MessageSwitchDisplayDetailMessageType,
    MessageSwitchInviteToGroupType,
    MessageSwitchConfirmToGroupType,

    MessageSwitchTweetReactType,        //动态互动通知
    MessageSwitchActiveReactType,       //活动互动
    MessageSwitchActiveParticipateRemindType,     //活动参与提醒

    MessageSwitchFriendCycleInteractionType,        //朋友圈互动提醒
    MessageSwitchMyTrackInteractionType,            //我的足迹互动提醒
    MessageSwitchGroupDynamicsInteractionType,      //群动态互动提醒
    MessageSwitchAlbumInteractionType,     //活动参与提醒
    MessageSwitchCollectionInteractionType,     //活动参与提醒
};


@interface WARSettingCellItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *titleString;

@end

@interface WARSettingWithRightTextCellItem : WARSettingCellItem

@property (nonatomic, strong) NSString *rightText;

@end

@interface WARSettingSwitchCellItem : NSObject

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) MessageSwitchType messageSettingType;

@end

@interface WARSettingSwitchWithDetailCellItem : WARSettingSwitchCellItem

@property (nonatomic, strong) NSString *detailString;

@end

@interface WARSettingCheckMarkCellItem : NSObject

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL checked;

@end


@interface WARSettingSelectTimeCellItem : NSObject

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) NSInteger fromTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) BOOL checked;

@end
