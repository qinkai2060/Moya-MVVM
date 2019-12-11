//
//  WARBaseUserDiaryViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/23.
//

#import "WARBaseViewController.h"

@class WARBaseUserDiaryViewController,WARNewUserDiaryMoment,WARRecommendVideo,WARMoment;

typedef void (^UserDiaryPushToFriendCycleblock)(void);
typedef void (^UserDiaryPushToFootprintblock)(void);
typedef void (^UserDiaryPushToGroupMomentblock)(void);
typedef void (^UserDiaryPushToDiaryDetailblock)(WARMoment *moment);
typedef void (^UserDiaryPushToPublishblock)(void);
typedef void (^UserDiaryPushToFeedEditingBlock)(NSString *momentId);
typedef void (^UserDiaryPushToWebBrowserBlock)(NSString *url);
typedef void (^UserDiaryPushToPlayBlock)(WARRecommendVideo *video,BOOL fullScreen);

@protocol WARBaseUserDiaryViewControllerDelegate <NSObject>

-(void)dl_UserDiarviewControllerDidFinishRefreshing:(WARBaseUserDiaryViewController *)viewController;

@end

@interface WARBaseUserDiaryViewController : WARBaseViewController

- (instancetype)initWithType:(BOOL)isMine;

@property (assign, nonatomic) BOOL canScroll;
@property (nonatomic, copy) UserDiaryPushToFriendCycleblock block;
@property (nonatomic, copy) UserDiaryPushToFootprintblock pushToFootprintblock;
@property (nonatomic, copy) UserDiaryPushToGroupMomentblock pushToGroupMomentblock;
@property (nonatomic, copy) UserDiaryPushToDiaryDetailblock pushToDiaryDetailblock;
@property (nonatomic, copy) UserDiaryPushToDiaryDetailblock pushToAllContextblock;
@property (nonatomic, copy) UserDiaryPushToPublishblock pushToPublishblock;
@property (nonatomic, copy) UserDiaryPushToFeedEditingBlock pushToFeedEditingblock;
@property (nonatomic, copy) UserDiaryPushToWebBrowserBlock pushToWebBrowserblock;
@property (nonatomic, copy) UserDiaryPushToPlayBlock pushToPlayBlock;

@property(nonatomic, assign)BOOL isRefreshing;
@property(nonatomic, weak)id<WARBaseUserDiaryViewControllerDelegate> delegate;

-(void)dl_refresh;

@end
