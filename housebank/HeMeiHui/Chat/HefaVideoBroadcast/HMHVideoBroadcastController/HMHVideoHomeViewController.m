//
//  HMHVideoHomeViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/4/23.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoHomeViewController.h"
#import "XLCycleScrollView.h"
#import "VideoTopCategoryView.h"
#import "HMHHomepageVideoCollectionViewCell.h"
#import "HMHVHCollectionSectionFootView.h"
#import "HMHVHCollectionSectionHeaderView.h"
#import "HMHVideoSearchViewController.h"
#import "HMHVideoCacheListViewController.h"
#import "HMHVideoCategoryViewController.h"
#import "HMHShortVideoViewController.h"
#import "HMHVideoPreviewViewController.h"
#import "HMHCollectViewController.h"
#import "HMHVideosListViewController.h"
#import "HMHVideoHistoryViewController.h"
#import "HMHAliyunTimeShiftLiveViewController.h" // 直播
#import "HMHAliYunVodPlayerViewController.h" // 回放
#import "HMHVideoHomeBannerModel.h"
#import "HMHVideoHomeModuleMenuModel.h"


#define bannerHeight  ScreenW / 3

@interface HMHVideoHomeViewController ()<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,VideoCategoryBtnDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CollectionSectionFootViewDelegate>

@property (nonatomic, strong) XLCycleScrollView *HMH_xlScrollView;///滚动图片
@property (nonatomic, strong) UIView *HMH_headerView;

@property (nonatomic, strong) VideoTopCategoryView *HMH_centerView;
@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *HMH_lineLab;

@property (nonatomic, strong) UIView *HMH_navView;
@property (nonatomic, strong) UITextField *HMH_searchTextField;

@property (nonatomic, strong) NSMutableArray *HMH_bannerArr;
@property (nonatomic, strong) NSMutableArray *HMH_moduleMenuArr;
@property (nonatomic, strong) NSMutableArray *HMH_sectionGriditemArr;

@property (nonatomic,strong) UIActivityIndicatorView *loadingView;

@end

@implementation HMHVideoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 防止自动锁屏 （常亮）
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _HMH_bannerArr = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_moduleMenuArr = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_sectionGriditemArr = [[NSMutableArray alloc] initWithCapacity:1];
    // 测试数据
//    [self getPrcessdata:nil];
    [self HMH_refreshLoadData];
    [self HMH_createNav];
    
    [self HMH_createCollectionView];
        
    [self HMH_createHeaderView];
    
    [self loadingAnimation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = YES;
    if (_collectionView) {
        CGRect rect = _collectionView.frame;
        rect.size.height = ScreenH - self.HMH_statusHeghit - 44 - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH;
        _collectionView.frame = rect;
    }
}
// 数据加载
- (void)HMH_refreshLoadData{
    [self.loadingView startAnimating];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/info-index/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }
    [self requestData:[NSDictionary dictionary] withUrl:getUrlStr withRequestName:@""];
}

- (void)loadingAnimation{
    //小菊花
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    UIActivityIndicatorViewStyleWhiteLarge 的尺寸是（37，37）
    //    UIActivityIndicatorViewStyleWhite 的尺寸是（22，22）
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
//    [self.loadingView startAnimating];
}

