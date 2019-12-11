//
//  WARMessageListViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARMessageListViewController.h"
#import "WARCollectionMessageListVC.h"
#import "WARPhotoMessageListVC.h"
#import "WARFriendMessageListVC.h"
#import "WARProfileOtherViewController.h"

#import "WARCPageTitleView.h"
#import "WARCPageContentView.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"

#import "WARDBNotification.h"

#import "WARMomentUser.h"


static const CGFloat kPageTitleHeight = 34.0;

@interface WARMessageListViewController ()<WARCPageTitleViewDelegate ,WARCPageContentViewDelegare>

/** pageContentView */
@property (nonatomic, strong) WARCPageContentView *pageContentView;
/** titleSegmentView */
@property (nonatomic, strong) WARCPageTitleView *titleSegmentView;

/** groupMomentMessageListVC */
@property (nonatomic, strong) UIViewController *groupMomentMessageListVC;
/** groupPublicMessageListVC */
@property (nonatomic, strong) WARFriendMessageListVC *groupPublicMessageListVC;
/** friendMessageListVC */
@property (nonatomic, strong) WARFriendMessageListVC *friendMessageListVC;
/** photoMessageListVC */
@property (nonatomic, strong) WARFriendMessageListVC *photoMessageListVC;
/** collectionMessageListVC */
@property (nonatomic, strong) WARCollectionMessageListVC *collectionMessageListVC;

/** 消息通知类型 */
@property (nonatomic, assign) WARNotificationType notificationType;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@end

@implementation WARMessageListViewController

#pragma mark - System

- (instancetype)initWithNotificationType:(WARNotificationType) notificationType {
    if (self = [super init]) {
        self.notificationType = notificationType;
        switch (notificationType) {
            case WARNotificationTypeGroupMoment:
                self.selectedIndex = 0;
                break;
            case WARNotificationTypePublicGroup:
                self.selectedIndex = 1;
                break;
            case WARNotificationTypeFriend:
                self.selectedIndex = 2;
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addRealmObserver];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.title = WARLocalizedString(@"消息列表");
    
    [self.view addSubview:self.titleSegmentView];
    [self.view addSubview:self.pageContentView];
    
    self.titleSegmentView.selectedIndex = self.selectedIndex;
}

- (void)dealloc {
    [self removeRealmObserver];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARCPageTitleViewDelegate

- (void)WARCPageTitleView:(WARCPageTitleView *)WARCPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    [self updateSubControllersWithIndex:selectedIndex];
}

#pragma mark - WARCPageContentViewDelegare

- (void)WARCPageContentView:(WARCPageContentView *)WARCPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.titleSegmentView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    
    [self updateSubControllersWithIndex:targetIndex];
}

- (void)updateSubControllersWithIndex:(NSInteger)selectedIndex {
    if (selectedIndex < self.childViewControllers.count) {
        for (int i = 0; i < self.childViewControllers.count; i++) {
            UIViewController *vc = [self.childViewControllers objectAtIndex:i];
            if (i == selectedIndex) {
                [vc viewWillAppear:NO];
            }else {
                [vc viewWillDisappear:NO];
            }
        }
    }
}


#pragma mark - Observer

- (void)addRealmObserver {
    __weak typeof(self) weakSelf = self; 
    self.notificationToken = [[WARDBNotification allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NDLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }else{
            if (change) {
                NSInteger friendUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypeFriend)];
                NSInteger groupUnReadCount = [WARDBNotification sumOfUnreadWithType:(WARDBNotificationTypePerson)];
             
                [strongSelf.titleSegmentView setNumber:friendUnReadCount atIndex:2];
                [strongSelf.titleSegmentView setNumber:groupUnReadCount atIndex:1];
            }
        }
    }];
}

- (void)removeRealmObserver {
    [_notificationToken invalidate];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (WARCPageTitleView *)titleSegmentView {
    if (!_titleSegmentView) {
        NSArray *titleArray = @[WARLocalizedString(@"群动态"),WARLocalizedString(@"公众圈"),WARLocalizedString(@"好友圈"),WARLocalizedString(@"相册")];
        //,WARLocalizedString(@"足迹"),WARLocalizedString(@"相册"),WARLocalizedString(@"收藏")
        _titleSegmentView = [[WARCPageTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kPageTitleHeight) delegate:self titleNames: titleArray badgeViewType:WARBadgeNumberViewType];
        _titleSegmentView.isNeedBounces = NO;
        _titleSegmentView.backgroundColor = [UIColor whiteColor];
        _titleSegmentView.titleColorStateSelected = HEXCOLOR(0x2CBE61);
        _titleSegmentView.titleColorStateNormal = HEXCOLOR(0x8D93A4);
        _titleSegmentView.indicatorColor = HEXCOLOR(0x2CBE61);
        _titleSegmentView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
        _titleSegmentView.titleLabelFont = kFont(14);
         
//        [_titleSegmentView disPlayBadgeAtIndexPath:0 isShow:NO];
//        [_titleSegmentView disPlayBadgeAtIndexPath:1 isShow:NO];
//        [_titleSegmentView disPlayBadgeAtIndexPath:2 isShow:NO]; 
    }
    return _titleSegmentView;
}

- (WARCPageContentView *)pageContentView {
    if (!_pageContentView) {
        /// 群动态
        self.groupMomentMessageListVC = [[UIViewController alloc] init];
        
        /// 公众圈
        self.groupPublicMessageListVC = [[WARFriendMessageListVC alloc] initWithNotificationType:(WARNotificationTypePublicGroup)];
        __weak typeof(self) weakSelf = self;
        self.groupPublicMessageListVC.pushToUserProfileBlock = ^(WARMomentUser *user) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:user.accountId friendWay:@""];
 
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        
        /// 好友圈
        self.friendMessageListVC = [[WARFriendMessageListVC alloc] initWithNotificationType:(WARNotificationTypeFriend)];
        self.friendMessageListVC.pushToUserProfileBlock = ^(WARMomentUser *user) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:user.accountId friendWay:@""];
            //            UIViewController *controller = [[UIViewController alloc] init];
            //            controller.view.backgroundColor = [UIColor whiteColor];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        
        /// 相册
        self.photoMessageListVC = [[WARFriendMessageListVC alloc] initWithNotificationType:(WARNotificationTypeAlbum)];
        self.photoMessageListVC.pushToUserProfileBlock = ^(WARMomentUser *user) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:user.accountId friendWay:@""];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        };
        self.collectionMessageListVC = [[WARCollectionMessageListVC alloc] init];
        
        NSArray *childArr = @[self.groupMomentMessageListVC,self.groupPublicMessageListVC,self.friendMessageListVC,self.photoMessageListVC,self.collectionMessageListVC];
        CGFloat contentViewY = kPageTitleHeight;
        CGFloat contentViewHeight = kScreenHeight - contentViewY - kStatusBarAndNavigationBarHeight - kSafeAreaBottom;
        
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, contentViewY, kScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.isScrollEnabled = NO;
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}


@end
