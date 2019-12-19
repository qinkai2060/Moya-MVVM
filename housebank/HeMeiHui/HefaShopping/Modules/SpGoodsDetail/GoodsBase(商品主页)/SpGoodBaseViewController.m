//
//  SpGoodBaseViewController.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpGoodBaseViewController.h"
#import "SpGoodParticularsViewController.h"
#import "SpDetailShufflingHeadView.h"
#import "SpDeatilCustomHeadView.h"
#import "SpDetailOverFooterView.h"
#import "SpDetailGoodReferralCell.h"
#import "SpFeatureItemCell.h"
#import "SpParameterCell.h"
#import "SpProductReviewCell.h"
#import "SpStoreInformationCell.h"
#import "SpaceLineCell.h"
#import "ZJJTimeCountDown.h"
#import "ZJJTimeCountDownDateTool.h"
#import "CustomVipSelectTableView.h"
#import "CustumDiscountCouponSelectView.h"
#import "CustomInputMoneyView.h"
#import "CutomVipShareView.h"
#import "HFLoginViewController.h"
//#import "WRNavigationBar.h"
#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64
#define  SpikeTimerheight 55
@interface SpGoodBaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,ZJJTimeCountDownDelegate>


@property (nonatomic ,strong) ZJJTimeCountDownLabel *twoTimeLabel;
@property (nonatomic ,strong) ZJJTimeCountDown *countDown;
@property (nonatomic ,strong)UILabel *timeLable1;//天
@property (nonatomic ,strong)UILabel *timeLable2;//时
@property (nonatomic ,strong)UILabel *timeLable3;//分
@property (nonatomic ,strong)UILabel *timeLable4;//秒
/* 商品现价 */
@property (strong , nonatomic)UILabel *currentPriceLabel;
/* 商品原价 */
@property (strong , nonatomic)UILabel *originalPriceLabel;

@property (strong , nonatomic) SpDetailOverFooterView *spfooterView;

@property (assign , nonatomic)CGRect cellInCollection;


@end
//header
static NSString *DCDetailShufflingHeadViewID = @"DCDetailShufflingHeadView";
static NSString *DCDeatilCustomHeadViewID = @"DCDeatilCustomHeadView";
//cell
static NSString *DCDetailGoodReferralCellID = @"DCDetailGoodReferralCell";
static NSString *SpFeatureItemCellID = @"SpFeatureItemCell";
static NSString *SpProductReviewCellID = @"SpProductReviewCell";
static NSString *SpStoreInformationCellID = @"SpStoreInformationCell";
static NSString *SpParameterCellID=@"SpParameterCell";
static NSString *SpaceLineCellID=@"SpaceLineCell";


