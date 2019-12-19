//
//  HFYDDetialHeaderView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDDetialHeaderView.h"
#import "HFYDDetialViewModel.h"
#import "ZTGCDTimerManager.h"
#import "HFHeaderCell.h"
#import "HFYDDetialDataModel.h"
#import "HFAlertView.h"
@interface HFYDDetialHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UILabel *shopTitleLb;
@property(nonatomic,strong)UIButton *favriteBtn;
@property(nonatomic,strong)UILabel *expenditureLb;// 人均消费
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *loctionImgV;
@property(nonatomic,strong)UILabel *locationLb;
@property(nonatomic,strong)UIButton *telPhoneBtn;
@property(nonatomic,strong)UIButton *dingWeiBtn;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UILabel *distanceLb;
@property(nonatomic,strong)UIView *lineView3;
@property(nonatomic,strong)NSArray *dataArray;
@property (nonatomic,assign) BOOL autoScroll;
@property(nonatomic,strong)HFYDDetialTopDataModel *topModel;
@property(nonatomic,strong)AMapLocationManager *locationManger;


@end
@implementation HFYDDetialHeaderView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self addSubview:self.favriteBtn];
    [self addSubview:self.shopTitleLb];
    [self addSubview:self.expenditureLb];
    [self addSubview:self.lineView];
    [self addSubview:self.telPhoneBtn];
    [self addSubview:self.lineView2];
    [self addSubview:self.loctionImgV];
    [self addSubview:self.locationLb];
    [self addSubview:self.distanceLb];
    [self addSubview:self.dingWeiBtn];
    [self addSubview:self.lineView3];
   
}
- (void)hh_bindViewModel {
     [self doMessageRendering];
}
- (void)doMessageRendering {
    [self Fuvalue];
    @weakify(self)
    [self.viewModel.ydDataSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x && [x isKindOfClass:[HFYDDetialDataModel class]]) {
             HFYDDetialDataModel *model = (HFYDDetialDataModel*)x;
            self.topModel = model.shopsBaseInfo;
            self.shopTitleLb.text = model.shopsBaseInfo.shopsName;
            self.expenditureLb.text = [NSString stringWithFormat:@"人均消费 ¥%@",model.shopsBaseInfo.consumptionPerPerson];
            self.locationLb.text = model.shopsBaseInfo.address;
//            self.distanceLb.text = @"距您4.5km";
            self.collectionView.frame = CGRectMake(0, 0, ScreenW, 210);
            self.pageControl.frame = CGRectMake(0, 210-10-15, self.dataArray.count*(7+3), 20);
            self.favriteBtn.frame = CGRectMake(ScreenW-44-8, self.collectionView.bottom, 44, 44);
            self.favriteBtn.imageEdgeInsets =  UIEdgeInsetsMake(0, 0, 20, 0);
            self.favriteBtn.selected =model.shopsBaseInfo.hasConcerned;
            CGFloat height =   [HFUntilTool boundWithStr:model.shopsBaseInfo.shopsName blodfont:20 maxSize:CGSizeMake(ScreenW-15-44-10, 56)].height;
            self.shopTitleLb.frame = CGRectMake(15, self.collectionView.bottom, ScreenW-15-44-10,height);
            NSInteger badScore = 5-[model.shopsBaseInfo.star integerValue];
            CGFloat minX = 15;
            for (int i = 0; i < [model.shopsBaseInfo.star integerValue]; i++) {
                UIImageView *good = [[UIImageView alloc] initWithFrame:CGRectMake(minX, self.shopTitleLb.bottom+11, 10, 10)];
                good.image = [UIImage imageNamed:@"yd_score"];
                [self addSubview:good];
                good.tag = 100+i;
                minX = good.right+2;
            }
            for (int i = 0; i < badScore; i++) {
                UIImageView *bade = [[UIImageView alloc] initWithFrame:CGRectMake(minX, self.shopTitleLb.bottom+11, 10, 10)];
                bade.image = [UIImage imageNamed:@"yd_score_bad"];
                bade.tag = 105+i;
                [self addSubview:bade];
                minX = bade.right+2;
            }
            self.expenditureLb.frame = CGRectMake(minX, self.shopTitleLb.bottom+8, ScreenW-79-15, 16);
            self.lineView.frame = CGRectMake(15, self.expenditureLb.bottom+10, ScreenW-30, 0.5);
            self.telPhoneBtn.frame = CGRectMake(ScreenW-15-20, self.lineView.bottom+20, 20, 20);
            self.lineView2.frame = CGRectMake(self.telPhoneBtn.left-15-0.5, self.lineView.bottom+17, 0.5, 25);
            self.loctionImgV.frame = CGRectMake(15, self.lineView.bottom+10, 20, 20);
            self.locationLb.frame = CGRectMake(self.loctionImgV.right+8, self.lineView.bottom+10, ScreenW-self.loctionImgV.right-8-56,   [HFUntilTool boundWithStr:model.shopsBaseInfo.address font:16 maxSize:CGSizeMake(ScreenW-self.loctionImgV.right-8-56, 40)].height);
            self.distanceLb.frame = CGRectMake(self.loctionImgV.right+8, self.locationLb.bottom+5, ScreenW-self.loctionImgV.right-8-56, 18);
            self.dingWeiBtn.frame = CGRectMake(0, self.lineView.bottom, self.lineView2.left-10,( self.distanceLb.bottom- self.lineView.bottom)+10);
            self.lineView3.frame = CGRectMake(0, self.dingWeiBtn.bottom, ScreenW, 10);
            self.dataArray = model.shopsBaseInfo.shopImagesList;
            self.autoScroll = YES;
            self.pageControl.centerX = self.centerX;
            self.pageControl.numberOfPages = self.dataArray.count;
            self.pageControl.currentPage = 0;
            self.pageControl.hidden = !(self.dataArray.count>1);
            if (self.dataArray.count>1 ){
                [self setAutoScroll:self.autoScroll];
            }
            if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//                    [HFAlertView showAlertViewType:0 title:@"你尚未开启定位服务" detailString:@"建议您开启服务" cancelTitle:@"不开启" cancelBlock:^(HFAlertView *view) {
//                        
//                    } sureTitle:@"去开启" sureBlock:^(HFAlertView *view) {
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        if([[UIApplication sharedApplication] canOpenURL:url]) {
//                            [[UIApplication sharedApplication] openURL:url];
//                        }
//                    }];
                }else {
                    [self.locationManger requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                        if (!error) {
                            double f = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:[self.viewModel.detialModel.shopsBaseInfo.pointLat floatValue] longitude:[self.viewModel.detialModel.shopsBaseInfo.pointLng floatValue]]]/1000;
                            self.viewModel.usercoordinate =CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
                            self.distanceLb.text = [NSString stringWithFormat:@"距您%.01fkm",f];
                        }else {
                            self.distanceLb.text = @"获取失败";
                        }
                        
                    }];
                }

            }else {
                self.distanceLb.text = @"暂无详细距离";
                [MBProgressHUD showAutoMessage:@"网络已断开"];
            }
            [self.collectionView reloadData];
        }
       
    }];

    [[self.telPhoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)

        if (self.topModel.mobile != 0) {
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", [NSString stringWithFormat:@"%ld",self.topModel.mobile]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }else {
            [MBProgressHUD showAutoMessage:@"暂无电话"];
        }

    }];
    
    [[self.favriteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (![HFUserDataTools isLogin]) {
            [self.viewModel.loginSubjc sendNext:nil];
        }else {
            self.viewModel.isFollow = self.favriteBtn.selected;
            [self.viewModel.ydfollowCommand execute:nil];
        }
        
    }];
    [[self.dingWeiBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.enterMapSubjc sendNext:nil];
    }];
    [self.viewModel.ydfollowSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSString class]] &&x) {
            if ([x integerValue] == 1) {
                [MBProgressHUD showAutoMessage:@"关注成功"];
            }else {
                [MBProgressHUD showAutoMessage:@"取关成功"];
            }
        }else {
            [MBProgressHUD showAutoMessage:@"关注失败"];
        }
    }];


}
- (void)Fuvalue {

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count >1){
        return self.dataArray.count*1000;
    }else {
        return self.dataArray.count;
    }

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HFHeaderCell" forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
//    cell.imageView.image = [UIImage imageNamed:self.dataArray[itemIndex]];
    
    HFYDImagModel *model = self.dataArray[itemIndex];
    cell.model = model;
    [cell domessageData];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
