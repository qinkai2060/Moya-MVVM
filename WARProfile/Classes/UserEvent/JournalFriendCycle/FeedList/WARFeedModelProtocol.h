//
//  WARFeedModelProtocol.h
//  WARControl
//
//  Created by helaf on 2018/4/26.
//
/**
 moment（显示在哪个列表）类型
 
 - WARMomentShowTypeUserDiary: 日志
 - WARMomentShowTypeFriend: 朋友圈
 - WARMomentShowTypeFriendFollow: 关注
 - WARMomentShowTypeFriendDetail: 朋友圈详情
 - WARMomentShowTypeFullText: 全文
 - WARMomentShowTypeUserDiaryDetail: 日志详情
 - WARMomentShowTypeMapProfile: 地图个人动态列表
 */
typedef NS_ENUM(NSUInteger, WARMomentShowType) {
    WARMomentShowTypeUserDiary = 0,
    WARMomentShowTypeFriend,
    WARMomentShowTypeFriendFollow,
    WARMomentShowTypeFriendFollowDetail,
    WARMomentShowTypeFriendDetail,
    WARMomentShowTypeFullText,
    WARMomentShowTypeUserDiaryDetail,
    WARMomentShowTypeMapProfile
};

#pragma mark - 模型必须遵循的协议
 
@class WARFeedPageLayout;

@protocol WARFeedModelProtocol <NSObject>

/** 当前页的索引 */
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* feedLayoutArr;
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* limitFeedLayoutArr;

@end

