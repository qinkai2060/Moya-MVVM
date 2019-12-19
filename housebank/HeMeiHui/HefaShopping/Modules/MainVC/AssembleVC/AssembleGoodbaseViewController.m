//
//  AssembleGoodbaseViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleGoodbaseViewController.h"
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
#import "GroupByingHeaderView.h"
#import "GroupBuyingCollectionViewCell.h"
#import "DetailedRulesGroupBuyingCell.h"
#import "AssembleSubViewTool.h"



#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64
#define  SpikeTimerheight 55
@interface AssembleGoodbaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,ZJJTimeCountDownDelegate>


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
static NSString *GroupByingHeaderViewID=@"GroupByingHeaderView";
//cell
static NSString *DCDetailGoodReferralCellID = @"DCDetailGoodReferralCell";
static NSString *SpFeatureItemCellID = @"SpFeatureItemCell";
static NSString *SpProductReviewCellID = @"SpProductReviewCell";
static NSString *SpStoreInformationCellID = @"SpStoreInformationCell";
static NSString *SpParameterCellID=@"SpParameterCell";
static NSString *SpaceLineCellID=@"SpaceLineCell";


static NSString *GroupBuyingCollectionViewCellID=@"GroupBuyingCollectionViewCell";
static NSString *DetailedRulesGroupBuyingCellID=@"DetailedRulesGroupBuyingCell";