//footer
static NSString *DCDetailOverFooterViewID = @"DCDetailOverFooterView";
@implementation SpGoodBaseViewController
#pragma mark - LazyLoad

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0; //Y
        layout.minimumInteritemSpacing = 0; //X
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        if (@available(iOS 11.0, *)) {
            //      iOS11 UICollectionView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UICollectionView的自动调整功能为状态栏留出的位置
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, ScreenW, ScreenH-TabBarHeight);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop=YES;
        [self.view  addSubview:_collectionView];
        
        //注册header
        [_collectionView registerClass:[SpDetailShufflingHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDetailShufflingHeadViewID];
        [_collectionView registerClass:[SpDeatilCustomHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDeatilCustomHeadViewID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SeckillHeadViewID"];
        //注册Cell
        [_collectionView registerClass:[SpDetailGoodReferralCell class] forCellWithReuseIdentifier:DCDetailGoodReferralCellID];
        [_collectionView registerClass:[SpFeatureItemCell class] forCellWithReuseIdentifier:SpFeatureItemCellID];
        [_collectionView registerClass:[SpParameterCell class] forCellWithReuseIdentifier:SpParameterCellID];
        [_collectionView registerClass:[SpProductReviewCell class] forCellWithReuseIdentifier:SpProductReviewCellID];
        [_collectionView registerClass:[SpStoreInformationCell class] forCellWithReuseIdentifier:SpStoreInformationCellID];
        [_collectionView registerClass:[SpaceLineCell class] forCellWithReuseIdentifier:SpaceLineCellID];
        
        //注册Footer
        [_collectionView registerClass:[SpDetailOverFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCDetailOverFooterViewID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //间隔
        
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
//    [self setUpViewScroller];
    [self setUpSpGoodParticularsVC];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
    //  自动滚动调整，默认为YES
    self.automaticallyAdjustsScrollViewInsets = NO;
    //  指定边缘要延伸的方向
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //      iOS11 UIScrollView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UIScrollView的自动调整功能为状态栏留出的位置
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.lastcontentOffset = scrollView.contentOffset.y;
    if([scrollView isMemberOfClass:[UICollectionView class]])
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        [self.Delegate resetThirdNavBar:offsetY];
    }
//    if (scrollView == _collectionView) {
//        CGFloat offsetY = scrollView.contentOffset.y;
//        NSLog(@"%.2f", ([self collectionViewContentSizeHeight] - (ScreenH - KTopHeight - TabBarHeight) - IPHONEX_SAFE_AREA_TOP_HEIGHT_88));
//        if (offsetY >= [self collectionViewContentSizeHeight] - (ScreenH - KTopHeight - TabBarHeight) - IPHONEX_SAFE_AREA_TOP_HEIGHT_88) {
//            _collectionView.scrollEnabled = NO;
//            _collectionView.bounces = NO;
//            [self.spfooterView.webView.scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
//            self.spfooterView.webView.scrollView.scrollEnabled = YES;
//        } else {
//            _collectionView.bounces = YES;
//            _collectionView.scrollEnabled = YES;
//            self.spfooterView.webView.scrollView.scrollEnabled = NO;
//        }
//    }
    
    

        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        UICollectionViewCell * item = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (self.cellInCollection.origin.y == 0) {
            self.cellInCollection = [self.collectionView convertRect:item.frame toView:self.collectionView];
        }
        if (self.cellInCollection.origin.y > 0) {
            if (scrollView.contentOffset.y < self.cellInCollection.origin.y - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 5) {
                NSLog(@"商品");
                if (self.offSetBlock) {
                    self.offSetBlock(OffSetStyleGood);
                }

            } else if (scrollView.contentOffset.y >= [self collectionViewContentSizeHeight] - self.wkwebviewHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 1){
                 NSLog(@"详情");
                if (self.offSetBlock) {

                self.offSetBlock(OffSetStyledDetail);
                }
            } else {
                NSLog(@"评价");
                if (self.offSetBlock) {

                self.offSetBlock(OffSetStyleComment);
                }
            }
        }
    
    
    
   

    
   
    
    
}

- (CGFloat)collectionViewContentSizeHeight{
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;

}
#pragma mark - initialize
- (void)setUpInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.scrollerView.backgroundColor=[UIColor whiteColor];
    self.collectionView.backgroundColor =[UIColor whiteColor];
    _shufflingArray=[NSArray arrayWithObjects:@"product_1",@"product_2",@"product_4", nil];
    
}
- (void)setUpSpGoodParticularsVC
{
//    self.SpGoodParticularsVC=[[SpGoodParticularsViewController alloc]init];
//    self.SpGoodParticularsVC.detailModel=self.detailModel;
//    self.SpGoodParticularsVC.isChangFlag=YES;
//    self.SpGoodParticularsVC.spGoodBaseVC=self;
//    self.SpGoodParticularsVC.view.frame = CGRectMake(0,ScreenH , ScreenW, self.view.bounds.size.height);
//    [self.scrollerView addSubview:self.SpGoodParticularsVC.view];
//    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //   section 0商品详情  轮播器header+cell+分割foot
    //   section 1规格\参数  cell+分割foot
    //   section 2评价 header+cell  分割foot
    //   section 3店铺
    
    return 4;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //     return (section == 1 ) ?3 : 1;
    return (section == 1 ) ? 1 : 1;
    
}
- (void)cellClickAvtionType:(GoodsDetailClickType)clickType{
    switch (clickType) {
        case GoodsDetailClickTypeGiveProfit://返利
                [CustomVipSelectTableView CustomVipSelectTableViewIn:[UIApplication sharedApplication].keyWindow arrDate:self.detailModel.data.product.vipRebateInfo.rebateInfos viewType:(CustomVipSelectTableViewTypeTreturnoOnProfit) sureblock:^{
            
                } closeblock:^{
            
                }];
            
            break;
        case GoodsDetailClickTypeWholesale://批发可享
            [CustomVipSelectTableView CustomVipSelectTableViewIn:[UIApplication sharedApplication].keyWindow arrDate:self.detailModel.data.product.vipProduct.priceInfos viewType:(CustomVipSelectTableViewTypeBuyWholesale) sureblock:^{
                
            } closeblock:^{
                
            }];
            break;
        case  GoodsDetailClickTypeGetCoupon://领取优惠券
        {
                [CustumDiscountCouponSelectView CustumDiscountCouponSelectViewIn:[UIApplication sharedApplication].keyWindow closeblock:^{
            
                } isNoLoginBlock:^{
                    [HFLoginViewController showViewController:self];
                }];
        }
            
            break;
            
            
        default:
            break;
    }
    
    
    
    
    
    
    
   
    
    
}
#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    switch (indexPath.section) {
        case 0:
        {
            SpDetailGoodReferralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCDetailGoodReferralCellID forIndexPath:indexPath];
            cell.productInfo=self.detailModel.data.product;
            cell.spaceTime=self.spaceTime;
            cell.code=self.code;
            cell.skuItemPrice=self.skuItemPrice;
            cell.skuItemIntrinsicPrice=self.skuItemIntrinsicPrice;
            gridcell = cell;
            [cell reSetVDataValue:self.detailModel.data.product allData:self.detailModel];
            WEAKSELF
            cell.clickBlock = ^(GoodsDetailClickType clickType) {
                [weakSelf cellClickAvtionType:clickType];
            };
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    SpFeatureItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpFeatureItemCellID forIndexPath:indexPath];
                    gridcell = cell;
                    if (self.code) {
                        [cell reSetSelectedData:self.code];
                    }else
                    {
                        [cell reSetSelectedData:self.detailModel.data.product.code];
                    }
                    if (self.featureModel.data.rsMap.productTtributesMap.seriesAttributes==nil||self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count==0) {//规格为空
                        cell.hidden = YES;
                    } else {
                        cell.hidden = NO;
                    }
                    
                }
                    //                break;
                    //                case 1:
                    //                {
                    //                    SpaceLineCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpaceLineCellID forIndexPath:indexPath];
                    //                    cell.backgroundColor=HEXCOLOR(0xF5F5F5);
                    //                    gridcell = cell;
                    //                }
                    //                break;
                    //                case 2:
                    //                {
                    //                    SpParameterCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpParameterCellID forIndexPath:indexPath];
                    //                    gridcell = cell;
                    //                }
                    //                break;
                    //
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            
            SpProductReviewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpProductReviewCellID forIndexPath:indexPath];
            cell.commentList=self.commentList;
            [cell reSetVDataValue:self.commentList];
            gridcell = cell;
        }
            break;
        case 3:
        {
            
            SpStoreInformationCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpStoreInformationCellID forIndexPath:indexPath];
            cell.productInfo=self.detailModel;
            [cell reSetVDataValue:self.detailModel];
            gridcell = cell;
            if (self.goodsBaseStyle == DirectSupplyGoodsBaseDetailStyle && self.isVipGiftPackage == NO) {
                gridcell.hidden = YES;
            } else {
                gridcell.hidden = NO;
            }
        }
            break;
            
        default:
            break;
    }
    return gridcell;
}
//设置各个区的头部尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            SpDetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDetailShufflingHeadViewID forIndexPath:indexPath];
            NSMutableArray *picList=[NSMutableArray new];
            if (self.detailModel.data.product.productPics.count>0) {
                for (int i=0; i<self.detailModel.data.product.productPics.count; i++) {
                    ProductPicsItem *PicsItem= [self.detailModel.data.product.productPics objectAtIndex:i];
                   
                    
                    [picList addObject:[PicsItem.address get_sharImage]];
                }
            }
            headerView.shufflingArray = picList;
            if (self.goodsBaseStyle==PromotionGoodsBaseDetailStyle||self.goodsBaseStyle==SpikeGoodsBaseDetailStyle) {
                
                if (self.detailModel.data.seckillInfo.noticeActivityStart) {//预告
                    [_spikeTimerView  removeFromSuperview];
                    _spikeTimerView= [self creatSpikeTimerView];
                    [headerView  addSubview: _spikeTimerView];
                    _spikeTimerView.hidden=NO;
                }else
                {
                    if (self.detailModel.data.seckillInfo.isSeckill==1) {//秒杀中
                        [_spikeTimerView  removeFromSuperview];
                        _spikeTimerView= [self creatSpikeTimerView];
                        [headerView  addSubview: _spikeTimerView];
                        _spikeTimerView.hidden=NO;
                    }else
                    {
                        //促销
                        if ([self.spaceTime integerValue]>0) {
                            [_spikeTimerView  removeFromSuperview];
                            _spikeTimerView= [self creatSpikeTimerView];
                            [headerView  addSubview: _spikeTimerView];
                            _spikeTimerView.hidden=NO;
                            
                        }else
                        {//普通商品
                            _spikeTimerView.hidden=YES;
                            [_spikeTimerView  removeFromSuperview];
                        }
                    }
                }
                
            }
            
            reusableview = headerView;
        }else if (indexPath.section == 1) {
            
            if (self.detailModel.data.seckillInfo.isSeckill==1) {//秒杀中
                
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SeckillHeadViewID" forIndexPath:indexPath];
                
                
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 80, 20)];
                headerView.backgroundColor=[UIColor whiteColor];
                imageView.image=[UIImage imageNamed:@"Group20"];
                [headerView addSubview:imageView];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 12, ScreenW-40-imageView.width, 20)];
                lable.text=@"限时限量 疯狂抢购";
                lable.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
                lable.textColor=HEXCOLOR(0xF3344A);
                [headerView addSubview:lable];
                UILabel *lineLable=[[UILabel alloc]initWithFrame:CGRectMake(0, headerView.height-1, ScreenW, 1)];
                lineLable.backgroundColor=HEXCOLOR(0xF5F5F5);
                [headerView  addSubview:lineLable];
                reusableview = headerView;
            }
        }
    }else if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == 3) {
            SpDetailOverFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCDetailOverFooterViewID forIndexPath:indexPath];
            footerView.detailModel = self.detailModel;
            WEAKSELF

            footerView.wkWebViewScrollViewFinshBlock = ^(CGFloat height) {
                weakSelf.wkwebviewHeight = height;
                weakSelf.isFirstRefrenshWeb = YES;
                [weakSelf.collectionView reloadData];
            };
            reusableview = footerView;
            self.spfooterView = footerView;
        } 
        else{
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
            footerView.backgroundColor = DCBGColor;
            reusableview = footerView;
        }
    }
    return reusableview;
    
    
}
//设置促销秒杀时间
-(UIImageView *)creatSpikeTimerView
{
    UIImageView *spikeTimerView;
    //现价
    /* 商品现价 */
    
    _currentPriceLabel= [[UILabel alloc] initWithFrame:CGRectZero];
    //    CGRectMake(10, 7, 100, 40)
    _currentPriceLabel.font = [UIFont systemFontOfSize:16.0];
    _currentPriceLabel.text=@"¥89.10";
    
    /* 商品原价 */
    _originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _originalPriceLabel.font = [UIFont systemFontOfSize:10.0];
    _originalPriceLabel.text=@"¥150";
    
    if (self.detailModel.data.seckillInfo.noticeActivityStart) {//秒杀预告
        spikeTimerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenW, ScreenW, SpikeTimerheight+10)];
        spikeTimerView.backgroundColor=[UIColor whiteColor];
        _currentPriceLabel.textColor = HEXCOLOR(0xF3344A);
        _originalPriceLabel.textColor=HEXCOLOR(0x666666);
        [self setSpikeForecast:spikeTimerView];
    }else if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
    {
        spikeTimerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenW, ScreenW, SpikeTimerheight)];
        spikeTimerView.image=[UIImage imageNamed:@"商品详情-拼团bg"];
        _currentPriceLabel.textColor = HEXCOLOR(0xFFFFFF);
        _originalPriceLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
        //    添加倒计时
        self.countDown.timeStyle = ZJJCountDownTimeStyleTamp;
        self.countDown.delegate = self;
        [self setupTwoTimeLabelP:spikeTimerView];
        [self.countDown addTimeLabel:self.twoTimeLabel time:[ZJJTimeCountDownDateTool dateByAddingSeconds:self.spaceTime timeStyle:self.countDown.timeStyle]];
        
    }else
    {//促销商品
        spikeTimerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenW, ScreenW, SpikeTimerheight)];
        spikeTimerView.image=[UIImage imageNamed:@"商品详情-拼团bg"];
        _currentPriceLabel.textColor = HEXCOLOR(0xFFFFFF);
        _originalPriceLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
        //    添加倒计时
        self.countDown.timeStyle = ZJJCountDownTimeStyleTamp;
        self.countDown.delegate = self;
        [self setupTwoTimeLabelP:spikeTimerView];
        if ([self.starSpaceTime integerValue]>0) {
//            促销未开始,距离开始促销
             [self.countDown addTimeLabel:self.twoTimeLabel time:[ZJJTimeCountDownDateTool dateByAddingSeconds:self.starSpaceTime timeStyle:self.countDown.timeStyle]];
        }else
        {//促销中,距离结束时间
            [self.countDown addTimeLabel:self.twoTimeLabel time:[ZJJTimeCountDownDateTool dateByAddingSeconds:self.spaceTime timeStyle:self.countDown.timeStyle]];
        }
        
        
    }
    //           促销秒杀专用
    [spikeTimerView addSubview:_currentPriceLabel];
    [spikeTimerView addSubview:_originalPriceLabel];
    [self reSetVDataValue:self.detailModel.data.product allData:self.detailModel spikeTimerView:spikeTimerView];
    
    
    
    return spikeTimerView;
    
}
//设置秒杀预告
-(void)setSpikeForecast:(UIImageView*)spikeTimerView
{
    UIImageView *forecastImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, spikeTimerView.height-2-18, 72, 18)];
    forecastImageView.image=[UIImage imageNamed:@"SpikeForecast"];
    [spikeTimerView addSubview:forecastImageView];
    
    UILabel *dateLable=[[UILabel alloc]initWithFrame:CGRectMake(forecastImageView.right+10, spikeTimerView.height-2-18, ScreenW-30-10-forecastImageView.width, 18)];
    dateLable.textColor=HEXCOLOR(0xF3344A);
    NSDate * ForecastDay=[MyUtil timestampToDate:self.detailModel.data.seckillInfo.noticeActivityStart];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    //     NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    //    @"yyyy年MM月dd日 HH:mm:ss"
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:ForecastDay];
    dateLable.text=[NSString stringWithFormat:@"%@开始秒杀",strDate];
    [spikeTimerView addSubview:dateLable];
    
}
//设置价钱
-(void)reSetVDataValue:(Product*)productInfo  allData:(GoodsDetailModel*)goodDetail spikeTimerView:(UIImageView*)spikeTimerView
{
    self.skuItemPrice; self.skuItemIntrinsicPrice;
    
    if (![self.code isEqualToString:@""]&&self.code) {
        if (self.skuItemIntrinsicPrice&&[self.skuItemIntrinsicPrice integerValue]!=0&&![self.skuItemIntrinsicPrice isEqualToString:@""]&&![self.skuItemIntrinsicPrice isEqualToString:self.skuItemPrice]) {
            _originalPriceLabel.hidden=NO;
        }else
        {
            _originalPriceLabel.hidden=YES;
        }
        if (self.detailModel.data.seckillInfo.noticeActivityStart)//预告
        {
            NSString *str =[HFUntilTool thousandsFload:[self.skuItemPrice floatValue]];
            NSRange range = [str rangeOfString:@"."];//匹配得到的下标
            _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xF3344A) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
            NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:[self.skuItemIntrinsicPrice floatValue]]] lineColor:HEXCOLOR(0x666666)];
            _originalPriceLabel.attributedText=setLineStr;
            CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 24)];
            CGSize size2 = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 12)];
            _currentPriceLabel.frame=CGRectMake(15, 10, size.width, 24);
            _originalPriceLabel.frame=CGRectMake(15+size.width+2, 23, size2.width, 12);
            
        }else if(self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
        {
            NSString *str =[HFUntilTool thousandsFload:[self.skuItemPrice floatValue]];
            NSRange range = [str rangeOfString:@"."];//匹配得到的下标
            _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xFFFFFF) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
            NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:[self.skuItemIntrinsicPrice floatValue]]] lineColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
            _originalPriceLabel.attributedText=setLineStr;
            CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 24)];
            CGSize size2 = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 12)];
            _currentPriceLabel.frame=CGRectMake(15, spikeTimerView.height-6-24, size.width, 24);
            _originalPriceLabel.frame=CGRectMake(15, 6, size2.width, 12);
        }else
        {
            NSString *str =[HFUntilTool thousandsFload:[self.skuItemPrice floatValue]];
            NSRange range = [str rangeOfString:@"."];//匹配得到的下标
            _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xFFFFFF) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
            NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:[self.skuItemIntrinsicPrice floatValue]]] lineColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
            _originalPriceLabel.attributedText=setLineStr;
            CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 24)];
            CGSize size2 = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 12)];
            _currentPriceLabel.frame=CGRectMake(15, 15, size.width, 24);
            _originalPriceLabel.frame=CGRectMake(15+size.width+2, 28, size2.width, 12);
        }
        
        
    }else
    {
        if(productInfo.intrinsicPrice&&productInfo.intrinsicPrice>0&&![[NSString stringWithFormat:@"%f",productInfo.intrinsicPrice] isEqualToString:[NSString stringWithFormat:@"%f",productInfo.price]]) {
            _originalPriceLabel.hidden=NO;
        }else
        {
            _originalPriceLabel.hidden=YES;
        }
        if (self.detailModel.data.seckillInfo.noticeActivityStart)//预告
        {
            NSString *str =[HFUntilTool thousandsFload:productInfo.price];
            NSRange range = [str rangeOfString:@"."];//匹配得到的下标
            _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xF3344A) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
            NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:productInfo.intrinsicPrice]] lineColor:HEXCOLOR(0x666666)];
            _originalPriceLabel.attributedText=setLineStr;
            CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 24)];
            CGSize size2 = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 12)];
            _currentPriceLabel.frame=CGRectMake(15, 10, size.width, 24);
            _originalPriceLabel.frame=CGRectMake(15+size.width+2, 23, size2.width, 12);
        }else if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
        {
            NSString *str =[HFUntilTool thousandsFload:productInfo.price];
            NSRange range = [str rangeOfString:@"."];//匹配得到的下标
            _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xFFFFFF) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
            NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:productInfo.intrinsicPrice]] lineColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
            _originalPriceLabel.attributedText=setLineStr;
            CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 24)];
            CGSize size2 = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 12)];
            _currentPriceLabel.frame=CGRectMake(15, spikeTimerView.height-6-24, size.width, 24);
            _originalPriceLabel.frame=CGRectMake(15, 6, size2.width, 12);
        }else
        {
            
            NSString *str =[HFUntilTool thousandsFload:productInfo.price];
            NSRange range = [str rangeOfString:@"."];//匹配得到的下标
            _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xFFFFFF) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
            NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:productInfo.intrinsicPrice]] lineColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
            _originalPriceLabel.attributedText=setLineStr;
            CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 24)];
            CGSize size2 = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 12)];
            _currentPriceLabel.frame=CGRectMake(15, 15, size.width, 24);
            _originalPriceLabel.frame=CGRectMake(15+size.width+2, 28, size2.width, 12);
        }
        
    }
    
    
}
//设置倒计时
- (void)setupTwoTimeLabelP:(UIImageView*)spikeTimerView{
    CGFloat height=18;
    if (self.detailModel.data.seckillInfo.isSeckill==1) {//秒杀中
        height=8;
        //        CGSize size = [_currentPriceLabel sizeThatFits:CGSizeMake(ScreenW/2, 11)];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(ScreenW-10-50,spikeTimerView.height-6-15 ,50 , 0)];
        lable.textColor=HEXCOLOR(0xFFFFFF);
        lable.font=[UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        lable.text=[NSString stringWithFormat:@"已抢%ld件",(long)self.detailModel.data.seckillInfo.purchasedQuantity];
        [lable sizeToFit];
        lable.right=ScreenW-10;
        [spikeTimerView addSubview:lable];
        self.progressView = [[SptimeKillProgressView alloc] initWithFrame:CGRectMake(lable.left-10-120, spikeTimerView.height-8-12,  120, 12)];
        self.progressView.gradientLayer.colors =    @[(id)HEXCOLOR(0xFFFF00).CGColor,(id)HEXCOLOR(0xFFFF00).CGColor];
        [spikeTimerView addSubview:self.progressView];
        self.progressView.progress = self.detailModel.data.seckillInfo.purchasedQuantity/(self.detailModel.data.seckillInfo.stock*1.00);
        CGFloat progress = self.detailModel.data.seckillInfo.purchasedQuantity/(self.detailModel.data.seckillInfo.stock*1.00)*100;
        if(progress < 1 &&progress >0 ) {
            progress = 1;
        }
        if (progress>=99 && progress<100) {
            progress = 99;
        }
        self.progressView.stateLb.text = [NSString stringWithFormat:@"已抢%.f%%",floor(progress)];
        self.progressView.stateLb.textColor=HEXCOLOR(0xF3344A);
        
        //        self.progressView.percentageLb.text = [NSString stringWithFormat:@"%.f%%",progress];
    }else
    {
        height=18;
    }
    //    隐藏计数字
    self.twoTimeLabel=[[ZJJTimeCountDownLabel alloc]initWithFrame:CGRectMake(190, height, 175, 0)];
    [spikeTimerView addSubview:self.twoTimeLabel];
    //自定义模式，
    self.twoTimeLabel.textStyle = ZJJTextStlyeCustom;
    //设置水平方向居中
    self.twoTimeLabel.jj_textAlignment = ZJJTextAlignmentStlyeHorizontalCenter;
    //设置偏左距离
    self.twoTimeLabel.textLeftDeviation = 0;
    //过时后保留最终的样式
    self.twoTimeLabel.isRetainFinalValue = YES;
    //整体背景图片
    //    self.twoTimeLabel.backgroundImage = [UIImage imageNamed:@"timeBackground2"];
    //   显示展示倒计时
    self.TimeView=[[UIView alloc]initWithFrame:CGRectMake(ScreenW-172-10, height, 172, 20)];
    self.TimeView.backgroundColor=[UIColor clearColor];
    [spikeTimerView  addSubview:self.TimeView];
    
    self.lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 20)];
    if ([self.starSpaceTime integerValue]>0) {
        self.lable1.frame=CGRectMake(-25, 0, 50, 20);
        self.lable1.text=@"距离开始";
       
    }else
    {
        self.lable1.frame=CGRectMake(0, 0, 25, 20);
         self.lable1.text=@"剩余";
    }
   
    self.lable1.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.lable1.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:self.lable1];
    //   天
    _timeLable1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lable1.frame)+5,0 , 20, 20)];
    _timeLable1.text=@"";
    _timeLable1.backgroundColor=HEXCOLOR(0x323232);
    _timeLable1.layer.cornerRadius = _timeLable1.height/2;
    _timeLable1.layer.masksToBounds = YES;
    _timeLable1.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _timeLable1.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:_timeLable1];
    
    self.lable2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLable1.frame)+2, 0, 12, 20)];
    self.lable2.text=@"天";
    self.lable2.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.lable2.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:self.lable2];
    //    时
    _timeLable2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lable2.frame)+2,0 , 20, 20)];
    _timeLable2.text=@"";
    _timeLable2.backgroundColor=HEXCOLOR(0x323232);
    _timeLable2.layer.cornerRadius = _timeLable2.height/2;
    _timeLable2.layer.masksToBounds = YES;
    _timeLable2.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _timeLable2.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:_timeLable2];
    
    self.lable3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLable2.frame)+2, 0, 12, 20)];
    self.lable3.text=@"时";
    self.lable3.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.lable3.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:self.lable3];
    //    分
    _timeLable3=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.lable3.frame)+2,0, 20, 20)];
    _timeLable3.text=@"";
    _timeLable3.backgroundColor=HEXCOLOR(0x323232);
    _timeLable3.layer.cornerRadius = _timeLable3.height/2;
    _timeLable3.layer.masksToBounds = YES;
    _timeLable3.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _timeLable3.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:_timeLable3];
    
    self.lable4=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLable3.frame)+2,0 , 12, 20)];
    self.lable4.text=@"分";
    self.lable4.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.lable4.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:self.lable4];
    //    秒
    _timeLable4=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lable4.frame)+2,0 , 20, 20)];
    _timeLable4.text=@"";
    _timeLable4.backgroundColor=HEXCOLOR(0x323232);
    _timeLable4.layer.cornerRadius = _timeLable4.height/2;
    _timeLable4.layer.masksToBounds = YES;
    _timeLable4.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _timeLable4.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:_timeLable4];
    
    self.lable5=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLable4.frame)+2,0 , 12, 20)];
    self.lable5.text=@"秒";
    self.lable5.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.lable5.textColor=[UIColor whiteColor];
    [self.TimeView addSubview:self.lable5];
    
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //商品详情
        
        CGFloat titleheight= [MyUtil getHeightWithFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold] with:ScreenW-30 text:self.detailModel.data.product.title];
        CGFloat subTitleheight= [MyUtil getHeightWithFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] with:ScreenW-30 text:self.detailModel.data.product.productSubtitle];
        if (self.detailModel.data.seckillInfo.noticeActivityStart!=0&&self.detailModel.data.seckillInfo.noticeActivityStart) {//预告
            return CGSizeMake(ScreenW, 100-45+titleheight+subTitleheight);
        }else if (self.detailModel.data.seckillInfo.isSeckill)//秒杀中
        {
            return CGSizeMake(ScreenW, 100-45+titleheight+subTitleheight);
        }else
        {
            if ([self.spaceTime integerValue]>0) {
                return CGSizeMake(ScreenW, 100-45+titleheight+subTitleheight);
            } else {
                CGFloat heiget =  100+titleheight+subTitleheight;
                if (self.detailModel.data.product.vipRebateInfo && self.detailModel.data.product.vipRebateInfo.rebate && self.detailModel.data.product.vipRebateInfo.vipLevel &&
                    self.detailModel.data.product.vipRebateInfo.rebate > 0 ) {
                    //返利
                    
                    if (CHECK_STRING_ISNULL(self.detailModel.data.product.productSubtitle) || [self.detailModel.data.product.productSubtitle isEqualToString:@""]) {
                        heiget = heiget + 35;
                    } else {
                        heiget = heiget + 50;
                    }
                }
                if (self.detailModel.data.product.isWholesaleProduct &&
                    self.detailModel.data.product.isWholesaleProduct == 1 &&
                    self.detailModel.data.product.commodityType == 6
                    ) {
                    //领取优惠券
                    heiget = heiget + 45;
                }
                
                return CGSizeMake(ScreenW, heiget);
                
            }
        }
        
        
        
        
    }else if (indexPath.section == 1){//商品属性选择
        if (self.featureModel.data.rsMap.productTtributesMap.seriesAttributes==nil||self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count==0) {//规格为空
            return CGSizeMake(ScreenW, 0.001);
        }else
        {
            if (indexPath.row == 0||indexPath.row == 2) {
                return CGSizeMake(ScreenW, 45);
            }else{
                return CGSizeMake(ScreenW, 1);
            }
        }
        
    }else if (indexPath.section == 2){//商品评价部分展示
        
        if (self.commentList &&self.commentList.data.commentList.list) {
            if (self.commentList.data.commentList.list.count>=2) {
                ListItem *commentItem=[self.commentList.data.commentList.list objectAtIndex:0];
                ListItem *commentItem2=[self.commentList.data.commentList.list objectAtIndex:1];
                if (commentItem.commentPictureList.count>0&&commentItem2.commentPictureList.count>0) {
                    return CGSizeMake(ScreenW, 495);//待计算
                }else if (commentItem.commentPictureList.count<=0&&commentItem2.commentPictureList.count<=0)
                {
                    return CGSizeMake(ScreenW, 245);//待计算
                }else
                {
                    return CGSizeMake(ScreenW, 370);//待计算
                }
            }else if (self.commentList.data.commentList.list.count==1) {
                ListItem *commentItem=[self.commentList.data.commentList.list objectAtIndex:0];
                if (commentItem.commentPictureList.count>0) {
                    return CGSizeMake(ScreenW, 270);//待计算
                }else
                {
                    return CGSizeMake(ScreenW, 145);//待计算
                }
            }else
            {
                return CGSizeMake(ScreenW, 115);//暂无评价
            }
        }else
        {
            return CGSizeMake(ScreenW, 115);//暂无评价
        }
        
    }else if (indexPath.section == 3){//店铺信息
        if (self.goodsBaseStyle == DirectSupplyGoodsBaseDetailStyle && self.isVipGiftPackage == NO) {
            return CGSizeZero;
        } else{
            if (self.detailModel.data.topProducts.count>0) {
                return CGSizeMake(ScreenW, 257 + 10);
            }else
            {
                return CGSizeMake(ScreenW, 80 + 10);
            }
        }
       
        
    }else{
        return CGSizeZero;
    }
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (self.goodsBaseStyle==PromotionGoodsBaseDetailStyle||self.goodsBaseStyle==SpikeGoodsBaseDetailStyle) {
                //                促销或者秒杀
                if (self.detailModel.data.seckillInfo.noticeActivityStart) {//秒杀预告
                    return CGSizeMake(ScreenW, ScreenW+SpikeTimerheight+10);
                }else
                {
                    if (self.detailModel.data.seckillInfo.isSeckill==1) {//秒杀中
                        return CGSizeMake(ScreenW, ScreenW+SpikeTimerheight);
                    }else
                    {
                        //促销
                        if ([self.spaceTime integerValue]>0) {
                            return CGSizeMake(ScreenW, ScreenW+SpikeTimerheight);
                        }else
                        {//正常商品
                            return CGSizeMake(ScreenW, ScreenW);
                        }
                    }
                    
                }
                
                
                
            }else if (self.goodsBaseStyle==DirectSupplyGoodsBaseDetailStyle)
            {
                //                直供精品
                return CGSizeMake(ScreenW, ScreenW);
            }else
            {
                //                普通商品
                return CGSizeMake(ScreenW, ScreenW);
            }
            
            break;
        case 1:
            if (self.goodsBaseStyle==PromotionGoodsBaseDetailStyle) {
                //                促销商品疯抢。名品折扣
                //                没有区头
                return CGSizeZero;
            }else
            {
                //                秒杀
                //
                if (self.detailModel.data.seckillInfo.isSeckill==1) {//秒杀中
                    return CGSizeMake(ScreenW, 45);
                }else
                {
                    return CGSizeZero;
                }
                
            }
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size;
    if (section == 0){//商品属性选择
       
            size=CGSizeMake(ScreenW, 10);
        
        
    }else if (section == 1){//商品属性选择
        if ((self.featureModel.data.rsMap.productTtributesMap.seriesAttributes==nil||self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count==0) && self.detailModel.data.seckillInfo.isSeckill !=1 ) {//不是秒杀 没有规格
            size=CGSizeMake(ScreenW, 0.001);
        }else
        {
            size=CGSizeMake(ScreenW, 10);
        }
        
    }else if (section== 2){//商品评价部分展示
        if (self.commentList &&self.commentList.data.commentList.list&&self.commentList.data.commentList.list.count>0) {
            size=CGSizeMake(ScreenW, 10);
        }else
        {
            size=CGSizeMake(ScreenW, 0.001);
        }
        
    }else if(section == 3)//店铺
    {
        CGFloat height = ScreenH-IPHONEX_SAFE_AREA_TOP_HEIGHT_88-TabBarHeight;
        size=CGSizeMake(ScreenW, self.wkwebviewHeight >= height ? self.wkwebviewHeight : height);
    }else
    {
        size=CGSizeMake(ScreenW, 0.001);
        
    }
    
    return  size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //        [self scrollToDetailsPage]; //滚动到详情页面
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        //        [self chageUserAdress]; //跟换地址
    }else if (indexPath.section == 1){ //属性选择
        if (indexPath.row==0) {
            //            选择规格
            [[NSNotificationCenter defaultCenter]postNotificationName:SelectionSpecification object:nil userInfo:nil];
        }else
        {
            //           查看参数
            [[NSNotificationCenter defaultCenter]postNotificationName:SeaParameters object:nil userInfo:nil];
            
        }
        
    }
}


