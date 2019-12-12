//
//  WARSettingDataManager.h
//  Pods
//
//  Created by huange on 2017/8/7.
//
//

#import <Foundation/Foundation.h>
#import "WARDBUser.h"
#import "WARSeeSBListItem.h"
#import "WARMacros.h"

#define showLoginViewNotification @"showLoginViewNotification"
#define userLogoutSuccessNotification @"userLogoutSuccessNotification"

typedef NS_ENUM(NSInteger,AccountSettingStatus) {
    AccountSettingOldPasswordError  = 100007,
    AccountSettingCodeError         = 100001,
    AccountSettingPhoneAlreadyExist = 100003,
    AccountSettingPhoneSameAsOrigin = 100005,
};

typedef NS_ENUM(NSInteger,WARSeeSBType) {
    WARSeeSBTypeCannotSeeMyself         = 100001,
    WARSeeSBTypeCannotReceiveHerTweet   = 100002,
    WARSeeSBTypeCannotReceiveHerMessage = 100003,
    WARSeeSBTypeCannotLetHeSeeMe        = 100004,
};

typedef NS_ENUM(NSInteger,DistanceScopeType) {
    DistanceScopeTypeAll = 0x100,
    DistanceScopeTypeFried = 0x1001,
    DistanceScopeTypeStar = 0x1002,
    DistanceScopeTypeClose = 0x1003,
};

typedef NS_ENUM(NSInteger, addMyselfWay) {
    addMyselfWayAccount = 0,
    addMyselfWayPhone = 1,
};

typedef NS_ENUM(NSInteger, canSearchWay) {
    addMyselfWayByQRcode = 0,
    addMyselfWayByCard = 1,
};

typedef void(^successBlock)(id successData);
typedef void(^failedBlock)(id failedData);

@interface WARSettingDataManager : NSObject

@property (nonatomic, strong) WARDBUser *userInfo;

- (void)confirmPassword:(NSString *)password
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild;

- (void)getCodeForChangePhone:(NSString *)phoneNumber
                      success:(successBlock)success
                       failed:(failedBlock)faild;

- (void)changePhoneNumber:(NSString *)phoneNumber
                     code:(NSString *)code
                  success:(successBlock)success
                   failed:(failedBlock)faild;

- (void)changePasswordByOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword
                            success:(successBlock)success
                             failed:(failedBlock)faild;

- (void)logoutWithSuccess:(successBlock)success
                   failed:(failedBlock)faild;
/*
 关注分组
 */
- (void)CareGroupWithSuccess:(successBlock)success
                      failed:(failedBlock)faild ;
#pragma mark - private
- (void)getPrivateSettingListSuccess:(successBlock)success
                              failed:(failedBlock)faild;

- (void)friendRecommandSwitch:(BOOL)isOpen
                      Success:(successBlock)success
                       failed:(failedBlock)faild;

- (void)addFriendNeedConfirmSwitch:(BOOL)isOpen
                           Success:(successBlock)success
                            failed:(failedBlock)faild;

- (void)toGroupNeedConfirmSwitch:(BOOL)isOpen
                         Success:(successBlock)success
                          failed:(failedBlock)faild;

- (void)broadcastSwitch:(BOOL)isOpen
                Success:(successBlock)success
                 failed:(failedBlock)faild;

- (void)distanceSwitch:(BOOL)isOpen
               Success:(successBlock)success
                failed:(failedBlock)faild;

- (void)distanceScopeByType:(DistanceScopeType)type
                    Success:(successBlock)success
                     failed:(failedBlock)faild;

#pragma mark - can't see anybody tweet
- (void)cannotSeenSBByType:(WARSeeSBType)type
                   Success:(successBlock)success
                         failed:(failedBlock)faild;

#pragma mark - add Myself way
- (void)addMyselfWayByType:(addMyselfWay)way
                switchOpen:(BOOL)isOpen
                   Success:(successBlock)success
                    failed:(failedBlock)faild;

- (void)cansearchWayType:(canSearchWay)way
              switchOpen:(BOOL)isOpen
                 Success:(successBlock)success
                  failed:(failedBlock)faild;
#pragma mark remove actions
- (void)removeUserBySeeSBType:(WARSeeSBType)type
                userListArray:(NSArray *)userList
                      Success:(successBlock)success
                       failed:(failedBlock)faild;

#pragma mark - MessageSettings
- (void)messageSettingSoundOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild;

- (void)messageSettingShakeOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild;

- (void)messageReceiveNewMessage:(BOOL)open
                         Success:(successBlock)success
                          failed:(failedBlock)faild;

- (void)messagDisplayDetail:(BOOL)open
                    Success:(successBlock)success
                     failed:(failedBlock)faild;

- (void)messagInviteToGroupOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild;

- (void)messagconfirmToGroupOpen:(BOOL)open
                         Success:(successBlock)success
                          failed:(failedBlock)faild;

- (void)messageDoNotDisturb:(BOOL)open
                  timeStrig:(NSString*)timeString
                    Success:(successBlock)success
                     failed:(failedBlock)faild;

- (void)messagTweetReactOpen:(BOOL)open
                     Success:(successBlock)success
                      failed:(failedBlock)faild;

- (void)messagActiviteReactOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild;

- (void)messagActiviteParticipateRemindOpen:(BOOL)open
                                    Success:(successBlock)success
                                     failed:(failedBlock)faild;

- (void)messageFriendCycleInteractionOpen:(BOOL)open
                                  Success:(successBlock)success
                                   failed:(failedBlock)faild;

- (void)messageMyTrackInteractionOpen:(BOOL)open
                              Success:(successBlock)success
                               failed:(failedBlock)faild;

- (void)messageGroupDynamicsInteractionOpen:(BOOL)open
                                    Success:(successBlock)success
                                     failed:(failedBlock)faild;

- (void)messageAlbumInteractionOpen:(BOOL)open
                            Success:(successBlock)success
                             failed:(failedBlock)faild;

- (void)messageCollectionInteractionOpen:(BOOL)open
                                 Success:(successBlock)success
                                  failed:(failedBlock)faild;

#pragma mark - feedBack
- (void)feedbackWithText:(NSString*)text
                 Success:(successBlock)success
                  failed:(failedBlock)faild;

+ (void)getUserSettingsInfo;

@end