//footer
static NSString *DCDetailOverFooterViewID = @"DCDetailOverFooterView";
@implementation AssembleGoodbaseViewController
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
         [_collectionView registerClass:[GroupByingHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GroupByingHeaderViewID];
        //注册Cell
        [_collectionView registerClass:[SpDetailGoodReferralCell class] forCellWithReuseIdentifier:DCDetailGoodReferralCellID];
        [_collectionView registerClass:[SpFeatureItemCell class] forCellWithReuseIdentifier:SpFeatureItemCellID];
        [_collectionView registerClass:[SpParameterCell class] forCellWithReuseIdentifier:SpParameterCellID];
        [_collectionView registerClass:[SpProductReviewCell class] forCellWithReuseIdentifier:SpProductReviewCellID];
        [_collectionView registerClass:[SpStoreInformationCell class] forCellWithReuseIdentifier:SpStoreInformationCellID];
        [_collectionView registerClass:[SpaceLineCell class] forCellWithReuseIdentifier:SpaceLineCellID];
        
         [_collectionView registerClass:[GroupBuyingCollectionViewCell class] forCellWithReuseIdentifier:GroupBuyingCollectionViewCellID];
         [_collectionView registerClass:[DetailedRulesGroupBuyingCell class] forCellWithReuseIdentifier:DetailedRulesGroupBuyingCellID];
       
        //注册Footer
        [_collectionView registerClass:[SpDetailOverFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCDetailOverFooterViewID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //间隔
        
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    
    
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
   
    
        NSIndexPath * indexPath;
        if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
            //   section 0商品详情  轮播器header+cell+分割foot
            //   section 1快速参团 header+cell  分割foot
            //   section 2购买成团 cell  分割foot
            //   section 3评价 header+cell  分割foot
            //   section 4店铺
            indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        }else
        {
            //   section 0商品详情  轮播器header+cell+分割foot
            //   section 1规格\参数  cell+分割foot
            //   section 2评价 header+cell  分割foot
            //   section 3店铺
            indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        }
        
        UICollectionViewCell * item = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (self.cellInCollection.origin.y == 0) {
            self.cellInCollection = [self.collectionView convertRect:item.frame toView:self.collectionView];
        }
        if (self.cellInCollection.origin.y > 0) {
            if (scrollView.contentOffset.y < self.cellInCollection.origin.y - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 5) {
                NSLog(@"商品");
                if (self.offSetBlock) {
                    self.offSetBlock(AssemOffSetStyleGood);
                }
                
            } else if (scrollView.contentOffset.y >= [self collectionViewContentSizeHeight] - self.wkwebviewHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 1){
                NSLog(@"详情");
                if (self.offSetBlock) {
                    
                    self.offSetBlock(AssemOffSetStyledDetail);
                }
            } else {
                NSLog(@"评价");
                if (self.offSetBlock) {
                    
                    self.offSetBlock(AssemOffSetStyleComment);
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
    self.collectionView.backgroundColor =[UIColor whiteColor];
    _shufflingArray=[NSArray arrayWithObjects:@"product_1",@"product_2",@"product_4", nil];
    
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
        //   section 0商品详情  轮播器header+cell+分割foot
        //   section 1快速参团 header+cell  分割foot
        //   section 2购买成团 cell  分割foot
        //   section 3评价 header+cell  分割foot
        //   section 4店铺
        return 5;
    }else
    {
        //   section 0商品详情  轮播器header+cell+分割foot
        //   section 1规格\参数  cell+分割foot
        //   section 2评价 header+cell  分割foot
        //   section 3店铺
         return 4;
    }
   
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //     return (section == 1 ) ?3 : 1;
    //   section 0商品详情  轮播器header+cell+分割foot
    //   section 1规格\参数  cell+分割foot
    //   section 2快速参团 header+cell  分割foot
    //   section 3购买成团 cell  分割foot
    //   section 4评价 header+cell  分割foot
    //   section 5店铺
    if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
        switch (section) {
            case 1:
            {
                if (self.detailModel.data.productActiveChk.activeType==1) {//拉新拼团且新人登录
                    //1：按拉新成团，2：按购买成团',
                    if (self.openGroupList.data.isNewUser==1||self.openGroupList.data.isNewUser==2) {
//                        新人和未登录正常显示，按拉新成团商品老人不显示
                        if (self.openGroupList.data.openGroupList.count>2) {
                            
                            return 2;
                        }else
                        {
                            return self.openGroupList.data.openGroupList.count;
                        }
                    }else
                    {
//                        按拉新成团商品老人不显示
                         return 0;
                    }
                }else
                {
                    if (self.openGroupList.data.openGroupList.count>2) {
                        
                        return 2;
                    }else
                    {
                        return self.openGroupList.data.openGroupList.count;
                    }
                }
               
                
            }
            
                
            default:
            {
                return (section == 1 ) ? 1 : 1;
            }
                break;
        }
       

    }else
    {
        return (section == 1 ) ? 1 : 1;
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
            gridcell = cell;
            [cell reSetVDataValue:self.detailModel.data.product allData:self.detailModel];
            
        }
            break;
        case 1:
        {
             if (self.assembleBaseStyle==AssembleBaseDetailStyle)
             {
                 //拼团
                 GroupBuyingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:GroupBuyingCollectionViewCellID forIndexPath:indexPath];
                 //                待设置数据
                 OpenGroupListItem *model= [self.openGroupList.data.openGroupList objectAtIndex:indexPath.row];
                
                 [cell reSetSelectedData:model];
                 gridcell = cell;
             }else
             {
                 switch (indexPath.row) {
                     case 0:
                     {
                         
                         SpFeatureItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpFeatureItemCellID forIndexPath:indexPath];
                         gridcell = cell;
                         [cell reSetSelectedData:self.code];
                     }
                         
                     default:
                         break;
                 }
             }
            
            
        }
            break;
        case 2:
        {
            if (self.assembleBaseStyle==AssembleBaseDetailStyle)
            {
                //拼团
                DetailedRulesGroupBuyingCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:DetailedRulesGroupBuyingCellID forIndexPath:indexPath];
                //                待设置数据
                 cell.activeType=self.detailModel.data.productActiveChk.activeType;
                [cell reSetSelectedData:[NSString stringWithFormat:@"%ld",(long)cell.activeType]];
                gridcell = cell;
            }else
            {//正常商品
                SpProductReviewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpProductReviewCellID forIndexPath:indexPath];
                cell.commentList=self.commentList;
                [cell reSetVDataValue:self.commentList];
                gridcell = cell;
                
            }
            
         
        }
            break;
        case 3:
        {
            if (self.assembleBaseStyle==AssembleBaseDetailStyle)
            {
                //正常商品
                SpProductReviewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpProductReviewCellID forIndexPath:indexPath];
                cell.commentList=self.commentList;
                [cell reSetVDataValue:self.commentList];
                gridcell = cell;
            }else
            {//正常商品
                SpStoreInformationCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpStoreInformationCellID forIndexPath:indexPath];
                cell.productInfo=self.detailModel;
                [cell reSetVDataValue:self.detailModel];
                gridcell = cell;
            }
           
        }
            break;
        case 4:
        {
            if (self.assembleBaseStyle==AssembleBaseDetailStyle)
            {
                SpStoreInformationCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:SpStoreInformationCellID forIndexPath:indexPath];
                cell.productInfo=self.detailModel;
                [cell reSetVDataValue:self.detailModel];
                gridcell = cell;
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
        
        switch (indexPath.section) {
            case 0:
                {
                  SpDetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDetailShufflingHeadViewID forIndexPath:indexPath];
                        NSMutableArray *picList=[NSMutableArray new];
                        if (self.detailModel.data.product.productPics.count>0) {
                            for (int i=0; i<self.detailModel.data.product.productPics.count; i++) {
                                ProductPicsItem *PicsItem= [self.detailModel.data.product.productPics objectAtIndex:i];
                                [picList addObject:[PicsItem.address get_sharImage]];
                            }
                        }
                        headerView.shufflingArray = picList;
                        if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
                            if (self.detailModel.data.productActiveChk.activeEndDate) {//结束日期有值
                                self.spacEndDateTime=[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.productActiveChk.activeEndDate];
                                //  设置倒计时时间
                                NSString *nowTime=[MyUtil getNowTimeTimestamp3];
                                self.spaceTime=[MyUtil compareTwoTime:self.spacEndDateTime time2:nowTime];
                                if ([self.spaceTime intValue]>0) {
                                    self.spikeTimerView= [self creatSpikeTimerView];
                                    [headerView addSubview:self.spikeTimerView];
                                }else
                                {
                                    [self.spikeTimerView removeFromSuperview];
                                }
                                
                            }
                        }
                        
                        reusableview = headerView;
                    
                }
         
                break;
            case 1:
            {
                //快速参团
                if (self.assembleBaseStyle==AssembleBaseDetailStyle&&self.openGroupList.data.openGroupList.count>0) {
//                  //                显示快速参团
                    GroupByingHeaderView *headerView ;
                    if (self.detailModel.data.productActiveChk.activeType==1) {//拉新拼团且新人登录
                        //1：按拉新成团，2：按购买成团',
                        if (self.openGroupList.data.isNewUser==1||self.openGroupList.data.isNewUser==2) {
                              headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GroupByingHeaderViewID forIndexPath:indexPath];
                              headerView.featureTitleLabel.text=@"新人参团（点击可快速成团）";
                            UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
                            aTapGR.numberOfTapsRequired = 1;
                            [headerView addGestureRecognizer:aTapGR];
                            reusableview = headerView;
                           
                        }else
                        {
//                            老人不显示
                          headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GroupByingHeaderViewID forIndexPath:indexPath];
                        reusableview = headerView;
                        }
                      
                    }else
                    {
                        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GroupByingHeaderViewID forIndexPath:indexPath];
                        headerView.featureTitleLabel.text=@"快速参团（点击可快速成团）";
                        UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
                        aTapGR.numberOfTapsRequired = 1;
                        [headerView addGestureRecognizer:aTapGR];
                        reusableview = headerView;
                    }
                    
                }else
                {
                    //不处理
                    
                }
            }
                 break;
            default:
                break;
        }
        
    }else if (kind == UICollectionElementKindSectionFooter){
        switch (indexPath.section) {
            case 4:
            {
                if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
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

                }else
                {
                    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                    footerView.backgroundColor = DCBGColor;
                    reusableview = footerView;
                }
                
            }
                
                break;
            case 3:
            {
                if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
                    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                    footerView.backgroundColor = DCBGColor;
                    reusableview = footerView;
                }else
                {
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
            }
                
                break;
            case 1:
            {
                if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
                    if (self.openGroupList.data.openGroupList.count>0) {
                        if (self.detailModel.data.productActiveChk.activeType==1)
                            //拉新拼团且新人登录
                        {
                            if (self.openGroupList.data.isNewUser==1||self.openGroupList.data.isNewUser==2)
                            {
                                UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                                footerView.backgroundColor = DCBGColor;
                                reusableview = footerView;
                            }else
                            {
                                //                              老人不做处理
                                UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                                footerView.backgroundColor = DCBGColor;
                                reusableview = footerView;
                            }
                        }else
                        {//购买成团
                            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                            footerView.backgroundColor = DCBGColor;
                            reusableview = footerView;
                        }
                }else
                {
//                     无数据不做处理
                    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                    footerView.backgroundColor = DCBGColor;
                    reusableview = footerView;
                }
                }else
                {
//                    正常商品
                    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                    footerView.backgroundColor = DCBGColor;
                    reusableview = footerView;
                }
            }
                
                break;
                
            default:
            {
                UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
                footerView.backgroundColor = DCBGColor;
                reusableview = footerView;
            }
                break;
        }
        
    }
    return reusableview;
    
}
//设置促销秒杀时间
-(UIImageView *)creatSpikeTimerView
{
    //           促销秒杀专用
    _spikeTimerView= [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenW, ScreenW, SpikeTimerheight)];
    _spikeTimerView.image=[UIImage imageNamed:@"商品详情-拼团bg"];
    //现价
