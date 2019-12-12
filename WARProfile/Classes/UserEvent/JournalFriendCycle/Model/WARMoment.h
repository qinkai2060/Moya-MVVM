//
//  WARMoment.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#define WARMacSource_MAC          @"MAC" //机器人发布
#define WARMacSource_IRON         @"IRON" //用户发布

#define WARDisplyPage_TRUE          @"TRUE" //显示分页
#define WARDisplyPage_FALSE         @"FALSE" //不显示分页

//日志类型（MOMENT,//日志 GROUP,//群发布 ADVERTISEMEN，//广告）
#define WARMomentType_MOMENT         @"MOMENT" //日志
#define WARMomentType_GROUP          @"GROUP" //群发布
#define WARMomentType_ADVERTISEMEN   @"ADVERTISEMEN" //广告


#import <Foundation/Foundation.h>
#import "WARCommentWrapper.h"
#import "WARIronBody.h"
#import "WARMacBody.h"
#import "WARMomentReword.h"
#import "WARMomentTraceInfo.h"

#import "WARJournalListLayout.h"
#import "WARFeedModelProtocol.h"
#import "WARDBContactModel.h"
#import "WARFriendCommentLayout.h"
#import "WARFriendMomentLayout.h"
#import "WARJournalThumbLayout.h"
 
typedef NS_ENUM(NSUInteger, WARPlatformType) {
    WARPlatformTypeFriend = 1,
    WARPlatformTypeDouBan,
};

typedef NS_ENUM(NSUInteger, WARMacSourceType) {
    WARMacSourceTypeMac = 1,//机器人发布
    WARMacSourceTypeIron,//用户发布
};

/**
 动态类型

 - WARMomentTypeMoment: 普通动态
 - WARMomentTypeGroup: 群发布
 - WARMomentTypeAD: 广告
 */
typedef NS_ENUM(NSUInteger, WARMomentType) {
    WARMomentTypeMoment = 0,
    WARMomentTypeGroup,
    WARMomentTypeAD,
};

@interface WARMoment : NSObject<NSCopying>

/** 用户id */
@property (nonatomic, copy) NSString *accountId;
/** 用户发布的内容 */
@property (nonatomic, strong) WARIronBody *ironBody;
/** 动态id */
@property (nonatomic, copy) NSString *momentId;
/** 评论数据相关 */
@property (nonatomic, strong) WARCommentWrapper *commentWapper;
/** 经纬度 */
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
/** 机器人发布的内容 */
@property (nonatomic, strong) WARMacBody *macBody;
/** 位置 */
@property (nonatomic, copy) NSString *location;
/** 权限 */
@property (nonatomic, copy) NSString *permission;
/** 发布平台 */
@property (nonatomic, copy) NSArray <NSString *> *platforms;
/** 发布时间 */
@property (nonatomic, copy) NSString *publishTime;
/** 发布来源  MAC,//机器人发布 IRON,//用户发布 */
@property (nonatomic, copy) NSString *publishSource;
/** 奖励数据 */
@property (nonatomic, strong) WARMomentReword *reword;
/** 足迹信息 */
@property (nonatomic, strong) WARMomentTraceInfo *traceInfo;
/** 是否显示分页："TRUE" ,"FALSE"; 单页过长，底部显示查看全文 */
@property (nonatomic, assign) BOOL isDisplyPage;
@property (nonatomic, copy) NSString *displyPage;
/** 日志类型（MOMENT,//日志 GROUP,//群发布 ADVERTISEMEN，//广告） */
@property (nonatomic, copy) NSString *momentType; 
@property (nonatomic, assign) WARMomentType momentTypeEnum;

/** 群推荐 */
/** 该日志人的信息 */
@property (nonatomic, strong) WARMomentUser *groupMember;

/** 详情字段 */
/** 公众圈评论点赞信息 */
@property (nonatomic, strong) WARCommentWrapper *pCommentWapper;
/** 公众是否 TRUE(是),FALSE(否)*/
@property (nonatomic, copy) NSString *pMoment;
/** 朋友圈评论点赞信息 */
@property (nonatomic, strong) WARCommentWrapper *fCommentWapper;
/** 朋友是否 TRUE(是),FALSE(否)*/
@property (nonatomic, copy) NSString *fMoment;
/** 朋友是否 */
@property (nonatomic, assign) BOOL isFriendMoment;
/** 公众是否 */
@property (nonatomic, assign) BOOL isPublicMoment;
 
/** 辅助字段 */
/** 已经获取了奖励值 */
@property (nonatomic, assign) BOOL alreadyGetReword;
/** 来源我的日志列表 */
@property (nonatomic, assign) BOOL fromMineJournalList;
/** 来源好友列表 */
@property (nonatomic, assign) BOOL fromFriendList;
/** 日志列表布局 */
@property (nonatomic, strong) WARJournalListLayout <WARFeedModelProtocol>*journalListLayout;
/** 朋友圈布局 */
@property (nonatomic, strong) WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout;
/** 朋友圈列表评论布局 */
@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr;
/** 日志详情点赞布局 */
@property (nonatomic, strong) WARJournalThumbLayout *journalThumbLayout;
/** 发布来源  MAC,//机器人发布 IRON,//用户发布 */
@property (nonatomic, assign) WARMacSourceType publishSourceEnum;
/** 是否为多页 */
@property (nonatomic, assign) BOOL isMultilPage;
/** 根据accountId 从数据库查询到的联系人 */
@property (nonatomic, strong) WARDBContactModel *friendModel;
/** 发布时间 */
@property (nonatomic, copy) NSString *publishTimeString;
/** 发布时间 */
@property (nonatomic, copy) NSMutableAttributedString *publishTimeAttributedString;
/** moment展现在什么模块 */
@property (nonatomic, assign) WARMomentShowType momentShowType; 
/** 是自己发布的 */
@property (nonatomic, assign) BOOL isMine;
/** 显示点赞展开收起按钮 */
@property (nonatomic, assign) BOOL showLikeExtend;
/** 显示评论展开收起按钮 */
@property (nonatomic, assign) BOOL showCommentExtend;
/** 点赞用户 */
@property (nonatomic, strong) NSAttributedString *thumbUsersAttributedContent;
@property (nonatomic, strong) NSAttributedString *noIconThumbUsersAttributedContent;
/** 限制点赞用户显示数量 */
@property (nonatomic, strong) NSAttributedString *limitThumbUsersAttributedContent;
@property (nonatomic, strong) NSAttributedString *noIconLimitThumbUsersAttributedContent;
/** 是否存在不兼容的类型 */
@property (nonatomic, assign) BOOL hasIncompatible;
/** 是否是关注详情 */
@property (nonatomic, assign) BOOL isFollowDetail;
/** 显示全文tip按钮 */
@property (nonatomic, assign) BOOL isShowAllContextTip;


/** 发布模块的moment，还没发布成功 */
@property (nonatomic, assign) BOOL isPublishMoment;
/** 是否处于发送中（YES:发送中；NO:发送失败） */
@property (nonatomic, assign) BOOL isPublishIng;
/** 发布容器中moment唯一标识 */
@property (nonatomic, copy) NSString *serialId;
/** 是否显示发布失败视图 */
@property (nonatomic, assign) BOOL showSendFailView;
/** 是否显示发布中视图 */
@property (nonatomic, assign) BOOL showSendingView; 
@end
