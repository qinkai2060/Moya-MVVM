//
//  WARUserEventMainViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import "WARUserEventMainViewController.h"

#import "WARLocalizedHelper.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"




#import "WARJournalListViewController.h"
#import "WARUserRepositoryViewController.h"
#import "WARUserOrderViewController.h"
#import "WARUserOtherViewController.h"

#import "WARDBUserManager.h"


#define kPageTitleHeight 49

@interface WARUserEventMainViewController ()<WARCPageTitleViewDelegate, WARCPageContentViewDelegare>
@property (nonatomic,retain) NSMutableArray *childViewControllersArray;

@property (nonatomic, strong) WARJournalListViewController *myDiaryVC;
@property (nonatomic, strong) WARUserRepositoryViewController *myRepositoryVC;
@property (nonatomic, strong) WARUserOrderViewController *myOrderVC;
@property (nonatomic, strong) WARUserOtherViewController *myOtherVC;;
@end

@implementation WARUserEventMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

        self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
   [self.navigationController setNavigationBarHidden:YES];
    
    [WARUIHelper setThemeColor:self];
    //back button
    UIButton *button = (UIButton*)(self.navigationItem.leftBarButtonItem.customView);
    [button setImage:[WARUIHelper war_backWhite] forState:UIControlStateNormal];
    
    
    self.title = [WARDBUserManager userModel].nickname;
    
    [self configureContentViews];
    

    
    
}

- (void)configureContentViews{
    //[self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
}

#pragma mark - WARCPageTitleViewDelegate && WARCPageContentViewDelegare
// 点击
//- (void)WARCPageTitleView:(WARCPageTitleView *)WARCPageTitleView selectedIndex:(NSInteger)selectedIndex {
//    
//    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
//    
//    self.currentControllerIndex = selectedIndex;
//}
//滚动


- (void)WARCPageContentView:(WARCPageContentView *)WARCPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    if ([self.delegete respondsToSelector:@selector(UserEventMainViewController:scrollindex:progress:originalIndex:)]){
        [self.delegete UserEventMainViewController:self scrollindex:targetIndex progress:progress originalIndex:originalIndex];
    }

}
#pragma mark ---------getter methods--------------------
- (WARJournalListViewController *)myDiaryVC{
    if (!_myDiaryVC) {
        _myDiaryVC = [[WARJournalListViewController alloc]init];
    }
    return _myDiaryVC;
}

- (WARUserRepositoryViewController *)myRepositoryVC{
    if (!_myRepositoryVC) {
        _myRepositoryVC = [[WARUserRepositoryViewController alloc]init];
    }
    return _myRepositoryVC;
}

- (WARUserOrderViewController *)myOrderVC{
    if (!_myOrderVC) {
        _myOrderVC = [[WARUserOrderViewController alloc]init];
    }
    return _myOrderVC;
}

- (WARUserOtherViewController *)myOtherVC{
    if (!_myOtherVC) {
        _myOtherVC = [[WARUserOtherViewController alloc]init];
    }
    return _myOtherVC;
}

- (NSMutableArray *)childViewControllersArray{
    if (!_childViewControllersArray) {
        _childViewControllersArray = [[NSMutableArray array]init];
        
        [_childViewControllersArray addObject:self.myDiaryVC];
        [_childViewControllersArray addObject:self.myRepositoryVC];
        [_childViewControllersArray addObject:self.myOrderVC];
        [_childViewControllersArray addObject:self.myOtherVC];
    }
    return _childViewControllersArray;
}

//- (WARCPageTitleView *)pageTitleView{
//    if (!_pageTitleView) {
//        _pageTitleView = [[WARCPageTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageTitleHeight) delegate:self titleNames:@[WARLocalizedString(@"动态"),WARLocalizedString(@"仓库"),WARLocalizedString(@"订单"),WARLocalizedString(@"其他")] badgeViewType:WARBadgeDotViewType];
//        _pageTitleView.backgroundColor = kColor(whiteColor);
//        _pageTitleView.titleColorStateSelected = COLOR_WORD_Theme;
//        _pageTitleView.titleColorStateNormal = COLOR_WORD_GRAY_9;
//        _pageTitleView.indicatorColor = COLOR_WORD_Theme;
//        _pageTitleView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
//        _pageTitleView.titleLabelFont = kFont(17);
//        _pageTitleView.isNeedBounces = NO;
//        [_pageTitleView disPlayBadgeAtIndexPath:0 isShow:NO];
//        [_pageTitleView disPlayBadgeAtIndexPath:1 isShow:NO];
//        [_pageTitleView disPlayBadgeAtIndexPath:2 isShow:NO];
//        [_pageTitleView disPlayBadgeAtIndexPath:3 isShow:NO];
//    }
//    return _pageTitleView;
//}

- (WARCPageContentView *)pageContentView{
    if (!_pageContentView) {
        NSArray *childArr = [NSArray arrayWithArray:self.childViewControllersArray];
        CGFloat contentViewHeight = kScreenHeight - kPageTitleHeight - kStatusBarAndNavigationBarHeight-kTabbarHeight;
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
//        _pageContentView.delegatePageContentView = self;
        _pageContentView.backgroundColor = kColor(blueColor);
    }
    return _pageContentView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
