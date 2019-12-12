//
//  WARUbtParam.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/23.
//

#import <Foundation/Foundation.h>

/**
 CANCEL_LIKE    取消点赞
 COMMENT    评论
 FAVOR    收藏
 FOLLOW    关注
 IGNORE    不看消息
 LIKE    点赞
 RETURN    从详情返回列表页
 SHARE    分享
 UNFOLLOW    取关
 VISIT_DETAIL    进入详情
 VISIT_LINK    访问原文链接
 RETURN_LINK    从链接返回
 */
#define CANCEL_LIKE     @"CANCEL_LIKE"
#define COMMENT         @"COMMENT"
#define FAVOR           @"FAVOR"
#define FOLLOW          @"FOLLOW"
#define IGNORE          @"IGNORE"
#define LIKE            @"LIKE"
#define RETURN          @"RETURN"
#define SHARE           @"SHARE"
#define UNFOLLOW        @"UNFOLLOW"
#define VISIT_DETAIL    @"VISIT_DETAIL"
#define VISIT_LINK      @"VISIT_LINK"
#define RETURN_LINK     @"RETURN_LINK"

/**
 PERSON(人),INFO(资讯)
 */
#define kTargetTypePerson   @"PERSON"
#define kTargetTypeInfo     @"INFO"


@class WARUbtAction;
@class WARUbtTarget;
@class WARUbtActionContent;

@interface WARUbtParam : NSObject
/** 发起行为的用户 id */
@property (nonatomic, copy) NSString *accountId;
/** 行为 */
@property (nonatomic, strong) WARUbtAction *action;
/** 行为目标 */
@property (nonatomic, strong) WARUbtTarget *target;
/** 时间戳,默认最新时间 */
@property (nonatomic, copy) NSString *time;
@end

@interface WARUbtAction : NSObject
/** 行为内容 */
@property (nonatomic, strong) WARUbtActionContent *content;
/** 行为类型 参考"行为列表"
 CANCEL_LIKE    取消点赞
 COMMENT    评论
 FAVOR    收藏
 FOLLOW    关注
 IGNORE    不看消息
 LIKE    点赞
 RETURN    从详情返回列表页
 SHARE    分享
 UNFOLLOW    取关
 VISIT_DETAIL    进入详情
 */
@property (nonatomic, copy) NSString *type;
@end

@interface WARUbtActionContent : NSObject
/** imageList */
@property (nonatomic, strong) NSMutableArray *imageList;
/** textList */
@property (nonatomic, strong) NSMutableArray *textList;
/** videoList */
@property (nonatomic, strong) NSMutableArray *videoList;
@end

@interface WARUbtTarget : NSObject
/** 行为目标 id */
@property (nonatomic, copy) NSString *targetId;
/** 行为目标类型 PERSON(人),INFO(资讯) */
@property (nonatomic, copy) NSString *type;

@end
