//
//  WARSettingDataManager.m
//  Pods
//
//  Created by huange on 2017/8/7.
//
//

#import "WARSettingDataManager.h"

#import "ReactiveObjC.h"
#import "WARNetwork.h"

@implementation WARSettingDataManager

NSString *logoutURL = @"/account-app/account/logout";
NSString *ConfirmPassword = @"/account-app/account/setting/check";
NSString *GetCode = @"/account-app/account/setting/code";
NSString *ChangePassword = @"/account-app/account/setting/password";
NSString *ChangePhoneNumber = @"/account-app/account/setting/phone";

NSString *PrivateSettingList = @"/cont-app/contact/setting/privacy";
NSString *FriendRecommandSwitch = @"/cont-app/contact/setting/addressbook/";
NSString *addFriendNeedConfirmSwitch = @"/cont-app/user/setting/contact/friend/";
NSString *toGroupNeedConfirmSwitch = @"/cont-app/user/setting/contact/groupcheck/";
NSString *BroadcastSwitch = @"/cont-app/user/moment/setting/broadcast/";
NSString *DistanceSwitch = @"/cont-app/user/location/setting/";
NSString *DistanceScope = @"/cont-app/user/setting/scope/";

NSString *CanSeeMyselfList = @"/cont-app/user/moment/setting/noaccess";
NSString *CanReceivedHisTweet = @"/cont-app/user/moment/setting/nosee";
NSString *CanReceivedHisMessage = @"/cont-app/contact/setting/chat/nomsg";
NSString *CannotLetHeSee = @"/cont-app/contact/setting/location/noshow";

NSString *AddMyselfWaySwitch = @"/cont-app/user/setting/contact/search/";
NSString *AddMyselfWayOtherSwitch = @"/cont-app/contact/setting/friend/register/";
NSString *CareGroupURL = @"/ cont-app/friend/follow/category";
NSString *HandelCareGroupURL = @"/ cont-app/friend/follow/category";
//delete URL
NSString *RemoveFromCannotSeeMyself = @"/cont-app/user/moment/setting/noaccess";
NSString *RemoveFromCannotReceiveHisTweet = @"/cont-app/user/moment/setting/nosee";
NSString *RemoveFromCannotReceiveHisMessage = @"/cont-app/contact/setting/chat/nomsg";
NSString *RemoveFromCannotLetHeSeeMe = @"/cont-app/contact/setting/location/noshow";

//Message URI
NSString *MessageSoundURL = @"/cont-app/user/setting/message/remind/voice";
NSString *MessageShakeURL = @"/cont-app/user/setting/message/remind/shake";
NSString *MessageReceiveNewMessage = @"/cont-app/user/setting/message/push/call/";
NSString *MessageDisplayDetail = @"/cont-app/user/setting/message/push/detail/";
NSString *DoNotDisturb = @"/cont-app/user/setting/message/quiet/";
NSString *MessageInviteToGroup = @"/cont-app/user/setting/message/push/notice/group-apply-invitee/";
NSString *MessageConfirmToGroup = @"/cont-app/user/setting/message/push/notice/group-apply-owner/";

NSString *TweetReact = @"/cont-app/user/setting/message/push/notice/moments-moment-interaction/";
NSString *ActiveReact = @"/cont-app/user/setting/message/push/notice/moments-activity-interaction/";
NSString *ActiveParticaptRemind = @"/cont-app/user/setting/message/push/notice/moments-activity-involvement/";

NSString *FriendCycleInteraction = @"/cont-app/user/setting/comment/remind/fm/";
NSString *MyTrackInteraction = @"/cont-app/user/setting/comment/remind/walk/";
NSString *GroupDynamicsInteraction = @"/cont-app/user/setting/comment/remind/group/";
NSString *AlbumInteraction = @"/cont-app/user/setting/comment/remind/album/";
NSString *CollectionInteraction = @"/cont-app/user/setting/comment/remind/favorite/";

