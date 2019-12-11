//
//  WARJournalFriendCycleNetManager.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalFriendCycleNetManager.h"
#import "WARNetwork.h"
#import "WARMacros.h" 
#import "MJExtension.h"
#import "WARPublishUploadManager.h"
#import "WARUIHelper.h"

#import "NSString+UUID.h"
#import "WARMediator+Contacts.h"

#import "WARFeedModel.h"
#import "WARFeedComponentLayout.h" 

NSString *const kWARAddressBookNetworkToolPrefix = @"cont-app";

@implementation WARJournalFriendCycleNetManager

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
                          compeletion:(void (^)(WARMomentModel *model,NSArray<WARMoment *> *results,NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/diary/list", kDomainNetworkUrl];
    if (friendId != nil && friendId.length > 0) {
        uri = [NSString stringWithFormat:@"%@/moment-app/moment/diary/list/%@", kDomainNetworkUrl,friendId];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lastFindId"] = lastFindId == nil ? @"" : lastFindId;
    params[@"lastPublishTime"] = lastPublishTime == nil ? @"" : lastPublishTime;

    
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
                                                 NDLog(@"responseObj = %@", responseObj);
                                                 if (!err) {
                                                     WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
                                                     for (WARMoment *moment in model.moments) {
                                                         moment.fromMineJournalList = YES;
                                                         if (friendId != nil && friendId.length > 0) {
                                                             moment.fromMineJournalList = NO;
                                                         }
                                                         
                                                         NSMutableArray *pageLayouts = [NSMutableArray array];
                                                         for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                                                             WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                                                             [layout configComponentLayoutsWithPage:pageM
                                                                                       contentScale:kContentScale
                                                                                         momentShowType:WARMomentShowTypeUserDiary
                                                                                       isMultilPage:moment.isMultilPage];
                                                             [pageLayouts addObject:layout];
                                                         }
                                                         
                                                         //
                                                         WARJournalListLayout *momentLayout = [WARJournalListLayout journalListLayoutWithMoment:moment];
                                                         
                                                         momentLayout.feedLayoutArr = pageLayouts;
                                                         momentLayout.currentPageIndex = 0;
                                                         moment.journalListLayout = momentLayout;
                                                     }
                                                     if (compeletion) {
                                                         compeletion(model,model.moments,nil);
                                                     }
                                                 } else {
                                                     if (compeletion) {
                                                         compeletion(nil,nil,err);
                                                     }
                                                 }
                                             }];
}


/**
 朋友圈列表

 @param lastFindId 最后一条数据id
 @param lastPublishTime 最后发布时间
 @param type（FRIEND, //好友 FOLLOW, //关注）
 @param compeletion 结果回调
 */
+ (void)loadFriendListWithLastFindId:(NSString *)lastFindId
                             maskId:(NSString *)maskId
                               type:(NSString *)type
                        compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/friend/list", kDomainNetworkUrl];
    [WARNetwork postDataFromURI:uri params:@{
                                             @"lastFindId": [NSString stringWithFormat:@"%@",lastFindId == nil ? @"" : lastFindId],
                                             @"maskId":[NSString stringWithFormat:@"%@",maskId],
                                             @"type":[NSString stringWithFormat:@"%@",type]
                                             } completion:^(id responseObj, NSError *err) {
                                                 NDLog(@"responseObj = %@", responseObj);
                                                 if (!err) { 
                                                     WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
                                                     NSMutableArray *friendMomentLayouts = [NSMutableArray array];
                                                     for (WARMoment *moment in model.moments) {
                                                         //朋友圈列表评论布局
                                                         NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
                                                         [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                             WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
                                                             [commentsLayoutArr addObject:layout];
                                                         }];
                                                         moment.commentsLayoutArr = commentsLayoutArr;

                                                         //内容布局
                                                         NSMutableArray *pageLayouts = [NSMutableArray array];
                                                         NSMutableArray *limitPageLayouts = [NSMutableArray array];
                                                         for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                                                             WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                                                             [layout configComponentLayoutsWithPage:pageM
                                                                                       contentScale:kContentScale
                                                                                         momentShowType:WARMomentShowTypeFriend
                                                                                       isMultilPage:moment.isMultilPage];
                                                             [pageLayouts addObject:layout];

                                                             if (limitPageLayouts.count < 3){
                                                                 [limitPageLayouts addObject:layout];
                                                             }
                                                         }
 
                                                         WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout type:type moment:moment openLike:NO openComment:NO];

                                                         friendMomentLayout.feedLayoutArr = pageLayouts;
                                                         friendMomentLayout.limitFeedLayoutArr = limitPageLayouts;
                                                         friendMomentLayout.currentPageIndex = 0;

                                                         moment.friendMomentLayout = friendMomentLayout;
                                                         [friendMomentLayouts addObject:friendMomentLayout];

                                                     }
                                                     if (compeletion) {
                                                         compeletion(model,model.moments,nil);
                                                     }
                                                 } else {
                                                     if (compeletion) {
                                                         compeletion(nil,nil,err);
                                                     }
                                                 }
                                             }];
}

