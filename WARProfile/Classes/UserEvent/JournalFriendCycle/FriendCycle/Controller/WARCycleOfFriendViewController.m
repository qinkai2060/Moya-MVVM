//
//  WARCycleOfFriendViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/9.
//

#import "WARCycleOfFriendViewController.h"

#import "Masonry.h"
#import "WARMacros.h"
#import "WARProfileNetWorkTool.h"
#import "WARProgressHUD.h"
#import "ReactiveObjC.h"
#import "WARTweetVideoTool.h"
#import "WARJournalFriendCycleNetManager.h"
#import "WARModal.h"

#import "WARMediator+Publish.h"
#import "UIImage+PreViewImage.h"
#import "UIView+Frame.h"

#import "WARProfileUserModel.h"
#import "WARMaskItem.h"

#import "WARFriendCycleTableHeaderView.h"
#import "WARCycleOfFriendNavigationBar.h"
#import "WARCycleOfFriendMaskModalView.h"
#import "WARActionSheet.h"
#import "WARImagePickerController.h"
#import "WARCameraViewController.h"
#import "WARUserCenterViewController.h"

@interface WARCycleOfFriendViewController ()<WARFriendCycleTableHeaderViewDelegate>
/** 头部 */
@property (nonatomic, strong) WARFriendCycleTableHeaderView *tableHeaderView;
/** 自定义导航条 */
@property (nonatomic, strong) WARCycleOfFriendNavigationBar *customNavigationBar;
/** 当前offsetY */
@property (nonatomic, assign) CGFloat currentContentOffsetY;
/** 最后offsetY */
@property (nonatomic, assign) CGFloat lastContentOffsetY;
/** 是显示白色状态栏状态 */
@property (nonatomic, assign) BOOL showStatusBarStyleLightContent;
/** 朋友圈面具id数组 */
@property (nonatomic, strong) NSMutableArray<WARDBCycleOfFriendMaskModel *> *friendMaskIdLists;
/** 选中的面具 */
@property (nonatomic, strong) NSArray *selectdMaskIds;
@end

@implementation WARCycleOfFriendViewController

#pragma mark - System

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.showStatusBarStyleLightContent) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showStatusBarStyleLightContent = YES;
    
    [self loadHeaderData];
    
    [self loadMaskIdData];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];//HEXCOLOR(0xf4f4f4);
    
    [self.view addSubview:self.customNavigationBar];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottom);
    }];
}

- (void)loadHeaderData {
    __weak typeof(self) weakSelf = self;
    [WARProfileNetWorkTool getUserInfoWithCallBack:^(id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        WARProfileUserModel *model = [[WARProfileUserModel alloc] init];
        model.isMine = YES;
        [model praseData:response];
        if (model.MasksArr.count > 0) {
            strongSelf.tableHeaderView.model = model.MasksArr.firstObject;
        }
    } failer:^(id response) {
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"加载失败")];
    }];
}

- (void)loadMaskIdData {
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager getMaskListWithCompletion:^(NSArray<WARDBCycleOfFriendMaskModel *> *results, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //全部好友
        WARDBCycleOfFriendMaskModel *allMask = [[WARDBCycleOfFriendMaskModel alloc]init];
        allMask.maskId = @"all";
        allMask.remark = WARLocalizedString(@"全部好友");
        allMask.isAllFriends = YES;
        
        if (!err) {
            [strongSelf.friendMaskIdLists removeAllObjects];
            
            [strongSelf.friendMaskIdLists addObject:allMask];
            [strongSelf.friendMaskIdLists addObjectsFromArray:results];
        } else {
            [WARProgressHUD showAutoMessage:[err description]];
            [strongSelf.friendMaskIdLists removeAllObjects];
            
            [strongSelf.friendMaskIdLists addObject:allMask];
        }
    }];  
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARFriendCycleTableHeaderViewDelegate

-(void)headerViewDidUserHeader:(WARFriendCycleTableHeaderView *)headerView {
    WARUserCenterViewController *controller = [[WARUserCenterViewController alloc] init];
    controller.isOtherfromWindow = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIScrollDelegate

- (void)tableView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentContentOffsetY = scrollView.contentOffset.y;
//    NDLog(@"offsetY:%.f",self.currentContentOffsetY);
    
    //开始计算比例的位置
    CGFloat startCaculatePosition =  (kWARFriendCycleTableHeaderViewHeight - kStatusBarAndNavigationBarHeight - 27);
    
    //offsetY不满足比例计算，直接返回
    if (self.currentContentOffsetY <= startCaculatePosition) {
//        //更新状态栏
//        self.showStatusBarStyleLightContent = YES;
//        [self setNeedsStatusBarAppearanceUpdate];
//        return ;
    }
    
    //可以减少的最大高度 = 导航栏高度 -（状态栏高度 + 最终的高度）
    CGFloat reduceBaseHeight = (kStatusBarAndNavigationBarHeight - (kStatusBarHeight + 20));
    
    //比例 = （offsetY - 主题图高度）/ reduceBaseHeight
    CGFloat scale = (self.currentContentOffsetY - startCaculatePosition) / reduceBaseHeight;
    
    //需要减少的高度 = reduceBaseHeight * 比例
    CGFloat reduceHeight = (kStatusBarAndNavigationBarHeight - (kStatusBarHeight + 20)) * (scale > 1 ? 1 : scale);
    reduceHeight = reduceHeight < 0 ? 0 : reduceHeight;
//    NSLog(@"reduceHeight:%.f",reduceHeight);
    
//    //reduceHeight 小于 0，直接返回
//    if (reduceHeight < 0) {
//        //更新状态栏
//        self.showStatusBarStyleLightContent = NO;
//        [self setNeedsStatusBarAppearanceUpdate];
//        return ;
//    }
    
    //字体比例
    CGFloat fontScale = (kStatusBarAndNavigationBarHeight - reduceHeight) / kStatusBarAndNavigationBarHeight;
    fontScale = fontScale < 0.82 ? 0.82 : fontScale;
    
    
    if (self.lastContentOffsetY > scrollView.contentOffset.y) { /// 向下滑动
        if (self.currentContentOffsetY <= kHeaderView) { /// 整个头部以下才是滑动就展开
            [self.customNavigationBar scrollWithScale:scale fontScale:fontScale changeAlpha:YES];
            //导航栏高度
            self.customNavigationBar.height = kStatusBarAndNavigationBarHeight - reduceHeight;
        } else {
            [self.customNavigationBar scrollWithScale:1 fontScale:1 changeAlpha:YES];
            //导航栏高度
            self.customNavigationBar.height = kStatusBarAndNavigationBarHeight;
        }
    } else if (self.lastContentOffsetY < scrollView.contentOffset.y){ ///向上滑动
        [self.customNavigationBar scrollWithScale:scale fontScale:fontScale changeAlpha:YES];
        //导航栏高度
        self.customNavigationBar.height = kStatusBarAndNavigationBarHeight - reduceHeight;
    }
    self.lastContentOffsetY = scrollView.contentOffset.y;
    
    
    //更新状态栏
    self.showStatusBarStyleLightContent = (scale <= 0);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)tableView:(UITableView *)tableView scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)tableView:(UITableView *)tableView scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

