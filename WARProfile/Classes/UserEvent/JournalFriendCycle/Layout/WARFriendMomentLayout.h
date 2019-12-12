//
//  WARNewUserDiaryMomentLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#define kSeparatorH 0.5
 
#import <Foundation/Foundation.h>
#import "WARFeedModelProtocol.h"

@class WARMoment;

@interface WARFriendMomentLayout : NSObject<WARFeedModelProtocol>

/** 使用weak，避免循环引用 */
@property (nonatomic, weak) WARMoment *moment;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat detailCellHeight;

///** 朋友圈列表评论布局 */
//@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr;

@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* feedLayoutArr;
/** 多页时最多展示3页 */
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* limitFeedLayoutArr;
/** Description */
@property (nonatomic, assign) NSInteger currentPageIndex;

/** frame */
@property (nonatomic, assign) CGRect topViewFrame;

@property (nonatomic, assign) CGRect platformContainerViewFrame;
@property (nonatomic, assign) CGRect thirdImageFrame;
@property (nonatomic, assign) CGRect thirdPlatformNameFrame;
@property (nonatomic, assign) CGRect nameLableFrame;
@property (nonatomic, assign) CGRect userImageFrame;
@property (nonatomic, assign) CGRect sexImageFrame;
@property (nonatomic, assign) CGRect ageImageFrame;
@property (nonatomic, assign) CGRect followButtonFrame;
@property (nonatomic, assign) CGRect extendButtonFrame;
@property (nonatomic, assign) CGRect adButtonFrame;

@property (nonatomic, assign) CGRect textContentLableFrame;

/** 多页视图frame */
@property (nonatomic, assign) CGRect feedMainContentViewFrame;

/** bottomview frame */
@property (nonatomic, assign) CGRect bottomViewFrame;

@property (nonatomic, assign) CGRect timeLableFrame;
@property (nonatomic, assign) CGRect addressButtonFrame;
@property (nonatomic, assign) CGRect allContextButtonFrame;
@property (nonatomic, assign) CGRect praiseButtonFrame;
@property (nonatomic, assign) CGRect commentButtonFrame;
@property (nonatomic, assign) CGRect toCommentButtonFrame;
//@property (nonatomic, assign) CGRect stepCountButtonFrame;
//@property (nonatomic, assign) CGRect closeButtonFrame;
@property (nonatomic, assign) CGRect bottomSeparatorFrame;
@property (nonatomic, assign) CGRect mineContainerFrame;

/** arrowImageFrame   */
@property (nonatomic, assign) CGRect arrowImageFrame;

/** likeview frame */
@property (nonatomic, assign) CGRect likeViewFrame;

@property (nonatomic, assign) CGRect likeBgImageViewFrame;
@property (nonatomic, assign) CGRect likeLabelFrame;
@property (nonatomic, assign) CGRect likeLableBottomLineFrame;
@property (nonatomic, assign) CGRect extendLikeFrame;
@property (nonatomic, assign) CGRect separatorFrame;

/** commentview frame */
@property (nonatomic, assign) CGRect commentViewFrame;

/** rewordView frame */
@property (nonatomic, assign) CGRect rewordViewFrame;
@property (nonatomic, assign) CGRect rewordValueLableFrame;

/** 朋友圈详情 page展开总高度 */
@property (nonatomic, assign) CGFloat extendPageContentHeight;


/**
 Description

 @param type FOLLOW:关注  FRIEND:好友
 @param moment moment description
 @param openLike openLike description
 @param openComment openComment description
 @return return value description
 */
+ (WARFriendMomentLayout *)type:(NSString *)type
                         moment:(WARMoment *)moment
                         openLike:(BOOL)openLike
                      openComment:(BOOL)openComment;

@property (nonatomic, assign) BOOL showCommentView;
@property (nonatomic, assign) BOOL showLikeView;


/**
 地图个人动态列表

 @param moment moment
 @return 地图个人动态列表布局
 */
+ (WARFriendMomentLayout *)mapProfileMomentListLayoutWithMoment:(WARMoment *)moment;

/**
 信息流布局
 
 @param moment moment
 @return 信息流列表布局
 */
+ (WARFriendMomentLayout *)flowLayoutWithMoment:(WARMoment *)moment;

@end
