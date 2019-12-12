//
//  WARGameRankContainerViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import "WARGameRankContainerViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
 
#import "WARCPageTitleView.h"
#import "WARCPageContentView.h"

#import "WARGameRankListViewController.h"

static const CGFloat kPageTitleHeight = 34.0;
static const CGFloat kCategoryBarHeight = 23.0;

@interface WARGameRankContainerViewController ()<WARCPageTitleViewDelegate,WARCPageContentViewDelegare>
/** titleSegmentView */
@property (nonatomic, strong) WARCPageTitleView *titleSegmentView;
/** pageContentView */
@property (nonatomic, strong) WARCPageContentView *pageContentView;
/** categoryBar */
@property (nonatomic, strong) UIView *categoryBar;
/** friendGameRankListVC */
@property (nonatomic, strong) WARGameRankListViewController *friendGameRankListVC;
/** areaGameRankListVC */
@property (nonatomic, strong) WARGameRankListViewController *areaGameRankListVC;
/** wholeCountryGameRankListVC */
@property (nonatomic, strong) WARGameRankListViewController *wholeCountryGameRankListVC;
/** gameId */
@property (nonatomic, copy) NSString *gameId;
/** gameId */
@property (nonatomic, copy) NSArray <NSString *> *rankNames;
@end

@implementation WARGameRankContainerViewController

#pragma mark - Initial

- (instancetype)initWithGameId:(NSString *)gameId  rankNames:(NSArray <NSString *>*)rankNames {
    if (self = [super init]) {
        self.gameId = gameId;
        self.rankNames = rankNames;
    }
    return self;
}

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = WARLocalizedString(@"游戏排行");
    
    [self.view addSubview:self.titleSegmentView];
    [self.view addSubview:self.categoryBar];
    [self.view addSubview:self.pageContentView];
    
    self.titleSegmentView.selectedIndex = 0;
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

#pragma mark - Public

#pragma mark - Private

#pragma mark - Setter And Getter
 
- (WARCPageTitleView *)titleSegmentView {
    if (!_titleSegmentView) {
        NSArray *titleArray = @[WARLocalizedString(@"好友排行"),WARLocalizedString(@"区域排行"),WARLocalizedString(@"全国排行")];
        _titleSegmentView = [[WARCPageTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kPageTitleHeight) delegate:self titleNames: titleArray badgeViewType:WARBadgeNumberViewType];
        _titleSegmentView.isNeedBounces = NO;
        _titleSegmentView.backgroundColor = [UIColor whiteColor];
        _titleSegmentView.titleColorStateSelected = HEXCOLOR(0x2CBE61);
        _titleSegmentView.titleColorStateNormal = HEXCOLOR(0x8D93A4);
        _titleSegmentView.indicatorColor = HEXCOLOR(0x2CBE61);
        _titleSegmentView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
        _titleSegmentView.titleLabelFont = kFont(14);
    }
    return _titleSegmentView;
}

- (WARCPageContentView *)pageContentView {
    if (!_pageContentView) {
        if (self.rankNames.count >= 3) {
            self.friendGameRankListVC = [[WARGameRankListViewController alloc] initWithGameId:self.gameId rankName:self.rankNames[0]];
            self.areaGameRankListVC = [[WARGameRankListViewController alloc]  initWithGameId:self.gameId rankName:self.rankNames[1]];
            self.wholeCountryGameRankListVC = [[WARGameRankListViewController alloc]  initWithGameId:self.gameId rankName:self.rankNames[2]];
        }
        
        NSArray *childArr = @[self.friendGameRankListVC,self.areaGameRankListVC,self.wholeCountryGameRankListVC];
        CGFloat contentViewY = kPageTitleHeight + kCategoryBarHeight;
        CGFloat contentViewHeight = kScreenHeight - contentViewY - kStatusBarAndNavigationBarHeight - kSafeAreaBottom;
        
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, contentViewY, kScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.isScrollEnabled = NO;
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (UIView *)categoryBar {
    if (!_categoryBar) {
        _categoryBar = [[UIView alloc]initWithFrame:CGRectMake(0, kPageTitleHeight, kScreenWidth, kCategoryBarHeight)];
        _categoryBar.backgroundColor = HEXCOLOR(0xF4F4F4);
        
        UILabel *rankLable = [[UILabel alloc]initWithFrame:CGRectMake(AdaptedWidth(19.5), 0, AdaptedWidth(77), kCategoryBarHeight)];
        rankLable.text = WARLocalizedString(@"排行");
        rankLable.textColor = HEXCOLOR(0x8D93A4);
        rankLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_categoryBar addSubview:rankLable];
        
        UILabel *nickNameLable = [[UILabel alloc]initWithFrame:CGRectMake(AdaptedWidth(96.5), 0, AdaptedWidth(77), kCategoryBarHeight)];
        nickNameLable.text = WARLocalizedString(@"昵称");
        nickNameLable.textColor = HEXCOLOR(0x8D93A4);
        nickNameLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_categoryBar addSubview:nickNameLable];
        
        UILabel *scoreLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - AdaptedWidth(77) - AdaptedWidth(27), 0, AdaptedWidth(77), kCategoryBarHeight)];
        scoreLable.text = WARLocalizedString(@"得分");
        scoreLable.textAlignment = NSTextAlignmentRight;
        scoreLable.textColor = HEXCOLOR(0x8D93A4);
        scoreLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_categoryBar addSubview:scoreLable];
    }
    return _categoryBar;
}

@end
