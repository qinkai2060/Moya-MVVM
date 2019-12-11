//
//  WARUserDiaryViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import "WARUserDiaryViewController.h"

#import "WARLocalizedHelper.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "UIImage+WARBundleImage.h"
#import "WARAlertView.h"

#import "WARUserDiaryPhotosTableViewCell.h"
#import "WARUserDiaryTweetCell.h"
#import "WARUserDiaryOrderCell.h"
#import "WARUserDiaryActivityCell.h" 
#import "WARNewUserDiaryTableHeaderView.h"

#import "WARUserDiaryWeatherModel.h"
#import "WARUserDiaryModel.h"
#import "WARDBUserManager.h"

#import "WARMediator+SendInfo.h"

#import "WARUserDiaryManager.h"
#import "WARUserDiarySinglePageCell.h"
#import "WARUserDiaryPageCell.h"
#import "WARNewUserDiaryMomentLayout.h"
#import "WARNewUserDiaryModel.h"
#import "MJRefresh.h"
#import "WARUIHelper.h"
#import "WARUserDiaryBaseCell+WebCache.h"
#import "WARNewUserDiaryMonthModel.h"
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARMultiItemsToolBar.h"
#import "WARProgressHUD.h"
#import "WARFeedModel.h"
#import "WARPhotoBrowser.h"

#define kMonthMinCount 5
#define kPageTitleHeight 49
#define kScrollViewContentHeight 2661

#define kWARProfileBundle @"WARProfile.bundle"
#define kWARUserDiaryTweetCellId @"kWARUserDiaryTweetCellId"
#define kWARUserDiaryOrderCellId @"kWARUserDiaryOrderCellId"
#define kWARUserDiaryActivityCellId @"kWARUserDiaryActivityCellId"
#define kWARUserDiaryPhotosTableViewCellId @"kWARUserDiaryPhotosTableViewCellId"


#define kWARUserDiaryPageCellId @"kWARUserDiaryPageCellId"
#define kWARUserDiarySinglePageCellId @"kWARUserDiarySinglePageCellId"

#define kDiaryInputPhoto @"INPUTPHOTO"

@interface WARUserDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARNewUserDiaryTableHeaderViewDeleagte,WARUserDiaryBaseCellDelegate,WARMultiItemsToolBarDelegate>
@property (nonatomic, strong) WARNewUserDiaryTableHeaderView *tableHeaderView;
@property (nonatomic, strong) WARMultiItemsToolBar *monthToolBar;
//判断手指是否离开
//@property (nonatomic, assign) BOOL isTouch;
  
@property (nonatomic, copy)NSMutableArray <WARNewUserDiaryMonthModel *>*monthLogs;

@property (nonatomic, copy)NSArray <WARNewUserDiaryMoment *>*userDiaryLists;
@property (nonatomic, copy) NSString *lastFindId;

@property (nonatomic, strong) WARDBUserModel *userModel;

@end

