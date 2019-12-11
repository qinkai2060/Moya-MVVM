
//  WARTrackContainerVC.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/19.
//

#import "WARTrackContainerVC.h"

#import "Masonry.h"
#import "WARMacros.h"

#import "WARExploreSegmentBar.h"
#import "WARCPageContentView.h"

#import "WARActivationExplorationTrackListVC.h"
#import "WARMineExplorationTrackListVC.h"

@interface WARTrackContainerVC ()<WARCPageContentViewDelegare>

/** pageContentView */
@property (nonatomic, strong) WARCPageContentView *pageContentView;
/** exploreSegmentBar */
@property (nonatomic, strong) WARExploreSegmentBar *exploreSegmentBar;
 
@property (nonatomic, strong) WARActivationExplorationTrackListVC *aeVc;
@property (nonatomic, strong) WARMineExplorationTrackListVC *meVc;
@end

@implementation WARTrackContainerVC

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.exploreSegmentBar];
    [self.exploreSegmentBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARCPageContentViewDelegare

- (void)WARCPageContentView:(WARCPageContentView *)WARCPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    self.exploreSegmentBar.selectedIndex = targetIndex;
    
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

#pragma mark - Private

#pragma mark - Setter And Getter

- (WARExploreSegmentBar *)exploreSegmentBar {
    if (!_exploreSegmentBar) {
        _exploreSegmentBar = [[WARExploreSegmentBar alloc]init];
        _exploreSegmentBar.didBlock = ^(NSInteger didIndex) {
            if (didIndex == 0) {
                
            } else {
                
            }
        };
    }
    return _exploreSegmentBar;
}

- (WARCPageContentView *)pageContentView {
    if (!_pageContentView) {
 
        ///
        self.aeVc = [[WARActivationExplorationTrackListVC alloc] init];
        self.meVc = [[WARMineExplorationTrackListVC alloc] init];
        
        NSArray *childArr = @[self.aeVc,self.meVc];
        CGFloat contentViewHeight = kScreenHeight - 34 - kStatusBarAndNavigationBarHeight - kSafeAreaBottom;
        
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.isScrollEnabled = NO;
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

@end
