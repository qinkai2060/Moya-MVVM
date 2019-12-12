//
//  WARUserCenterViewController.m
//  Pods
//
//  Created by 秦恺 on 2018/1/24.
//

#import "WARUserCenterViewController.h"
#import "UIView+WARFrame.h"
#import "UIImage+WARBundleImage.h"
#import "WARDBContactModel.h"
#import "WARDBContactManager.h"
#import "WARDBUserManager.h"
#import "WARUIHelper.h"
#import "Masonry.h"
#import "WARNetwork.h"
#import "YYModel.h"
#import "WARProgressHUD.h"
#import "WARMediator+User.h"
#import "WARProfileUserModel.h"
#import "WARMediator+UserEditor.h"
#import "WARCPageTitleView.h"
#import "WARUserEventMainViewController.h"
#import "WARCPageContentView.h"
#import "TZAssetModel.h"
#import "WARImagePickerController.h"
#import "WARUSerCenterProfileCell.h"
#import "WARPRofilePersonTableView.h"
#import "WARProfileFaceView.h"
#import "WARUserDiaryTableHeaderView.h"
#import "WARPhotoQuickUploadView.h"
#import "WARProfileNetWorkTool.h"
#import "WARPhotoQuickManger.h"
#import "WARConfigurationMacros.h"
#import "WARProfileHeaderDetailView.h"
#import "YYModel.h"
#import "WARPhotoBrowser.h"
#import "WARMediator+Store.h"
#import "UIImageView+WebCache.h"
#import "WARMacros.h"
#define TweetSendGetImage(name, className)  [UIImage war_imageName:name curClass:className.class curBundle:@"WARProfile.bundle"]
#define kPageTitleHeight 35
typedef enum : NSUInteger {
    Normal,
    Pulling,
    Refreshing,
} WARRefreshControlState;

@interface WARUserCenterViewController ()<WARUSerCenterProfileDelegete,WARUserEventMainViewControllerDelegete,UITableViewDelegate,UITableViewDataSource,WARPhotoQuickUploadViewDelegate>

@property (nonatomic, copy) NSString* accountId;
@property (nonatomic, strong) WARProfileHeaderDetailView* headerinfoView;
//@property (nonatomic, strong) WARProfileHeaderInfonView* headerinfoView;
@property (nonatomic, strong) WARDBContactModel *umModel;
@property (nonatomic, strong)  WARUserEventMainViewController *vc;
@property (nonatomic,strong) WARPRofilePersonTableView *tbView;
@property (nonatomic, strong) WARUSerCenterProfileCell* cell;
@property (nonatomic,retain) WARCPageTitleView *pageTitleView;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) WARUserDiaryTableHeaderView *header;
@property (nonatomic,assign) CGFloat headerH;
@property (nonatomic,strong) UIButton *uploadPhotoBtn;
@property (nonatomic,strong) WARPhotoQuickUploadView *quickUploadView;
@property (nonatomic,assign) BOOL isMine;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) WARProfileUserModel *profileModel;
@property (nonatomic,assign) NSInteger selectCatoryIndex;
@property (nonatomic,retain) UIView *pageContentView;

@property (nonatomic, assign) WARRefreshControlState refreshState;
/** 特殊处理群编辑，跳转群编辑不显示Nav */
@property (nonatomic, assign) BOOL hiddenNav;
@end

@implementation WARUserCenterViewController
#pragma mark - System
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadDataFromCache];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    if ([[TZImageManager manager] authorizationStatusAuthorized]) {
        [self hiddenQuickView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMineData];
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    [self initSetting];
    [self initSubviewsSub];
    [self initCallBack];
    self.hiddenNav = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
}

- (void)initSetting {
    self.selectRow = 0;
    self.headerH = 190+112;
    self.canScroll = YES;
    self.isRefreshing = NO;
    self.isMine = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tbView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [_tbView removeFromSuperview];
    _tbView = nil;
}

#pragma mark - 自定义-init
- (void)initSubviewsSub {
     CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    if (@available(iOS 11.0, *)) {
        self.tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tbView];

    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (WAR_IS_IPHONE_X ? 344:310))];
    self.tbView.tableHeaderView = emptyTableHeaderView;
    [self.tbView addSubview :self.headerinfoView];
    [self.view addSubview:self.userPageNavBar];
    [self.view addSubview:self.uploadPhotoBtn];
    [self initLayout];
    self.pageContentView = [[UIView alloc] init];
    self.pageContentView.backgroundColor = UIColorWhite;
    self.pageContentView.alpha = 0;

    [self.headerinfoView addSubview:self.pageContentView];
    [self.headerinfoView addSubview:self.pageTitleView];
    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerinfoView);
        make.height.equalTo(@35);
    }];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerinfoView);
        make.height.equalTo(@35);
    }];
}

