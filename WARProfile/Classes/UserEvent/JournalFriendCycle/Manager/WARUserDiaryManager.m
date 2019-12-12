//
//  WARUserDiaryManager.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import "WARUserDiaryManager.h"
#import "NSString+UUID.h"

#import "WARNetwork.h"
#import "WARMacros.h"
#import "YYModel.h"
#import "MJExtension.h"

#import "WARNewUserDiaryModel.h"
#import "WARFeedModel.h"
#import "WARNewUserDiaryMomentLayout.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"
#import "WARFeedModelProtocol.h"
#import "WARNewUserDiaryMonthModel.h"
#import "WARFriendMaskModel.h"
#import "WARFriendCommentLayout.h"
#import "WARCommentLayout.h" 

NSString *const kWARAddressBookNetworkToolPrefix1 = @"cont-app";

@implementation WARUserDiaryManager

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
                            compeletion:(void (^)(WARNewUserDiaryModel *model,NSArray <WARNewUserDiaryMoment *>*results,NSArray <WARNewUserDiaryMomentLayout *>*layouts, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/list/%@/v2", kDomainNetworkUrl,friendId];
    [WARNetwork postDataFromURI:uri params:@{
                                             @"lastFindId": [NSString stringWithFormat:@"%@",lastFindId],
                                             @"lastPublishTime":[NSString stringWithFormat:@"%@",lastPublishTime]
                                             } completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARNewUserDiaryModel *model = [WARNewUserDiaryModel mj_objectWithKeyValues:responseObj]; 
            NSMutableArray *momentLayouts = [NSMutableArray array];
            for (WARNewUserDiaryMoment *moment in model.moments) {
                WARNewUserDiaryMomentLayout <WARFeedModelProtocol>* momentLayout = [[WARNewUserDiaryMomentLayout alloc] init];
                
                NSMutableArray *pageLayouts = [NSMutableArray array];
                for (WARFeedPageModel *pageM in moment.pageContents) {
                    WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                    layout.page = pageM;
                    [pageLayouts addObject:layout];
                } 
                momentLayout.feedLayoutArr = pageLayouts;
                moment.momentLayout = momentLayout;
                
                momentLayout.currentPageIndex = 0;
                momentLayout.moment = moment;
                
                [momentLayouts addObject:momentLayout];
            }
            if (compeletion) {
                compeletion(model,model.moments,momentLayouts,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,nil,err);
            }
        }
    }];
}

+ (void)loadFriendCycleListWithType:(NSString *)type
                         lastFindId:(NSString *)lastFindId
                                   maskId:(NSString *)maskId
                                     type:(NSString *)type
                              compeletion:(void (^)(WARNewUserDiaryModel *model,NSArray <WARNewUserDiaryMoment *>*results,NSArray <WARFriendMomentLayout *>*layouts, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/circle/list/v2", kDomainNetworkUrl];
    [WARNetwork postDataFromURI:uri params:@{
                                             @"lastFindId": [NSString stringWithFormat:@"%@",lastFindId],
                                             @"maskId":[NSString stringWithFormat:@"%@",maskId],
                                             @"type":[NSString stringWithFormat:@"%@",type]
                                             } completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            WARNewUserDiaryModel *model = [WARNewUserDiaryModel mj_objectWithKeyValues:responseObj];
            NSMutableArray *friendMomentLayouts = [NSMutableArray array];
            for (WARNewUserDiaryMoment *moment in model.moments) {
//                WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [[WARFriendMomentLayout alloc] init];
                
                //朋友圈列表评论布局
                NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWrapper.comments.count];
                [moment.commentWrapper.comments enumerateObjectsUsingBlock:^(WARNewUserDiaryComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WARFriendCommentLayout* layout = [WARFriendCommentLayout commentLayout:obj openCommentLayout:NO];
                    [commentsLayoutArr addObject:layout];
                }];
                moment.commentsLayoutArr = commentsLayoutArr;
                
                //内容布局
                NSMutableArray *pageLayouts = [NSMutableArray array];
                NSMutableArray *limitPageLayouts = [NSMutableArray array];
                for (WARFeedPageModel *pageM in moment.pageContents) {
                    WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
                    [layout configComponentLayoutsWithPage:pageM
                                              contentScale:kContentScale
                                                momentShowType:WARMomentShowTypeFriend
                                              isMultilPage:moment.pageContents.count > 1];
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
                compeletion(model,model.moments,friendMomentLayouts,nil);
            }
        } else {
            if (compeletion) {
                compeletion(nil,nil,nil,err);
            }
        }
    }];
}
 
+ (void)loadMomentConverge:(void(^)(NSArray <WARNewUserDiaryMonthModel *> *results, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/converge", kDomainNetworkUrl];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            NSArray <WARNewUserDiaryMonthModel *> *userArray = [WARNewUserDiaryMonthModel objectArrayWithKeyValuesArray:responseObj];
            if (compeletion) {
                compeletion(userArray,err);
            }
        } else {
            if (compeletion) {
                compeletion(nil,err);
            }
        }
    }];
}