/**
 朋友圈列表
 
 @param fromType  MESSAGE:首页推荐 CHAT:群聊  默认：朋友圈
 @param lastFindId 最后一条数据id
 @param lastPublishTime 最后发布时间
 @param type（FRIEND, //好友 FOLLOW, //关注）
 @param compeletion 结果回调
 */
+ (void)loadFriendListFromType:(NSString *)fromType
                    lastFindId:(NSString *)lastFindId
                        maskId:(NSString *)maskId
                          type:(NSString *)type
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/friend/list", kDomainNetworkUrl];
    if ([fromType isEqualToString:@"MESSAGE"]) {
        uri = [NSString stringWithFormat:@"%@/moment-app/flow/list/v1", kDomainNetworkUrl];
        
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"refId"];
        [params setObject:[NSString stringWithFormat:@"%@",maskId] forKey:@"category"];
    } else if ([fromType isEqualToString:@"CHAT"]) {
        uri = [NSString stringWithFormat:@"%@/moment-app/group/recmd", kDomainNetworkUrl];
        
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"];
        [params setObject:[NSString stringWithFormat:@"%@",maskId] forKey:@"groupId"];
    } else {
        if ([type isEqualToString:@"FOLLOW"]) {
            uri = [NSString stringWithFormat:@"%@/momment-app/follow/list", kDomainNetworkUrl];
        } else {
            [params setObject:[NSString stringWithFormat:@"%@",maskId] forKey:@"maskId"];
        }
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"]; 
//        [params setObject:[NSString stringWithFormat:@"%@",type] forKey:@"type"];
    }
    
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
                                                 NDLog(@"responseObj = %@", responseObj);
                                                 if (!err) {
//                                                     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                                     dispatch_async(queue, ^{
//
//                                                     });
                                                     
                                                     WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
                                                     NSMutableArray *friendMomentLayouts = [NSMutableArray array];
                                                     for (WARMoment *moment in model.moments) {
                                                         if ([type isEqualToString:@"FRIEND"]) {
                                                             moment.fromFriendList = YES;
                                                         }
                                                         
                                                         //朋友圈列表评论布局
                                                         NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
                                                         [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                             WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
                                                             [commentsLayoutArr addObject:layout];
                                                         }];
                                                         moment.commentsLayoutArr = commentsLayoutArr;
                                                         
                                                         //内容布局
                                                         NSMutableArray *pageLayouts = [NSMutableArray array];
                                                         NSMutableArray *limitPageLayouts = [NSMutableArray array];
                                                         for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                                                             WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                                                             [layout configComponentLayoutsWithPage:pageM
                                                                                       contentScale:kContentScale
                                                                                         momentShowType:WARMomentShowTypeFriend
                                                                                       isMultilPage:moment.isMultilPage];
                                                             [pageLayouts addObject:layout];
                                                             
                                                             if (limitPageLayouts.count < 3){
                                                                 [limitPageLayouts addObject:layout];
                                                             }
                                                         }
                                                         
                                                         WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout type:type moment:moment openLike:NO openComment:NO];
                                                         
                                                         friendMomentLayout.feedLayoutArr = pageLayouts;
                                                         friendMomentLayout.limitFeedLayoutArr = limitPageLayouts;
                                                         friendMomentLayout.currentPageIndex = 0;
                                                         
                                                         moment.friendMomentLayout = friendMomentLayout;
                                                         [friendMomentLayouts addObject:friendMomentLayout]; 
                                                     }
                                                     if (compeletion) {
                                                         compeletion(model,model.moments,nil);
                                                     }
                                                 } else {
                                                     if (compeletion) {
                                                         compeletion(nil,nil,err);
                                                     }
                                                 }
                                             }];
}