@implementation WARUserDiaryViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
     
    self.userModel = [WARDBUserManager userModel];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.monthToolBar];
    [self.monthToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(MultiItemsToolBarScrollViewHeight);
    }];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableHeaderView.photos = [[[WARWeatherManager alloc]init] setUpWeatherData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self loadItemDataRefresh:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadItemDataRefresh:(BOOL)refresh {
    if (refresh) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    kUserDefaultSetObjectForKey(@"", kPreMonthYearKey);
    
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager loadMomentConverge:^(NSArray<WARNewUserDiaryMonthModel *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NDLog(@"results:%@",results);
        NSMutableArray <WARNewUserDiaryMonthModel *> *monthLogs = [NSMutableArray <WARNewUserDiaryMonthModel *>arrayWithArray:results];
        
        strongSelf.monthLogs = [strongSelf configMonthDisplayOffsetY:monthLogs];
        
        strongSelf.tableHeaderView.monthLogs = strongSelf.monthLogs;
        
        strongSelf.monthToolBar.tags = strongSelf.monthLogs;
        [strongSelf.tableView reloadData];
        
        [strongSelf dealWithLoadResultNoMoreData:YES];
    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (UIImage *)war_getNameInBaseBundle:(NSString *)imageName{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* imageNameStr = [NSString stringWithFormat:@"%@.png", imageName];
    NSString* imagePath = [curBundle pathForResource:imageNameStr ofType:nil inDirectory:kWARProfileBundle];
    return [UIImage imageWithContentsOfFile:imagePath];
    
}

#pragma mark - Event Response

- (void)showBottomViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath{
    WARPopHorizontalMenuConfiguration *config = [WARPopHorizontalMenuConfiguration defaultConfiguration];
    config.tintColor = [UIColor blackColor];
    config.needArrow = YES;
    NSArray *images = @[@"newfriend_delete",@"newfriend_edit"];
    NSArray *imageArrays = @[@"newfriend_delete",@"daily_lock",@"newfriend_edit"];//daily_public
    
    __weak typeof(self) weakSelf = self;
    [WARPopHorizontalMenu showFromSenderFrame:frame imageArray:imageArrays doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        WARUserDiaryBaseCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
        
        if (selectedIndex == 0) {//删除
            if (indexPath.section < strongSelf.monthLogs.count) {
                WARNewUserDiaryMonthModel *model = strongSelf.monthLogs[indexPath.section];
                if (indexPath.row < model.momentOutlines.count) {
                    [WARUserDiaryManager deleteDiaryOrFriendMoment:cell.moment.momentId compeletion:^(bool success, NSError *err) {
                        if (success) {
                            [model.momentOutlines removeObjectAtIndex:indexPath.row];
                            [strongSelf.tableView reloadData];
                            
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"删除成功")];
                        } else {
                            [WARProgressHUD showErrorMessage:WARLocalizedString(@"删除失败")];
                        }
                    }];
                }
            }
        } else if (selectedIndex == 1) {
            
        } else if (selectedIndex == 2) {
            if (self.pushToFeedEditingblock) {
                self.pushToFeedEditingblock(cell.moment.momentId);
            }
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.monthLogs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WARNewUserDiaryMonthModel *monthModel = self.monthLogs[section];
    return monthModel.momentOutlines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARNewUserDiaryMonthModel *monthModel = self.monthLogs[indexPath.section];
    WARNewUserDiaryMomentOutline *momentOutline = monthModel.momentOutlines[indexPath.row];
    
    WARUserDiaryBaseCell *cell;
    if (momentOutline.isSinglePage) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARUserDiarySinglePageCellId];
        if (!cell) {
            cell = [[WARUserDiarySinglePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARUserDiarySinglePageCellId];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kWARUserDiaryPageCellId];
        if (!cell) {
            cell = [[WARUserDiaryPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARUserDiaryPageCellId];
        }
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell war_setMomentWithId:[NSString stringWithFormat:@"%@",momentOutline.momentId]];
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    if (indexPath.section < self.monthLogs.count) {
        WARNewUserDiaryMonthModel *monthModel = self.monthLogs[indexPath.section];
        if (indexPath.row < monthModel.momentOutlines.count) {
            WARNewUserDiaryMomentOutline *momentOutline = monthModel.momentOutlines[indexPath.row];
            cellHeight = momentOutline.displayMomentHeight;
        }
    }

    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.000001f;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pushToDiaryDetailblock) {
        WARUserDiaryBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        WARNewUserDiaryMoment *moment = cell.moment;
        self.pushToDiaryDetailblock(moment);
    }
}

#pragma mark  - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView){
        //与父控制器的滑动交互
        if (!self.canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
//        NSLog(@"WARUserDiaryViewController---offsetY:%.f",offsetY);
        if (offsetY<0) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
            self.canScroll = NO;
            scrollView.contentOffset = CGPointZero;
        }
        
        //月份悬浮工具条
        //显示与隐藏时机
        if (self.monthToolBar.tags.count <= 0) {
            return;
        }
        if ((offsetY + MultiItemsToolBarScrollViewHeight) >= (self.tableHeaderView.bounds.size.height)) {
            if (self.monthToolBar.hidden) {
                self.monthToolBar.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    self.monthToolBar.alpha = 1.0;
                }];
            }
        } else {
            if (!self.monthToolBar.hidden) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.monthToolBar.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.monthToolBar.hidden = YES;
                }];
            }
        }
        
        //屏幕上第一个显示的cell在tablview上的posision
        CGPoint firstShowCellPosition = [self.view convertPoint:CGPointMake(0, MultiItemsToolBarScrollViewHeight + 6) toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:firstShowCellPosition];
        [self.monthToolBar selectedBtnIndex:indexPath.section animate:YES];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.isTouch = YES;
}

///用于判断手指是否离开了 要做到当用户手指离开了，tableview滑道顶部，也不显示出主控制器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