//    超值拼团
    UIImageView *iconImage= [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 38, 39)];
    iconImage.image=[UIImage imageNamed:@"超值拼团"];
    [_spikeTimerView addSubview:iconImage];
//    竖线
    UILabel *linelable = [[UILabel alloc] initWithFrame:CGRectMake(69, 8, 1, 40)];
    //    CGRectMake(CGRectGetMaxX(_currentPriceLabel.frame),32, 100, 15)
    linelable.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
    linelable.font = [UIFont systemFontOfSize:10.0];
    [_spikeTimerView addSubview:linelable];
    /* 商品现价 */
    _currentPriceLabel= [[UILabel alloc] initWithFrame:CGRectZero];
    //    CGRectMake(10, 7, 100, 40)
    _currentPriceLabel.textColor = HEXCOLOR(0xFFFFFF);
    _currentPriceLabel.font = [UIFont systemFontOfSize:16.0];
    [_spikeTimerView addSubview:_currentPriceLabel];
    _currentPriceLabel.text=@"¥89.10";
    
    /* 商品原价 */
    _originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //    CGRectMake(CGRectGetMaxX(_currentPriceLabel.frame),32, 100, 15)
    _originalPriceLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _originalPriceLabel.font = [UIFont systemFontOfSize:10.0];
    [_spikeTimerView addSubview:_originalPriceLabel];
    _originalPriceLabel.text=@"¥150";
    [self reSetVDataValue:self.detailModel.data.product allData:self.detailModel];
    
    //    添加倒计时
    self.countDown.timeStyle = ZJJCountDownTimeStyleTamp;
    self.countDown.delegate = self;
    [self setupTwoTimeLabelP:_spikeTimerView];
    [self.countDown addTimeLabel:self.twoTimeLabel time:[ZJJTimeCountDownDateTool dateByAddingSeconds:self.spaceTime timeStyle:ZJJCountDownTimeStyleTamp]];
    
    
    return _spikeTimerView;
    
}
//设置价钱
-(void)reSetVDataValue:(Product*)productInfo  allData:(GoodsDetailModel*)goodDetail
{

//    有促销价显示促销价
    NSString *str=@"";
    if (goodDetail.data.productActiveChk.activeCashPrice) {
        str=[HFUntilTool thousandsFload:goodDetail.data.productActiveChk.activeCashPrice];
    }else
    {
        str =[HFUntilTool thousandsFload:productInfo.price];
    }
  
    NSRange range = [str rangeOfString:@"."];//匹配得到的下标
    _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:HEXCOLOR(0xFFFFFF) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:productInfo.intrinsicPrice]] lineColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
    _originalPriceLabel.attributedText=setLineStr;
    [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        [make.left.mas_equalTo(self.spikeTimerView)setOffset:80];
        [make.top.mas_equalTo(self.spikeTimerView)setOffset:23];
        //[make.bottom.mas_equalTo(self.spikeTimerView.mas_bottom)setOffset:-15];
    }];
    [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        [make.left.mas_equalTo(self.spikeTimerView)setOffset:80];
        [make.top.mas_equalTo(self.spikeTimerView)setOffset:10];
    }];
    
}
//设置倒计时
- (void)setupTwoTimeLabelP:(UIImageView*)spikeTimerView{
    //    隐藏计数字
    self.twoTimeLabel=[[ZJJTimeCountDownLabel alloc]initWithFrame:CGRectMake(190, 18, 175, 0)];
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
    self.TimeView=[[UIView alloc]initWithFrame:CGRectMake(ScreenW-172-10, 18, 172, 20)];
    self.TimeView.backgroundColor=[UIColor clearColor];
    [spikeTimerView  addSubview:self.TimeView];
    
    self.lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.lable1.text=@"剩余";
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
        
            if (self.detailModel.data.productActiveChk.activeEndDate) {//结束日期有值
                self.spacEndDateTime=[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.productActiveChk.activeEndDate];
                NSString *nowTime=[MyUtil getNowTimeTimestamp3];
                self.spaceTime=[MyUtil compareTwoTime:self.spacEndDateTime time2:nowTime];
                if ([self.spaceTime intValue]>0) {
                    return CGSizeMake(ScreenW, 100-45+titleheight+subTitleheight);
                }else
                {
                    return CGSizeMake(ScreenW, 100+titleheight+subTitleheight);
                }
            }else
            {
                
                return CGSizeMake(ScreenW, 100+titleheight+subTitleheight);
            }
        
        
    }else if (indexPath.section == 1){//商品属性选择
         if (self.assembleBaseStyle==AssembleBaseDetailStyle)
         {
             //                显示快速参团
               return CGSizeMake(ScreenW, 60);//待计算
         }else
         {
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
         }
       
        
    }else if (indexPath.section == 2){//商品评价部分展示
        if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
            //                显示快速参团
        return CGSizeMake(ScreenW, 45);//待计算
        }else
        {
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
                    return CGSizeMake(ScreenW, 115);//待计算 无评价
                }
            }else
            {
                return CGSizeMake(ScreenW, 115);//无评价
            }
        }
       
        
    }
    else if (indexPath.section == 3){//店铺信息
        if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
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
                    return CGSizeMake(ScreenW, 115);//待计算 无评价
                }
            }else
            {
                return CGSizeMake(ScreenW, 115); //无评价
            }
        }else
        {
            if (self.detailModel.data.topProducts.count>0) {
                return CGSizeMake(ScreenW, 257 + 10);
            }else
            {
                return CGSizeMake(ScreenW, 80 + 10);
            }
        }
    }
    else if (indexPath.section == 4){
        if (self.assembleBaseStyle==AssembleBaseDetailStyle)
        {
            if (self.detailModel.data.topProducts.count>0) {
                return CGSizeMake(ScreenW, 257 + 10);
            }else
            {
                return CGSizeMake(ScreenW, 80 + 10);
            }
        }else
        {
              return CGSizeZero;
        }
        
    }else
    {
        return CGSizeZero;
    }
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:

            if (self.assembleBaseStyle==AssembleBaseDetailStyle) {
                 return CGSizeMake(ScreenW, ScreenW+SpikeTimerheight);
            }else
            {
               return CGSizeMake(ScreenW, ScreenW);
            }
           
            break;
        case 1:
              if (self.assembleBaseStyle==AssembleBaseDetailStyle&&self.openGroupList.data.openGroupList.count>0)  {
                  if (self.detailModel.data.productActiveChk.activeType==1) {//拉新拼团且新人登录
                      //1：按拉新成团，2：按购买成团',
                      if (self.openGroupList.data.isNewUser==1||self.openGroupList.data.isNewUser==2) {
                           return CGSizeMake(ScreenW, 35);
                      }else
                      {
                           return CGSizeZero;
                      }
                  }else
                  {
                    return CGSizeMake(ScreenW, 35);
                  }
//                快速参团头
              
            }else
            {
               
                return CGSizeZero;
                
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
    if (section == 1){//商品属性选择
         if (self.assembleBaseStyle==AssembleBaseDetailStyle&&self.openGroupList.data.openGroupList.count>0)
         {
             size=CGSizeMake(ScreenW, 10);
         }else
         {
             if (self.featureModel.data.rsMap.productTtributesMap.seriesAttributes==nil||self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count==0) {
                 size=CGSizeMake(ScreenW, 0.001);
             }else
             {
                 if (self.detailModel.data.productActiveChk.activeType==1) {//拉新拼团且新人登录
                     //1：按拉新成团，2：按购买成团',
                     if (self.openGroupList.data.isNewUser==1||self.openGroupList.data.isNewUser==2)
                     {
                       size=CGSizeMake(ScreenW, 10);
                     }else
                     {
                         size=CGSizeMake(ScreenW, 0.001);
                         
                     }
                 }else
                 {
                   size=CGSizeMake(ScreenW, 10);
                 }
                 
             }
         }
      
    }else if (section== 2){//商品评价部分展示
        if (self.assembleBaseStyle==AssembleBaseDetailStyle)  {
             size=CGSizeMake(ScreenW, 10);
        }else
        {
            if (self.commentList &&self.commentList.data.commentList.list&&self.commentList.data.commentList.list.count>0) {
                size=CGSizeMake(ScreenW, 10);
            }else
            {
                size=CGSizeMake(ScreenW, 0.001);
            }
        }
    }else if(section == 3)//店铺
    {
         if (self.assembleBaseStyle==AssembleBaseDetailStyle)
         {
             if (self.commentList &&self.commentList.data.commentList.list&&self.commentList.data.commentList.list.count>0) {
                 size=CGSizeMake(ScreenW, 10);
             }else
             {
                 size=CGSizeMake(ScreenW, 0.001);
             }
         }else
         {
             CGFloat height = ScreenH-IPHONEX_SAFE_AREA_TOP_HEIGHT_88-TabBarHeight;
             size=CGSizeMake(ScreenW, self.wkwebviewHeight >= height ? self.wkwebviewHeight : height);
         }
        
    }else if(section == 4)
    {
        if (self.assembleBaseStyle==AssembleBaseDetailStyle)
        {
            CGFloat height = ScreenH-IPHONEX_SAFE_AREA_TOP_HEIGHT_88-TabBarHeight;
            size=CGSizeMake(ScreenW, self.wkwebviewHeight >= height ? self.wkwebviewHeight : height);
        }else
        {
            size=CGSizeMake(ScreenW, 10);
        }
        
    }
     else
    {
        size=CGSizeMake(ScreenW, 10);
    }
    
    return  size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //        [self scrollToDetailsPage]; //滚动到详情页面
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        if (self.assembleBaseStyle==AssembleBaseDetailStyle)
        {//拼团查看规则
            [AssembleSubViewTool showReluerSubView:self.detailModel.data.productActiveChk.activeNum activeType:self.detailModel.data.productActiveChk.activeType ];
            
        }
        //        [self chageUserAdress]; //跟换地址
    }else if (indexPath.section == 1){ //属性选择
        if (self.assembleBaseStyle==AssembleBaseDetailStyle)
        {//去拼团
             [[NSNotificationCenter defaultCenter]postNotificationName:GoToPinTuanlViewView object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row]}];
            
            
        }else
            
        {
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
}