-(void)HMH_createNav{
    _HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit, ScreenW, 44)];
    _HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_navView];
    //
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, 7, ScreenW - 30 * 3 - 60, 30)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, 7, ScreenW - 30 * 2 - 60, 30)];

    bgView.backgroundColor = RGBACOLOR(233, 234, 235, 1);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = bgView.frame.size.height / 2;
    [_HMH_navView addSubview:bgView];
    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 7.5, 15, 15)];
    img.image = [UIImage imageNamed:@"VH_videoSearch"];
    [bgView addSubview:img];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0, 20, 60, 44);
    backButton.frame=CGRectMake(0, 0, 60, 44);

    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backImageView.image=[UIImage imageNamed:@"VH_blackBack"];
    [backButton addSubview:backImageView];
    [_HMH_navView addSubview:backButton];
    
    _HMH_searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height)];
    _HMH_searchTextField.backgroundColor = [UIColor clearColor];
    _HMH_searchTextField.enabled = NO;
    _HMH_searchTextField.returnKeyType = UIReturnKeySearch;
    _HMH_searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _HMH_searchTextField.text = self.searchKeyStr;
    _HMH_searchTextField.placeholder = @"请输入搜索内容";
    _HMH_searchTextField.font = [UIFont systemFontOfSize:14.0];
    [bgView addSubview:_HMH_searchTextField];
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:searchBtn];
    
    
    // 缓存
    UIButton *rightButton1=[UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton1.frame=CGRectMake(_HMH_navView.frame.size.width-35, 27, 30, 30);
    rightButton1.frame=CGRectMake(_HMH_navView.frame.size.width-35, 7, 30, 30);

    [rightButton1 setImage:[UIImage imageNamed:@"VH_videoCache"] forState:UIControlStateNormal];
    [rightButton1 setTitleColor:RGBACOLOR(73,73,75,1)forState:UIControlStateNormal];
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton1 addTarget:self action:@selector(rightBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
//    [_HMH_navView addSubview:rightButton1];
    
    // 收藏
    UIButton *rightButton2=[UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton2.frame=CGRectMake(_HMH_navView.frame.size.width-35 - 35, rightButton1.frame.origin.y, 30, 30);
    rightButton2.frame=CGRectMake(_HMH_navView.frame.size.width - 35, rightButton1.frame.origin.y, 30, 30);

    [rightButton2 setImage:[UIImage imageNamed:@"VH_videoCollect"] forState:UIControlStateNormal];
    [rightButton2 setTitleColor:RGBACOLOR(73,73,75,1)forState:UIControlStateNormal];
    rightButton2.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton2 addTarget:self action:@selector(rightBtn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_navView addSubview:rightButton2];
    
    // 历史
    UIButton *rightButton3=[UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton3.frame=CGRectMake(_HMH_navView.frame.size.width-35 - 35 * 2, rightButton2.frame.origin.y, 30, 30);
    rightButton3.frame=CGRectMake(_HMH_navView.frame.size.width-35 - 35 * 1, rightButton2.frame.origin.y, 30, 30);

    [rightButton3 setImage:[UIImage imageNamed:@"VH_videoRecord"] forState:UIControlStateNormal];
    [rightButton3 setTitleColor:RGBACOLOR(73,73,75,1)forState:UIControlStateNormal];
    rightButton3.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton3 addTarget:self action:@selector(rightBtn3Click:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_navView addSubview:rightButton3];
    
    //
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _HMH_navView.frame.size.height - 1, _HMH_navView.frame.size.width, 1)];
    bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    [_HMH_navView addSubview:bottomLab];
}

#pragma mark 顶部搜索框的点击事件
- (void)searchBtnClick:(UIButton *)btn{
    HMHVideoSearchViewController *searchVC = [[HMHVideoSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark 返回到上一页
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//缓存
- (void)rightBtn1Click:(UIButton *)btn{
    if (self.isLogin) {
        HMHVideoCacheListViewController *cacheVC = [[HMHVideoCacheListViewController alloc] init];
        [self.navigationController pushViewController:cacheVC animated:YES];
        return;
    }
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
        
    };
}
// 收藏
- (void)rightBtn2Click:(UIButton *)btn{
    if (self.isLogin) {
        HMHCollectViewController *collecVC = [[HMHCollectViewController alloc] init];
        [self.navigationController pushViewController:collecVC animated:YES];
        return;
    }
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
        
    };
}

// 历史
- (void)rightBtn3Click:(UIButton *)btn{
    if (self.isLogin) {
        HMHVideoHistoryViewController *VC = [[HMHVideoHistoryViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    self.HMH_loginVC.judgeIsLoginBack = ^(NSString *sidStr) {
        
    };
}

-(void)HMH_createCollectionView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 10;
    
    //最小两行之间的间距
    layout.minimumLineSpacing = 10;    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.HMH_statusHeghit + 44,ScreenW,ScreenH - self.HMH_statusHeghit - 44 - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(400, 0, 0, 0);
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [self.view addSubview:_collectionView];
    
    //这种是自定义cell不带xib的注册
    [_collectionView registerClass:[HMHHomepageVideoCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    //这是头部与脚部的注册
//    [_collectionView registerClass:[VHCollectionTopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView1"];

    [_collectionView registerClass:[HMHVHCollectionSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    [_collectionView registerClass:[HMHVHCollectionSectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    
    // 顶部刷新
//    __weak typeof(self) weakSelf = self;
//    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [_collectionView.mj_footer  beginRefreshing];
//        NSLog(@"%@",[NSThread currentThread]);
////        [weakSelf HMH_refreshLoadData];
//        [weakSelf getPrcessdata:nil];
//
//    }];
}
// 当头部的banner为空的时候 调整UI
- (void)refreshHeaderView{
    if (self.HMH_bannerArr.count == 0) {
        _collectionView.contentInset = UIEdgeInsetsMake(400 - bannerHeight, 0, 0, 0);
        _HMH_headerView.frame = CGRectMake(0, -400 + bannerHeight, ScreenW, 400 -  bannerHeight);
        _HMH_xlScrollView.frame = CGRectMake(0, 0, ScreenW, 0);
        
        _HMH_centerView.frame = CGRectMake(0, CGRectGetMaxY(_HMH_xlScrollView.frame) + 10, ScreenW, 150);
        
        _HMH_lineLab.frame = CGRectMake(0, _HMH_headerView.frame.size.height - 1, ScreenW, 1);
    }
}
// 创建顶部的view
- (void)HMH_createHeaderView{
    _HMH_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, ScreenW, 400)];
    _HMH_headerView.backgroundColor =[UIColor whiteColor];
    [_collectionView addSubview:_HMH_headerView];
    
    [self createXLScrollView];
    
    [self HMH_createCenterView];
}

-(void)createXLScrollView{
    //225
    _HMH_xlScrollView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, bannerHeight) autoCycle:YES];
    _HMH_xlScrollView.delegate = self;
    _HMH_xlScrollView.datasource = self;
    [_HMH_xlScrollView setShowPageControl:YES];
    [_HMH_headerView addSubview:_HMH_xlScrollView];
}
// 创建中间的按钮view
- (void)HMH_createCenterView{
    _HMH_centerView = [[VideoTopCategoryView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_HMH_xlScrollView.frame) + 10, ScreenW, 150) withDataSource:_HMH_moduleMenuArr];
    _HMH_centerView.delegate = self;
    [_HMH_headerView addSubview:_HMH_centerView];
    
    CGFloat centenViewH = [VideoTopCategoryView getCenterViewHeightWithArr:_HMH_moduleMenuArr];
    
    _HMH_centerView.frame = CGRectMake(0, CGRectGetMaxY(_HMH_xlScrollView.frame) + 10, ScreenW, centenViewH);
    _collectionView.contentInset = UIEdgeInsetsMake(centenViewH +  bannerHeight + 10, 0, 0, 0);
    _HMH_headerView.frame = CGRectMake(0, -(centenViewH +  bannerHeight + 10), ScreenW, centenViewH +  bannerHeight + 10);
    
    //
    _HMH_lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _HMH_headerView.frame.size.height - 1, ScreenW, 1)];
    _HMH_lineLab.backgroundColor = RGBACOLOR(241, 242, 244, 1);
    [_HMH_headerView addSubview:_HMH_lineLab];
}

#pragma mark collectionView delegate
//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _HMH_sectionGriditemArr.count;
}

//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_HMH_sectionGriditemArr.count > section) {
        if ([_HMH_sectionGriditemArr[section] count] < 4) {
            return [_HMH_sectionGriditemArr[section] count];
        }
        return 4;
    }
    return 0;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HMHHomepageVideoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //    cell.label.text=[NSString stringWithFormat:@"%ld",indexPath.section*100+indexPath.row];
    if (_HMH_sectionGriditemArr.count > indexPath.section) {
        NSMutableArray *indexArr = _HMH_sectionGriditemArr[indexPath.section];
        if (indexArr.count > indexPath.row) {
            HMHVideoHomeGriditemModel *model = indexArr[indexPath.row];
            model.sectionIndexPath = indexPath.section;
            model.rowIndexPath = indexPath.row;
            [cell refreshViewWithModel:model];
        }
    }
    return cell;
}

