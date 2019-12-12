//
//  WARProfileOtherViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/17.
//

#import "WARProfileOtherViewController.h"
#import "UIView+WARFrame.h"
#import "UIImage+WARBundleImage.h"
#import "WARDBContactModel.h"
#import "WARDBContactManager.h"
#import "WARDBUserManager.h"
//#import "WARUNetworkTool.h"
#import "WARNetwork.h"
#import "YYModel.h"
#import "WARProgressHUD.h"
#import "WARMediator+User.h"
#import "WARUIHelper.h"
#import "WARMediator+UserEditor.h"
#import "WARCPageTitleView.h"
#import "WARUserEventMainViewController.h"
#import "WARCPageContentView.h"
#import "TZAssetModel.h"
#import "WARImagePickerController.h"
#import "WARUSerCenterProfileCell.h"
#import "WARPRofilePersonTableView.h"
#import "WARUserSettingViewController.h"
#import "WARUserSettingNewViewController.h"

#import "WARUserDiaryTableHeaderView.h"
#import "WARPhotoQuickUploadView.h"
#import "WARProfileNetWorkTool.h"
#import "WARPhotoQuickManger.h"
#import "WARProfileSendContactView.h"
#import "WARMediator+Chat.h"
#import "WARMediator+Contacts.h"
#import "WARMediator+UserEditor.h"
#import "WARConfigurationMacros.h"
#import "WARPhotosUploadManger.h"
#import "WARProfileHeaderDetailView.h"
#import "UIImageView+WebCache.h"
#define TweetSendGetImage(name, className)  [UIImage war_imageName:name curClass:className.class curBundle:@"WARProfile.bundle"]
#define kPageTitleHeight 35
typedef enum : NSUInteger {
    Normal,
    Pulling,
    Refreshing,
} WARRefreshControlState;
@interface WARProfileOtherViewController ()< WARUSerCenterProfileDelegete, WARUserEventMainViewControllerDelegete, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WARProfileSendContactViewDelegate>

@property (nonatomic, copy) NSString* accountId;
@property (nonatomic, strong)  WARProfileHeaderDetailView* headerinfoView;
@property (nonatomic, strong)  WARDBContactModel *umModel;
@property (nonatomic, strong) WARProfileUserModel *userModel;
@property (nonatomic, strong)  WARUserEventMainViewController *vc;
@property(nonatomic,  strong)  WARPRofilePersonTableView *tbView;
@property (nonatomic, strong)  WARUSerCenterProfileCell* cell;
@property (nonatomic, retain)  WARCPageTitleView *pageTitleView;

@property (nonatomic, assign)  BOOL canScroll;
@property (nonatomic, assign)  WARUserDiaryTableHeaderView *header;
@property (nonatomic, strong)  WARProfileSendContactView *toolView;
@property (nonatomic, assign)  CGFloat headerH;
@property (nonatomic, assign)  BOOL isMine;
@property (nonatomic, copy)    NSString  *guyID;
@property (nonatomic, copy)    NSString  *friendWay;
@property (nonatomic, assign) WARRefreshControlState refreshState;
@end

@implementation WARProfileOtherViewController
- (instancetype)initWithGuyID:(NSString *)guyID friendWay:(NSString *)friendWay{
    if (self = [super init]){
        self.guyID = guyID;
        self.friendWay = friendWay;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[WARPhotosUploadManger sharedGolbalViewManager] start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initSetting];
    [self initUI];
    [self initData];
}
#pragma mark - init 初始化
- (void)initSetting{
    self.headerH = 190+112;
    self.canScroll = YES;
    self.isRefreshing = NO;
    self.isMine = NO;
   [self dl_addNotification];
}
- (void)initUI{
    [self.view addSubview:self.tbView];
    [self.view addSubview:self.userPageNavBar];
    [self.view addSubview:self.toolView];

    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (WAR_IS_IPHONE_X ? 344:310))];
    self.tbView.tableHeaderView = emptyTableHeaderView;
    [self.tbView addSubview :self.headerinfoView];

    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    [self.userPageNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(navbarH));
    }];
    [self.headerinfoView addSubview:self.pageTitleView];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerinfoView);
        make.height.equalTo(@35);
    }];

}

- (void)initData{
    // 加载数据
    [self loadDataFromCache];
}

#pragma mark - 点击方法