//过时回调方法
- (void)outDateTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
    if ([timeLabel isEqual:self.twoTimeLabel]) {
        self.twoTimeLabel.textColor = [UIColor redColor];
        
    }
    
}

- (NSAttributedString *)customTextWithTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
    if ([timeLabel isEqual:self.twoTimeLabel]) {
        
        NSArray *textArray = @[@"剩余",[NSString stringWithFormat:@" %.2ld",(long)timeLabel.days],
                               @" 天",
                               [NSString stringWithFormat:@" %.2ld",(long)timeLabel.hours],
                               @" 时",
                               [NSString stringWithFormat:@" %.2ld",(long)timeLabel.minutes],
                               @" 分",
                               [NSString stringWithFormat:@" %.2ld",(long)timeLabel.seconds],
                               @" 秒"];
        _timeLable1.text=[NSString stringWithFormat:@" %.2ld",(long)timeLabel.days];
    
        CGSize size = [_timeLable1 sizeThatFits:CGSizeMake(100, 20)];
        if (size.width>20) {
            self.TimeView.frame=CGRectMake(ScreenW-172-10-size.width+20, 18, 172+size.width-20, 20);
            
            self.lable1.frame=CGRectMake(0, 0, 25, 20);
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
        _timeLable2.text=[NSString stringWithFormat:@" %.2ld",(long)timeLabel.hours];
        _timeLable3.text=[NSString stringWithFormat:@" %.2ld",(long)timeLabel.minutes];
        _timeLable4.text= [NSString stringWithFormat:@" %.2ld",(long)timeLabel.seconds];
        return [self dateAttributeWithTexts:textArray];
    }
    return nil;
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
//拼团手势展示参团列表
-(void)tapGRAction:(UITapGestureRecognizer*)gesture
{
    [AssembleSubViewTool showAssembleListSubView:self.openGroupList.data.openGroupList];
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