//#pragma mark - 视图滚动
//- (void)setUpViewScroller{
//    WEAKSELF
//    self.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(YES);
//            weakSelf.scrollerView.contentOffset = CGPointMake(0, ScreenH);
//        } completion:^(BOOL finished) {
//            [weakSelf.collectionView.mj_footer endRefreshing];
//        }];
//    }];
//
//    self.SpGoodParticularsVC.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        [UIView animateWithDuration:0.8 animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(NO);
//            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
//        } completion:^(BOOL finished) {
//            [weakSelf.SpGoodParticularsVC.tableView.mj_header endRefreshing];
//        }];
//
//    }];
//}
//过时回调方法
- (void)outDateTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
    if ([timeLabel isEqual:self.twoTimeLabel]) {
        self.twoTimeLabel.textColor = [UIColor redColor];
        
    }
    
}

- (NSAttributedString *)customTextWithTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
    if ([timeLabel isEqual:self.twoTimeLabel]) {
        NSArray *textArray=@[];
        if ([self.starSpaceTime integerValue]>0) {
            textArray = @[@"距离开始",[NSString stringWithFormat:@" %.2ld",(long)timeLabel.days],
                          @" 天",
                          [NSString stringWithFormat:@" %.2ld",(long)timeLabel.hours],
                          @" 时",
                          [NSString stringWithFormat:@" %.2ld",(long)timeLabel.minutes],
                          @" 分",
                          [NSString stringWithFormat:@" %.2ld",(long)timeLabel.seconds],
                          @" 秒"];
            
        }else
        {
           textArray = @[@"剩余",[NSString stringWithFormat:@" %.2ld",(long)timeLabel.days],
                                   @" 天",
                                   [NSString stringWithFormat:@" %.2ld",(long)timeLabel.hours],
                                   @" 时",
                                   [NSString stringWithFormat:@" %.2ld",(long)timeLabel.minutes],
                                   @" 分",
                                   [NSString stringWithFormat:@" %.2ld",(long)timeLabel.seconds],
                                   @" 秒"];
        }
        
       
        _timeLable1.text=[NSString stringWithFormat:@" %.2ld",(long)timeLabel.days];
        //        _timeLable1.text=[NSString stringWithFormat:@" 1000"];
        CGSize size = [_timeLable1 sizeThatFits:CGSizeMake(100, 20)];
        CGFloat height=18;
        if (self.detailModel.data.seckillInfo.isSeckill==1) {//秒杀中
            height=8;
        }else
        {
            height=18;
        }
        if (timeLabel.days==0) {
            self.TimeView.frame=CGRectMake(ScreenW-172-10+47, height, 172+size.width-20, 20);
            
             if ([self.starSpaceTime integerValue]>0) {
                  self.lable1.frame=CGRectMake(-25, 0, 50, 20);
             }else
             {
             self.lable1.frame=CGRectMake(0, 0, 25, 20);
             }
            
            //   天
            _timeLable1.frame=CGRectMake(CGRectGetMaxX(self.lable1.frame),0 , 0, 20);
            self.lable2.frame=CGRectMake(CGRectGetMaxX(_timeLable1.frame), 0, 0, 20);
            
            //    时
            _timeLable2.frame=CGRectMake(CGRectGetMaxX(self.lable2.frame)+2,0 , 20, 20);
            
            
            self.lable3.frame=CGRectMake(CGRectGetMaxX(_timeLable2.frame)+2, 0, 12, 20);
            
            //    分
            _timeLable3.frame=CGRectMake( CGRectGetMaxX(self.lable3.frame)+2,0, 20, 20);
            
            
            self.lable4.frame=CGRectMake(CGRectGetMaxX(_timeLable3.frame)+2,0 , 12, 20);
            
            //    秒
            _timeLable4.frame=CGRectMake(CGRectGetMaxX(self.lable4.frame)+2,0 , 20, 20);
            
            
            self.lable5.frame=CGRectMake(CGRectGetMaxX(_timeLable4.frame)+2,0 , 12, 20);
        }else
        {
            if (size.width>20) {
                self.TimeView.frame=CGRectMake(ScreenW-172-10-size.width+20, height, 172+size.width-20, 20);
                
                if ([self.starSpaceTime integerValue]>0) {
                    self.lable1.frame=CGRectMake(-25, 0, 50, 20);
                }else
                {
                    self.lable1.frame=CGRectMake(0, 0, 25, 20);
                }
                //   天
                _timeLable1.frame=CGRectMake(CGRectGetMaxX(self.lable1.frame)+5,0 , size.width, 20);
                self.lable2.frame=CGRectMake(CGRectGetMaxX(_timeLable1.frame)+2, 0, 12, 20);
                
                //    时
                _timeLable2.frame=CGRectMake(CGRectGetMaxX(self.lable2.frame)+2,0 , 20, 20);
                
                
                self.lable3.frame=CGRectMake(CGRectGetMaxX(_timeLable2.frame)+2, 0, 12, 20);
                
                //    分
                _timeLable3.frame=CGRectMake( CGRectGetMaxX(self.lable3.frame)+2,0, 20, 20);
                
                
                self.lable4.frame=CGRectMake(CGRectGetMaxX(_timeLable3.frame)+2,0 , 12, 20);
                
                //    秒
                _timeLable4.frame=CGRectMake(CGRectGetMaxX(self.lable4.frame)+2,0 , 20, 20);
                
                
                self.lable5.frame=CGRectMake(CGRectGetMaxX(_timeLable4.frame)+2,0 , 12, 20);
            }
            
            
        }
        
        _timeLable2.text=[NSString stringWithFormat:@" %.2ld",(long)timeLabel.hours];
        _timeLable3.text=[NSString stringWithFormat:@" %.2ld",(long)timeLabel.minutes];
        _timeLable4.text= [NSString stringWithFormat:@" %.2ld",(long)timeLabel.seconds];
        if (timeLabel.days==0&&timeLabel.hours==0&&timeLabel.minutes==0&&timeLabel.seconds==0) {
            //刷线页面
            [self performSelector:@selector(reloadDate) withObject:nil afterDelay:0.5];
        }
        return [self dateAttributeWithTexts:textArray];
    }
    return nil;
}
//刷新页面
-(void)reloadDate
{
    [self.Delegate reloadViewAndData ];
}
- (NSAttributedString *)dateAttributeWithTexts:(NSArray *)texts{
    
    NSDictionary *datedic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@(0),NSStrokeColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:HEXCOLOR(0x323232)};
    NSMutableAttributedString *dateAtt = [[NSMutableAttributedString alloc] init];
    
    [texts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *text = (NSString *)obj;
        text = text ? text : @"";
        //说明是时间字符串
        if ([text integerValue] || [text rangeOfString:@"0"].length) {
            
            [dateAtt appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:datedic]];
            
        }else{
            //          UIColor *color = (idx+1)%4?[UIColor greenColor]:[UIColor blueColor];
            UIColor *color=[UIColor whiteColor];
            
            [dateAtt appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:color}]];
        }
        
    }];
    return dateAtt;
}


- (ZJJTimeCountDown *)countDown{
    
    if (!_countDown) {
        
        _countDown = [[ZJJTimeCountDown alloc] init];
    }
    return _countDown;
}

- (void)dealloc{
    [self.countDown destoryTimer];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
