//
//  WARFriendComment.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARMomentVoice.h"
#import "WARMomentUser.h"
#import "WARMomentMedia.h"

@interface WARFriendComment : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* commentId;
@property (nonatomic, copy) NSString* commentTime;
@property (nonatomic, copy) NSString* msgId;
@property (nonatomic, strong) WARMomentVoice *commentVoiceInfo;
@property (nonatomic, strong) WARMomentUser *commentorInfo;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, copy) NSString* replyId;
@property (nonatomic, strong) WARMomentUser *replyorInfo;
@property (nonatomic, copy) NSArray <WARMomentMedia *> *medias;
@property (nonatomic, assign) BOOL thumbUp;
/** 好友不可见 */
@property (nonatomic, assign) BOOL noFriend;
/** 是否是悄悄话 */
@property (nonatomic, assign) BOOL whisper;

- (NSString *)formatCommentTime;

- (NSString *)totalTitle;
- (NSString *)nameTitle ;
- (NSString *)contentTitle ;
@end