//    self.isTouch = NO;
}

#pragma mark - WARNewUserDiaryTableHeaderViewDeleagte

- (void)userDiaryTableHeaderView:(WARNewUserDiaryTableHeaderView *)userDiaryTableHeaderView actionType:(WARNewUserDiaryTableHeaderActionType)actionType value:(id)value {
    switch (actionType) {
        case WARNewUserDiaryTableHeaderActionTypeRecordToday:
        {
            
            break;
        }
        case WARNewUserDiaryTableHeaderActionTypeFriend:
        {
            if (self.block) {
                self.block();
            }
            break;
        }
        case WARNewUserDiaryTableHeaderActionTypePublish:
        {
            if (self.pushToPublishblock) {
                self.pushToPublishblock();
            }
            break;
        }
        case WARNewUserDiaryTableHeaderActionTypeDidMonth:
        {
            WARNewUserDiaryMonthModel *monthModel = (WARNewUserDiaryMonthModel *)value;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidMonthItemToScroll" object:nil];
            [self scrollToSpecialOffsetWithMonthModel:monthModel];
            
            break;
        }
    }
}

- (void)scrollToSpecialOffsetWithMonthModel:(WARNewUserDiaryMonthModel *)monthModel {
    NSInteger index = [self.monthLogs indexOfObject:monthModel];
    // 滚动到指定位置
    [self.tableView reloadData];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    CGPoint contentOffset = CGPointMake(0, self.tableView.contentOffset.y - MultiItemsToolBarScrollViewHeight);
    [self.tableView setContentOffset:contentOffset animated:YES];
}

#pragma mark - WARUserDiaryBaseCellDelegate

- (void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell didImageIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents {
    
    WARFeedImageComponent *didComponent = [imageComponents objectAtIndex:index];
    if (didComponent.videoUrl) {
        if (self.pushToPlayBlock) {
//            self.pushToPlayBlock(didComponent.videoUrl);
        }
    } else {
        NSArray *photoUrls = [imageComponents valueForKeyPath:@"url"];
        if (photoUrls == nil || photoUrls.count <= 0) {
            return ;
        }

        NSMutableArray* tempArr = [NSMutableArray array];
        for (NSString *imageID in photoUrls) {
            WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
            photoBrowserModel.picUrl = [kCMPRPhotoUrl(imageID) absoluteString];
            
            [tempArr addObject:photoBrowserModel];
        }
        
        WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
        photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
        photoBrowser.photoArray = tempArr;
        photoBrowser.currentIndex = index;
        [photoBrowser show];
    }  
}

-(void)userDiaryBaseCellShowPop:(WARUserDiaryBaseCell *)userDiaryBaseCell actionType:(WARUserDiaryBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    [self showBottomViewPopWithFrame:frame indexPath:indexPath];
}

- (void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell didLink:(WARFeedComponentContent *)linkContent {
    if (linkContent && self.pushToWebBrowserblock) {
        self.pushToWebBrowserblock(linkContent.link.url);
    }
}

-(void)userDiaryBaseCellDidPriase:(WARUserDiaryBaseCell *)userDiaryBaseCell  indexPath:(NSIndexPath *)indexPath {
    [self praiseOrCancle:indexPath];
}

-(void)userDiaryBaseCellDidComment:(WARUserDiaryBaseCell *)userDiaryBaseCell  indexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - WARMultiItemsToolBarDelegate

- (void)toolBar:(WARMultiItemsToolBar *)toolBar didSelectedIndex:(NSUInteger)index {
    NDLog(@"index:%ld",index);
    [self.monthToolBar selectedBtnIndex:index animate:YES];
    // 滚动到指定位置
    [self.tableView reloadData];
    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    CGPoint contentOffset = CGPointMake(0, self.tableView.contentOffset.y - MultiItemsToolBarScrollViewHeight);
    [self.tableView setContentOffset:contentOffset animated:YES];
}

#pragma mark - public

-(void)dl_refresh{
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dl_UserDiarviewControllerDidFinishRefreshing:)]) {
                [self.delegate dl_UserDiarviewControllerDidFinishRefreshing:self];
                self.isRefreshing = NO;
            }
        });
    }
}

#pragma mark - private

