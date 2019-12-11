//
//  WARFriendViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARBaseViewController.h"
@class WARMoment;
@class WARRecommendVideo;

typedef void (^PushToFriendDetailblock)(WARMoment *moment);
typedef void (^PushToFriendCommentDetailblock)(WARMoment *moment);
typedef void (^PushToFriendMessageblock)();
typedef void (^DealWithLoadResultNoMoreDataBlock)(BOOL noMoreData);
typedef void (^PushToWebBrowserBlock)(NSString *url);
typedef void (^PushToPlayBlock)(WARRecommendVideo *video,BOOL fullScreen);
typedef void (^PushToUserProfileBlock)(NSString *guyId,NSString *friendWay,BOOL isMine);

typedef void(^WARFriendListViewControllerCategorysBlock)(NSArray <NSString *> *categorys);

@interface WARFriendListViewController : WARBaseViewController

- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId;

- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId
                        from:(NSString *)from
              pushController:(UIViewController *)pushController;

- (instancetype)initWithType:(NSString *)type
                      maskId:(NSString *)maskId
                        from:(NSString *)from
                       label:(NSString *)lable
                    sysLabel:(NSArray<NSString *> *)sysLabel
              pushController:(UIViewController *)pushController;

@property (nonatomic, copy) PushToFriendDetailblock pushBlock;
@property (nonatomic, copy) PushToFriendCommentDetailblock pushCommentBlock;
@property (nonatomic, copy) PushToFriendMessageblock pushToFriendMessageblock;
@property (nonatomic, copy) DealWithLoadResultNoMoreDataBlock dealWithLoadResultNoMoreDataBlock;
@property (nonatomic, copy) PushToWebBrowserBlock pushToWebBrowserblock;
@property (nonatomic, copy) PushToWebBrowserBlock pushToGameWebBrowserblock;
@property (nonatomic, copy) PushToUserProfileBlock pushToUserProfileBlock;
@property (nonatomic, copy) PushToPlayBlock pushToPlayBlock;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) float contentOffsetY;
@property (nonatomic, assign) float contentOffsetBottomY;
@property (nonatomic, assign) float contentOffsetUpY;

/**
 根据面具id加载数据

 @param maskId 面具id(）
 */
- (void)loadDataWithMaskId:(NSString *)maskId;

/**
 根据类别加载数据
 
 @param category  （推荐@"MESSAGE" ,关注 @"FOLLOW"）
 */
- (void)loadDataWithCategory:(NSString *)category;

/**
 根据类别加载数据
 
 @param category  （推荐@"MESSAGE" ,其他分类名）
 @param isFollow   是否是关注
 */
- (void)loadDataWithCategory:(NSString *)category isFollow:(BOOL)isFollow;

/**
 群推荐，切换标签加载数据

 @param lable 标签
 */
- (void)loadDataWithLable:(NSString *)lable;
 
/**
 加载数据

 @param refresh 是否是刷新
 */
- (void)loadDataRefresh:(BOOL)refresh ;
- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData;


/** categorys 回调 */
@property (nonatomic, copy) WARFriendListViewControllerCategorysBlock maskIdListsBlock;
 
//- (void)loadDataWithCategoryId:(NSString *)categoryId;

@end
