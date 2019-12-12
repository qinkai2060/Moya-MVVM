//
//  WARMomentRemind.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

//COMMENT, THUMB
#define WARMoment_Remind_Comment       @"COMMENT"
#define WARMoment_Remind_Thumb       @"THUMB"

typedef NS_ENUM(NSUInteger, WARMomentRemindType) {
    WARMomentRemindTypeDefault,
    WARMomentRemindTypeComment,
    WARMomentRemindTypeThumb
};

////COMMENT, THUMB
//#define WARMoment_Remind_Comment       @"COMMENT"
//#define WARMoment_Remind_Thumb       @"THUMB"
//
//typedef NS_ENUM(NSUInteger, WARMomentRemindType) {
//    WARMomentRemindTypeDefault,
//    WARMomentRemindTypeComment,
//    WARMomentRemindTypeThumb
//};

#import <Foundation/Foundation.h>
#import "WARFriendComment.h"
#import "WARMomentRemindBody.h"
#import "WARMomentUser.h"
#import "WARFriendCommentLayout.h"

@interface WARMomentRemind : NSObject

/** 评论的内容 */
@property (nonatomic, strong) WARFriendComment *commentBody;
/** 评论点赞唯一标记 */
@property (nonatomic, copy) NSString *commentId;
/** 评论状态 (评论的删除状态，点赞取消 TRUE ,FALSE) */
@property (nonatomic, copy) NSString *commentState;
/** 评论时间 */
@property (nonatomic, copy) NSString *commentTime;
/** 类型 (COMMENT, THUMB)*/
@property (nonatomic, copy) NSString *commentType;
/** momentAccId */
@property (nonatomic, copy) NSString *momentAccId; 
/** moment */
@property (nonatomic, strong) WARMomentRemindBody *moment;
/** 唯一id */
@property (nonatomic, copy) NSString *remindId;
/** 人的数据 */
@property (nonatomic, strong) WARMomentUser *replyorInfo;
/** 是否是悄悄说 */
@property (nonatomic, assign) BOOL whisper;

/** 辅助字段 */
/** bodyType */
@property (nonatomic, assign) WARMomentRemindType remindTypeEnum;
/** commentTimeDesc */
@property (nonatomic, copy) NSString *commentTimeDesc;
/** 朋友圈列表评论布局 */
@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr;
/** nameAttributeString */
@property (nonatomic, strong) NSAttributedString *nameAttributeString;
@end
