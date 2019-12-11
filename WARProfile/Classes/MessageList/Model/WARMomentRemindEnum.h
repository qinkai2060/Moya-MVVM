//
//  WARMomentRemindEnum.h
//  Pods
//
//  Created by 卧岚科技 on 2018/7/13.
//

/**
 消息通知类型
 
 - WARNotificationTypeGroupMoment: 群动态
 - WARNotificationTypeFriend: 朋友圈
 - WARNotificationTypePublicGroup: 公众圈
 - WARNotificationTypeAlbum: 相册
 */
typedef NS_ENUM(NSUInteger, WARNotificationType) {
    WARNotificationTypeGroupMoment = 1,
    WARNotificationTypePublicGroup,
    WARNotificationTypeFriend,
    WARNotificationTypeAlbum
};