//feedback
NSString *feedbackURI = @"/account-app/advice";

//get user settings
NSString *SettingsURL = @"/cont-app/user/profile/home";

- (WARDBUser *)userInfo {
    if (!_userInfo) {
        _userInfo = [WARDBUser user];
    }
    
    return _userInfo;
}


#pragma mark - Account safety
- (void)confirmPassword:(NSString *)password
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild {
    if (!password) {
        return;
    }
    
    @weakify(self);
    NSDictionary *params = @{@"oldPassword" : password};
    [WARNetwork postDataFromURI:ConfirmPassword params:params completion:^(id responseObj, NSError *err) {
        @strongify(self);
        [self handResultByRespond:responseObj error:err success:success failed:faild];
    }];

}

- (void)getCodeForChangePhone:(NSString *)phoneNumber
                      success:(successBlock)success
                       failed:(failedBlock)faild {
    if (!phoneNumber) {
        return;
    }
    
    @weakify(self);
    NSString *URL = [NSString stringWithFormat:@"%@/%@",GetCode,phoneNumber];
    [WARNetwork getDataFromURI:URL params:nil completion:^(id responseObj, NSError *err) {
        @strongify(self);
        [self handResultByRespond:responseObj error:err success:success failed:faild];
    }];
}

- (void)changePhoneNumber:(NSString *)phoneNumber
                     code:(NSString *)code
                  success:(successBlock)success
                   failed:(failedBlock)faild {
    NSDictionary *params = @{@"newPhoneNumber" : phoneNumber,@"code":code};
    
    if (!phoneNumber || !code) {
        return;
    }
    
    @weakify(self);
    [WARNetwork postDataFromURI:ChangePhoneNumber params:params completion:^(id responseObj, NSError *err) {
        @strongify(self);
        [self handResultByRespond:responseObj error:err success:success failed:faild];
    }];
}

- (void)changePasswordByOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword
                            success:(successBlock)success
                             failed:(failedBlock)faild {
    if (!oldPassword || !newPassword) {
        return;
    }
    
    @weakify(self);
    NSDictionary *params = @{@"newPassword" : newPassword,@"oldPassword":oldPassword};
    [WARNetwork postDataFromURI:ChangePassword params:params completion:^(id responseObj, NSError *err) {
        @strongify(self);
        [self handResultByRespond:responseObj error:err success:success failed:faild];
    }];
}

//handle respond
- (void)handResultByRespond:(id)responseObj error:(NSError*)error  success:(successBlock)success failed:(failedBlock)faild {
    if (error) {
        if (faild) {
            faild(responseObj);
        }
    }else {
//        if (responseObj) {
            if (success) {
                success(responseObj);
            }
//        }else {
//            if (faild) {
//                faild(nil);
//            }
//        }
    }
}