#pragma mark - 通知
-(void)dl_addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSubScrolleview:) name:@"subScrollerView" object:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (self.tbView.contentOffset.y > 0) {
        return;
    }
    CGFloat contentInsetTop = self.tbView.contentInset.top;
    CGFloat conditionValue = -contentInsetTop - kStatusBarAndNavigationBarHeight;
    if (self.tbView.dragging) {
        if (self.refreshState == Normal && (self.tbView.contentOffset.y < 0)) {
            NDLog(@"正在拖拽");
            self.refreshState = Pulling;
        } else if (self.refreshState == Pulling && (self.tbView.contentOffset.y >= 0)) {
            self.refreshState = Normal;
            NDLog(@"回复");
        }
    } else {
        // 用户松手的时候会执行
        if (self.refreshState == Pulling) {
            NDLog(@"正在刷新");
            self.refreshState = Refreshing;
        }
    }
}
- (void)setRefreshState:(WARRefreshControlState)refreshState {
    _refreshState = refreshState;
    switch (refreshState) {
        case Pulling: {
            NDLog(@"正在拖拽");
            [self.userPageNavBar dl_willRefresh];
        }
            break;
        case Refreshing: {
            NDLog(@"正在刷新");
            [self.userPageNavBar dl_refresh];
            
            [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
            break;
        }
        case Normal: {
            NDLog(@"回复");
            
            break;
        }
    }
    
}
- (void)stopAnimating {
    [self.userPageNavBar stopAnmation:^{
        [self.cell dl_refresh];
        [self.userPageNavBar dl_endRefresh];
        self.refreshState = Normal;
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tbView.dragging) {
        if (self.refreshState == Normal && (self.tbView.contentOffset.y < -10)) {
            NDLog(@"正在拖拽%.f",self.tbView.contentOffset.y);
            self.refreshState = Pulling;
        } else if (self.refreshState == Pulling && (self.tbView.contentOffset.y >= 0)) {
            self.refreshState = Normal;
            //     NDLog(@"回复");
        }
    } else {
        // 用户松手的时候会执行
        if (self.refreshState == Pulling) {
            NDLog(@"正在刷新");
            self.refreshState = Refreshing;
        }
    }
}
- (void)onSubScrolleview:(NSNotification *)ntf{
    self.header = ntf.object;
    
}
- (void)onPageViewCtrlChange:(NSNotification *)ntf {
    
    //更改YUSegment选中目标
    [self.pageTitleView setSelectedIndex:[ntf.object integerValue]];
    [self.pageTitleView setNeedsLayout];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.cell.canScroll = NO;
}

//当滑动下面的PageView时，当前要禁止滑动
- (void)onScrollBottomView:(NSNotification *)ntf {
    if ([ntf.object isEqualToString:@"ended"]) {
        //bottomView停止滑动了  当前页可以滑动
        self.tbView.scrollEnabled = YES;
    } else {
        //bottomView滑动了 当前页就禁止滑动
        self.tbView.scrollEnabled = NO;
    }
}

#pragma mark -- tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    CGFloat tabH  = [TZCommonTools tz_isIPhoneX] ? (49+34):49;
    
    return kScreenHeight - kStatusBarAndNavigationBarHeight;//self.view.frame.size.height-64;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARUSerCenterProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[WARUSerCenterProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" atType:self.isMine atGuyId:self.guyID == 0 ?@"":self.guyID];
 
    }
    cell.guyID = self.guyID == 0 ?@"":self.guyID;
    self.cell = cell;
    cell.delegate = self;
    cell.isMine = self.isMine;
    
    return cell;
}
#pragma mark - WARProfileSendContactView
- (void)profileSendContactView:(WARProfileSendContactView *)view atBtn:(NSInteger)index{
    if (index == 0) {
        UIButton *btn = [view viewWithTag:100+index];
        NSString *operation = @"";
        if ([self.profileUsermodel.followRelation isEqualToString:@"BOTH"] || [self.profileUsermodel.followRelation isEqualToString:@"FOLLOW"] ) {
            operation = @"DOWN";
        }else{
            operation = @"UP";
        }
        
        WS(weakself);
        [WARProfileNetWorkTool postSendFollowWithGuid:self.profileUsermodel.accountId atOperation:operation CallBack:^(id response) {
            if(view.followBtn.selected) {
                [WARProgressHUD showSuccessMessage:@"取消关注"];
            }else {
                [WARProgressHUD showSuccessMessage:@"关注成功"];
            }
            view.followBtn.selected = !view.followBtn.selected;
        } failer:^(id response) {
            [WARProgressHUD showAutoMessage:@"关注失败"];
        }];
    }else if (index == 1){
        
        if(view.addFriendBtn.selected){
            view.addFriendBtn.userInteractionEnabled = NO;
            return;
        }


        UIViewController *VC = [[WARMediator sharedInstance] Mediator_AddFriendViewControllerWithFriendWay:self.friendWay friendId:self.guyID refId:nil callback:^(BOOL isSuccess) {
            if (isSuccess) {
                NDLog(@"friendApplySuccess");
                // view.addFriendBtn.selected = YES;
        
            }else {
             
            }

        }];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        
        if (self.guyID.length==0) {
            [WARProgressHUD showAutoMessage:@"账号不能为空"];
            return;
        }
        
        UIViewController *vc = [[WARMediator sharedInstance] Mediator_viewControllerForSessionId:self.guyID];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - WARCPageTitleView 代理
- (void)WARCPageTitleView:(WARCPageTitleView *)WARCPageTitleView selectedIndex:(NSInteger)selectedIndex {

    self.cell.selectIndex = selectedIndex;

}
#pragma mark - WARUSerCenterProfileCell 代理
- (void)USerCenterProfileCell:(WARUSerCenterProfileCell *)cell scrollindex:(NSInteger)pageContentViewindex progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex{
    NDLog(@"目标%ld",pageContentViewindex);
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:pageContentViewindex];
}


#pragma mark - UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    //    //计算导航栏的透明度
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = (WAR_IS_IPHONE_X ? 309:275)-navbarH ;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    self.userPageNavBar.dl_alpha = alpha;
    [self.userPageNavBar changeOffset:offset];
    //
    if (offset > 0) {
        self.headerinfoView.accoutlb.hidden = YES;
    }else{
        self.headerinfoView.accoutlb.hidden = NO;
    }
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = ([self.tbView rectForSection:0].origin.y-navbarH-35);
    if (scrollView.contentOffset.y > tabOffsetY) {
        
        if (self.canScroll) {
            
            self.canScroll = NO;
            self.cell.canScroll = YES;
        }
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
    } else {
        NDLog(@"异常%f",offset);
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
    if (offset <= 0) {
        CGRect f = self.headerinfoView.frame;
        f.size.width = kScreenWidth;
        self.headerinfoView.frame = f;
        CGFloat offsetY = (scrollView.contentOffset.y ) * -1;
        if(scrollView.contentOffset.y < 0) {
            f .origin.y = offsetY * -1;
            f .size.height = (WAR_IS_IPHONE_X ? 344:310) + offsetY;
            self.headerinfoView.frame = f;
            CGRect mask = self.headerinfoView.maskView.frame;
            mask .size.height = f.size.height;
            self.headerinfoView.maskView.frame = mask ;
        }else{
            
        }
           self.userPageNavBar.backImageView.alpha = 0;
           self.userPageNavBar.maskView.alpha = 0;
    }else {
           self.userPageNavBar.maskView.alpha = 1;
           self.userPageNavBar.backImageView.alpha = 1;
    }

    
    
}

-(void)configRefreshStateWithScrollView:(UIScrollView *)scrollView
{
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? -24:0;
    if (scrollView.contentOffset.y <= navbarH && scrollView.contentOffset.y <= self.lastContentOffY) {
        
        self.shouldRefresh = YES;
    }else{
        
        self.shouldRefresh = NO;
    }
    // 偏移量小于0 (任何时候都是小于0)  没有正在刷新 当前偏移量 小于 此次最大的偏移量 最大的也要小于0
    if (scrollView.contentOffset.y <= navbarH && !self.isRefreshing && scrollView.contentOffset.y <= self.lastContentOffY && self.lastContentOffY <= 0) {
    
        [self.userPageNavBar dl_endRefresh];
    
    }
    
    self.lastContentOffY = scrollView.contentOffset.y;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (self.shouldRefresh && !self.isRefreshing) {
        
        [self.userPageNavBar dl_refresh];
        [self.cell dl_refresh];
        self.isRefreshing  = YES;
    }else if(!self.isRefreshing){
        
        [self.userPageNavBar dl_endRefresh];
        self.isRefreshing = NO;
    }
    
}

// 刷新结束的回调
-(void)dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:(WARUSerCenterProfileCell *)cell
{
    
    [self.userPageNavBar dl_endRefresh];
    self.isRefreshing = NO;
}


- (void)loadDataFromCache {
    WARDBContactModel *model = [WARDBContactManager contactWithUserModel:[WARDBUserManager userModel]];
    if (!model.accountId) {
        model.accountId = self.accountId;
    }
   // [self.headerinfoView setDataModel:model];
    self.userPageNavBar.isMine = NO;
    self.umModel = model;
    
    // 加载面具数据
    WS(weakself);
    [WARProfileNetWorkTool getOtherPersonDataWithguyId:self.guyID CallBack:^(id response) {
        
        WARProfileUserModel *model = [WARProfileUserModel yy_modelWithJSON:response];
        model.isMine = NO;
            [weakself.userPageNavBar.backImageView  sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth, 190), model.guyMask.bgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
             weakself.userModel = model;
             weakself.userPageNavBar.accoutlb.text = model.accNum.length == 0 ?@"":[NSString stringWithFormat:@"账号:%@",model.accNum];
             weakself.userPageNavBar.namelabel.text = WARLocalizedString(model.otherMaskModel.nickname);
             weakself.headerinfoView.otherModel = model;
             weakself.profileUsermodel = model;
        if ( [model.followRelation isEqualToString: @"FOLLOW"] || [self.profileUsermodel.followRelation isEqualToString:@"BOTH"] ) {
             weakself.toolView.followBtn.selected = YES;
        }else{
             weakself.toolView.followBtn.selected = NO;
        }
        
        if ([model.friendRelation isEqualToString:@"FRIEND"]) {
            weakself.toolView.addFriendBtn.selected = YES;
            weakself.toolView.addFriendBtn.userInteractionEnabled = NO;
        }else{
            weakself.toolView.addFriendBtn.selected = NO;
        }

    } failer:^(id response) {
           [WARProgressHUD showAutoMessage:@"加载失败"];
    }];
    
}
- (WARCPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        _pageTitleView = [[WARCPageTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageTitleHeight) delegate:self titleNames:@[WARLocalizedString(@"日志"),WARLocalizedString(@"相册"),WARLocalizedString(@"收藏")] badgeViewType:WARBadgeDotViewType];
        _pageTitleView.backgroundColor = kColor(whiteColor);
        _pageTitleView.titleColorStateSelected = ThemeColor;
        _pageTitleView.titleColorStateNormal = ThreeLevelTextColor;
        _pageTitleView.indicatorColor = ThemeColor;
        _pageTitleView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
        _pageTitleView.titleLabelFont = [UIFont boldSystemFontOfSize:16];
        _pageTitleView.isNeedBounces = NO;
        [_pageTitleView disPlayBadgeAtIndexPath:0 isShow:NO];
        [_pageTitleView disPlayBadgeAtIndexPath:1 isShow:NO];
        [_pageTitleView disPlayBadgeAtIndexPath:2 isShow:NO];
        [self drarectAngle:_pageTitleView corners:UIRectCornerTopRight|UIRectCornerTopLeft size:CGSizeMake(14, 14)];
    }
    return _pageTitleView;
}

