//
//  WARMomentThumbListVC.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/19.
//

#import "WARMomentThumbListVC.h"

#import "WARMacros.h"

#import "WARCPageTitleView.h"
#import "WARCPageContentView.h"

#import "WARJournalThumbListVC.h"

static NSInteger kPageTitleHeight = 38;

@interface WARMomentThumbListVC ()<WARCPageTitleViewDelegate>
/** titleSegmentView */
@property (nonatomic, strong) WARCPageTitleView *titleSegmentView;
/** segmentBarSuperView */
@property (nonatomic, strong) UIView *segmentBarSuperView;
/** pageContentView */
@property (nonatomic, strong) WARCPageContentView *pageContentView;

/** thumbListFriendVC */
@property (nonatomic, strong) WARJournalThumbListVC *thumbListFriendVC;
/** thumbListPublicVC */
@property (nonatomic, strong) WARJournalThumbListVC *thumbListPublicVC;

/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** momentId */
@property (nonatomic, copy) NSString *nickname;
/** pThumbTotalCount */
@property (nonatomic, assign) NSInteger pThumbTotalCount;
/** fThumbTotalCount */
@property (nonatomic, assign) NSInteger fThumbTotalCount;
@end

@implementation WARMomentThumbListVC

#pragma mark - System

- (instancetype)initWithMomentId:(NSString *)momentId pThumbTotalCount:(NSInteger)pThumbTotalCount fThumbTotalCount:(NSInteger)fThumbTotalCount nickname:(NSString *)nickname {
    if (self = [super init]) {
        self.momentId = momentId;
        self.pThumbTotalCount = pThumbTotalCount;
        self.fThumbTotalCount = fThumbTotalCount;
        self.nickname = nickname;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.nickname;
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.segmentBarSuperView];
    [self.view addSubview:self.pageContentView];
}
 
#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARCPageTitleViewDelegate

- (void)WARCPageTitleView:(WARCPageTitleView *)WARCPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    [self updateSubControllersWithIndex:selectedIndex];
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

- (UIView *)segmentBarSuperView {
    if (!_segmentBarSuperView) {
        _segmentBarSuperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageTitleHeight)];
        [_segmentBarSuperView addSubview:self.titleSegmentView];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kPageTitleHeight - 0.5, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = HEXCOLOR(0xDCDEE6);
        [_segmentBarSuperView addSubview:bottomLine];
    }
    return _segmentBarSuperView;
}

- (WARCPageTitleView *)titleSegmentView {
    if (!_titleSegmentView) {
        NSArray *titleArray = @[WARLocalizedString(@"好友"),WARLocalizedString(@"公众")];
        _titleSegmentView = [[WARCPageTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, kPageTitleHeight) delegate:self titleNames: titleArray badgeViewType:WARBadgeNumberViewType];
        _titleSegmentView.isNeedBounces = NO;
        _titleSegmentView.backgroundColor = kColor(whiteColor);
        _titleSegmentView.titleColorStateSelected = HEXCOLOR(0x2CBE61);
        _titleSegmentView.titleColorStateNormal = COLOR_WORD_GRAY_9;
        _titleSegmentView.indicatorColor = HEXCOLOR(0x2CBE61);
        _titleSegmentView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
        _titleSegmentView.titleLabelFont = kFont(14);
    }
    return _titleSegmentView;
}

- (WARCPageContentView *)pageContentView {
    if (!_pageContentView) {
        self.thumbListFriendVC = [[WARJournalThumbListVC alloc] initWithMomentId:self.momentId thumbTotalCount:self.fThumbTotalCount isPMoment:NO];
        self.thumbListPublicVC = [[WARJournalThumbListVC alloc] initWithMomentId:self.momentId thumbTotalCount:self.pThumbTotalCount isPMoment:YES];
        
        NSArray *childArr = @[self.thumbListFriendVC,self.thumbListPublicVC];
        CGFloat contentViewHeight = kScreenHeight - kStatusBarAndNavigationBarHeight - kSafeAreaBottom - kPageTitleHeight;
        
        _pageContentView = [[WARCPageContentView alloc] initWithFrame:CGRectMake(0, kPageTitleHeight, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.isScrollEnabled = NO;
    }
    
    return _pageContentView;
}

@end