//头部和脚部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HMHVHCollectionSectionHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if (_HMH_sectionGriditemArr.count > indexPath.section) {
            NSArray *arr = _HMH_sectionGriditemArr[indexPath.section];
            if (arr.count > indexPath.row) {
                HMHVideoHomeGriditemModel *model = arr[indexPath.row];
                headerView.titleLab.text = model.titleText;
            }
        }
        return headerView;
    }else{
        HMHVHCollectionSectionFootView *footView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
        footView.sectionIndex = indexPath.section;
        if (_HMH_sectionGriditemArr.count > indexPath.section) {
            NSArray *arr = _HMH_sectionGriditemArr[indexPath.section];
            if (arr.count > indexPath.row) {
                HMHVideoHomeGriditemModel *model = arr[indexPath.row];
                footView.bottomStr = model.bottomText;
                [footView refreshTitle:model.bottomText];
            }
        }
        footView.delegate = self;
        return footView;
    }
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (_HMH_sectionGriditemArr.count > section) {
        if ([_HMH_sectionGriditemArr[section] count] == 0) {
            return CGSizeMake(0, 0);
        }
    }
    return CGSizeMake(ScreenW, 50);
}

//脚部试图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (_HMH_sectionGriditemArr.count > section) {
        if ([_HMH_sectionGriditemArr[section] count] == 0) {
            return CGSizeMake(0, 0);
        }
    }
    return CGSizeMake(ScreenW, 50);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW - 30) / 2, (ScreenW - 30) / 2 * 0.618 + 40);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell被点击后移动的动画
    //    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    
    // （0普通视频|1短视频）

