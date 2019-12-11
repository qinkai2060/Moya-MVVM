//
//  WARUSerCenterProfileCell.m
//  Pods
//
//  Created by 秦恺 on 2018/1/29.
//

#import "WARUSerCenterProfileCell.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARUserCenterViewController.h"
#import "WARMediator+SendInfo.h"
#import "WARPhotoViewController.h"
#import "WARMediator+Order.h"
#import "UIImage+WARBundleImage.h"
#import "WARCreatPhotoViewController.h"
#import "WARProfileNetWorkTool.h"
#import "WARPhotoDetailsViewController.h"
#import "WARGroupModel.h"
#import "TZAssetModel.h"
#import "WARProfileOtherViewController.h"
#import "WARProfileUserModel.h"
#import "WARPhotoTempBrowserViewController.h"
#import "WARFriendCycleViewController.h"
#import "WARCycleOfFriendViewController.h"
#import "WARPhotosSortGroupViewController.h"
#import "WARProfileFavoriteViewController.h"
#import "WARFavriteCreatEditeViewController.h"
#import "WARFavoriteModel.h"
#import "WARMediator+Publish.h"

#import "WAROtherJournalListViewController.h"
#import "WARBaseUserDiaryViewController.h"
#import "WARJournalDetailViewController.h"
#import "WARJournalDetailViewController1.h"
#import "WARFriendDetailViewController.h"

#import "WARMediator+WebBrowser.h"
#import "WARWebViewController.h"

#import "WARDouYinPlayVideoVC.h"
#import "WARLightPlayVideoVC.h"
#import "WARMessageListViewController.h"
#import "WARMediator+Store.h"
#define kPageTitleHeight 49


@interface WARUSerCenterProfileCell ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,WARBaseUserDiaryViewControllerDelegate>


@property (strong, nonatomic) UIPageViewController *pageViewCtrl;

@property (strong, nonatomic) UIScrollView *pageScrollView;


/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;

