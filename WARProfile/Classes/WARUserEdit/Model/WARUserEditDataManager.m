//
//  WARUserEditDataManager.m
//  Pods
//
//  Created by huange on 2017/8/29.
//
//

#import "WARUserEditDataManager.h"
#import "WARDBUserManager.h"

#import "WARMacros.h"
#import "ReactiveObjC.h"
#import "WARNetwork.h"
#import "WARTagItem.h"
#import "WARDBFriendTag.h"

#import "WARUploadDataManager.h"
#import "WARUploadManager.h"

NSString *ChangeBirthdayURI = @"/contact-app/user/birthday";
NSString *ChangeNickNameURI = @"/contact-app/user/nickname";
NSString *changeGenderURI = @"/contact-app/user/gender";
NSString *ChangeSignatureURI = @"/contact-app/user/sign";
NSString *ChangeTagsURI = @"/contact-app/user/tags";
NSString *UpdateImages = @"/media-app/file/uploads/fat";
NSString *SaveImageIDsURI = @"/contact-app/user/images";

////////////////////// users setting ///////////////
NSString *StartFriendURI = @"/contact-app/friend/star/";
NSString *UserIsTopURI = @"/contact-app/friend/privilege/%@/msg_top/%@";
NSString *UserCanSeeMyTweetURI = @"/contact-app/friend/privilege/%@/moments_access/%@";
NSString *receiveUserTweetMessageURI = @"/contact-app/friend/privilege/%@/moment_receive/%@";
NSString *receiveUserSendMessageURI = @"/contact-app/friend/privilege/%@/msg_call/%@";
NSString *LetUserCanSeeMyDistanceURI = @"/contact-app/friend/privilege/%@/show_self/%@";
NSString *AddUserToBlackListURI = @"/contact-app/blacklist/add/%@";
NSString *RemoveUserToBlackListURI = @"/contact-app/blacklist/moveout/%@";
NSString *RemoveFriendURI = @"/contact-app/friend/delete/%@";

////////////////  user remark ///////////////////////////////
NSString *RemarkStrangerURI = @"/contact-app/guy/remarkname/%@";
NSString *RemarkFriendURI = @"/contact-app/friend/remark/%@";

@implementation WARUserEditDataManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.user = [WARDBUserManager userModel];
    }
    
    return self;
}

- (instancetype)initWithAccountID:(NSString *)accountID {
    self = [self init];
    if (self) {
        self.contactUser = [WARDBContactManager contactWithAccountId:accountID];
    }
    
    return self;
}

- (NSArray *)allGroupsName {
    NSMutableArray *allGoups = [NSMutableArray new];
    if (!_allGroupsName) {
        RLMArray *allTage = [WARDBFriendTag allObjects];
        for (WARDBFriendTag *tag in allTage) {
            if (tag.tagName) {
                [allGoups addObject:tag.tagName];
            }
        }
        
        _allGroupsName = [allGoups copy];
    }
    
    return _allGroupsName;
}

- (void)changeBirthdayWithDate:(NSString *)dateString
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild {
    
    if (!dateString) {
        return;
    }
    
    @weakify(self);
    [WARNetwork fetchDataWithType:WARPostType uri:ChangeBirthdayURI params:@{@"birthday":dateString} completion:^(id responseObj, NSError *err) {

        @strongify(self);
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                [self updateBirthday:dateString];
                success(nil);
            }
        }
    }];
}

- (void)updateBirthday:(NSString *)dateString {
    [WARDBUserManager updateUserWithDateString:dateString];
}

- (void)changeNickNameWithName:(NSString *)nameString
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild {
    
    if (!nameString) {
        return;
    }
    
    [nameString dataUsingEncoding:NSUTF8StringEncoding];
    
    [WARNetwork fetchDataWithType:WARPostType uri:ChangeNickNameURI params:@{@"nickname":nameString} completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                [WARDBUserManager updateUserWithNickname:nameString];
                success(nil);
            }
        }
    }];
}