- (void)drarectAngle:(UIView*)v corners:(UIRectCorner)corners size :(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth, v.frame.size.height) byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = v.bounds;
    maskLayer.path = maskPath.CGPath;
    v.layer.mask = maskLayer;
    
    
}
- (WARProfileSendContactView *)toolView {
    if (!_toolView) {
        CGFloat tabH = WAR_IS_IPHONE_X ? 50+34:50;
        _toolView = [[WARProfileSendContactView alloc] initWithFrame:CGRectMake(0, kScreenHeight-tabH, kScreenWidth, tabH) byNormaryArray:@[@"关注",@"好友",@"聊天"] bySelectTileArray:@[@"已关注",@"已加好友",@"聊天"]];
        _toolView.layer.shadowColor = [UIColor blackColor].CGColor;
        _toolView.layer.shadowOffset=CGSizeMake(0, 1);
        _toolView.layer.shadowOpacity = 0.5f;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_toolView.bounds];
        _toolView.layer.shadowPath = shadowPath.CGPath;
        _toolView.delegate = self;
    }
    return _toolView;
}
-(WARNavgationBar *)userPageNavBar {
    if (!_userPageNavBar) {
        _userPageNavBar = [[WARNavgationBar alloc] init];
        _userPageNavBar.dl_alpha = 0;
        WS(weakSelf);
        _userPageNavBar.settingBlock = ^{
            
            __block BOOL isBack = NO;
            [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WARUserSettingNewViewController class]]) {
                    isBack = YES;
                    *stop = YES;
                }
            }];
            if (isBack) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else {
                WARUserSettingNewViewController *vc = [[WARUserSettingNewViewController alloc] init];
                vc.userModel = weakSelf.userModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return _userPageNavBar;
}
- (WARPRofilePersonTableView *)tbView {
    if (!_tbView){
        _tbView = [[WARPRofilePersonTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tbView.delegate = self;
        _tbView.dataSource = self;
    }
    return _tbView;
}
- (WARProfileHeaderDetailView *)headerinfoView {
    if (!_headerinfoView) {
        _headerinfoView = [[WARProfileHeaderDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (WAR_IS_IPHONE_X ? 344:310))];
        
    }
    return _headerinfoView;
}
@end