+ (void)loadUserDiaryUnread:(void(^)(bool hasUnread, NSError *err))compeletion {
    __weak typeof(self) weakSelf = self;
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/circle/unread/v2", kDomainNetworkUrl];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err) {
            if (compeletion) {
                compeletion([responseObj[@"hasUnread"]boolValue],nil);
            }
        } else {
            if (compeletion) {
                compeletion([responseObj[@"hasUnread"]boolValue],err);
            }
        }
    }];
}


/**
 删除自己的朋友圈或日志
 
 @param momentId
 */
+ (void)deleteDiaryOrFriendMoment:(NSString *)momentId compeletion:(void(^)(bool success, NSError *err))compeletion {
    if (momentId == nil || momentId.length <= 0) {
        if (compeletion) {
            compeletion(false,[NSError new]);
        }
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/%@", kDomainNetworkUrl,momentId];
    [WARNetwork deleteDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err) {
            if (compeletion) {
                compeletion(true,nil);
            }
        } else {
            if (compeletion) {
                compeletion(false,err);
            }
        }
    }];
}

+ (void)putNoInterestFriendMoment:(NSString *)momentId compeletion:(void(^)(bool success, NSError *err))compeletion {
    if (momentId == nil || momentId.length <= 0) {
        if (compeletion) {
            compeletion(false,[NSError new]);
        }
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString* uri = [NSString stringWithFormat:@"%@/moment-app/moment/circle/%@/nointerest", kDomainNetworkUrl,momentId];
    [WARNetwork putDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err) {
            if (compeletion) {
                compeletion(true,nil);
            }
        } else {
            if (compeletion) {
                compeletion(false,err);
            }
        }
    }];
}

+ (void)getMaskListWithCompletion:(void(^)(NSArray <WARFriendMaskModel *>*results, NSError *err)) compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/%@/mask/list",kDomainNetworkUrl,kWARAddressBookNetworkToolPrefix1];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            NSArray <WARFriendMaskModel *> *maskArray = [WARFriendMaskModel objectArrayWithKeyValuesArray:responseObj];
            
            //全部
            WARFriendMaskModel *allMask = [[WARFriendMaskModel alloc]init];
            allMask.maskId = @"";
            allMask.nickname = WARLocalizedString(@"全部");
            NSMutableArray *mutArray = [NSMutableArray arrayWithArray:maskArray];
            [mutArray insertObject:allMask atIndex:0];
            
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
             compeletion:(void(^)(bool success, NSError *err))compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/comment-app/MOMENT/thumb/%@/%@/%@/%@",kDomainNetworkUrl,itemId,msgId,thumbedAcctId,thumbState];
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
                compeletion(YES,err);
            }
        } else {
            if (compeletion) {
                compeletion(NO,err);
            }
        }
    }];
}


+ (void)praiseWithMoudle:(NSString *)moudle
                  itemId:(NSString *)itemId
                   msgId:(NSString *)msgId
           thumbedAcctId:(NSString *)thumbedAcctId
              thumbState:(NSString *)thumbState
             compeletion:(void(^)(bool success, NSError *err))compeletion {
    NSString *uri = [NSString stringWithFormat:@"%@/comment-app/%@/thumb",kDomainNetworkUrl,moudle];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:itemId forKey:@"itemId"];
    [params setObject:msgId forKey:@"msgId"];
    [params setObject:thumbedAcctId forKey:@"thumbedAcctId"];
    [params setObject:thumbState forKey:@"thumbState"];
    NDLog(@"uri:%@",uri);
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
                compeletion(YES,err);
            }
        } else {
            if (compeletion) {
                compeletion(NO,err);
            }
        }
    }];
}

/**
 点赞列表
 
 @param itemId 源id
 @param lastId lastId
 */
+ (void)getThumbListWithItemId:(NSString *)itemId
                        lastId:(NSString *)lastId
                   compeletion:(void(^)(NSArray *results, NSString *lastId, NSError *err))compeletion {
    NSString *uri = nil;
    if (lastId.length) {
        uri = [NSString stringWithFormat:@"%@/comment-app/MOMENT/thumb/%@?lastId=%@",kDomainNetworkUrl,itemId,lastId];
    }else {
        uri = [NSString stringWithFormat:@"%@/comment-app/MOMENT/thumb/%@?lastId=",kDomainNetworkUrl,itemId];
    }
    [WARNetwork getDataFromURI:uri params:nil completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            NSArray *array = [WARNewUserDiaryUser objectArrayWithKeyValuesArray:responseObj[@"thumbUserBos"]];
            NSString *lastId = responseObj[@"lastId"];
            
            if (compeletion) {
                compeletion(array, lastId, err);
            }
        } else {
            if (compeletion) {
                compeletion(nil, nil, err);
            }
        }
    }];
}

@end