+ (void)loadFriendListFromType:(NSString *)fromType
                    lastFindId:(NSString *)lastFindId
                        maskId:(NSString *)maskId
                          type:(NSString *)type
                         label:(NSString *)lable
                      sysLabel:(NSArray<NSString *> *)sysLabel
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/friend/list", kDomainNetworkUrl];
    if ([fromType isEqualToString:@"MESSAGE"]) {
        uri = [NSString stringWithFormat:@"%@/moment-app/flow/list/v1", kDomainNetworkUrl];
        
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"refId"];
        [params setObject:[NSString stringWithFormat:@"%@",maskId] forKey:@"category"];
    } else if ([fromType isEqualToString:@"CHAT"]) {
        uri = [NSString stringWithFormat:@"%@/moment-app/group/recmd", kDomainNetworkUrl];
        
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"refId"];
        [params setObject:[NSString stringWithFormat:@"%@",maskId] forKey:@"groupId"];
        [params setObject:[NSString stringWithFormat:@"%@",lable] forKey:@"lable"];
        if (sysLabel && sysLabel.count > 0) {
            [params setObject:sysLabel forKey:@"sysLabel"];
        }
    } else {
        if ([type isEqualToString:@"FOLLOW"]) {
            uri = [NSString stringWithFormat:@"%@/moment-app/follow/list", kDomainNetworkUrl];
        } else {
            [params setObject:[NSString stringWithFormat:@"%@",maskId] forKey:@"maskId"];
        }
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"];
    }
    
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) { 
            WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
            NSMutableArray *friendMomentLayouts = [NSMutableArray array];
            for (WARMoment *moment in model.moments) { 
                if ([type isEqualToString:@"FRIEND"]) {
                    moment.fromFriendList = YES;
                }
                
                //朋友圈列表评论布局
                NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
                [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
                    [commentsLayoutArr addObject:layout];
                }];
                moment.commentsLayoutArr = commentsLayoutArr;
                
                //内容布局
                NSMutableArray *pageLayouts = [NSMutableArray array];
                for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                    WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                    [layout configComponentLayoutsWithPage:pageM
                                              contentScale:kContentScale
                                                momentShowType:WARMomentShowTypeFriend
                                              isMultilPage:moment.isMultilPage];
                    [pageLayouts addObject:layout];
                }
                
                WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout flowLayoutWithMoment:moment];//[WARFriendMomentLayout type:type moment:moment openLike:NO openComment:NO];
                friendMomentLayout.feedLayoutArr = pageLayouts;
                friendMomentLayout.currentPageIndex = 0;
                
                moment.friendMomentLayout = friendMomentLayout;
                [friendMomentLayouts addObject:friendMomentLayout];
            }
            if (compeletion) {
                compeletion(model,model.moments,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}


+ (void)loadFriendListFromType:(NSString *)fromType
                friendOrFollow:(NSString *)friendOrFollow
                    categoryId:(NSString *)categoryId
                       groupId:(NSString *)groupId
                       maskIds:(NSArray *)maskIds
                    lastFindId:(NSString *)lastFindId
                   compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/friend/list", kDomainNetworkUrl];
    if ([fromType isEqualToString:@"MESSAGE"]) {
        uri = [NSString stringWithFormat:@"%@/moment-app/flow/list/v1", kDomainNetworkUrl];
        
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"refId"];
        [params setObject:[NSString stringWithFormat:@"%@",categoryId] forKey:@"category"];
    } else if ([fromType isEqualToString:@"CHAT"]) {
        uri = [NSString stringWithFormat:@"%@/moment-app/group/recmd", kDomainNetworkUrl];
        
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"];
        [params setObject:[NSString stringWithFormat:@"%@",groupId] forKey:@"groupId"];
    } else {
        [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"];
        if (maskIds && maskIds.count > 0) {
            [params setObject:maskIds forKey:@"maskIds"];
        }
    }
    
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
            NSMutableArray *friendMomentLayouts = [NSMutableArray array];
            for (WARMoment *moment in model.moments) {
                if ([friendOrFollow isEqualToString:@"FRIEND"]) {
                    moment.fromFriendList = YES;
                }
                
                //朋友圈列表评论布局
                NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
                [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
                    [commentsLayoutArr addObject:layout];
                }];
                moment.commentsLayoutArr = commentsLayoutArr;
                
                //内容布局
                NSMutableArray *pageLayouts = [NSMutableArray array];
                NSMutableArray *limitPageLayouts = [NSMutableArray array];
                for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                    WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                    [layout configComponentLayoutsWithPage:pageM
                                              contentScale:kContentScale
                                                momentShowType:WARMomentShowTypeFriend
                                              isMultilPage:moment.isMultilPage];
                    [pageLayouts addObject:layout];
                    
                    if (limitPageLayouts.count < 3){
                        [limitPageLayouts addObject:layout];
                    }
                }
                
                WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout type:friendOrFollow moment:moment openLike:NO openComment:NO];
                
                friendMomentLayout.feedLayoutArr = pageLayouts;
                friendMomentLayout.limitFeedLayoutArr = limitPageLayouts;
                friendMomentLayout.currentPageIndex = 0;
                
                moment.friendMomentLayout = friendMomentLayout;
                [friendMomentLayouts addObject:friendMomentLayout];
                
            }
            if (compeletion) {
                compeletion(model,model.moments,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}

/**
 点赞列表
 
 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadThumbUsersListWithLastFindId:(NSString *)lastFindId
                                  itemId:(NSString *)itemId
                             compeletion:(void (^)(WARThumbModel *model,NSArray <WARMomentUser *>*results, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/comment-app/MOMENT/thumb/%@?lastId=%@", kDomainNetworkUrl,itemId,lastFindId];
 // comment-app/{module}/thumb/list
    [WARNetwork postDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
                                                 NDLog(@"responseObj = %@", responseObj);
                                                 if (!err) {
                                                     WARThumbModel *model = [WARThumbModel mj_objectWithKeyValues:responseObj];
                                                     
                                                     WARJournalThumbLayout *journalThumbLayout = [WARJournalThumbLayout layoutWithThumb:model];
                                                     model.journalThumbLayout = journalThumbLayout;
                                                     
                                                     WARFriendDetailThumbLayout *friendDetailThumbLayout = [WARFriendDetailThumbLayout layoutWithThumb:model];
                                                     model.friendDetailThumbLayout = friendDetailThumbLayout;
                                                     
                                                     if (compeletion) {
                                                         compeletion(model,model.thumbUserBos,nil);
                                                     }
                                                 } else {
                                                     if (compeletion) {
                                                         compeletion(nil,nil,err);
                                                     }
                                                 }
                                             }];
}
/**
 moment点赞列表
 
 @param module MOMENT(日志)  FMOMENT(朋友圈),PMOMENT(公众圈);
 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadThumbUsersListWithModule:(NSString *)module
                          LastFindId:(NSString *)lastFindId
                              itemId:(NSString *)itemId
                         compeletion:(void (^)(WARThumbModel *model,NSArray <WARMomentUser *>*results, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/comment-app/%@/thumb/list", kDomainNetworkUrl,module];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lastId"] = lastFindId == nil ? @"" : lastFindId;
    params[@"itemId"] = itemId;
    // comment-app/{module}/thumb/list
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARThumbModel *model = [WARThumbModel mj_objectWithKeyValues:responseObj];
            
            WARJournalThumbLayout *journalThumbLayout = [WARJournalThumbLayout layoutWithThumb:model];
            model.journalThumbLayout = journalThumbLayout;
            
            WARFriendDetailThumbLayout *friendDetailThumbLayout = [WARFriendDetailThumbLayout layoutWithThumb:model];
            model.friendDetailThumbLayout = friendDetailThumbLayout;
            
            if (compeletion) {
                compeletion(model,model.thumbUserBos,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}


/**
 日志评论列表

 @param lastFindId lastId
 @param itemId momentId
 @param compeletion 回调结果
 */
+ (void)loadCommentsListWithLastFindId:(NSString *)lastFindId
                                itemId:(NSString *)itemId
                           compeletion:(void (^)(WARFriendCommentModel *model,NSArray <WARFriendCommentLayout *>*results, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/comment-app/MOMENT/comment/ref/%@?refId=%@", kDomainNetworkUrl,itemId,lastFindId];
    
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARFriendCommentModel *model = [WARFriendCommentModel mj_objectWithKeyValues:responseObj];
            
            NSMutableArray *array = [NSMutableArray array];
            for (WARFriendComment *comment in model.comments) {
                WARFriendCommentLayout *journalCommentLayout = [WARFriendCommentLayout commentDiaryDetailLayout:comment openCommentLayout:NO];
                [array addObject:journalCommentLayout];
            }
            model.journalCommentLayoutArray = array;
            
            if (compeletion) {
                compeletion(model,array,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}

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
                           compeletion:(void (^)(WARFriendCommentModel *model,NSArray <WARFriendCommentLayout *>*results, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/comment-app/%@/comment/ref", kDomainNetworkUrl,module];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"refId"] = lastFindId == nil ? @"" : lastFindId;
    params[@"itemId"] = itemId;
    
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARFriendCommentModel *model = [WARFriendCommentModel mj_objectWithKeyValues:responseObj];
            
            NSMutableArray *array = [NSMutableArray array];
            for (WARFriendComment *comment in model.comments) {
                WARFriendCommentLayout *journalCommentLayout = [WARFriendCommentLayout commentDiaryDetailLayout:comment openCommentLayout:NO];
                [array addObject:journalCommentLayout];
            }
            model.journalCommentLayoutArray = array;
            
            if (compeletion) {
                compeletion(model,array,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}

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
                    compeletion:(void (^)(BOOL success, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/comment-app/%@/comment/delete", kDomainNetworkUrl, module];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromAccId"] = fromAccId;
    params[@"itemId"] = itemId;
    params[@"msgId"] = msgId;
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
                compeletion(YES,nil);
            }
        } else {
            if (compeletion) {
                compeletion(NO,err);
            }
        }
    }];
}


/** 信息流分类 moment-app/flow/category */
+ (void)getFlowCategoryCompletion:(void(^)(NSArray <NSString *> *results, NSError *err)) compeletion {
    
//    if (compeletion) {
//        compeletion(@[WARLocalizedString(@"推荐"),WARLocalizedString(@"关注")],nil);
//    }
    
    NSString *uri = [NSString stringWithFormat:@"%@/moment-app/flow/categories",kDomainNetworkUrl];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            NSArray <NSString *>*categorys = [NSString mj_objectArrayWithKeyValuesArray:responseObj];

            //推荐
            NSMutableArray *mutArray = [NSMutableArray arrayWithArray:categorys];
            [mutArray insertObject:WARLocalizedString(@"推荐") atIndex:0];
            [mutArray insertObject:WARLocalizedString(@"关注") atIndex:1];

            if (compeletion) {
                compeletion(mutArray,err);
            }
        } else {
            if (compeletion) {
                compeletion(nil,err);
            }
        }
    }];
}