- (void)logoutWithSuccess:(successBlock)success
                   failed:(failedBlock)faild {
    [WARNetwork getDataFromURI:logoutURL params:nil completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}
- (void)CareGroupWithSuccess:(successBlock)success
                   failed:(failedBlock)faild {
    [WARNetwork getDataFromURI:CareGroupURL params:nil completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}
#pragma mark - Private list
- (void)getPrivateSettingListSuccess:(successBlock)success
                              failed:(failedBlock)faild {
    [WARNetwork getDataFromURI:PrivateSettingList params:nil completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (NSString *)getSwitchParamString:(BOOL)isOpen {
    NSString *paramString = nil;
    if (isOpen) {
        paramString = @"TRUE"; //true
    }else {
        paramString = @"FALSE"; //false
    }

    return paramString;
}

- (void)friendRecommandSwitch:(BOOL)isOpen
                      Success:(successBlock)success
                       failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",FriendRecommandSwitch,[self getSwitchParamString:isOpen]];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)addFriendNeedConfirmSwitch:(BOOL)isOpen
                           Success:(successBlock)success
                            failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",addFriendNeedConfirmSwitch,[self getSwitchParamString:isOpen]];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)toGroupNeedConfirmSwitch:(BOOL)isOpen
                         Success:(successBlock)success
                          failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",toGroupNeedConfirmSwitch,[self getSwitchParamString:isOpen]];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)broadcastSwitch:(BOOL)isOpen
                Success:(successBlock)success
                 failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",BroadcastSwitch,[self getSwitchParamString:isOpen]];
    
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)distanceSwitch:(BOOL)isOpen
               Success:(successBlock)success
                failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",DistanceSwitch,[self getSwitchParamString:isOpen]];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)distanceScopeByType:(DistanceScopeType)type
                    Success:(successBlock)success
                     failed:(failedBlock)faild {
    NSString *paramString = nil;
    switch (type) {
        case DistanceScopeTypeAll: {
            paramString = @"all";
            break;
        }
        case DistanceScopeTypeFried:{
            paramString = @"friend";
            break;
        }
        case DistanceScopeTypeClose:{
            paramString = @"close";
            break;
        }
        default:{
            paramString = @"all";
            break;
        }
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",DistanceScope,paramString];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

#pragma mark - can't see anybody tweet
- (void)cannotSeenMyselfSuccess:(successBlock)success
                         failed:(failedBlock)faild {
    
    [WARNetwork fetchDataWithType:WARPostType uri:CanSeeMyselfList completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

- (void)cannotSeenSBByType:(WARSeeSBType)type
                   Success:(successBlock)success
                    failed:(failedBlock)faild {
    
    NSString *URLString = nil;
    if (type == WARSeeSBTypeCannotSeeMyself) {
        URLString = CanSeeMyselfList;
    }else if (type == WARSeeSBTypeCannotReceiveHerTweet) {
        URLString = CanReceivedHisTweet;
    }else if (type == WARSeeSBTypeCannotReceiveHerMessage) {
        URLString = CanReceivedHisMessage;
    }else if (type == WARSeeSBTypeCannotLetHeSeeMe) {
        URLString = CannotLetHeSee;
    }

    [WARNetwork fetchDataWithType:WARGetType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                [self createData:responseObj Success:success];
            }
        }
    }];
}

- (void)createData:(NSArray*)listArray Success:(successBlock)success {
    if (listArray && [listArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *dataList = [NSMutableArray new];
        
        for (NSDictionary *dict in listArray) {
            
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                WARSeeSBListItem *item = [[WARSeeSBListItem alloc] initWithDict:dict];
                if (item) {
                    [dataList addObject:item];
                }
            }
        }
        
        if (success) {
            success(dataList);
        }
    }else {
        if (success) {
            success(nil);
        }
    }
}

#pragma mark - add Myself way
- (void)addMyselfWayByType:(addMyselfWay)way
                switchOpen:(BOOL)isOpen
                   Success:(successBlock)success
                    failed:(failedBlock)faild {
    NSString *wayString = @"";
    NSString *isOpenString = [self getSwitchParamString:isOpen];
    
    if (addMyselfWayAccount == way) {
        wayString = @"num";
    }else if (addMyselfWayPhone == way) {
        wayString = @"phone";
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@/%@",AddMyselfWaySwitch,wayString,isOpenString];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
    
}

- (void)cansearchWayType:(canSearchWay)way
              switchOpen:(BOOL)isOpen
                 Success:(successBlock)success
                  failed:(failedBlock)faild {
    NSString *wayString = @"";
    NSString *isOpenString = [self getSwitchParamString:isOpen];
    
    if (addMyselfWayByQRcode == way) {
        wayString = @"qrcode";
    }else if (addMyselfWayByCard == way) {
        wayString = @"card";
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@/%@",AddMyselfWayOtherSwitch,wayString,isOpenString];
    [WARNetwork fetchDataWithType:WARPostType uri:URLString completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(responseObj);
            }
        }
    }];
}

#pragma mark delete
- (void)removeUserBySeeSBType:(WARSeeSBType)type
                userListArray:(NSArray *)userList
                      Success:(successBlock)success
                       failed:(failedBlock)faild {
    NSString *URLString = nil;
    if (type == WARSeeSBTypeCannotSeeMyself) {
        URLString = RemoveFromCannotSeeMyself;
    }else if (type == WARSeeSBTypeCannotReceiveHerTweet) {
        URLString = RemoveFromCannotReceiveHisTweet;
    }else if (type == WARSeeSBTypeCannotReceiveHerMessage) {
        URLString = RemoveFromCannotReceiveHisMessage;
    }else if (type == WARSeeSBTypeCannotLetHeSeeMe) {
        URLString = RemoveFromCannotLetHeSeeMe;
    }
    
    [WARNetwork fetchDataWithType:WARPostType uri:URLString params:userList completion:^(id responseObj, NSError *err) {
        if (err) {
            if (faild) {
                faild(err);
            }
        }else {
            if (success) {
                success(nil);
            }
        }
    }];
}

#pragma mark - MessageSettings
- (void)messageSettingSoundOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",MessageSoundURL,[self getSwitchParamString:open]];
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageSettingShakeOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",MessageShakeURL,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageReceiveNewMessage:(BOOL)open
                         Success:(successBlock)success
                          failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",MessageReceiveNewMessage,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messagDisplayDetail:(BOOL)open
                    Success:(successBlock)success
                     failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",MessageDisplayDetail,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messagInviteToGroupOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",MessageInviteToGroup,[self getSwitchParamString:open]];

    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messagconfirmToGroupOpen:(BOOL)open
                         Success:(successBlock)success
                          failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",MessageConfirmToGroup,[self getSwitchParamString:open]];

    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageDoNotDisturb:(BOOL)open
                  timeStrig:(NSString*)timeString
                    Success:(successBlock)success
                     failed:(failedBlock)faild {

    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",DoNotDisturb,[self getSwitchParamString:open]];
    NSDictionary *param = nil;
    if (open) {
        if (!timeString) {
            return;
        }
        
        param = @{@"timePeriod": timeString};
    }
    
    [WARNetwork postDataFromURI:URLString params:param completion:^(id responseObj, NSError *err) {
        ;
    }];
}


- (void)messagTweetReactOpen:(BOOL)open
                     Success:(successBlock)success
                      failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",TweetReact,[self getSwitchParamString:open]];

    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messagActiviteReactOpen:(BOOL)open
                        Success:(successBlock)success
                         failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",ActiveReact,[self getSwitchParamString:open]];

    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messagActiviteParticipateRemindOpen:(BOOL)open
                                    Success:(successBlock)success
                                     failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",ActiveParticaptRemind,[self getSwitchParamString:open]];

    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageFriendCycleInteractionOpen:(BOOL)open
                                  Success:(successBlock)success
                                   failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",FriendCycleInteraction,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageMyTrackInteractionOpen:(BOOL)open
                              Success:(successBlock)success
                               failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",MyTrackInteraction,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageGroupDynamicsInteractionOpen:(BOOL)open
                                    Success:(successBlock)success
                                     failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",GroupDynamicsInteraction,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageAlbumInteractionOpen:(BOOL)open
                            Success:(successBlock)success
                             failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",AlbumInteraction,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

- (void)messageCollectionInteractionOpen:(BOOL)open
                                 Success:(successBlock)success
                                  failed:(failedBlock)faild {
    NSString *URLString = [NSString stringWithFormat:@"%@%@",CollectionInteraction,[self getSwitchParamString:open]];
    
    [WARNetwork postDataFromURI:URLString params:nil completion:^(id responseObj, NSError *err) {
        ;
    }];
}

#pragma mark - feedBack
- (void)feedbackWithText:(NSString*)text
                 Success:(successBlock)success
                  failed:(failedBlock)faild {
    
    if (text && text.length > 0) {
        NSDictionary *param = @{@"suggestion":text};
        [WARNetwork fetchDataWithType:WARPutType uri:feedbackURI params:param completion:^(id responseObj, NSError *err) {
            if (err) {
                if (faild) {
                    faild(err);
                }
            }else {
                if (success) {
                    success(nil);
                }
            }
        }];
    }
}

#pragma mark - settings
+ (void)getUserSettingsInfo {
    [WARNetwork getDataFromURI:SettingsURL params:nil completion:^(id responseObj, NSError *err) {
        if (!err) {
            if (responseObj && [responseObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary*)responseObj[@"setting"];
                
                NSDictionary *messageSettings = [dict objectForKey:@"messageSettings"];
                NSDictionary *privateSettings = [dict objectForKey:@"privacySettings"];
                NSDictionary *storeSettings = [dict objectForKey:@"storeSettings"];
                
                WARDBUser *user = [WARDBUser user];
                //message
                if (messageSettings && [messageSettings isKindOfClass:[NSDictionary class]]) {
                    
                    BOOL receiveNewMessage = [[self class] boolValueFromString:[messageSettings objectForKey:@"msgCall"]];
                    BOOL showDetail = [[self class] boolValueFromString:[messageSettings objectForKey:@"msgDetail"]];
                    BOOL voice = [[self class] boolValueFromString:[messageSettings objectForKey:@"voice"]];
                    BOOL doNotDisTurb = [[self class] boolValueFromString:[messageSettings objectForKey:@"msgQuiet"]];
                    BOOL shake = [[self class] boolValueFromString:[messageSettings objectForKey:@"shake"]];

                    BOOL groupJoinApplyInvitee = [[self class] boolValueFromString:[messageSettings objectForKey:@"groupJoinApplyInvitee"]];
                    BOOL groupJoinApplyOwner = [[self class] boolValueFromString:[messageSettings objectForKey:@"groupJoinApplyOwner"]];

                    BOOL tweetReact = [[self class] boolValueFromString:[messageSettings objectForKey:@"momentsMomentInteraction"]];
                    BOOL activeReact = [[self class] boolValueFromString:[messageSettings objectForKey:@"momentsActivityInteraction"]];
                    BOOL activeParticpate = [[self class] boolValueFromString:[messageSettings objectForKey:@"momentsActivityInvolvement"]];

                    NSString *timeString = [messageSettings objectForKey:@"timePeriod"];
                    NSInteger fromTime = 22;
                    NSInteger totime = 8;
                    if (timeString && timeString.length > 0) {
                        NSArray *array = [timeString componentsSeparatedByString:@"-"];
                        if (array && array.count == 2) {
                            NSString *fromTimeString = [array objectAtIndex:0];
                            NSArray *fromTimeArray = [fromTimeString componentsSeparatedByString:@":"];
                            if (fromTimeArray && fromTimeArray.count > 0) {
                                fromTime = [[fromTimeArray objectAtIndex:0] integerValue];
                            }
                            
                            NSString *toTimeString = [array objectAtIndex:1];
                            NSArray *toTimeArray = [toTimeString componentsSeparatedByString:@":"];
                            if (toTimeArray && toTimeArray.count > 0) {
                                totime = [[toTimeArray objectAtIndex:0] integerValue];
                            }
                        }
                    }
                    
                    [kRealm transactionWithBlock:^{
                        user.profileSetting.messageSetting.sound = voice;
                        user.profileSetting.messageSetting.shake = shake;
                        user.profileSetting.messageSetting.reveiveNewMessage = receiveNewMessage;
                        user.profileSetting.messageSetting.disPlayDetail = showDetail;
                        user.profileSetting.messageSetting.doNotDisTurb = doNotDisTurb;
                        user.profileSetting.messageSetting.fromTime = fromTime;
                        user.profileSetting.messageSetting.toTime = totime;
                        user.profileSetting.messageSetting.inviteToGroup = groupJoinApplyInvitee;
                        user.profileSetting.messageSetting.confirmToGroup = groupJoinApplyOwner;
                        user.profileSetting.messageSetting.tweetReact = tweetReact;
                        user.profileSetting.messageSetting.activeReact = activeReact;
                        user.profileSetting.messageSetting.activeParticipateRemind = activeParticpate;
                    }];
                }
                
                //private
                if (privateSettings && [privateSettings isKindOfClass:[NSDictionary class]]) {
                    
//                    BOOL friendRecommand = [[self class] boolValueFromString:[privateSettings objectForKey:@"addressbook"]];
                    BOOL addNeedConfirm = [[self class] boolValueFromString:[privateSettings objectForKey:@"friendCheck"]];
                    BOOL toGroupNeedConfirm = [[self class] boolValueFromString:[privateSettings objectForKey:@"groupJoinCheck"]];

                    BOOL broadcast = [[self class] boolValueFromString:[privateSettings objectForKey:@"momentBroadcast"]];
//                    BOOL distance = [[self class] boolValueFromString:[privateSettings objectForKey:@"locationSwith"]];
                    NSString *allCanSeeDistanceString = [privateSettings objectForKey:@"locationScope"];
                    
                    BOOL allCanSeeDistance = [allCanSeeDistanceString isEqualToString:@"all"];
                    BOOL friendCanSeeDistance = [allCanSeeDistanceString isEqualToString:@"friend"];
                    BOOL startCanSeeDistance = [allCanSeeDistanceString isEqualToString:@"star"];
                    BOOL distanceClosed = [allCanSeeDistanceString isEqualToString:@"close"];

                    
                    BOOL addMeByPhone = [[self class] boolValueFromString:[privateSettings objectForKey:@"userSearchWayPhone"]];
                    BOOL addMeByQR = [[self class] boolValueFromString:[privateSettings objectForKey:@"friendWayQrcode"]];
                    BOOL addByCard = [[self class] boolValueFromString:[privateSettings objectForKey:@"friendWayCard"]];
//                    BOOL searchByLike = [[self class] boolValueFromString:[privateSettings objectForKey:@"friendWayFocus"]];

                    [kRealm transactionWithBlock:^{
//                        user.profileSetting.friendRecommand = friendRecommand;
                        user.profileSetting.addNeedConfirm = addNeedConfirm;
                        user.profileSetting.toGroupNeedConfirm = toGroupNeedConfirm;
                        user.profileSetting.broadcast = broadcast;
                        user.profileSetting.distanceClosed = distanceClosed;
                        user.profileSetting.allCanSeeDistance = allCanSeeDistance;
                        user.profileSetting.friendCanSeeDistance = friendCanSeeDistance;
                        user.profileSetting.startCanSeeDistance = startCanSeeDistance;
                        user.profileSetting.addMeByPhone = addMeByPhone;
                        user.profileSetting.addMeByQR = addMeByQR;
                        user.profileSetting.searchByQRCode = addMeByQR;
                        user.profileSetting.searchByCard = addByCard;
                    }];
                }
                
                
                if (storeSettings && [storeSettings isKindOfClass:[NSDictionary class]]) {
                    BOOL storeOpen = [[self class] boolValueFromString:[storeSettings objectForKey:@"storeOpen"]];
                    [kRealm transactionWithBlock:^{
                        user.storeOpen = storeOpen;
                    }];
                    
                }
                
                
                
                
                
            }
        }
    }];
}

+ (BOOL)boolValueFromString:(NSString*)str {
    if (str && [str isKindOfClass:[NSString class]]) {
        if ([str isEqualToString:@"TRUE"]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

@end