/** 根据offsetY 获取悬浮月份对应的index */
- (NSInteger)indexWithOffsetY:(CGFloat)offsetY {
    for (int i = 0; i < self.monthLogs.count; i++) {
        WARNewUserDiaryMonthModel *monthModel = self.monthLogs[i];
        if (i == 0) {
            if (offsetY < monthModel.currentMonthDisplayBottomY) {
                return i;
            } else {
                continue ;
            }
        }
        WARNewUserDiaryMonthModel *preMonthModel = self.monthLogs[i - 1]; 
        if (offsetY < monthModel.currentMonthDisplayBottomY) {
            if (offsetY > preMonthModel.currentMonthDisplayBottomY) {
                return i;
            }
        }
    }
    return 0;
}

/** 配置每月开始时的offsetY  */
- (NSMutableArray <WARNewUserDiaryMonthModel *> *)configMonthDisplayOffsetY:(NSMutableArray <WARNewUserDiaryMonthModel *> *)monthLogs {
    NSMutableArray <WARNewUserDiaryMonthModel *> *tempMonthLogs = [NSMutableArray <WARNewUserDiaryMonthModel *>arrayWithArray:monthLogs];
 
    return tempMonthLogs;
}

- (void)praiseOrCancle:(NSIndexPath *)indexPath {
    WARUserDiaryBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    WARNewUserDiaryMoment *moment = cell.moment;
    
    NSString *itemId = moment.momentId;
    NSString *msgId = moment.momentId;
    NSString *thumbedAcctId = moment.accountId;
    
    NSString *thumbState = @"UP";
    if (moment.thumbUp) {
        thumbState = @"DOWN";
    }
    
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager praiseWithItemId:itemId msgId:msgId thumbedAcctId:thumbedAcctId thumbState:thumbState compeletion:^(bool success, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //构建点赞用户 model
        WARNewUserDiaryThumbUser *thumb = [[WARNewUserDiaryThumbUser alloc]init];
        thumb.accountId = strongSelf.userModel.accountId;
        thumb.name = strongSelf.userModel.nickname;
        
        NSMutableArray *thumbUsers = [NSMutableArray arrayWithArray:moment.thumbUsers];
        moment.thumbUp = !moment.thumbUp;
        if (moment.thumbUp) { //已点赞
            moment.praiseCount += 1;
            [thumbUsers addObject:thumb];
        } else { // 取消点赞
            moment.praiseCount -= 1;
            [thumbUsers enumerateObjectsUsingBlock:^(WARNewUserDiaryThumbUser *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.accountId isEqualToString:thumb.accountId]) {
                    [thumbUsers removeObject:obj];
                }
            }];
        } 
        moment.thumbUsers = [thumbUsers copy];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }]; 
}

#pragma mark - getther methods

- (NSMutableArray<WARNewUserDiaryMonthModel *> *)monthLogs {
    if (!_monthLogs) {
        _monthLogs = [NSMutableArray<WARNewUserDiaryMonthModel *> array];
    }
    return _monthLogs;
}

- (WARNewUserDiaryTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        CGFloat collectionViewW = kScreenWidth - 2 * AdaptedWidth(20);
        CGFloat itemW = (collectionViewW - 3 * 3) / 4;
        CGFloat collectionViewH = 2 * itemW + 3 ;
        CGFloat photoH = collectionViewH + 26 + 18;
        
        _tableHeaderView = [[WARNewUserDiaryTableHeaderView alloc]init];
        _tableHeaderView.delegate = self;
        _tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth,248 + photoH);
    }
    return _tableHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = kColor(whiteColor);
        _tableView.userInteractionEnabled = YES;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0; 
        [_tableView registerClass:[WARUserDiaryPageCell class] forCellReuseIdentifier:kWARUserDiaryPageCellId];
        [_tableView registerClass:[WARUserDiarySinglePageCell class] forCellReuseIdentifier:kWARUserDiarySinglePageCellId];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf loadDataRefresh:YES];
            [strongSelf loadItemDataRefresh:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;
//
//        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf loadDataRefresh:NO];
//        }];
//        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

- (WARMultiItemsToolBar *)monthToolBar {
    if (!_monthToolBar) {
        _monthToolBar = [[WARMultiItemsToolBar alloc]init];
        _monthToolBar.backgroundColor = HEXCOLOR(0xFBFBFB);
        _monthToolBar.hidden = YES;
        _monthToolBar.alpha = 0.0;
        _monthToolBar.clickDelegate = self;
        _monthToolBar.showsVerticalScrollIndicator = NO;
        _monthToolBar.showsHorizontalScrollIndicator = NO;
    }
    return  _monthToolBar;
}
 
@end