//    HFBrowserModel *model = self.browserModel.dataArray[itemIndex];
//    if (self.didBrowserBlock) {
//        self.didBrowserBlock(model);
//    }
}
#pragma mark - UIScrollViewDelegate
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.dataArray.count;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.dataArray.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    //    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (!self.dataArray.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
}
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    if (_autoScroll&&self.dataArray.count > 1) {
        [self setupTimer];
    }
    
}


- (void)setupTimer {
    [self invalidateTimer];
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:NSStringFromClass([HFYDDetialHeaderView class]) interval:2 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        if (0 == self.dataArray.count*1000) return;
        int currentIndex = [self currentIndex];
        int targetIndex = currentIndex + 1;
        [self scrollToIndex:targetIndex];
    }];
}
- (void)invalidateTimer {
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:NSStringFromClass([HFYDDetialHeaderView class])];
}

- (int)currentIndex
{
    if (self.collectionView.width == 0 || self.collectionView.height == 0) {
        return 0;
    }
    int   index = (self.collectionView.contentOffset.x + ScreenW * 0.5) / ScreenW;
    
    
    return MAX(0, index);
}
- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= self.dataArray.count*1000) {
        
        targetIndex = self.dataArray.count*1000 * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}
- (UIButton *)dingWeiBtn {
    if (!_dingWeiBtn) {
        _dingWeiBtn = [[UIButton alloc] init];
    }
    return _dingWeiBtn;
}
- (UIButton *)telPhoneBtn {
    if (!_telPhoneBtn) {
        _telPhoneBtn = [HFUIkit image:@"yd_Bitmap" selectImage:@""];
    }
    return _telPhoneBtn;
}
- (UILabel *)distanceLb {
    if (!_distanceLb) {
        _distanceLb = [HFUIkit textColor:@"999999" font:13 numberOfLines:1];
    }
    return _distanceLb;
}
- (UILabel *)locationLb {
    if (!_locationLb) {
        _locationLb = [HFUIkit textColor:@"333333" font:16 numberOfLines:1];
    }
    return _locationLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView;
}
- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _lineView3;
}
- (UIImageView *)loctionImgV {
    if(!_loctionImgV) {
        _loctionImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd_location_light"]];
    }
    return _loctionImgV;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView2;
}
- (UIButton *)favriteBtn {
    if (!_favriteBtn) {
        _favriteBtn = [HFUIkit image:@"yd_like_none" selectImage:@"yd_like"];
    }
    return _favriteBtn;
}
- (UILabel *)expenditureLb {
    if (!_expenditureLb) {
        _expenditureLb = [HFUIkit textColor:@"494949" font:12 numberOfLines:1];
    }
    return _expenditureLb;
}
- (UILabel *)shopTitleLb {
    if (!_shopTitleLb) {
        _shopTitleLb = [HFUIkit textColor:@"333333" blodfont:20 numberOfLines:2];
    }
    return _shopTitleLb;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [HFUIkit minimumLineSpacing:0 minimumInteritemSpacing:0 scrollDirection:UICollectionViewScrollDirectionHorizontal sectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSize:CGSizeMake(ScreenW,210) backgroundColor:[UIColor whiteColor] delegate:self frame:CGRectMake(0, 0, ScreenW, 210)];
        [_collectionView registerClass:[HFHeaderCell class] forCellWithReuseIdentifier:@"HFHeaderCell"];
    }
    return _collectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [HFUIkit pageIndicatorTintColor:@"ffffff" currentPageIndicatorTintColor:@"F3344A"];
        _pageControl.userInteractionEnabled = NO;
    
    }
    return _pageControl;
}
- (AMapLocationManager *)locationManger {
    if (!_locationManger) {
        _locationManger = [[AMapLocationManager alloc] init];
        [_locationManger setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManger.locationTimeout =5;
        //   逆地理请求超时时间，最低2s，此处设置为2s
       _locationManger.reGeocodeTimeout = 5;
    }
    return _locationManger;
}
@end
