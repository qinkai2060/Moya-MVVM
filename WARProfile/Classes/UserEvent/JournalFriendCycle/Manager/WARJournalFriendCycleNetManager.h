//
//  WARJournalFriendCycleNetManager.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARMomentModel.h"
#import "WARMomentRemindModel.h"
#import "WARRecommendVideoModel.h"
#import "WARDBCycleOfFriendMaskModel.h"
#import "WARJournalDetailModel.h"
#import "WARActivationExplorationLayout.h"
#import "WARActivationExplorationModel.h"
#import "WARFeedGameRankModel.h"

@interface WARJournalFriendCycleNetManager : NSObject

/**
 日志列表  (好友id为空时获取自己日志列表，不为空时获取好友日志列表)
 post
 @param lastFindId 最后一条数据id
 @param lastPublishTime 最后发布时间
 @param friendId 好友id (为空时获取自己日志列表，不为空时获取好友日志列表)
 @param compeletion 结果回调
 */
+ (void)loadJournalListWithLastFindId:(NSString *)lastFindId
                      lastPublishTime:(NSString *)lastPublishTime
                             friendId:(NSString *)friendId
                          compeletion:(void (^)(WARMomentModel *model,NSArray<WARMoment *> *results,NSError *err))compeletion ;

/**
 朋友圈列表
 */
+ (void)loadFriendListWithLastFindId:(NSString *)lastFindId
                              maskId:(NSString *)maskId
                                type:(NSString *)type
                         compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion;

+ (void)loadFriendListFromType:(NSString *)fromType
                    lastFindId:(NSString *)lastFindId
                        maskId:(NSString *)maskId
                          type:(NSString *)type
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion;



/**
 信息流列表

 @param fromType <#fromType description#>
 @param lastFindId <#lastFindId description#>
 @param maskId <#maskId description#>
 @param type <#type description#>
 @param lable <#lable description#>
 @param sysLabel <#sysLabel description#>
 @param compeletion <#compeletion description#>
 */
+ (void)loadFriendListFromType:(NSString *)fromType
                    lastFindId:(NSString *)lastFindId
                        maskId:(NSString *)maskId
                          type:(NSString *)type
                         label:(NSString *)lable
                      sysLabel:(NSArray<NSString *> *)sysLabel
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion;


/**
 好友圈列表

 @param fromType <#fromType description#>
 @param friendOrFollow <#friendOrFollow description#>
 @param categoryId <#categoryId description#>
 @param groupId <#groupId description#>
 @param maskIds <#maskIds description#>
 @param lastFindId <#lastFindId description#>
 @param compeletion <#compeletion description#>
 */
+ (void)loadFriendListFromType:(NSString *)fromType
                friendOrFollow:(NSString *)friendOrFollow
                    categoryId:(NSString *)categoryId
                       groupId:(NSString *)groupId
                       maskIds:(NSArray *)maskIds
                    lastFindId:(NSString *)lastFindId
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion;
/**
 点赞列表

 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadThumbUsersListWithLastFindId:(NSString *)lastFindId
                              itemId:(NSString *)itemId
                         compeletion:(void (^)(WARThumbModel *model,NSArray <WARMomentUser *>*results, NSError *err))compeletion;
/**
 点赞列表
 
 @param module MOMENT(日志)  FMOMENT(朋友圈),PMOMENT(公众圈);
 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadThumbUsersListWithModule:(NSString *)module
                          LastFindId:(NSString *)lastFindId
                              itemId:(NSString *)itemId
                         compeletion:(void (^)(WARThumbModel *model,NSArray <WARMomentUser *>*results, NSError *err))compeletion;
/**
 日志评论列表
 
 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadCommentsListWithLastFindId:(NSString *)lastFindId
                                  itemId:(NSString *)itemId
                           compeletion:(void (^)(WARFriendCommentModel *model,NSArray <WARFriendCommentLayout *>*results, NSError *err))compeletion;

/**
 moment评论列表
 
 @param module MOMENT(日志)  FMOMENT(朋友圈),PMOMENT(公众圈);
 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadCommentsListWithModule:(NSString *)module
                        lastFindId:(NSString *)lastFindId
                            itemId:(NSString *)itemId
                       compeletion:(void (^)(WARFriendCommentModel *model,NSArray <WARFriendCommentLayout *>*results, NSError *err))compeletion;


/**
 删除评论
 comment-app/{module}/comment/{commentId}
 @param module MOMENT(日志)  FMOMENT(朋友圈),PMOMENT(公众圈);
 @param fromAccId 发出该评论的用户id
 @param itemId 当前评论列表所属的条目的ID，如：当前动态的ID
 @param msgId 当前的回复的ID
 */
+ (void)deleteCommentWithModule:(NSString *)module
                      fromAccId:(NSString *)fromAccId
                         itemId:(NSString *)itemId
                          msgId:(NSString *)msgId
                    compeletion:(void (^)(BOOL success, NSError *err))compeletion;