@end
@implementation WARUSerCenterProfileCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier atType:(BOOL)isMine atGuyId:(NSString*)guyID {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.guyID = guyID;
        [self customPageViewWithType:isMine];
        
    }
    return self;
}
- (void)customPageViewWithType:(BOOL)isMine {
    __weak __typeof(&*self)weakSelf = self;
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewCtrl = [[UIPageViewController alloc]
                         initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                         options:option];
    self.pageViewCtrl.dataSource = nil;
    self.pageViewCtrl.delegate = self;
    //日志
    WARBaseUserDiaryViewController *ctrl1;
    WS(weakself);
    if (isMine) {
        ctrl1 = [[WARJournalListViewController alloc] initWithType:isMine];
    } else {
        ctrl1 = [[WAROtherJournalListViewController alloc] initWithFriendId:self.guyID];
    }
    ctrl1.block = ^{
        UIViewController *vc =  [weakself currentVC:weakSelf];
        WARCycleOfFriendViewController *controller = [[WARCycleOfFriendViewController alloc]initWithType:@"FRIEND" maskId:@"" from:@"" pushController:vc];
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.pushToDiaryDetailblock = ^(WARMoment *moment) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        WARJournalDetailViewController1 *controller = [[WARJournalDetailViewController1 alloc]initWithMoment:moment];
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.pushToPublishblock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForMainEditBoardViewController];
        [vc.navigationController pushViewController:publishVC animated:YES];
    };
    ctrl1.pushToFeedEditingblock = ^(NSString *momentId) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForFeedEditingViewController:momentId];
        [vc.navigationController pushViewController:controllr animated:YES];
    };
    ctrl1.pushToWebBrowserblock = ^(NSString *url) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        UIViewController *controller = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:url callback:nil];//[WARWebViewController showWithUrlString:url];//
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.pushToPlayBlock = ^(WARRecommendVideo *video, BOOL fullScreen) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        WARDouYinPlayVideoVC *controller = [[WARDouYinPlayVideoVC alloc] initWithFirstVideo:video];
        if (!fullScreen) {
            controller = [[WARLightPlayVideoVC alloc] initWithFirstVideo:video];
        }
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.pushToFootprintblock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        WARMessageListViewController *controller = [[WARMessageListViewController alloc] init];
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.pushToGroupMomentblock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        WARMessageListViewController *controller = [[WARMessageListViewController alloc] initWithNotificationType:(WARNotificationTypePublicGroup)];
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.pushToAllContextblock = ^(WARMoment *moment) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIViewController *vc =  [strongSelf currentVC:strongSelf];
        WARFriendDetailViewController *controller = [[WARFriendDetailViewController alloc] initWithMoment:moment type:@"FOLLOW"];
        [vc.navigationController pushViewController:controller animated:YES];
    };
    ctrl1.delegate = self;
    WARPhotoViewController *ctrl2 = [[WARPhotoViewController alloc] initWithType:isMine atGuyID:self.guyID];
    ctrl2.block = ^(NSIndexPath *indexpath,WARGroupModel *model) {
        
        UIViewController *vc =    [weakself currentVC:weakself];
        if ([vc isKindOfClass:[WARProfileOtherViewController class]]){
            WARProfileOtherViewController *otherPVC = (WARProfileOtherViewController*)vc;
            WARPhotoDetailsViewController *VC = [[WARPhotoDetailsViewController alloc] initWithModel:model atAccountID:     weakself.guyID.length == 0 ? @"":weakself.guyID];
            VC.view.backgroundColor = [UIColor whiteColor];
            [otherPVC.navigationController pushViewController:VC animated:YES];
        } else{
            if (indexpath.item == 0) {
                
                WARCreatPhotoViewController *VC = [[WARCreatPhotoViewController alloc] init];
                VC.guyID = weakself.guyID;
                VC.isOtherEnterHome = weakself.isOtherEnterHome;
                VC.view.backgroundColor = [UIColor whiteColor];
                [vc.navigationController pushViewController:VC animated:YES];
                
            }else{
                // 进入相册详情 判断当前是不是好友 是不是有权限
                WARPhotoDetailsViewController *VC = [[WARPhotoDetailsViewController alloc] initWithModel:model atAccountID:weakself.guyID.length == 0 ? @"":weakself.guyID];
                VC.isOtherEnterHome = weakself.isOtherEnterHome;
                VC.uploadCount = model.uploadArray.count;
                VC.view.backgroundColor = [UIColor whiteColor];
                [vc.navigationController pushViewController:VC animated:YES];
            }
        }
        
    };
    ctrl2.sortBlock = ^(NSMutableArray *dataArr) {
        
        //    [dataArr removeObjectAtIndex:0];
        
        UIViewController *vc =    [weakself currentVC:weakself];
        WARPhotosSortGroupViewController *sortGroupViewVC = [[WARPhotosSortGroupViewController alloc] init];
        sortGroupViewVC.view.backgroundColor = [UIColor whiteColor];
        sortGroupViewVC.sortArray = dataArr;
        [vc.navigationController pushViewController:sortGroupViewVC animated:YES];
        
    };
    
    ctrl2.tempBrowserBlock = ^(NSArray *dataArr, NSInteger index) {
        UIViewController *vc =    [weakself currentVC:weakself];
        WARPhotoTempBrowserViewController *tempBrowserVC = [[WARPhotoTempBrowserViewController alloc] initWithModel:nil atCurrentindex:index atImagePictureArray:dataArr atAccountID:     weakself.guyID.length == 0 ? @"":weakself.guyID];
        [vc.navigationController pushViewController:tempBrowserVC animated:YES];
    };
    WARProfileFavoriteViewController *ctrl3 = [[WARProfileFavoriteViewController alloc] init];
    ctrl3.creatBlock = ^{
         UIViewController *vc =    [weakself currentVC:weakself];
        WARFavriteCreatEditeViewController *vccreat = [[WARFavriteCreatEditeViewController alloc] init];
        [vc.navigationController pushViewController:vccreat animated:YES];
    };
    ctrl3.editingBlock = ^(WARFavoriteInfoModel *model) {
        UIViewController *vc =    [weakself currentVC:weakself];
        WARFavriteCreatEditeViewController *vccreat = [[WARFavriteCreatEditeViewController alloc] init];
        [vccreat enterEditingFav:model];
        [vc.navigationController pushViewController:vccreat animated:YES];
    };
  UIViewController *ctr4 =  [[WARMediator sharedInstance] Mediator_viewControllerForNewShopping:@"https://wander.wallan-tech.com:1443/games/wallanshop"];
    self.dataArray = @[ctrl1,ctrl2,ctrl3,ctr4].mutableCopy;
    
    [self.pageViewCtrl setViewControllers:@[self.dataArray[0]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:NO
                               completion:nil];
    
    
    [self.contentView addSubview:self.pageViewCtrl.view];
    
    for (UIView *view in self.pageViewCtrl.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            //监听拖动手势
            self.pageScrollView = (UIScrollView *)view;
            [self.pageScrollView addObserver:self
                                  forKeyPath:@"panGestureRecognizer.state"
                                     options:NSKeyValueObservingOptionNew
                                     context:nil];
        }
    }
    
    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}