//    NSLog(@"row == %ld,section == %ld",indexPath.row,indexPath.section);
    if (_HMH_sectionGriditemArr.count > indexPath.section) {
        NSMutableArray *indexArr = _HMH_sectionGriditemArr[indexPath.section];
        if (indexArr.count > indexPath.row) {
            HMHVideoHomeGriditemModel *model = indexArr[indexPath.row];
            if ([model.sceneType isEqualToNumber:@1]) { // 短视频
                HMHShortVideoViewController *vc = [[HMHShortVideoViewController alloc] init];
                vc.videoNo = model.id;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else { // 普通视频
                // 视频播放状态（1预告、2直播中、3回放 4:已结束、）
                if ([model.videoStatus isEqualToNumber:@1]) { // 预告
                    HMHVideoPreviewViewController *previewVC = [[HMHVideoPreviewViewController alloc] init];
                    previewVC.indexSelected = @0;
                    previewVC.videoNum = model.id;
                    [self.navigationController pushViewController:previewVC animated:YES];
                    
                } else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
                    HMHAliyunTimeShiftLiveViewController *timeVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                    timeVC.videoNum = model.id;
                    timeVC.indexSelected = @0;
                    [self.navigationController pushViewController:timeVC animated:YES];
                    
                } else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
                    HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                    liveVC.indexSelected = @0;
                    liveVC.videoNum = model.id; // 此时的id为视频的id

                    [self.navigationController pushViewController:liveVC animated:YES];
                } else { // 已结束
                }
            }
        }
    }
}

#pragma  mark - XLCycleScrollViewDataSource method
- (UIView *)loadingview:(XLCycleScrollView *)cycleView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cycleView.bounds.size.width, cycleView.bounds.size.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    imgv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    imgv.contentMode = UIViewContentModeScaleAspectFill;
    [imgv setImage:[UIImage imageNamed:@"noImage"]];
    [bgView addSubview:imgv];
    return bgView;
}

- (NSInteger)numberOfPages:(XLCycleScrollView *)cycleView{
    return _HMH_bannerArr.count;
}

- (UIView *)pageView:(XLCycleScrollView *)cycleView atIndex:(NSInteger)index frame:(CGRect)maxFrame
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, cycleView.bounds.size.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
//    imgv.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:imgv];
    
    //
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(10, imgv.frame.size.height - 40, imgv.frame.size.width - 20, 35)];
    desLab.textColor = [UIColor whiteColor];
    desLab.font = [UIFont boldSystemFontOfSize:16.0];
    [imgv addSubview:desLab];
    
    if (_HMH_bannerArr.count>index) {
        HMHVideoHomeBannerModel *banModel = _HMH_bannerArr[index];
        
        [imgv sd_setImageWithURL:[banModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@""]];
    }
