//
//  WAROtherUserDiaryViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/23.
//

#import "WAROtherUserDiaryViewController.h"

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
#import "WARPopOverMenu.h"
#import "WARPopHorizontalMenu.h"
#import "WARMomentCellOperationMenu.h"
#import "WARProgressHUD.h"
#import "WARFeedModel.h"
#import "WARPhotoBrowser.h"

#define kScrollViewContentHeight 2661

#define kWARProfileBundle @"WARProfile.bundle"
#define kWARUserDiaryTweetCellId @"kWARUserDiaryTweetCellId"
#define kWARUserDiaryOrderCellId @"kWARUserDiaryOrderCellId"
#define kWARUserDiaryActivityCellId @"kWARUserDiaryActivityCellId"
#define kWARUserDiaryPhotosTableViewCellId @"kWARUserDiaryPhotosTableViewCellId"


#define kWARUserDiaryPageCellId @"kWARUserDiaryPageCellId"
#define kWARUserDiarySinglePageCellId @"kWARUserDiarySinglePageCellId"

#define kDiaryInputPhoto @"INPUTPHOTO"

@interface WAROtherUserDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WARUserDiaryBaseCellDelegate>

@property (nonatomic, strong) NSMutableArray <WARNewUserDiaryMoment *>*userDiaryLists;
@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *lastPublishTime;
@property (nonatomic, copy) NSString *friendId;

@end

@implementation WAROtherUserDiaryViewController

#pragma mark - System
 
- (instancetype)initWithFriendId:(NSString *)friendId{
    if (self = [super init]) {
        self.friendId = friendId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self loadDataRefresh:YES];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-kTabbarHeightAndSafeArea);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadDataRefresh:(BOOL)refresh {
    if (refresh) {
        self.lastFindId = @"";
        self.lastPublishTime = @"";
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.friendId == nil || self.friendId.length <= 0) {
        [WARProgressHUD showAutoMessage:@"朋友不存在"];
        return ;
    }

    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager loadUserDiaryListWithLastFindId:self.lastFindId lastPublishTime:self.lastPublishTime frinedId:self.friendId compeletion:^(WARNewUserDiaryModel *model, NSArray<WARNewUserDiaryMoment *> *results, NSArray<WARNewUserDiaryMomentLayout *> *layouts, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err && results > 0) {
            strongSelf.lastFindId = model.lastFindId;
            strongSelf.lastPublishTime = model.lastPublishTime;
        }
        
        [strongSelf.tableView reloadData];
        if (refresh) {
            strongSelf.userDiaryLists = [NSMutableArray arrayWithArray:results];
        } else {
            if (results.count > 0) {
                NSMutableArray *mutableAry = [NSMutableArray arrayWithArray:strongSelf.userDiaryLists];
                [mutableAry addObjectsFromArray:results];
                strongSelf.userDiaryLists = [NSMutableArray arrayWithArray:mutableAry];
            } else {
                [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
                return ;
            }
        }
        
        [strongSelf.tableView reloadData];
        [strongSelf dealWithLoadResultNoMoreData:results.count == 0];
    }];
}

- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - Event Response

- (void)showBottomViewPopWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath{
    WARPopHorizontalMenuConfiguration *config = [WARPopHorizontalMenuConfiguration defaultConfiguration];
    config.tintColor = [UIColor blackColor];
    config.needArrow = YES;
//    NSArray *images = @[@"newfriend_delete",@"newfriend_edit"];
    NSArray *imageArrays = @[@"newfriend_delete",@"daily_lock",@"newfriend_edit"];//daily_public
    
    __weak typeof(self) weakSelf = self;
    [WARPopHorizontalMenu showFromSenderFrame:frame imageArray:imageArrays doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (selectedIndex == 0) {//删除
            WARUserDiaryBaseCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
            if (indexPath.row < strongSelf.userDiaryLists.count) { 
                [WARUserDiaryManager deleteDiaryOrFriendMoment:cell.moment.momentId compeletion:^(bool success, NSError *err) {
                    if (success) {
                        [strongSelf.userDiaryLists removeObjectAtIndex:indexPath.row];
                        [strongSelf.tableView reloadData];
                        
                        [WARProgressHUD showAutoMessage:WARLocalizedString(@"删除成功")];
                    } else {
                        [WARProgressHUD showErrorMessage:WARLocalizedString(@"删除失败")];
                    }
                }];
            }
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userDiaryLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARNewUserDiaryMoment *moment = self.userDiaryLists[indexPath.row];
    WARUserDiaryBaseCell *cell;

    switch (moment.cellType) {
        case WARFriendCellTypeSinglePage:{
            cell = [tableView dequeueReusableCellWithIdentifier:kWARUserDiarySinglePageCellId];
            if (!cell) {
                cell = [[WARUserDiarySinglePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARUserDiarySinglePageCellId];
            }
            break;
        }
        case WARFriendCellTypeMultiPage:{
            cell = [tableView dequeueReusableCellWithIdentifier:kWARUserDiaryPageCellId];
            if (!cell) {
                cell = [[WARUserDiaryPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARUserDiaryPageCellId];
            }
            break;
        }
    }
    
    cell.moment = moment;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARNewUserDiaryMoment *moment = self.userDiaryLists[indexPath.row];
    WARNewUserDiaryMomentLayout *layout = moment.momentLayout;
    return layout.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pushToDiaryDetailblock) {
        WARNewUserDiaryMoment *moment = self.userDiaryLists[indexPath.row];
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
        NDLog(@"WARJournalListViewController---offsetY:%.f",offsetY);
        if (offsetY<0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
            self.canScroll = NO;
            scrollView.contentOffset = CGPointZero;
        }
    }
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

- (void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell actionType:(WARUserDiaryBaseCellActionType)actionType value:(id)value {
    
}

- (void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell didLink:(WARFeedComponentContent *)linkContent {
    if (linkContent && self.pushToWebBrowserblock) {
        self.pushToWebBrowserblock(linkContent.link.url);
    }
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


#pragma mark - getther methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
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
                [strongSelf loadDataRefresh:YES];
        }];
        mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = mj_header;

        MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDataRefresh:NO];
        }];
        _tableView.mj_footer = mj_footer;
    }
    return _tableView;
}

@end