/**
 日志消息提醒
 
 @param refId refId
 @param compeletion 回调结果
 */
+ (void)loadMessageListWithRefId:(NSString *)refId
                          compeletion:(void (^)(WARMomentRemindModel *model,NSArray <WARFriendMessageLayout *>*results, NSError *err))compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/comment-app/MOMENT/moment/remind/list?refId=%@",kDomainNetworkUrl,refId];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARMomentRemindModel *model = [WARMomentRemindModel mj_objectWithKeyValues:responseObj];
            
            NSMutableArray *array = [NSMutableArray array];
            for (WARMomentRemind *remind in model.reminds) {
                //评论布局
                NSMutableArray <WARFriendCommentLayout *> *commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:1];
//                WARFriendCommentLayout* commentLayout = [WARFriendCommentLayout commentLayout:remind.commentBody openCommentLayout:NO];
                WARFriendCommentLayout* commentLayout = [WARFriendCommentLayout commentMessageListLayout:remind.commentBody];
                [commentsLayoutArr addObject:commentLayout];
                remind.commentsLayoutArr = commentsLayoutArr;
                
                //内容布局
                WARFriendMessageLayout *layout = [WARFriendMessageLayout remindLayout:remind];
                [array addObject:layout]; 
            }
            model.layouts = array;
            
            if (compeletion) {
                compeletion(model,array,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}


+ (void)convertDataWithReminds:(NSMutableArray<WARMomentRemind *> *)reminds
                   compeletion:(void (^)(WARMomentRemindModel *model,NSArray <WARFriendMessageLayout *>*results))compeletion {
    WARMomentRemindModel *model = [[WARMomentRemindModel alloc] init];
    model.reminds = reminds;
    NSMutableArray *array = [NSMutableArray array];
    for (WARMomentRemind *remind in model.reminds) {
        //评论布局
        NSMutableArray <WARFriendCommentLayout *> *commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:1];
        //                WARFriendCommentLayout* commentLayout = [WARFriendCommentLayout commentLayout:remind.commentBody openCommentLayout:NO];
        WARFriendCommentLayout* commentLayout = [WARFriendCommentLayout commentMessageListLayout:remind.commentBody];
        [commentsLayoutArr addObject:commentLayout];
        remind.commentsLayoutArr = commentsLayoutArr;
        
        //内容布局
        WARFriendMessageLayout *layout = [WARFriendMessageLayout remindLayout:remind];
        [array addObject:layout];
    }
    model.layouts = array;
    
    if (compeletion) {
        compeletion(model,array);
    }
}