//    desLab.text = [NSString stringWithFormat:@"测试测试测试测试测试测试  %ld",index];
    return bgView;
}
#pragma  mark-XLCycleScrollViewDelegate methodbanner点击跳转处理
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
//    NSLog(@"图片点击事件%ld",index);
    if (_HMH_bannerArr.count>index) {
        HMHVideoHomeBannerModel *model = _HMH_bannerArr[index];
        NSDictionary *paramsDic = model.params;
        NSString *typeStr = [NSString stringWithFormat:@"%@",paramsDic[@"sceneType"]];
        NSString *statusStr = [NSString stringWithFormat:@"%@",paramsDic[@"videoStatus"]];
        if ([model.tag isEqualToNumber:@1]) { // 浏览器
            HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
            pvc.urlStr = model.target;
            pvc.isPushFromVideoWeb = YES;
            pvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pvc animated:NO];
            return;
        }
        if ([typeStr isEqualToString:@"1"]) { // 短视频
            HMHShortVideoViewController *shortVC = [[HMHShortVideoViewController alloc] init];
            shortVC.videoNo = model.id;
            [self.navigationController pushViewController:shortVC         animated:YES];
        } else {  // 普通视频
            // 视频播放状态（1预告、2直播中、3已结束、4:回放）
            if ([statusStr isEqualToString:@"1"]) { // 预告
                HMHVideoPreviewViewController *preview = [[HMHVideoPreviewViewController alloc] init];
                preview.videoNum = model.id;
                preview.indexSelected = @0;
                [self.navigationController pushViewController:preview animated:YES];
                
            }  else if ([statusStr isEqualToString:@"2"]){ // 直播中
                HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.id;
                [self.navigationController pushViewController:liveVC animated:YES];
            }  else if ([statusStr isEqualToString:@"3"] || [statusStr isEqualToString:@"4"]){ // 回放 已结束
                HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.id;
                [self.navigationController pushViewController:liveVC animated:YES];
            }
        }
    }
}

