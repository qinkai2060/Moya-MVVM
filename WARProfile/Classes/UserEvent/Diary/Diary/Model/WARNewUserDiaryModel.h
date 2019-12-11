//
//  WARNewUserDiaryModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//


/**
 天气

 - WARWeatherTypeSunny: 晴天
 - WARWeatherTypeCloudy: 多云
 - WARWeatherTypeRain: 雨
 */
typedef NS_ENUM(NSUInteger, WARWeatherType) {
    WARWeatherTypeSunny = 1,
    WARWeatherTypeCloudy,
    WARWeatherTypeRain
};
 
/**
cell 类型

 - WARFriendCellTypeSinglePage: 单页
 - WARFriendCellTypeMultiPage: 多页
 */
typedef NS_ENUM(NSUInteger, WARFriendCellType) {
    WARFriendCellTypeSinglePage = 1,
    WARFriendCellTypeMultiPage,
};

#define WEATHER_SUNNY          @"00" //晴天
#define WEATHER_CLOUDY         @"01" //多云
#define WEATHER_RAIN           @"02" //雨


#import <Foundation/Foundation.h>
#import "WARFeedModelProtocol.h"
#import "YYTextLayout.h"

@class WARNewUserDiaryMomentLayout;
@class WARNewUserDiaryMoment;
@class WARFriendMomentLayout;
@class WARFriendCommentLayout;
@class WARNewUserDiaryComment;

#pragma mark - WARNewUserDiaryModel

@interface WARNewUserDiaryModel : NSObject

@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *lastPublishTime;
@property (nonatomic, copy) NSArray <WARNewUserDiaryMoment *> *moments;

@end

#pragma mark - WARNewUserDiaryMoment

@class WARNewUserDiaryCommentWrapper, WARFeedPageModel, WARDBContactModel,WARNewUserDiaryThumbUser;

@interface WARNewUserDiaryMoment : NSObject<NSCopying>

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, strong) WARNewUserDiaryCommentWrapper *commentWrapper;

@property (nonatomic, assign) NSInteger componentPageCount;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *momentId;

/** 分页内容 */
@property (nonatomic, copy) NSArray <WARFeedPageModel *> *pageContents;
/** 权限 */
@property (nonatomic, copy) NSString *permission;
/** 发布平台 */
@property (nonatomic, copy) NSArray <NSString *> *platforms;
/** 点赞数 */
@property (nonatomic, assign) NSInteger praiseCount;
/** 发布时间 */
@property (nonatomic, copy) NSString *publishTime;
/** 步数 */
@property (nonatomic, assign) NSInteger stepNum;
/** 步数排名 */
@property (nonatomic, assign) NSInteger stepRank;
/** 点赞用户 */
@property (nonatomic, copy) NSArray <WARNewUserDiaryThumbUser *> *thumbUsers;
/** 是否点赞 */
@property (nonatomic, assign) BOOL thumbUp;
/** 天气 */
@property (nonatomic, copy) NSString *weather;

/** 辅助字段 */
/** 日志布局 */
@property (nonatomic, strong) WARNewUserDiaryMomentLayout <WARFeedModelProtocol>* momentLayout;
/** 朋友圈布局 */
@property (nonatomic, strong) WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout;
/** 朋友圈列表评论布局 */
@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr;
/** 根据accountId 从数据库查询到的联系人 */
@property (nonatomic, strong) WARDBContactModel *friendModel;
/** 发布时间 */
@property (nonatomic, copy) NSString *publishTimeString;
/** 发布时间 */
@property (nonatomic, copy) NSMutableAttributedString *publishTimeAttributedString;
/** cellType */
@property (nonatomic, assign) WARFriendCellType cellType; 
/** moment展现在什么模块 */
@property (nonatomic, assign) WARMomentShowType momentShowType;
/** 天气类型 */
@property (nonatomic, assign) WARWeatherType weatherType;
/** 是自己发布的 */
@property (nonatomic, assign) BOOL isMine;
/** 显示点赞展开收起按钮 */
@property (nonatomic, assign) BOOL showLikeExtend;
/** 显示评论展开收起按钮 */
@property (nonatomic, assign) BOOL showCommentExtend;
/** 点赞用户 */
@property (nonatomic, copy) NSAttributedString *thumbUsersAttributedContent;
/** 限制点赞用户显示数量 */
@property (nonatomic, copy) NSAttributedString *limitThumbUsersAttributedContent;

@end


#pragma mark - WARNewUserDiaryThumbUser

@interface WARNewUserDiaryThumbUser: NSObject

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *lastId;
@property (nonatomic, copy) NSString *name;

/** 辅助字段 */
/** 根据accountId 从数据库查询到的联系人 */
//@property (nonatomic, strong) WARDBContactModel *friendModel;

- (WARDBContactModel *)getFriendModel;

@end


#pragma mark - WARNewUserDiaryCommentWrapper
@interface WARNewUserDiaryCommentWrapper: NSObject

@property (nonatomic, copy) NSArray <WARNewUserDiaryComment *> *comments;
@property (nonatomic, copy) NSString *refId;


@end

#pragma mark - WARNewUserDiaryComment
@class WARNewUserDiaryVoice,WARNewUserDiaryUser,WARNewUserDiaryMedia;
@interface WARNewUserDiaryComment: NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* commentId;
@property (nonatomic, copy) NSString* commentTime;
@property (nonatomic, copy) NSString* msgId;
@property (nonatomic, strong) WARNewUserDiaryVoice *commentVoiceInfo;
@property (nonatomic, strong) WARNewUserDiaryUser *commentorInfo;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, copy) NSString* replyId;
@property (nonatomic, strong) WARNewUserDiaryUser *replyorInfo;
@property (nonatomic, copy) NSArray <WARNewUserDiaryMedia *> *medias;
@property (nonatomic, assign) BOOL thumbUp;

- (NSString *)totalTitle;
- (WARNewUserDiaryUser *) featchCommentorInfoWithAccountId:(NSString *)accountId;
- (WARNewUserDiaryUser *) featchReplyorInfoWithAccountId:(NSString *)accountId;

@end

#pragma mark - WARNewUserDiaryVoice

@interface WARNewUserDiaryVoice: NSObject

@property (nonatomic, copy) NSString* duration;
@property (nonatomic, copy) NSString* voiceId;

@property (nonatomic, copy) NSString* voiceURLStr;
@property (nonatomic, strong) NSURL* voiceURL;

@property (nonatomic, assign) BOOL isPlaying;
@end

#pragma mark - WARNewUserDiaryUser

@interface WARNewUserDiaryUser: NSObject

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *lastId;
@property (nonatomic, copy) NSString *headId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *sign;
@end

#pragma mark - WARNewUserDiaryMedia

@interface WARNewUserDiaryMedia: NSObject

@property (nonatomic, copy) NSString* duration;
@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSString* imgH;
@property (nonatomic, copy) NSString* imgId;
@property (nonatomic, copy) NSString* imgW;

@property (nonatomic, strong) NSURL* imageURL;
@property (nonatomic, strong) NSURL* originalImgURL;
@property (nonatomic, strong) NSURL* videoURL;

@end

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface FriendCommentTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end