/**
 刷经验值
 
 @param momentId momentId
 @param rewordId rewordId
 @param compeletion 回调结果
 */
+ (void)shuaRewordWithMomentId:(NSString *)momentId rewordId:(NSString *)rewordId compeletion:(void (^)(NSDictionary *resultDictionry, NSError *err))compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/grade-app/flow/shua/reword",kDomainNetworkUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[NSString stringWithFormat:@"%@",momentId] forKey:@"momentId"];
    [params setObject:[NSString stringWithFormat:@"%@",rewordId] forKey:@"rewordId"];
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
     
                compeletion(responseObj,err);
            }
        } else {
            if (compeletion) {
                compeletion(nil,err);
            }
        }
    }];
}


/**
 获取推荐视频列表
 
 @param refId refId
 @param compeletion 回调结果
 */
+ (void)getFlowVideosWithRefId:(NSString *)refId compeletion:(void (^)(WARRecommendVideoModel *model,NSArray <WARRecommendVideo *>*results, NSError *err))compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/moment-app/flow/videos?refId=%@",kDomainNetworkUrl,refId];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARRecommendVideoModel *model = [WARRecommendVideoModel mj_objectWithKeyValues:responseObj]; 
            if (compeletion) {
                compeletion(model,model.videos,err);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}


/**
 获取面具列表

 @param compeletion compeletion description
 */
