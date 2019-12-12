//
//  WARJournalDetailModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/17.
//

#import <Foundation/Foundation.h>
#import "WARCommentWrapper.h"
#import "WARIronBody.h"
#import "WARDBContactModel.h"

@interface WARJournalDetailModel : NSObject
/** 用户id */
@property (nonatomic, copy) NSString *accountId;
/** 朋友圈评论点赞信息 */
@property (nonatomic, strong) WARCommentWrapper *fCommentWapper;
/** 朋友是否 TRUE(是),FALSE(否)*/
@property (nonatomic, copy) NSString *fMoment;
/** 用户发布的内容 */
@property (nonatomic, strong) WARIronBody *ironBody;
/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** 公众圈评论点赞信息 */
@property (nonatomic, strong) WARCommentWrapper *pCommentWapper;
/** 公众是否 TRUE(是),FALSE(否)*/
@property (nonatomic, copy) NSString *pMoment;

/** 辅助字段 */
/** 朋友是否 */
@property (nonatomic, assign) BOOL isFriendMoment;
/** 公众是否 */
@property (nonatomic, assign) BOOL isPublicMoment;
/** 根据accountId 从数据库查询到的联系人 */
@property (nonatomic, strong) WARDBContactModel *friendModel;

@end