- (void)dragViewPoint:(CGPoint)point selectIndex:(NSInteger)selectIndex data:(TZAssetModel*)model {
    WARPhotoViewController *vc = self.dataArray[selectIndex];
    [vc coverpoin:self drapPoint:point photos:model];
}
- (void)dragViewPointChange:(CGPoint)point selectIndex:(NSInteger)selectIndex data:(TZAssetModel*)model {
     WARPhotoViewController *vc = self.dataArray[selectIndex];
     [vc coverpoinChange:self drapPoint:point photos:model];
}
- (void)outDragViewPoint{
    WARPhotoViewController *vc = self.dataArray[self.selectIndex];
    [vc outOfRang];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewGestureState" object:@"changed"];
    } else if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewGestureState" object:@"ended"];
    }
    
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    
    //修改所有的子控制器的状态
    for (UIViewController *ctrl in self.dataArray) {
        if ([ctrl isKindOfClass:[WARJournalListViewController class]]) {
            WARJournalListViewController *vc = (WARJournalListViewController*)ctrl;
            vc.canScroll = canScroll;
            if (!canScroll) {
                vc.tableView.contentOffset = CGPointZero;
            }
        }else if ([ctrl isKindOfClass:[WARPhotoViewController class]]) {
            WARPhotoViewController *vc = (WARPhotoViewController*)ctrl;
            
            vc.canScroll = canScroll;
            if (!canScroll) {
                vc.collectionView.contentOffset = CGPointZero;
            }
        }
        else{
            // 处理WAROrderListViewController
            WARProfileFavoriteViewController *vc = (WARProfileFavoriteViewController*)ctrl;
            vc.canScroll = canScroll;
      

            
        }
      
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (_selectIndex == 1) {
        WARPhotoViewController *vc = self.dataArray[selectIndex];
        vc.isMine = self.isMine;
    }
    
    [self.pageViewCtrl setViewControllers:@[self.dataArray[selectIndex]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:YES
                               completion:nil];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController {
    // 计算当前 viewController 数据在数组中的下标
    NSUInteger index = [self.dataArray indexOfObject:viewController];
    // index 为 0 表示已经翻到最前页
    if (index == 0 ||index == NSNotFound) {
        return  nil;
    }
    // 下标自减
    index --;
    
    return self.dataArray[index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController {
    // 计算当前 viewController 数据在数组中的下标
    NSUInteger index = [self.dataArray indexOfObject:viewController];
    // index为数组最末表示已经翻至最后页
    if (index == NSNotFound ||
        index == (self.dataArray.count - 1)) {
        return nil;
    }
    // 下标自增
    index ++;
    return self.dataArray[index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    NSUInteger index = [self.dataArray indexOfObject:self.pageViewCtrl.viewControllers.firstObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenterPageViewScroll" object:[NSNumber numberWithUnsignedInteger:index]];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControl {
    
}
-(void)dl_refresh
{
    UIViewController *ctrl = self.dataArray[self.selectIndex] ;

    if ([ctrl isKindOfClass:[WARJournalListViewController class]]) {
        WARJournalListViewController *vc = (WARJournalListViewController*)ctrl;
        [vc loadDataRefresh:YES];
    }else if ([ctrl isKindOfClass:[WARPhotoViewController class]]) {
        WARPhotoViewController *vc = (WARPhotoViewController*)ctrl;
    }
    else{
    }
}


-(void)dl_UserDiarviewControllerDidFinishRefreshing:(WARJournalListViewController *)viewController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:)]) {
        [self.delegate dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:self];
    }
}

@end