+ (void)getMaskListWithCompletion:(void(^)(NSArray <WARDBCycleOfFriendMaskModel *>*results, NSError *err)) compeletion {
//    NSString *uri = [NSString stringWithFormat:@"%@/%@/mask/list",kDomainNetworkUrl,kWARAddressBookNetworkToolPrefix];
//    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
//        NDLog(@"responseObj = %@", responseObj);
//        if (!err) {
//            NSArray <WARDBCycleOfFriendMaskModel *> *maskArray = [WARDBCycleOfFriendMaskModel objectArrayWithKeyValuesArray:responseObj];
//
////            //全部
////            WARDBCycleOfFriendMaskModel *allMask = [[WARDBCycleOfFriendMaskModel alloc]init];
////            allMask.maskId = @"all";
////            allMask.nickname = WARLocalizedString(@"全部");
////            NSMutableArray *mutArray = [NSMutableArray arrayWithArray:maskArray];
////            [mutArray insertObject:allMask atIndex:0];
//
//            if (compeletion) {
//                compeletion(maskArray,err);
//            }
//        } else {
//            if (compeletion) {
//                compeletion(nil,err);
//            }
//        }
//    }];
    [[WARMediator sharedInstance] Mediator_ContactsAllMaskData:^(NSString *json) {
        NSArray <WARDBCycleOfFriendMaskModel *> *maskArray = [WARDBCycleOfFriendMaskModel objectArrayWithKeyValuesArray:json];
        if (compeletion) {
            compeletion(maskArray,nil);
        }
    }];
}


/**
 日志详情，只有日志内容和用户信息-个人
 
 @param compeletion 回调结果
 */
+ (void)loadPersonalDetailWithMomentId:(NSString *)momentId friendId:(NSString *)friendId compeletion:(void (^)(WARJournalDetailModel *model,WARMoment *moment, NSError *err))compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/moment-app/moment/%@/personal/detail/v1?friendId=%@",kDomainNetworkUrl,momentId,friendId];
    [WARNetwork postDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARJournalDetailModel *model = [WARJournalDetailModel mj_objectWithKeyValues:responseObj];
            
            /// 1.构建moment
            WARMoment *moment = [WARMoment mj_objectWithKeyValues:responseObj];
//            moment.momentId = momentId;
//            moment.accountId = model.accountId;
//            moment.momentShowType = WARMomentShowTypeUserDiary;
//            moment.ironBody = model.ironBody;
//            moment.isMultilPage = model.ironBody.pageContents.count > 1;
//            moment.friendModel = model.friendModel;
//            WARCommentWrapper *commentWapper = [[WARCommentWrapper alloc] init];
//            commentWapper.commentCount = model.pCommentWapper.commentCount + model.fCommentWapper.commentCount;
//            commentWapper.praiseCount = model.pCommentWapper.praiseCount + model.fCommentWapper.praiseCount;
//            commentWapper.thumbUp = model.pCommentWapper.thumbUp || model.fCommentWapper.thumbUp;
//            moment.commentWapper = commentWapper;
            
            /// 2.page布局 （先计算page布局，然后计算moment布局）
            NSMutableArray *pageLayouts = [NSMutableArray array];
            for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                [layout configComponentLayoutsWithPage:pageM contentScale:kContentScale momentShowType:(WARMomentShowTypeUserDiary) isMultilPage:moment.isMultilPage];
                [pageLayouts addObject:layout];
            }
            
            /// 3.moment布局
            WARFriendMomentLayout <WARFeedModelProtocol> *momentLayout = [WARFriendMomentLayout type:@"" moment:moment openLike:NO openComment:NO];
            momentLayout.feedLayoutArr = pageLayouts;
            momentLayout.currentPageIndex = 0;
            moment.friendMomentLayout = momentLayout;
            
            if (compeletion) {
                compeletion(model,moment,err);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}

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
                                  compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/map/list/v1", kDomainNetworkUrl];
    [params setObject:[NSString stringWithFormat:@"%@",accountId] forKey:@"accId"];
    [params setObject:[NSString stringWithFormat:@"%@",categoryLabel] forKey:@"categoryLabel"];
    [params setObject:[NSString stringWithFormat:@"%@",lat] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%@",lon] forKey:@"lon"];
    [params setObject:[NSString stringWithFormat:@"%@",momentId] forKey:@"momentId"];
    [params setObject:[NSString stringWithFormat:@"%@",zoom] forKey:@"zoom"];
    [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"searchSort"];
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
            
//            NSArray <WARMoment *> *momentArray = [WARMoment objectArrayWithKeyValuesArray:responseObj];
            
            NSMutableArray *friendMomentLayouts = [NSMutableArray array];
            for (WARMoment *moment in model.moments) {
//                //朋友圈列表评论布局
//                NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
//                [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
//                    [commentsLayoutArr addObject:layout];
//                }];
//                moment.commentsLayoutArr = commentsLayoutArr;
                
                //内容布局
                NSMutableArray *pageLayouts = [NSMutableArray array];
                for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                    WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                    [layout configComponentLayoutsWithPage:pageM
                                              contentScale:kContentScale
                                                momentShowType:WARMomentShowTypeFriend
                                              isMultilPage:moment.isMultilPage];
                    [pageLayouts addObject:layout];
                }
                
                WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout mapProfileMomentListLayoutWithMoment:moment];
                friendMomentLayout.feedLayoutArr = pageLayouts;
                friendMomentLayout.currentPageIndex = 0;
                
                moment.friendMomentLayout = friendMomentLayout;
                [friendMomentLayouts addObject:friendMomentLayout]; 
            }
            if (compeletion) {
                compeletion(model,model.moments,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}


/**
 足迹日志列表

 @param accountId 用户id
 @param lastFindId 最后一条数据ID
 @param compeletion 回调
 */
+ (void)loadTrackMomentListWithAccountId:(NSString *)accountId
                                   lastFindId:(NSString *)lastFindId
                             compeletion:(void (^)(WARMomentModel *model,NSArray <WARMoment *>*results, NSError *err))compeletion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/trace/list", kDomainNetworkUrl];
    [params setObject:[NSString stringWithFormat:@"%@",accountId] forKey:@"accountId"];
    [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"];
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARMomentModel *model = [WARMomentModel mj_objectWithKeyValues:responseObj];
            NSMutableArray *friendMomentLayouts = [NSMutableArray array];
            for (WARMoment *moment in model.moments) {
                //朋友圈列表评论布局
                NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
                [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
                    [commentsLayoutArr addObject:layout];
                }];
                moment.commentsLayoutArr = commentsLayoutArr;
                
                //内容布局
                NSMutableArray *pageLayouts = [NSMutableArray array];
                NSMutableArray *limitPageLayouts = [NSMutableArray array];
                for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
                    WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                    [layout configComponentLayoutsWithPage:pageM
                                              contentScale:kContentScale
                                                momentShowType:WARMomentShowTypeFriend
                                              isMultilPage:moment.isMultilPage];
                    [pageLayouts addObject:layout];
                    
                    if (limitPageLayouts.count < 3){
                        [limitPageLayouts addObject:layout];
                    }
                }
                
                WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout mapProfileMomentListLayoutWithMoment:moment];
                friendMomentLayout.feedLayoutArr = pageLayouts;
                friendMomentLayout.limitFeedLayoutArr = limitPageLayouts;
                friendMomentLayout.currentPageIndex = 0;
                
                moment.friendMomentLayout = friendMomentLayout;
                [friendMomentLayouts addObject:friendMomentLayout];
            }
            if (compeletion) {
                compeletion(model,model.moments,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}

/**
 激活探索列表
 
 @param accountId 用户id
 @param lastFindId 最后一条数据ID
 @param compeletion 回调
 */
+ (void)loadActivitionExpTrackListWithAccountId:(NSString *)accountId
                                     lastFindId:(NSString *)lastFindId
                                    compeletion:(void (^)(WARActivationExplorationModel *model,NSArray <WARActivationExplorationLayout *>*results, NSError *err))compeletion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/trace/list", kDomainNetworkUrl];
    [params setObject:[NSString stringWithFormat:@"%@",accountId] forKey:@"accountId"];
    [params setObject:[NSString stringWithFormat:@"%@",lastFindId] forKey:@"lastFindId"];
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARActivationExplorationModel *model = [WARActivationExplorationModel mj_objectWithKeyValues:responseObj];
            NSMutableArray *layouts = [NSMutableArray array];
            for (WARActivationExploration *item in model.trackLists) {
                WARActivationExplorationLayout *layout = [WARActivationExplorationLayout layoutWithActivationExploration:item];
                [layouts addObject:layout];
            }
            if (compeletion) {
                compeletion(model,layouts,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}

/**
 小红点
 
 @param compeletion 回调
 */
+ (void)getMomentUnreadWithCompeletion:(void (^)(BOOL hasUnread, NSString *headId, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/friend/unread", kDomainNetworkUrl];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            BOOL hasUnread = [responseObj[@"hasUnread"] boolValue];
            NSString *headId = responseObj[@"headId"];
            if (compeletion) {
                compeletion(hasUnread,[headId isKindOfClass:[NSString class]] ? headId : @"",nil);
            }
        } else {
            if (compeletion) {
                compeletion(NO,nil,err);
            }
        }
    }];
}