- (void)changeGenderWithGender:(NSString *)genger
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild {
    if (!genger) {
        return;
    }
    
    [WARNetwork fetchDataWithType:WARPostType uri:changeGenderURI params:@{@"gender":genger} completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                [WARDBUserManager updateUserWithGender:genger];
                success(nil);
            }
        }
    }];
}

- (void)changeSignatureWithString:(NSString *)signatureString
                     successBlock:(successBlock)success
                      failedBlock:(failedBlock)faild {
    if (!signatureString) {
        return;
    }
    
    [WARNetwork fetchDataWithType:WARPostType uri:ChangeSignatureURI params:@{@"sign":signatureString} completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                [WARDBUserManager updateUserWithSignature:signatureString];
                success(nil);
            }
        }
    }];
}

#pragma mark - tags
- (void)changeTagsWithTagItemArray:(NSArray *)tagsArray
                      successBlock:(successBlock)success
                       failedBlock:(failedBlock)faild {
    if (!tagsArray || ![tagsArray isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *tagsArrayTemp = [NSMutableArray new];
    for (WARTagItem *item in tagsArray) {
        
        BOOL isExist = NO;
        for (NSString *string in tagsArrayTemp) {
            if ([string isEqualToString:item.tagName]) {
                isExist = YES;
            }
        }
        
        if (!isExist) {
            [tagsArrayTemp addObject:item.tagName];
        }
    }
    
    [WARNetwork fetchDataWithType:WARPostType uri:ChangeTagsURI params:@{@"tags":tagsArrayTemp} completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                [WARDBUserManager updateUserWithTags:tagsArrayTemp];
                success(nil);
            }
        }
    }];
}

#pragma mark - upload images
- (void)updateLoadImage:(NSArray *)imageArray
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild {
    
    [[WARUploadManager shared] uploadImages:imageArray uploadMoudle:WARUploadManagerTypeCONTACT progress:nil succeccBlock:^(NSArray *urlStrs) {
        if (success) {
            success(urlStrs);
        }
    } failureBlock:^{
        if(faild) {
            faild(nil);
        }
    }];
    
//    [[WARUploadDataManager sharedInstance] uploadMultiImagesWithUploadMoudle:WARUploadDataMoudleOfContact imagesArray:imageArray uploadProgressBlock:^(float progress) {
//
//    } succeccBlock:^(NSArray *urlStrs) {
//        success(urlStrs);
//    } failureBlock:^(NSString *error) {
//        faild(error);
//    }];
    
}

- (void)saveImagesIdsByBgImage:(NSString *)backgroundImage
                      headIdId:(NSString *)headerId
                    albumArray:(NSArray *)albumIdArray
                  successBlock:(successBlock)success
                   failedBlock:(failedBlock)faild {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (backgroundImage && backgroundImage.length) {
        [paramDict setObject:backgroundImage forKey:@"bgPicture"];
    }
    
    if (headerId && headerId.length) {
        [paramDict setObject:headerId forKey:@"headId"];
    }
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (WARImageItem *imageItem in albumIdArray) {
        if (![imageItem.imageId isEqualToString:@"add Icon"]) {
            [mutableArray addObject:imageItem.imageId ];
        }
    }
    if (mutableArray && mutableArray.count) {
        [paramDict setObject:[NSArray arrayWithArray:mutableArray] forKey:@"photos"];
    }
    
    [WARNetwork fetchDataWithType:WARPostType uri:SaveImageIDsURI params:paramDict completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                [WARDBUserManager updateUserWithHeadId:headerId bgPicture:backgroundImage photos:mutableArray];
                
                self.user.headId = headerId;
                self.user.bgPicture = backgroundImage;
                success(nil);
            }
        }
    }];
}

#pragma mark - ********************************* users setting *******************************
- (NSString *)getParamByBoolValue:(BOOL)is {
    return is ? @"TRUE" : @"FALSE";
}