#pragma mark 顶部多个按钮的点击事件
- (void)videoCategoryBtnClickToInfoWithIndex:(NSInteger)index{
    
    if (index == 1003){
        // 跳转分类
        HMHVideoCategoryViewController *categoryVC = [[HMHVideoCategoryViewController alloc] init];
        
        [self.navigationController pushViewController:categoryVC animated:YES];
    } else {
        // 0 最热   1 直播   2 预告 4 盗铃空间 5 合发购 6 全球家  7 OTO
        HMHVideosListViewController *listVC = [[HMHVideosListViewController alloc] init];
//        listVC.index = index - 1000;
        listVC.searchType = @"module";
        
        if (_HMH_moduleMenuArr.count > index - 1000) {
            HMHVideoHomeModuleMenuModel *model= _HMH_moduleMenuArr[index - 1000];
            listVC.searchValue = model.tag;
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

#pragma mark 查看全部按钮的点击事件
- (void)bottomToSeeAllVideoBtnClickWithSection:(NSInteger)sectionIndex{
    // 跳转一览列表
    // 编辑精选  为你推荐  短视频  查看全部都跳转一览列表页
    if (_HMH_sectionGriditemArr.count > sectionIndex) {
        HMHVideosListViewController *listVC = [[HMHVideosListViewController alloc] init];
        NSArray *arr = _HMH_sectionGriditemArr[sectionIndex];
        if (arr.count > 0) {
            HMHVideoHomeGriditemModel *model = arr[0];
            listVC.searchType = @"scene";
            listVC.searchValue = model.bottomTag;
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }
}

-(void)dealloc{
    if (_HMH_xlScrollView) {
        [_HMH_xlScrollView stopCycling];
        _HMH_xlScrollView.delegate = nil;
        _HMH_xlScrollView.datasource = nil;
        _HMH_xlScrollView=nil;
    }
}

#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName{
    [self.loadingView stopAnimating];
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf getPrcessdata:request.responseObject];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

- (void)getPrcessdata:(id)data{

//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"video.json" ofType:nil];
//
//    NSData *videoData = [[NSData alloc] initWithContentsOfFile:dataPath];
//
//    NSDictionary *videoDic = [NSJSONSerialization JSONObjectWithData:videoData options:0 error:nil];
//    NSDictionary *dataDic = videoDic[@"data"];
    
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];

    if (state == 1) {
        [_HMH_bannerArr removeAllObjects];
        [_HMH_moduleMenuArr removeAllObjects];
        [_HMH_sectionGriditemArr removeAllObjects];
        
        NSDictionary *dataDic = resDic[@"data"];
        NSArray *cardsArr = dataDic[@"cards"];
        if (cardsArr.count > 0) {
            NSDictionary *bannerDic = cardsArr[0];
            for (NSDictionary *cellDic in bannerDic[@"cells"]) {
                NSDictionary *cellData = cellDic[@"data"];
                if (cellData) {
                    HMHVideoHomeBannerModel *homeModel = [[HMHVideoHomeBannerModel alloc] init];
                    [homeModel setValuesForKeysWithDictionary:cellData];
                    [_HMH_bannerArr addObject:homeModel];
                }
            }
        }
        if (cardsArr.count > 1) {
            NSDictionary *moduleMenuDic = cardsArr[1];
            for (NSDictionary *cellsDic in moduleMenuDic[@"cells"]) {
                NSDictionary *mosuleDic = cellsDic[@"data"];
                if (mosuleDic) {
                    HMHVideoHomeModuleMenuModel *menuModel = [[HMHVideoHomeModuleMenuModel alloc] init];
                    [menuModel setValuesForKeysWithDictionary:mosuleDic];
                    [_HMH_moduleMenuArr addObject:menuModel];
                }
            }
        }
        if (!((cardsArr.count - 2) % 3)) {//剩余的count 是否能被3整除
            for (int i = 2; i < cardsArr.count; i++) {
                if (i == 2 || i == 5 || i == 8) {
                    NSMutableArray *griditemArr = [NSMutableArray arrayWithCapacity:1];
                    NSDictionary *titleDic = cardsArr[i];
                    NSString *titleStr;
                    for (NSDictionary *cellTitleDic in titleDic[@"cells"]) {
                        NSDictionary *titleDataDic = cellTitleDic[@"data"];
                        titleStr = titleDataDic[@"text"];
                    }
                    
                    NSDictionary *bottomDic = cardsArr[i+2];
                    NSString *bottomStr;
                    NSString *bottomTag;
                    for (NSDictionary *cellBottomDic in bottomDic[@"cells"]) {
                        NSDictionary *bottomDataDic = cellBottomDic[@"data"];
                        bottomStr = bottomDataDic[@"text"];
                        bottomTag = bottomDataDic[@"tag"];
                    }
                    
                    NSDictionary *gridDic = cardsArr[i+1];
                    for (NSDictionary *gridCellDic in gridDic[@"cells"]) {
                        NSDictionary *cellData = gridCellDic[@"data"];
                        if (cellData) {
                            HMHVideoHomeGriditemModel *model = [[HMHVideoHomeGriditemModel alloc] init];
                            [model setValuesForKeysWithDictionary:cellData];
                            model.titleText = titleStr;
                            model.bottomText = bottomStr;
                            model.bottomTag = bottomTag;
                            [griditemArr addObject:model];
                        }
                    }
                    [_HMH_sectionGriditemArr addObject:griditemArr];
                }
            }
        }
        if (_HMH_moduleMenuArr.count) {
            if (_HMH_centerView) {
                [_HMH_centerView removeFromSuperview];
                [_HMH_lineLab removeFromSuperview];
            }
            [self HMH_createCenterView];
        }
        [_HMH_xlScrollView reloadPages];
        
        [_collectionView reloadData];
        
        // 当头部的banner为空的时候 调整UI
        [self refreshHeaderView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    
    // 当collectionView的y坐标 小于-372时  进行数据请求 即刷新
    if(targetContentOffset->y < -372){
//        NSLog(@" ============= %f",targetContentOffset->y);
        [self HMH_refreshLoadData];
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