/** 松手时调用，松手时已经静止, 只会调用scrollViewDidEndDragging */
- (void)tableView:(UITableView *)tableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

/** 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating */
- (void)tableView:(UITableView *)tableView scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - Private

- (void)showFilterView {
    WARCycleOfFriendMaskModalView *view = [[WARCycleOfFriendMaskModalView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2 * 38, kScreenWidth - 2 * 38)];
    view.faceArray = self.friendMaskIdLists;
    
    WARModal *modal = [WARModal modalWithContentView:view];
    modal.hideWhenTouchOutside = YES;
    [modal show:YES];
    
    __weak typeof(self) weakSelf = self;
    view.closeBlock = ^{
        [modal hide:YES];
    };
    view.confirmBlock = ^(NSArray *selectdMaskIds) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [modal hide:YES];
        
        strongSelf.selectdMaskIds = [NSArray arrayWithArray:selectdMaskIds];
        
        [strongSelf loadDataWithMaskIdLists:strongSelf.selectdMaskIds];
    };
}

- (void)rightAction{
    @weakify(self)
    NSArray* titles = @[@"从手机相册选择", @"拍摄", @"文字"];
    [WARActionSheet actionSheetWithBtnTitles:titles cancelTitle:WARLocalizedString(@"取消") completionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        @strongify(self)
        if (index == 0) {
            [self showImagePicker];
        }else if (index == 1){
            [self showCamera];
        }else {
            [self toPublish];
        }
    }];
}

- (void)showImagePicker {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVc.allowPickingMultipleVideo = YES;
    imagePickerVc.allowTakePicture = NO;
    @weakify(self);
    imagePickerVc.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        @strongify(self)
        UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerWithImages:photos assets:assets videoData:nil];
        [self.navigationController pushViewController:publishVC animated:YES];
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)showCamera {
    WARCameraViewController *vc = [[WARCameraViewController alloc] init];
    @weakify(self);
    vc.takeBlock = ^(id item) {
        @strongify(self)
        if ([item isKindOfClass:[NSURL class]]) {
            //视频url
            NSURL *videoURL = item;
            [WARTweetVideoTool war_movFileTransformToMP4WithSourcePath:videoURL.absoluteString completion:^(NSString *Mp4FilePath) {
                UIImage *image = [UIImage getPreViewImageWithUrl:videoURL];
                NSUInteger duration = [WARTweetVideoTool war_durationWithVideo:videoURL];
                NSDictionary* dict = @{@"videoCoverImg" : @[image],
                                       @"duration" : [NSNumber numberWithInteger:duration],
                                       @"videoFilePath" : Mp4FilePath
                                       };
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerWithImages:@[] assets:@[]  videoData:dict];
                    [self.navigationController pushViewController:publishVC animated:YES];
                });
                
            } session:^(AVAssetExportSession *session) {
            }];
        } else if ([item isKindOfClass:[UIImage class]]){
            //图片
            UIImage *image = item;
            UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerWithImages:@[image] assets:@[] videoData:nil];
            [self.navigationController pushViewController:publishVC animated:YES];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)toPublish {
    UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForPublishViewControllerNoParams];
    [self.navigationController pushViewController:publishVC animated:YES];
}


#pragma mark - Setter And Getter

-(WARCycleOfFriendNavigationBar *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = [[WARCycleOfFriendNavigationBar alloc]init];
        _customNavigationBar.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight);
        __weak typeof(self) weakSelf = self;
        _customNavigationBar.didLeftItemBlcok = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _customNavigationBar.didFilterBlock = ^{
          __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf showFilterView];
        };
        _customNavigationBar.didRightItemBlcok = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf rightAction];
        };
        _customNavigationBar.didBarBlock = ^{
            
        };
    }
    return _customNavigationBar;
}

- (WARFriendCycleTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[WARFriendCycleTableHeaderView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderView);
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (NSMutableArray<WARDBCycleOfFriendMaskModel *> *)friendMaskIdLists {
    if (!_friendMaskIdLists) {
        _friendMaskIdLists = [NSMutableArray <WARDBCycleOfFriendMaskModel *>array];
        
    }
    return _friendMaskIdLists;
}

@end
