//
//  WARUserEditDataManager.h
//  Pods
//
//  Created by huange on 2017/8/29.
//
//

#import <Foundation/Foundation.h>
#import "WARDBUserModel.h"
#import "WARDBContactModel.h"
#import "WARDBFriendTagModel.h"
#import "WARDBContactManager.h"
#import "WARUserSettingItem.h"

typedef NS_ENUM(NSInteger, UpLoadImageType) {
    UpLoadImageHeaderBackgroundType = 0,
    UploadImageUserIconType,
    UpLoadImageAlbumType,
};


typedef void(^successBlock)(id successData);
typedef void(^failedBlock)(id failedData);

@interface WARUserEditDataManager : NSObject

- (instancetype)initWithAccountID:(NSString *)accountID;

@property (nonatomic, strong) WARDBUserModel *user;
@property (nonatomic, strong) WARDBContactModel *contactUser;
@property (nonatomic, strong) NSArray *allGroupsName;

- (void)changeBirthdayWithDate:(NSString *)dateString
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild;

- (void)changeNickNameWithName:(NSString *)nameString
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild;

- (void)changeGenderWithGender:(NSString *)genger
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild;

- (void)changeSignatureWithString:(NSString *)signatureString
                     successBlock:(successBlock)success
                      failedBlock:(failedBlock)faild;

- (void)changeTagsWithTagItemArray:(NSArray *)tagsArray
                      successBlock:(successBlock)success
                       failedBlock:(failedBlock)faild;

#pragma mark - 
- (void)updateLoadImage:(NSArray *)imageArray
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild;

- (void)saveImagesIdsByBgImage:(NSString *)backgroundImage
                      headIdId:(NSString *)headerId
                    albumArray:(NSArray *)albumIdArray
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild;

#pragma mark - user setting
- (void)setUserIsStartFriendByAccount:(NSString *)accountId
                              isStart:(BOOL)isStart
                         successBlock:(successBlock)success
                          failedBlock:(failedBlock)faild;

- (void)setUserIsTopFriendByAccount:(NSString *)accountId
                              isStart:(BOOL)isTop
                         successBlock:(successBlock)success
                          failedBlock:(failedBlock)faild;

- (void)setUserMomentAccessByAccount:(NSString *)accountID
                   isLetHeSeeMyTweet:(BOOL)showAccess
                        successBlock:(successBlock)success
                         failedBlock:(failedBlock)faild;

- (void)setMyselfReceiveHisTweetMessageByAccout:(NSString *)accountID
                               isReceiveMessage:(BOOL)isReceiveMessage
                                   successBlock:(successBlock)success
                                    failedBlock:(failedBlock)faild;

- (void)setMyselfReceiveHisSentMessageByAccout:(NSString *)accountID
                              isReceiveMessage:(BOOL)isReceiveMessage
                                  successBlock:(successBlock)success
                                   failedBlock:(failedBlock)faild;

- (void)setHeCanSeeMyDistanceByAccount:(NSString *)accountID
                            isLetHeSee:(BOOL)isLetHeCan
                          successBlock:(successBlock)success
                           failedBlock:(failedBlock)faild;

- (void)addBlackListByAccount:(NSString *)accountID
                 successBlock:(successBlock)success
                  failedBlock:(failedBlock)faild;

- (void)removeBlackListByAccount:(NSString *)accountID
                    successBlock:(successBlock)success
                     failedBlock:(failedBlock)faild;

- (void)remveFriendByAccount:(NSString *)account
                successBlock:(successBlock)success
                 failedBlock:(failedBlock)faild;

#pragma mark - remark
- (void)remarkStrangerByAccount:(NSString *)account
                     remarkName:(NSString *)remarkName
                   successBlock:(successBlock)success
                    failedBlock:(failedBlock)faild;

- (void)remarkFriendByAccount:(NSString *)account
                   remarkName:(NSString *)remarkName
                    tagsArray:(NSArray *)array
                 successBlock:(successBlock)success
                  failedBlock:(failedBlock)faild;
@end
