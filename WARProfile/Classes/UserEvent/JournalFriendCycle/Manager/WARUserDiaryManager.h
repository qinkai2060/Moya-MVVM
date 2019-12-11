//
//  WARUserDiaryManager.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import <Foundation/Foundation.h>

@class WARNewUserDiaryModel,WARNewUserDiaryMoment,
WARNewUserDiaryMomentLayout,WARFriendMomentLayout,
WARNewUserDiaryMonthModel,WARFriendMaskModel;

@interface WARUserDiaryManager : NSObject

/**
 获取别人日志列表v2
 
 @param lastFindId 最后一条数据的id
 @param lastPublishTime 最后一条的发布时间
 @param friendId 朋友id
 @param compeletion 回调
 */
+ (void)loadUserDiaryListWithLastFindId:(NSString *)lastFindId
                        lastPublishTime:(NSString *)lastPublishTime
                               frinedId:(NSString *)friendId
                            compeletion:(void (^)(WARNewUserDiaryModel *model,NSArray <WARNewUserDiaryMoment *>*results,NSArray <WARNewUserDiaryMomentLayout *>*layouts, NSError *err))compeletion;



/**
 朋友圈
 
 @param type FOLLOW：关注  FRIEND:好友
 @param lastFindId 最后一条数据的id
 @param maskId 面具ID
 @param type FRIEND, //好友 FOLLOW, //关注
 @param compeletion 回调
 */
+ (void)loadFriendCycleListWithType:(NSString *)type
                         lastFindId:(NSString *)lastFindId
                             maskId:(NSString *)maskId
                               type:(NSString *)type
                        compeletion:(void (^)(WARNewUserDiaryModel *model,NSArray <WARNewUserDiaryMoment *>*results,NSArray <WARFriendMomentLayout *>*layouts, NSError *err))compeletion;

/**
 日志，月份中日志篇数，高度。。

 @param compeletion
 */
+ (void)loadMomentConverge:(void(^)(NSArray <WARNewUserDiaryMonthModel *>*results, NSError *err))compeletion;


/**
 获取，是否有未读

 @param compeletion
 */
+ (void)loadUserDiaryUnread:(void(^)(bool hasUnread, NSError *err))compeletion;

/**
 删除自己的朋友圈或日志

 @param momentId
 */
+ (void)deleteDiaryOrFriendMoment:(NSString *)momentId compeletion:(void(^)(bool success, NSError *err))compeletion;

/**
 朋友圈不感兴趣

 @param momentId momentId description
 @param compeletion compeletion description
 */
+ (void)putNoInterestFriendMoment:(NSString *)momentId compeletion:(void(^)(bool success, NSError *err))compeletion;

/** 获取面具列表（新） */
+ (void)getMaskListWithCompletion:(void(^)(NSArray <WARFriendMaskModel *>*results, NSError *err)) compeletion;


/**
 对帖子或评论进行点赞

 @param itemId 帖子id
 @param msgId 点赞的id 对帖子点赞msgId传itemId
 @param thumbedAcctId 被点赞人id
 @param thumbState 点赞 UP,取消点赞DOWN
 @param compeletion 回调
 */
+ (void)praiseWithItemId:(NSString *)itemId
                   msgId:(NSString *)msgId
           thumbedAcctId:(NSString *)thumbedAcctId
              thumbState:(NSString *)thumbState
             compeletion:(void(^)(bool success, NSError *err))compeletion;
/**
 对帖子或评论进行点赞
 
 @param moudle MOMENT(日志)  FMOMENT(朋友圈),PMOMENT(公众圈);
 @param itemId 帖子id
 @param msgId 点赞的id 对帖子点赞msgId传itemId
 @param thumbedAcctId 被点赞人id
 @param thumbState 点赞 UP,取消点赞DOWN
 @param compeletion 回调
 */
+ (void)praiseWithMoudle:(NSString *)moudle
                  itemId:(NSString *)itemId
                   msgId:(NSString *)msgId
           thumbedAcctId:(NSString *)thumbedAcctId
              thumbState:(NSString *)thumbState
             compeletion:(void(^)(bool success, NSError *err))compeletion;

/**
 点赞列表
 
 @param itemId 源id
 @param lastId lastId
 */
+ (void)getThumbListWithItemId:(NSString *)itemId
                        lastId:(NSString *)lastId
                   compeletion:(void(^)(NSArray *results, NSString *lastId, NSError *err))compeletion;

@end