/**
 不感兴趣
 
 @param flowId 该条信息的id
 @param compeletion 回调
 */
+ (void)flowNointerestWithFlowId:(NSString *)flowId compeletion:(void (^)(BOOL success, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/flow/%@/nointerest", kDomainNetworkUrl,flowId];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
                compeletion(YES,nil);
            }
        } else {
            if (compeletion) {
                compeletion(NO,err);
            }
        }
    }];
}

/**
 不看他的消息
 
 @param guyId 该人的id
 @param compeletion 回调
 */
+ (void)flowNoseeWithGuyId:(NSString *)guyId compeletion:(void (^)(BOOL success, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/flow/%@/nosee", kDomainNetworkUrl,guyId];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
                compeletion(YES,nil);
            }
        } else {
            if (compeletion) {
                compeletion(NO,err);
            }
        }
    }];
}

+ (void)loadGameRankWithCursor:(NSString *)cursor
                        gameId:(NSString *)gameId
                      rankName:(NSString *)rankName
                   compeletion:(void (^)(WARFeedGameRankModel *rankModel,NSArray <WARFeedGameRank *>*results, NSError *err))compeletion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/game/rank", kDomainNetworkUrl];
    [params setObject:[NSString stringWithFormat:@"%@",cursor] forKey:@"cursor"];
    [params setObject:[NSString stringWithFormat:@"%@",gameId] forKey:@"gameId"];
    [params setObject:[NSString stringWithFormat:@"%@",rankName] forKey:@"rankName"];
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARFeedGameRankModel *model = [WARFeedGameRankModel mj_objectWithKeyValues:responseObj];
            
            if (compeletion) {
                compeletion(model,model.gameRanks,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,err);
            }
        }
    }];
}