- (WARProfileHeaderDetailView *)headerinfoView {
    if (!_headerinfoView) {
        _headerinfoView = [[WARProfileHeaderDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (WAR_IS_IPHONE_X ? 344:310))];
        _headerinfoView.backgroundColor = kRandomColor;
        
        WS(weakSelf);
        [_headerinfoView setDidPushToEditVC:^{
            weakSelf.hiddenNav = YES;
            [weakSelf.navigationController pushViewController: [[WARMediator alloc] Mediator_viewControllerForUserFaceManagerWithCurrentFaceId:nil] animated:YES];
        }];
        
    }
    return _headerinfoView;
}
- (void)initCallBack {
    WS(weakSelf);
    [self dl_addNotification];
    [[WARPhotoQuickManger shareManager] loadPhotoData];
    [self loadMineData];
    
}

- (void)initLayout {
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    [self.userPageNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(navbarH));
    }];
    CGFloat bottomMargin = WAR_IS_IPHONE_X?83:49;
    [self.uploadPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.width.height.equalTo(@43);
        make.bottom.equalTo(self.view).offset(-25);
    }];
    
}
- (void)hiddenQuickView{
    [UIView animateWithDuration:0.25 animations:^{
        self.quickUploadView.transform =  CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {

    }];
}
#pragma mark - Setter

- (void)setIsOtherfromWindow:(BOOL)isOtherfromWindow{
    _isOtherfromWindow = isOtherfromWindow;
    if (isOtherfromWindow) {
        self.userPageNavBar.isOtherFromWindow = YES;
        self.hidesBottomBarWhenPushed = YES;
         self.headerinfoView.isOherWindow = YES;
    }
}
- (void)setCanScroll:(BOOL)canScroll{
    _canScroll = canScroll;
    if (self.selectIndex == 1) {
        if (_canScroll) {
            self.uploadPhotoBtn.hidden = YES;
        }else {
            if (self.selectCatoryIndex == 0) {
                self.uploadPhotoBtn.hidden = NO;
            }else{
                self.uploadPhotoBtn.hidden = YES;
            }
        }
    }
}
#pragma mark - event

- (void)FasterUploadClick:(UIButton*)btn{
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        [WARProgressHUD showAutoMessage:@"请求授权"];
        return;
    }
    
    if ([WARPhotoQuickManger shareManager].state !=WARPhotoQuickMangerStateComplete) {
        
        [WARProgressHUD showAutoMessage:@"数据加载中..."];
        return;
    }
    if (self.quickUploadView) {
        [self.quickUploadView removeFromSuperview];
        self.quickUploadView = nil;
    }
    self.quickUploadView.segmentCotrolArr = [WARPhotoQuickManger shareManager].segementArr;
    self.quickUploadView.compareArr    = [WARPhotoQuickManger shareManager].compareArr;
    [self.view addSubview:self.quickUploadView];
    if (!self.isOtherfromWindow) {
        [self.tabBarController.tabBar setHidden:YES];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.quickUploadView.transform =  CGAffineTransformMakeTranslation(0, -250);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma - NetworkData
- (void)loadDataFromCache {
    WARDBContactModel *model = [WARDBContactManager contactWithUserModel:[WARDBUserManager userModel]];
    if (!model.accountId) {
               self.accountId =   model.accountId ;
    }
               self.umModel = model;
    WS(weakself);
    [WARProfileNetWorkTool getUserInfoWithCallBack:^(id response) {
                WARProfileUserModel *model = [WARProfileUserModel yy_modelWithJSON:response];
                model.isMine = YES;
                weakself.userPageNavBar.accoutlb.text = model.accNum.length == 0 ?@"":[NSString stringWithFormat:@"账号:%@",model.accNum];
                weakself.userPageNavBar.isMine = YES;
                weakself.headerinfoView.model = model;

        for (WARProfileMasksModel *maskmodel in model.masks) {
            if(maskmodel.defaults){
                weakself.userPageNavBar.namelabel.text = WARLocalizedString(maskmodel.nickname);
                [weakself.userPageNavBar.backImageView  sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth, 190), maskmodel.bgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
                break;
            }
        }
               weakself.profileModel = model;
               [weakself.tbView reloadData];
        
    } failer:^(id response) {
               [WARProgressHUD showAutoMessage:@"加载失败"];
    }];
    
}
- (void)loadMineData {
    WS(weakSelf);

    NSString* url = [NSString stringWithFormat:@"%@/contact-app/contact/profile/detail",kDomainNetworkUrl];
    [WARNetwork getDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
        if (!err) {
            WARDBContactModel *model = [WARDBContactModel yy_modelWithJSON:responseObj];
            //self.headerinfoView.userInfoModel = model;
            weakSelf.umModel = model;
            
            [WARDBUserManager updateUserAccountNumber:model.accountNum];
            [WARDBUserManager updateUserWithGender:model.gender];
            [WARDBUserManager updateUserWithSignature:model.signature];
            [WARDBUserManager updateUserWithNickname:model.nickname];
            if (model.year.length && model.month.length && model.day.length) {
                [WARDBUserManager updateUserWithDateString:[NSString stringWithFormat:@"%@-%@-%@",model.year,model.month,model.day]];
            }
            [WARDBUserManager updateUserWithTags:model.tags];
            
            [WARDBUserManager updateUserWithHeadId:model.headId bgPicture:model.bgPicture photos:model.photos];

        }else{
            [WARProgressHUD showAutoMessage:WARLocalizedString(responseObj[@"state"])];
        }
    }];
    
    
}
#pragma  mark
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (self.tbView.contentOffset.y > 0) {
        return;
    }
    CGFloat contentInsetTop = self.tbView.contentInset.top;
    CGFloat conditionValue = -contentInsetTop - kStatusBarAndNavigationBarHeight;
    if (self.tbView.dragging) {
        if (self.refreshState == Normal && (self.tbView.contentOffset.y < -10)) {
            NDLog(@"正在拖拽%.f",self.tbView.contentOffset.y);
            self.refreshState = Pulling;
        } else if (self.refreshState == Pulling && (self.tbView.contentOffset.y >= 0)) {
            self.refreshState = Normal;
        }
    } else {
        // 用户松手的时候会执行
        if (self.refreshState == Pulling) {
            NDLog(@"正在刷新");
            self.refreshState = Refreshing;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tbView.dragging) {
        if (self.refreshState == Normal && (self.tbView.contentOffset.y < -10)) {
            NDLog(@"正在拖拽%.f",self.tbView.contentOffset.y);
            self.refreshState = Pulling;
        } else if (self.refreshState == Pulling && (self.tbView.contentOffset.y >= 0)) {
            self.refreshState = Normal;
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
#pragma mark - NSNotificationCenter
-(void)dl_addNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSubScrolleview:) name:@"subScrollerView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidindex:) name:@"refreshCurrentIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goShopping:) name:@"goShopping" object:nil];
    [self.tbView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];//refreshEnd
    //WARJournalListViewController 点击月份滚动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidMonthItemToScroll:) name:@"kDidMonthItemToScroll" object:nil];
}
- (void)goShopping:(NSNotification*)noti {
    NSString *str = noti.object;
    UIViewController *vc = [[WARMediator sharedInstance] Mediator_viewControllerForDetail:str];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onDidMonthItemToScroll:(NSNotification*)noti {
    self.tbView.contentOffset = CGPointMake(0, 1000);
}
- (void)onDidindex:(NSNotification*)noti {
    NSDictionary *userinfo = noti.userInfo;
    NSInteger index = [userinfo[@"index"] integerValue];
    
    self.selectCatoryIndex = index;
    if (!self.canScroll&&self.selectCatoryIndex == 0) {
        self.uploadPhotoBtn.hidden = NO;
    }else {
        self.uploadPhotoBtn.hidden = YES;
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
//     [self drarectAngle:_pageTitleView corners:UIRectCornerTopRight|UIRectCornerTopLeft size:CGSizeMake(0,0)];
    
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



#pragma mark - quickUploadView 代理
- (void)photoQuickUploadViewChange:(WARPhotoQuickUploadView *)view point:(CGPoint)point gesture:(UILongPressGestureRecognizer *)gesture data:(id)data isDraging:(BOOL)isDraging{
    // 转化成view的点
    CGPoint Viewpoint =    [self.view  convertPoint:point fromView:view];
    // 需要转化cell的点
    CGPoint  cellPoint =  [self.view convertPoint:Viewpoint toView:self.cell];
    if (self.cell.selectIndex == 1) {
        if ([self.cell.layer containsPoint:cellPoint]&&!isDraging) {
            NDLog(@"在范围内");
            TZAssetModel *modelData = (TZAssetModel*)data;
            [self.cell dragViewPointChange: cellPoint selectIndex:self.cell.selectIndex data:modelData];
        }else{
            NDLog(@"不在范围内");
            [self.cell outDragViewPoint];
        }
    }
    view.tempView.center = CGPointMake(point.x,point.y);
}
- (void)photoQuicUploadViewEnd:(WARPhotoQuickUploadView *)view point:(CGPoint)point gesture:(UILongPressGestureRecognizer *)gesture data:(id)data isDraging:(BOOL)isDraging{
    // 转化成view的点
    CGPoint Viewpoint =    [self.view  convertPoint:point fromView:view];
    // 需要转化cell的点
    CGPoint  cellPoint =  [self.view convertPoint:Viewpoint toView:self.cell];
    if (self.cell.selectIndex == 1) {
        if ([self.cell.layer containsPoint:cellPoint]&&!isDraging) {
            TZAssetModel *modelData = (TZAssetModel*)data;
            [self.cell dragViewPoint: cellPoint selectIndex:self.cell.selectIndex data:modelData];
        }else{
            
        }
    }
}
#pragma mark - WARUserEditHeaderViewDelegate
- (void)disSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* tempArr = [NSMutableArray array];
    for (NSString *imageID in self.umModel.photos) {
        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
        photoBrowserModel.picUrl = kCMPRPhotoUrl(imageID);
        [tempArr addObject:photoBrowserModel];
    }
       WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
       photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
       photoBrowser.photoArray = tempArr;
       photoBrowser.currentIndex = index;
       [photoBrowser show];
}


#pragma mark - tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    v.backgroundColor = UIColorClear;
    [v addSubview:self.pageTitleView];
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    CGFloat tabH  = [TZCommonTools tz_isIPhoneX] ? (49+34):49;
    
    return kScreenHeight - kStatusBarAndNavigationBarHeight - kTabbarHeightAndSafeArea;//self.view.frame.size.height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARUSerCenterProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell){
        
        cell = [[WARUSerCenterProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" atType:self.isMine atGuyId: self.profileModel.accountId.length == 0 ?@"":self.profileModel.accountId];
    }
    
    cell.isOtherEnterHome = self.isOtherfromWindow;
    cell.guyID = self.profileModel.accountId.length == 0 ?@"":self.profileModel.accountId;
    self.cell = cell;
    cell.delegate = self;
    cell.isMine = self.isMine;
    
    return cell;
}
#pragma mark WARCPageTitleView
- (void)WARCPageTitleView:(WARCPageTitleView *)WARCPageTitleView selectedIndex:(NSInteger)selectedIndex {
    if(selectedIndex != 1){
        self.uploadPhotoBtn.hidden = YES;
        if ([[TZImageManager manager] authorizationStatusAuthorized]) {
            [self hiddenQuickView];
        }
    }else{
        if (self.canScroll) {
            self.uploadPhotoBtn.hidden = YES;
        }else{
            self.uploadPhotoBtn.hidden = NO;
        }
    }
    self.selectIndex = selectedIndex;
    self.cell.selectIndex = selectedIndex;
    
    
}
#pragma mark - WARUSerCenterProfileDelegete
- (void)USerCenterProfileCell:(WARUSerCenterProfileCell *)cell scrollindex:(NSInteger)pageContentViewindex progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex{
    NDLog(@"目标%ld",pageContentViewindex);
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:pageContentViewindex];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   CGFloat navbarH = [TZCommonTools tz_isIPhoneX] ? (64+24):64;
    // 计算导航栏的透明度
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = (WAR_IS_IPHONE_X ? 309:275)-navbarH ;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    [self.userPageNavBar changeOffset:offset];
    self.userPageNavBar.dl_alpha = alpha;
  
    if (offset > 0) {
        self.headerinfoView.accoutlb.hidden = YES;
    }else{
        self.headerinfoView.accoutlb.hidden = NO;
    }
   // 子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = ([self.tbView rectForSection:0].origin.y-navbarH-35);
    if (scrollView.contentOffset.y > tabOffsetY) {
        
        if (self.canScroll) {
            self.canScroll = NO;
            self.cell.canScroll = YES;
        }
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
    } else {
     
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
    if (scrollView.contentOffset.y > 0) {
        return;
    }
    CGFloat contentInsetTop = scrollView.contentInset.top;
    CGFloat navbarHeight = [TZCommonTools tz_isIPhoneX] ? 88:64;
    CGFloat conditionValue = -contentInsetTop - navbarHeight;
    if (scrollView.dragging) {
        if ( (scrollView.contentOffset.y < conditionValue)) {
            NDLog(@"H");
            [self.userPageNavBar dl_willRefresh];
        } else if ((scrollView.contentOffset.y >= conditionValue)) {
            NDLog(@"A");
            [self.userPageNavBar dl_endRefresh];
        }
    } else {
        NDLog(@"O");
        // 用户松手的时候会执行
        [self.userPageNavBar dl_refresh];
    }
    self.lastContentOffY = scrollView.contentOffset.y;
}
#pragma mark - lazy
-(WARNavgationBar *)userPageNavBar
{
    if (!_userPageNavBar) {
        _userPageNavBar = [[WARNavgationBar alloc] init];
        _userPageNavBar.dl_alpha = 0;
        
    }
    return _userPageNavBar;
}
- (UIButton *)uploadPhotoBtn{
    if (!_uploadPhotoBtn) {
        _uploadPhotoBtn = [[UIButton alloc] init];
        [_uploadPhotoBtn setImage:[UIImage war_imageName:@"personal_photo_shortcut" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_uploadPhotoBtn addTarget:self action:@selector(FasterUploadClick:) forControlEvents:UIControlEventTouchUpInside];
        _uploadPhotoBtn.hidden = YES;
    }
    return _uploadPhotoBtn;
}
- (WARCPageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [[WARCPageTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageTitleHeight) delegate:self titleNames:@[WARLocalizedString(@"日志"),WARLocalizedString(@"相册"),WARLocalizedString(@"收藏"),@"铺子"] badgeViewType:WARBadgeDotViewType];
        _pageTitleView.backgroundColor = kColor(whiteColor);
        _pageTitleView.titleColorStateSelected = ThemeColor;
        _pageTitleView.titleColorStateNormal = ThreeLevelTextColor;
        _pageTitleView.indicatorColor = ThemeColor;
        _pageTitleView.indicatorLengthStyle = WARCIndicatorLengthTypeMax;
        _pageTitleView.titleLabelFont = [UIFont boldSystemFontOfSize:14];
        _pageTitleView.isNeedBounces = NO;
        [_pageTitleView disPlayBadgeAtIndexPath:0 isShow:NO];
        [_pageTitleView disPlayBadgeAtIndexPath:1 isShow:NO];
        [_pageTitleView disPlayBadgeAtIndexPath:2 isShow:NO];
        [_pageTitleView disPlayBadgeAtIndexPath:4 isShow:NO];
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
- (WARPRofilePersonTableView *)tbView{
    if (!_tbView){
        _tbView = [[WARPRofilePersonTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.backgroundColor = UIColorClear;
        
    }
    return _tbView;
}
- (WARPhotoQuickUploadView *)quickUploadView {
    if (!_quickUploadView) {
        
        CGFloat tabH =   WAR_IS_IPHONE_X?83:49;
        CGFloat nav =  WAR_IS_IPHONE_X ? 34:0;
        WS(weakself);
        _quickUploadView = [[WARPhotoQuickUploadView alloc] initWithFrame:CGRectMake(0, kScreenHeight-nav, kScreenWidth, 200+tabH) atWithSegementArr:[WARPhotoQuickManger shareManager].segementArr atCompareArr: [WARPhotoQuickManger shareManager].compareArr];
        _quickUploadView.backgroundColor = [UIColor whiteColor];
        _quickUploadView.layer.shadowColor = [UIColor blackColor].CGColor;
        _quickUploadView.layer.shadowOffset=CGSizeMake(0, 0.5);
        _quickUploadView.layer.shadowOpacity = 0.5f;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.quickUploadView.bounds];
        _quickUploadView.layer.shadowPath = shadowPath.CGPath;
        _quickUploadView.delegate = self;
        _quickUploadView.closeBlock = ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                weakself.quickUploadView.transform =  CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                if (!weakself.isOtherfromWindow) {
                    [weakself.tabBarController.tabBar setHidden:NO];
                }
                
            }];
        };
        
    }
    return _quickUploadView;
}
@end
