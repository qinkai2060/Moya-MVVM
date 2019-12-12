//
//  WARFriendViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARBaseViewController.h"
@class WARMoment;
@class WARRecommendVideo;

/** block */
/** 带moment参数跳转 */
typedef void (^WARPushWithMomentBlock)(WARMoment *moment);
/** 不带参数跳转 */
typedef void (^WARPushBlock)(void);
/** 带url参数跳转 */
typedef void (^WARPushWithUrlBlock)(NSString *url);
/** 跳转视频播放 */
typedef void (^WARPushWithVideoBlock)(WARRecommendVideo *video,BOOL fullScreen);
/** 个人主页跳转 */
typedef void (^WARPushWithGuyIdFriendWayIsMineBlock)(NSString *guyId,NSString *friendWay,BOOL isMine);
/** 处理是否还有更多数据 */
typedef void (^WARDealResultWithNoMoreData)(BOOL noMoreData);
/** 回调面具id数组 */
typedef void (^WARMomentListViewControllerMaskIdListsBlock)(NSArray <NSString *> *maskIdLists);

/** 子类重写 */
/** scrollView滚动时调用 */
typedef void (^WARScrollViewDidScrollBlock)(UIScrollView *scrollView);
/** 松手时已经静止, 只会调用scrollViewDidEndDragging */
typedef void (^WARScrollViewDidEndDraggingBlock)(UIScrollView *scrollView,BOOL willDecelerate);
/** 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating */
typedef void (^WARScrollViewDidEndDeceleratingBlock)(UIScrollView *scrollView);

@interface WARFriendTrackListVC : WARBaseViewController

/**
 初始化

 @param type 类型（FOLLOW、FRIEND）
 @param maskId 面具id
 @return return value description
 */
- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId;

/**
 初始化

 @param type 类型（FOLLOW、FRIEND）
 @param maskId 面具id
 @param from 来源（MESSAGE：消息模块的推荐；CHAT: 群内的推荐；默认（好友圈、关注）不传）
 @param pushController push控制器
 @return return value description
 */
- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId
                        from:(NSString *)from
              pushController:(UIViewController *)pushController;

/**
 根据面具id加载数据

 @param maskId 首页选的类型
 */
- (void)loadDataWithMaskId:(NSString *)maskId;

/**
 根据面具id数组加载数据
 
 @param maskIdLists 面具id
 */
- (void)loadDataWithMaskIdLists:(NSArray *)maskIdLists;

/**
 加载数据

 @param refresh 是否刷新
 */
- (void)loadDataRefresh:(BOOL)refresh ;

/**
 处理更多数据

 @param noMoreData 是否还有更多数据
 */
- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData;

/** scrollView滚动时调用 子类去实现 */
- (void)tableView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView;
/** 松手时已经静止, 只会调用scrollViewDidEndDragging 子类去实现 */
- (void)tableView:(UITableView *)tableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/** 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating 子类去实现 */
- (void)tableView:(UITableView *)tableView scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)tableView:(UITableView *)tableView scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)tableView:(UITableView *)tableView scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

/** 朋友圈详情 */
@property (nonatomic, copy) WARPushWithMomentBlock pushFriendDetailBlock;
/** 评论详情 */
@property (nonatomic, copy) WARPushWithMomentBlock pushCommentBlock;
/** 朋友圈消息列表 */
@property (nonatomic, copy) WARPushBlock pushToFriendMessageblock;
/** 处理更多数据 */
@property (nonatomic, copy) WARDealResultWithNoMoreData dealWithLoadResultNoMoreDataBlock;
/** 调整网页 */
@property (nonatomic, copy) WARPushWithUrlBlock pushToWebBrowserblock;
/** 个人主页 */
@property (nonatomic, copy) WARPushWithGuyIdFriendWayIsMineBlock pushToUserProfileBlock;
/** 视频播放 */
@property (nonatomic, copy) WARPushWithVideoBlock pushToPlayBlock;
/** maskIdLists 回调 */
@property (nonatomic, copy) WARMomentListViewControllerMaskIdListsBlock maskIdListsBlock;
/** scrollView滚动时回用 */
@property (nonatomic, copy) WARScrollViewDidScrollBlock scrollViewDidScrollBlock;
/** 松手时已经静止, 只会调用scrollViewDidEndDragging 回调 */
@property (nonatomic, copy) WARScrollViewDidEndDraggingBlock scrollViewDidEndDraggingBlock;
/** 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating 回调 */
@property (nonatomic, copy) WARScrollViewDidEndDeceleratingBlock scrollViewDidEndDeceleratingBlock;

/** 动态列表展示 */
@property (nonatomic, strong) UITableView *tableView;
/** tableView是否可以滚动 */
@property (nonatomic, assign) BOOL canScroll;
/** tableView 的 contentOffsetY */
@property (nonatomic, assign) float contentOffsetY;
/** tableView 的 contentOffsetBottomY */
@property (nonatomic, assign) float contentOffsetBottomY;
/** tableView 的 contentOffsetUpY */
@property (nonatomic, assign) float contentOffsetUpY;

@end
