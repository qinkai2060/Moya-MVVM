//
//  WARFriendDetailViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/7.
//

#import "WARFriendDetailViewController.h"
#import "WARNavgationCutsomBar.h"
#import "WARFriendSinglePageCell.h"
#import "WARPopOverMenu.h"

#import "WARBaseMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import "WARMediator+WebBrowser.h"
#import "WARMediator+Contacts.h"
#import "UIImage+Tint.h"

#import "Masonry.h"

#import "WARMoment.h"
#import "WARDBContactModel.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedComponentLayout.h"
#import "WARFeedModel.h"

#import "WARPhotoBrowser.h"
#import "WARDBContactModel.h"

#import "WARProfileOtherViewController.h"
#import "WARUserDiaryManager.h"
#import "WARDBUserModel.h"
#import "WARDBUserManager.h"
#import "WARFriendCommentLayout.h"

#define kWARFriendSinglePageCellId @"kWARFriendSinglePageCellId"

@interface WARFriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WARFriendBaseCellDelegate,WARPhotoBrowserDelegate>

//@property (nonatomic,strong) WARNavgationCutsomBar *customBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) WARDBUserModel *userModel;
 
/** 图片浏览器正在浏览的图集 */
@property (nonatomic, strong) NSMutableArray<WARFeedImageComponent *> *currentBrowseImageComponents;
/** currentBrowseMagicImageView */
@property (nonatomic, weak) UIView *currentBrowseMagicImageView;
@end

@implementation WARFriendDetailViewController

#pragma mark - System

- (instancetype)initWithMoment:(WARMoment *)moment type:(NSString *)type{
    self = [super init];
    if (self) {
        self.type = type;
        WARMoment *copyMoment = [moment copy];
        
        if ([type isEqualToString:@"FRIEND"]) {
            copyMoment.momentShowType = WARMomentShowTypeFullText;
        } else if ([type isEqualToString:@"FOLLOW"]) {
            copyMoment.momentShowType = WARMomentShowTypeFullText;
        }
        
        NSMutableArray *pageLayouts = [NSMutableArray array];
        for (WARFeedPageModel *pageM in copyMoment.ironBody.pageContents) {
            WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
            [layout configComponentLayoutsWithPage:pageM contentScale:1 momentShowType:(WARMomentShowTypeFullText) isMultilPage:copyMoment.isMultilPage];
            [pageLayouts addObject:layout];
        }
        
        WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [WARFriendMomentLayout type:self.type moment:copyMoment openLike:NO openComment:NO];
        friendMomentLayout.feedLayoutArr = pageLayouts;
        copyMoment.friendMomentLayout = friendMomentLayout;
        
        friendMomentLayout.moment = copyMoment;
        
        self.moment = copyMoment;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userModel = [WARDBUserManager userModel];
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottom);
    }];
}