/**
 获取信息流分类

 @param compeletion 回调
 */
+ (void)getFlowCategoryCompletion:(void(^)(NSArray <NSString *> *results, NSError *err)) compeletion;


/**
 日志消息提醒

 @param refId refId
 @param compeletion 回调结果
 */
+ (void)loadMessageListWithRefId:(NSString *)refId
                           compeletion:(void (^)(WARMomentRemindModel *model,NSArray <WARFriendMessageLayout *>*results, NSError *err))compeletion;

+ (void)convertDataWithReminds:(NSMutableArray<WARMomentRemind *> *)reminds
                     compeletion:(void (^)(WARMomentRemindModel *model,NSArray <WARFriendMessageLayout *>*results))compeletion;


/**
 刷经验值

 @param momentId momentId
 @param rewordId rewordId
 @param compeletion 回调结果
 */
+ (void)shuaRewordWithMomentId:(NSString *)momentId rewordId:(NSString *)rewordId compeletion:(void (^)(NSDictionary *resultDictionry, NSError *err))compeletion;


/**
 获取推荐视频列表

 @param refId refId
 @param compeletion 回调结果
 */
+ (void)getFlowVideosWithRefId:(NSString *)refId compeletion:(void (^)(WARRecommendVideoModel *model,NSArray <WARRecommendVideo *>*results, NSError *err))compeletion;

/**
 获取面具列表新

 @param compeletion 回调结果
 */
+ (void)getMaskListWithCompletion:(void(^)(NSArray <WARDBCycleOfFriendMaskModel *>*results, NSError *err)) compeletion;


/**
 日志详情，只有日志内容和用户信息-个人

 @param compeletion 回调结果
 */
+ (void)loadPersonalDetailWithMomentId:(NSString *)momentId friendId:(NSString *)friendId compeletion:(void (^)(WARJournalDetailModel *model,WARMoment *moment, NSError *err))compeletion;


/**
 地图动态列表

 @param accountId 用户id
 @param categoryLabel 分类标签
 @param lat 纬度
 @param lon 经度
 @param momentId 第一tiao动态id
 @param searchSort 排序
 @param lastFindId lastId
 @param compeletion 回调
 */
+ (void)loadMapProfileMomentListWithAccountId:(NSString *)accountId
                                categoryLabel:(NSString *)categoryLabel
                            lat:(NSString *)lat
                            lon:(NSString *)lon
                       momentId:(NSString *)momentId
                     zoom:(NSString *)zoom
                    lastFindId:(NSString *)lastFindId
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion;

/**
 足迹日志列表
 
 @param accountId 用户id
 @param lastFindId 最后一条数据ID
 @param compeletion 回调
 */
+ (void)loadTrackMomentListWithAccountId:(NSString *)accountId
                              lastFindId:(NSString *)lastFindId
                             compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion;


/**
 激活探索列表

 @param accountId 用户id
 @param lastFindId 最后一条数据ID
 @param compeletion 回调
 */
+ (void)loadActivitionExpTrackListWithAccountId:(NSString *)accountId
                              lastFindId:(NSString *)lastFindId
                             compeletion:(void (^)(WARActivationExplorationModel *model,NSArray <WARActivationExplorationLayout *>*results, NSError *err))compeletion;


/**
 小红点

 @param compeletion 回调
 */
+ (void)getMomentUnreadWithCompeletion:(void (^)(BOOL hasUnread, NSString *headId, NSError *err))compeletion;

/**
 不感兴趣
 
 @param flowId 该条信息的id
 @param compeletion 回调
 */
+ (void)flowNointerestWithFlowId:(NSString *)flowId compeletion:(void (^)(BOOL success, NSError *err))compeletion;

/**
 不看他的消息
 
 @param guyId 该人的id
 @param compeletion 回调
 */
+ (void)flowNoseeWithGuyId:(NSString *)guyId compeletion:(void (^)(BOOL success, NSError *err))compeletion;


/**
 获取排名

 @param cursor 分页参数
 @param gameId 游戏id
 @param rankName 排名名
 @param compeletion 回调
 */
+ (void)loadGameRankWithCursor:(NSString *)cursor
                        gameId:(NSString *)gameId
                      rankName:(NSString *)rankName
                   compeletion:(void (^)(WARFeedGameRankModel *rankModel,NSArray <WARFeedGameRank *>*results, NSError *err))compeletion;


/**
 获取发布内容状态

 @param compeletion 回调
 */
+ (void)fetchAllPublishContentWithCompeletion:(void (^)(NSArray<WARMoment *> *results,NSError *err))compeletion;


/**
 关注/取消关注

 @param guyId 用户id
 @param isFollow 是否关注
 @param completion 回调
 */
+ (void)followWithGuyId:(NSString *)guyId isFollow:(BOOL)isFollow completion:(void(^)(id responseObj, NSError *err))completion;

@end