/**
 获取发布内容状态
 
 @param compeletion 回调
 */
+ (void)fetchAllPublishContentWithCompeletion:(void (^)(NSArray<WARMoment *> *results,NSError *err))compeletion {
    NSArray *results = [[WARPublishUploadManager shareduploadManager] fetchAllPublishContent];
    NSLog(@"%@",results);
    
    /// 发布时间富文本设置
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000 / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMM月"];
    NSString *monthDayFormat = [formatter stringFromDate: date];
    NSMutableAttributedString *attributedTextDay = [[NSMutableAttributedString alloc] initWithString:[monthDayFormat substringToIndex:2]];
    attributedTextDay.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    attributedTextDay.yy_color = HEXCOLOR(0x343C4F);
    NSMutableAttributedString *attributedTextMonth = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[monthDayFormat substringFromIndex:2]]];
    attributedTextMonth.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:9.5];
    attributedTextMonth.yy_color = HEXCOLOR(0x343C4F);
    [attributedTextDay appendAttributedString:attributedTextMonth];
    
    /// 数据拼接
    NSMutableArray *moments = [NSMutableArray array];
    for (NSDictionary *dict in results) {
        
        /// 数据转换拼接
        NSMutableArray <WARFeedPageModel *> *pageContents = [NSMutableArray <WARFeedPageModel *>array];
        NSMutableArray <WARFeedComponentModel*> *components = [NSMutableArray <WARFeedComponentModel*> array];
        for (NSDictionary *temDict in dict[@"components"]) {
            WARFeedComponentModel *componentModel = [WARFeedComponentModel mj_objectWithKeyValues:temDict];
            [components addObject:componentModel];
        }
        
        WARFeedPageModel *pageModel = [[WARFeedPageModel alloc]init];
        pageModel.components = components;
        [pageContents addObject:pageModel];
        
        WARIronBody *ironBody = [[WARIronBody alloc]init];
        ironBody.componentPageCount = 1;
        ironBody.pageContents = pageContents;
          
        WARMoment *moment = [WARMoment new];
        moment.fromMineJournalList = YES;
        moment.isPublishMoment = YES;
        moment.showSendingView = YES;
        moment.showSendFailView = NO;
        moment.ironBody = ironBody;
        moment.publishTimeAttributedString = attributedTextDay;
        moment.isShowAllContextTip = NO;
        moment.serialId = dict[@"serialId"];
        if([dict[@"state"] isEqualToString:PUBLISH_UPLOADING]){ /// 发送中
            moment.isPublishIng = YES;
        } else { /// 发送失败
            moment.isPublishIng = NO;
        }
        
        /// 布局计算
        NSMutableArray *pageLayouts = [NSMutableArray array];
        for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
            /// page 布局
            WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
            [layout configComponentLayoutsWithPage:pageM
                                      contentScale:kContentScale
                                        momentShowType:WARMomentShowTypeUserDiary
                                      isMultilPage:moment.isMultilPage];
            [pageLayouts addObject:layout];
            
            /// moment 布局
            WARJournalListLayout *momentLayout = [WARJournalListLayout journalListLayoutWithMoment:moment];
            momentLayout.feedLayoutArr = pageLayouts;
            momentLayout.currentPageIndex = 0;
            moment.journalListLayout = momentLayout;
            
            [moments addObject:moment];
        }
    }
    if (compeletion) {
        compeletion(moments,nil);
    } 
}

/** 关注/取消关注 */
+ (void)followWithGuyId:(NSString *)guyId isFollow:(BOOL)isFollow completion:(void(^)(id responseObj, NSError *err))completion {
    NSString *follow = isFollow ? @"DOWN" : @"UP" ;
    NSString *uriSuffix = [NSString stringWithFormat:@"follow/%@/%@",guyId,follow];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/%@",kDomainNetworkUrl,kWARAddressBookNetworkToolPrefix,uriSuffix];
//    NSString *uri = [NSString stringWithFormat:@"%@%@/follow/%@/%@"kDomainNetworkUrl,kWARAddressBookNetworkToolPrefix,guyId,follow];
 
    [WARNetwork postDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARFeedGameRankModel *model = [WARFeedGameRankModel mj_objectWithKeyValues:responseObj];
            
            if (completion) {
                completion(responseObj,nil);
            }
        } else {
            if (completion) {
                completion(nil,err);
            }
        }
    }];
}

@end