- (void)initNavigationBar { 
    self.title = WARLocalizedString(@"全文");
    UIImage *image = [[[UIImage war_imageName:@"person_zone_details_more" curClass:[self class] curBundle:@"WARProfile.bundle"] imageWithTintColor:[UIColor whiteColor]]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
}

#pragma mark - Event Response

- (void)addAction:(UIButton *)button {
    NDLog(@"Navigation addAction");
}

- (void)rightAction{
    
}

- (void)leftAtction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

#pragma mark - WARFriendBaseCellDelegate
 
- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType value:(id)value {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidPageContent:
        {
            
            break;
        }
        case WARFriendBaseCellActionTypeScrollHorizontalPage:{
            
            break;
        }
        case WARFriendBaseCellActionTypeFinishScrollHorizontalPage:{
            
            break;
        }
        case WARFriendBaseCellActionTypeDidUserHeader: {
            
            break;
        }
        case WARFriendBaseCellActionTypeDidPraise: {
            [self praiseOrCancle];
            break;
        }
        case WARFriendBaseCellActionTypeDidFollowComment:{
            
            break;
        }
        default:
            break;
    }
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents  magicImageView:(UIView *)magicImageView {
    self.currentBrowseImageComponents = [NSMutableArray arrayWithArray:imageComponents];
    self.currentBrowseMagicImageView = magicImageView;

    NSMutableArray *tempArray = [NSMutableArray array];
    [imageComponents enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
        if (obj.videoId && obj.videoId.length > 0) {
            photoBrowserModel.videoURL = obj.videoId;
            photoBrowserModel.thumbnailUrl = [[NSString stringWithFormat:@"%@?vframe/jpg/offset/0|imageView2/0/q/75|imageslim",obj.videoId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
            photoBrowserModel.picUrl = [kCMPRPhotoUrl(obj.imgId) absoluteString];
        }
        [tempArray addObject:photoBrowserModel];
    }];
    
    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
    photoBrowser.delegate = self;
    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
    photoBrowser.photoArray = tempArray;
    photoBrowser.currentIndex = index;
    [photoBrowser show];
    
}

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didLink:(WARFeedLinkComponent *)linkContent {
    if (linkContent) {
        UIViewController *controllr = [[WARMediator sharedInstance] Mediator_viewControllerForWebBrowserContainerWithUrl:linkContent.url callback:nil];
        [self.navigationController pushViewController:controllr animated:YES];
    }
}

-(void)friendBaseCellDidUserHeader:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model {
    if (self.moment.friendModel.thirdType && self.moment.friendModel.homeUrl) {
        UIViewController *controller = [[WARMediator sharedInstance]Mediator_ThirdHomeViewControllerWithTitle:self.moment.friendModel.nickname urlString:self.moment.friendModel.homeUrl guyId:self.moment.friendModel.accountId isFollow:self.moment.friendModel.followed];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        WARProfileOtherViewController *controller = [[WARProfileOtherViewController alloc] initWithGuyID:model.accountId friendWay:@""];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)friendBaseCellShowPop:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    switch (actionType) {
        case WARFriendBaseCellActionTypeDidTopPop:
        {
            break;
        }
        case WARFriendBaseCellActionTypeDidBottomPop:
        {
            [self showBottomViewPopWithFrame:frame];
            break;
        }
            
        default:
            break;
    }
}
 
- (void)showBottomViewPopWithFrame:(CGRect)frame {
    NSArray *titles = @[WARLocalizedString(@"不看此条消息"),WARLocalizedString(@"不看TA的朋友圈")];
    
    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = YES;
    config.textAlignment = NSTextAlignmentCenter;
    __weak typeof(self) weakSelf = self;
    [WARPopOverMenu showFromSenderFrame:frame withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        switch (selectedIndex) {
            case 0:
            {
                
                break;
            }
            case 1:
            {
                
                break;
            }
            case 2:
            {
                
                break;
            }
                
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
}

#pragma mark - WARPhotoBrowserDelegate

- (CGRect)imageBrowser:(WARPhotoBrowser *)imageBrowser disappearFrameForIndex:(NSInteger)index {
    WARFeedImageComponent *imageComponent = [self.currentBrowseImageComponents objectAtIndex:index];
    //                                             [self.currentBrowseImageComponents removeAllObjects]
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:imageComponent.listRect fromView:self.currentBrowseMagicImageView];
    return rect;
}

#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARFriendSinglePageCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFriendSinglePageCellId];
    if (!cell) {
        cell = [[WARFriendSinglePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFriendSinglePageCellId];
    }
    cell.delegate = self;
    cell.moment = self.moment;
    
    [cell hideLikeView:YES];
    [cell hideCommentView:YES];
    [cell showTopView:NO];
    [cell showBottomView:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    WARFriendMomentLayout *layout = self.moment.friendMomentLayout; 
    return layout.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Private


- (void)praiseOrCancle {
    WARMoment *moment = self.moment;
    
    NSString *itemId = moment.momentId;
    NSString *msgId = moment.momentId;
    NSString *thumbedAcctId = moment.friendModel.accountId;
    
    NSString *thumbState = @"UP";
    if (moment.commentWapper.thumbUp) {
        thumbState = @"DOWN";
    }
    
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager praiseWithItemId:itemId msgId:msgId thumbedAcctId:thumbedAcctId thumbState:thumbState compeletion:^(bool success, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //构建点赞用户 model
        WARMomentUser *thumb = [[WARMomentUser alloc]init];
        thumb.accountId = strongSelf.userModel.accountId;
        thumb.nickname = strongSelf.userModel.nickname;
        
        NSMutableArray *thumbUserBos = [NSMutableArray arrayWithArray:moment.commentWapper.thumb.thumbUserBos];
        moment.commentWapper.thumbUp = !moment.commentWapper.thumbUp;
        if (moment.commentWapper.thumbUp) { //已点赞
            moment.commentWapper.praiseCount += 1;
            [thumbUserBos addObject:thumb];
        } else { // 取消点赞
            moment.commentWapper.praiseCount -= 1;
            [thumbUserBos enumerateObjectsUsingBlock:^(WARMomentUser *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.accountId isEqualToString:thumb.accountId]) {
                    [thumbUserBos removeObject:obj];
                }
            }];
        }
        
        moment.commentWapper.thumb.thumbUserBos = [thumbUserBos copy];
        
        WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = [[WARFriendMomentLayout alloc] init];
        NSMutableArray *pageLayouts = [NSMutableArray array];
        for (WARFeedPageModel *pageM in moment.ironBody.pageContents) {
            WARFeedPageLayout *layout = [[WARFeedPageLayout alloc] init];
            [layout configComponentLayoutsWithPage:pageM contentScale:kContentScale momentShowType:(WARMomentShowTypeFriendFollowDetail) isMultilPage:moment.ironBody.pageContents.count > 1];
            [pageLayouts addObject:layout];
        }
        friendMomentLayout.feedLayoutArr = pageLayouts;
        moment.friendMomentLayout = friendMomentLayout;
        friendMomentLayout.moment = moment;
        //        //原布局
//        WARFriendMomentLayout *originalLayout = moment.friendMomentLayout;
//        //新生成布局
//        WARFriendMomentLayout *layout = [WARFriendMomentLayout type:self.type moment:moment openLike:open openComment:NO];
//        layout.feedLayoutArr = originalLayout.feedLayoutArr;
//        layout.limitFeedLayoutArr = originalLayout.limitFeedLayoutArr;
//        layout.currentPageIndex = originalLayout.currentPageIndex;
//        moment.friendMomentLayout = layout;
        
        //朋友圈列表评论布局
        NSMutableArray <WARFriendCommentLayout *>*commentsLayoutArr = [NSMutableArray <WARFriendCommentLayout *>arrayWithCapacity:moment.commentWapper.comment.comments.count];
        [moment.commentWapper.comment.comments enumerateObjectsUsingBlock:^(WARFriendComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARFriendCommentLayout* layout = [WARFriendCommentLayout commentFollowDetailLayout:obj openCommentLayout:NO];
            [commentsLayoutArr addObject:layout];
        }];
        moment.commentsLayoutArr = commentsLayoutArr;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadData];
        });
    }];
}

#pragma mark - Setter And Getter

//- (WARNavgationCutsomBar *)customBar{
//    if (!_customBar) {
//        WS(weakself);
//        _customBar = [[WARNavgationCutsomBar alloc] initWithTile:[NSString stringWithFormat:@"全文"] rightTitle:@"" alpha:0 backgroundColor:[UIColor whiteColor] rightHandler:^{
//            [weakself rightAction];
//        } leftHandler:^{
//            [weakself leftAtction];
//        }];
//        [_customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        CGFloat height = WAR_IS_IPHONE_X ? 84:64;
//        _customBar.frame = CGRectMake(0, 0, kScreenWidth, height);
//    }
//    return _customBar;
//}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kColor(whiteColor);
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[WARFriendSinglePageCell class] forCellReuseIdentifier:kWARFriendSinglePageCellId];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedRowHeight = 0;
        }
    }
    return _tableView;
}

@end