- (void)requestWithType:(WARRequestType)type
                    URI:(NSString *)URI
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild {
    
    [WARNetwork fetchDataWithType:type uri:URI completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)setUserIsStartFriendByAccount:(NSString *)accountId
                              isStart:(BOOL)isStart
                         successBlock:(successBlock)success
                          failedBlock:(failedBlock)faild {
    if (!accountId) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",StartFriendURI,accountId,[self getParamByBoolValue:isStart]];
    
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)setUserIsTopFriendByAccount:(NSString *)accountId
                            isStart:(BOOL)isTop
                       successBlock:(successBlock)success
                        failedBlock:(failedBlock)faild {
    if (!accountId) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:UserIsTopURI,accountId,[self getParamByBoolValue:isTop]];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)setUserMomentAccessByAccount:(NSString *)accountID
                   isLetHeSeeMyTweet:(BOOL)showAccess
                        successBlock:(successBlock)success
                         failedBlock:(failedBlock)faild {
    if (!accountID) {
        return;
    }

    NSString *url = [NSString stringWithFormat:UserCanSeeMyTweetURI,accountID,[self getParamByBoolValue:showAccess]];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}


- (void)setMyselfReceiveHisTweetMessageByAccout:(NSString *)accountID
                               isReceiveMessage:(BOOL)isReceiveMessage
                                   successBlock:(successBlock)success
                                    failedBlock:(failedBlock)faild; {
    if (!accountID) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:receiveUserTweetMessageURI,accountID,[self getParamByBoolValue:isReceiveMessage]];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)setMyselfReceiveHisSentMessageByAccout:(NSString *)accountID
                              isReceiveMessage:(BOOL)isReceiveMessage
                                  successBlock:(successBlock)success
                                   failedBlock:(failedBlock)faild {
    if (!accountID) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:receiveUserSendMessageURI,accountID,[self getParamByBoolValue:isReceiveMessage]];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)setHeCanSeeMyDistanceByAccount:(NSString *)accountID
                            isLetHeSee:(BOOL)isLetHeCan
                          successBlock:(successBlock)success
                           failedBlock:(failedBlock)faild {
    if (!accountID) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:LetUserCanSeeMyDistanceURI,accountID,[self getParamByBoolValue:isLetHeCan]];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)addBlackListByAccount:(NSString *)accountID
                 successBlock:(successBlock)success
                  failedBlock:(failedBlock)faild {
    if (!accountID) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:AddUserToBlackListURI,accountID];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)removeBlackListByAccount:(NSString *)accountID
                    successBlock:(successBlock)success
                     failedBlock:(failedBlock)faild {

    if (!accountID) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:RemoveUserToBlackListURI,accountID];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

- (void)remveFriendByAccount:(NSString *)account
                successBlock:(successBlock)success
                 failedBlock:(failedBlock)faild {
    if (!account) {
        return;
    }

    NSString *url = [NSString stringWithFormat:RemoveFriendURI,account];
    [self requestWithType:WARPostType URI:url successBlock:success failedBlock:faild];
}

#pragma mark - memark -
- (void)remarkStrangerByAccount:(NSString *)account
                     remarkName:(NSString *)remarkName
                   successBlock:(successBlock)success
                    failedBlock:(failedBlock)faild {
    if (!account || !remarkName) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:RemarkStrangerURI,account];
    [WARNetwork fetchDataWithType:WARPostType uri:url params:@{@"remarkName":remarkName} completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
   
}

- (void)remarkFriendByAccount:(NSString *)account
                   remarkName:(NSString *)remarkName
                    tagsArray:(NSArray *)array
                 successBlock:(successBlock)success
                  failedBlock:(failedBlock)faild {
    if (!account || !remarkName || !array) {
        return;
    }
   
    NSString *url = [NSString stringWithFormat:RemarkFriendURI,account];
    NSDictionary *paramDict = @{@"remarkName":remarkName,@"tagIds":array};
    [WARNetwork fetchDataWithType:WARPostType uri:url params:paramDict completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(nil);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}


@end
