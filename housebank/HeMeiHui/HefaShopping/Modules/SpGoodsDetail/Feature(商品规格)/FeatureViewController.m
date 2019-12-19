//
//  FeatureViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "FeatureViewController.h"
#import"UIView+addGradientLayer.h"
#import "ORSKUDataFilter.h"
#import "JYEqualCellSpaceFlowLayout.h"


//#define TableViewHeight 200//待计算
#define HeaderHeight 130

#define FootHeight 80
static const CGFloat kLineSpacing = 15.f;   //列间距 |
static const CGFloat kItemSpacing = 10.f;   //item之间的间距  --
static const CGFloat kCellMargins = 15.f;   //左右缩进
static const NSInteger kRowNumber = 4;     //列数
static const CGFloat kCellHeight  = 25.f;  //Cell高度
static const CGFloat kHeaderHeight  = 30.f;  //header高度
static const CGFloat kFootHeight  = 1.f;  //foot高度
static const CGFloat kTopHeight  = 10.f;  //距离header的高度
static const CGFloat kBootomHeight  = 15.f;  //距离foot的高度
@interface FeatureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PPNumberButtonDelegate,ORSKUDataFilterDataSource>
@property(nonatomic,strong) UIView *bagView;
@property(nonatomic,strong) UIView *subView;
@property (nonatomic, strong) UIView *headerView ;
@property (strong , nonatomic)UICollectionView *collectionView;
@property (nonatomic, strong) UIView *footView ;
@property (nonatomic, strong) UILabel *vipTJLabel;//vip数量条件
@property (nonatomic, assign) CGFloat CollectionViewHeight;
@property (nonatomic, strong) UIButton * buttton;

@property (nonatomic,strong)NSMutableArray *  allPowerSet;
@property (nonatomic,strong)NSMutableDictionary * cellIdentifierDic;





@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *skuData;;
@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*selectedIndexPaths;;

@property (nonatomic, strong) ORSKUDataFilter *filter;

//
@end
static NSInteger num_;
static NSString *const PropertyHeaderID = @"PropertyHeader";
static NSString *const PropertyCellID = @"PropertyCell";
@implementation FeatureViewController
//   self.featureModel.data.rsMap.descartesCombinationMap//规格库存
//   self.featureModel.data.rsMap.descartesCombinationMap.SKU//规格库存list//             self.featureModel.data.rsMap.productTtributesMap//规格属性
//  self.featureModel.data.rsMap.productTtributesMap.seriesAttributes//规格属性list
#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        JYEqualCellSpaceFlowLayout * layout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:10.0];
//        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = kLineSpacing; //Y
        layout.minimumInteritemSpacing = kItemSpacing; //X
//        layout.mi
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
//        [_collectionView registerClass:[PropertyCell class] forCellWithReuseIdentifier:PropertyCellID];//cell
        [_collectionView registerClass:[PropertyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PropertyHeaderID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerIdf"]; //尾部
        
//        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)viewDidLoad {

    [super viewDidLoad];
        
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.cellIdentifierDic=[[NSMutableDictionary alloc]init];
//    设置半透明背景
    _bagView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _bagView.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    aTapGR.numberOfTapsRequired = 1;
    [_bagView addGestureRecognizer:aTapGR];
    [self.view addSubview:_bagView];
    
    //    设置基础数据
    [self  setBaseData];

 _CollectionViewHeight=(kHeaderHeight+kFootHeight+kTopHeight+kCellHeight+kBootomHeight)*self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count;
    if (_CollectionViewHeight>300) {
        _CollectionViewHeight=300;
    }

//    设置白色子视图
    [self creatSubView];


}
- (void)loadingProductMap:(NSDictionary *)productMap {
//    productMap
//    self.featureModel=[];
//    if (productMap == nil) {
//        
//    }
}
-(void)creatSubView
{
 
    _subView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-TabBarHeight-FootHeight-_CollectionViewHeight-HeaderHeight, ScreenW, HeaderHeight+_CollectionViewHeight+FootHeight+TabBarHeight)];
    _subView.backgroundColor=[UIColor whiteColor];
    _subView.alpha=1.0;
    [self.view addSubview:_subView];
  
    _headerView=[self  creatSubHeaderView];
    [_subView addSubview:_headerView];
   
    
    _collectionView.frame=CGRectMake(0, HeaderHeight, ScreenW, _CollectionViewHeight);
    [_subView addSubview:_collectionView];
    
    _footView=[self  creatSubFootView];
     [_subView addSubview:_footView];
    

    _buttton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttton.frame = CGRectMake(0, HeaderHeight+_CollectionViewHeight+FootHeight, ScreenW, 50);
    [_buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buttton setTitle:@"确定" forState:UIControlStateNormal];
    [_buttton setTitleColor:HEXCOLOR(0XFFFFFF) forState:UIControlStateNormal];
    [_buttton addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [_subView addSubview:_buttton];
    [self  reloadHeaderViewData];
    
}
-(UIView *)creatSubHeaderView
{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, HeaderHeight)];
    _imageView=[[UIImageView alloc]init] ;
    _imageView.frame=CGRectMake(15, 15, 100, 100);
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5;
    [_headerView addSubview:_imageView];
    
    _priceL=[[UILabel alloc]init] ;
    _priceL.frame=CGRectMake(_imageView.rightX+10, 40, 200, 25);
    _priceL.font = PFR16Font;
    _priceL.textColor=HEXCOLOR(0xF3344A);
    [_headerView addSubview:_priceL];
 
    _storeL=[[UILabel alloc]init] ;
    _storeL.frame=CGRectMake(_imageView.rightX+10, 75, 200, 15);
    _storeL.font = PFR13Font;
    _storeL.textColor=HEXCOLOR(0x666666);
    [_headerView addSubview:_storeL];
 
    _selectedLable=[[UILabel alloc]init] ;
    _selectedLable.frame=CGRectMake(_imageView.rightX+10, 100, 200, 15);
    _selectedLable.font = PFR13Font;
    _selectedLable.textColor=HEXCOLOR(0x333333);
    [_headerView addSubview:_selectedLable];

    _closeBtn=[UIButton buttonWithType:UIButtonTypeCustom] ;
    _closeBtn.frame=CGRectMake(ScreenW-15-20, 15, 20, 20);
    [_closeBtn setImage:[UIImage imageNamed:@"close666"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(tapGRAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_closeBtn];
    /* line*/
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(15, _headerView.height-1, ScreenW-30, 1)];
    lable.backgroundColor=HEXCOLOR(0xEEEEEE);
    [_headerView addSubview:lable];
    return _headerView;
}
-(UIView *)creatSubFootView
{
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, HeaderHeight+_CollectionViewHeight, ScreenW, FootHeight)];
    
    _buyCount = [UILabel new];
    _buyCount.frame=CGRectMake(15, 18, 53, 15);
    _buyCount.font = PFR13Font;
    _buyCount.textColor=HEXCOLOR(0x333333);
    _buyCount.text=@"购买数量";
     [_footView addSubview:_buyCount];
    
    _buyLimitCount = [UILabel new];
    _buyLimitCount.frame=CGRectMake(_buyCount.rightX+10, 18, 80, 15);
    _buyLimitCount.font = PFR10Font;
    _buyLimitCount.textColor=HEXCOLOR(0x999999);
//    _buyLimitCount.text=@"(每人限购2件)";
    [_footView addSubview:_buyLimitCount];
    
    
    if (self.detailModel.data.product.isWholesaleProduct == 1 && self.detailModel.data.product.commodityType == 6) {
        _vipTJLabel = [UILabel new];
        _vipTJLabel.frame=CGRectMake(15, MaxY(_buyCount) + 5, ScreenW - 30, 15);
        _vipTJLabel.font = PFR12Font;
        _vipTJLabel.textColor=HEXCOLOR(0xFF0000);

        [_footView addSubview:_vipTJLabel];
        if (self.detailModel.data.product.vipProduct.priceInfos.count > 0) {
            PriceInfos *infosModel = (PriceInfos *)[self.detailModel.data.product.vipProduct.priceInfos lastObject];
            _vipTJLabel.text = [NSString stringWithFormat:@"%ld件(含)以上%.2f元/件", (long)infosModel.countBuy,infosModel.cashPrice];

        }
    }
    
    
    _changeNumberBtn = [PPNumberButton numberButtonWithFrame:CGRectMake(ScreenW-80-20, 15, 80, 20)];
    _changeNumberBtn.shakeAnimation = NO;
    _changeNumberBtn.minValue = 1;
    _changeNumberBtn.borderColor=HEXCOLOR(0x999999);
    _changeNumberBtn.inputFieldFont = 12;
    _changeNumberBtn.increaseImage=[UIImage imageNamed:@"加号可用"];
    _changeNumberBtn.decreaseImage=[UIImage imageNamed:@"减号可用"];
    
    num_ = (_lastNum == 0) ?  1 : [_lastNum integerValue];
    _changeNumberBtn.currentNumber = num_;
    _changeNumberBtn.delegate = self;
    _changeNumberBtn.minValue=1;
//    设置限购数量
 if(self.detailModel.data.seckillInfo.isSeckill==1&&self.detailModel.data.seckillInfo.purchaseLimitation&&self.detailModel.data.seckillInfo.purchaseLimitation>0) {
        _changeNumberBtn.maxValue=self.detailModel.data.seckillInfo.purchaseLimitation;
    }else
    {
        if (self.detailModel.data.purchaseLimitation&&self.detailModel.data.purchaseLimitation!=0) {
            _changeNumberBtn.maxValue=self.detailModel.data.purchaseLimitation;
        }
    }
   
    WEAKSELF
    _changeNumberBtn.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        num_ = num;
        if (self.detailModel.data.product.isWholesaleProduct == 1 && self.detailModel.data.product.commodityType == 6 && self.detailModel.data.product.vipProduct.priceInfos.count > 0) {
            [weakSelf vipChangeLabelForNum:num];
        }
    };
    [_footView addSubview:_changeNumberBtn];
    
    return _footView;
}

- (void)vipChangeLabelForNum:(NSInteger)productNum{
    NSLog(@"商品数量:%ld",productNum);
    NSArray *arr = [NSArray arrayWithArray:self.detailModel.data.product.vipProduct.priceInfos];
    PriceInfos *infosModelLast = (PriceInfos *)[arr lastObject];//(最小的)
    PriceInfos *infosModelFirst = (PriceInfos *)[arr firstObject];//(最大的)

    if (productNum < infosModelLast.countBuy) {
        _vipTJLabel.text = [NSString stringWithFormat:@"%ld件(含)以上%.2f元/件", (long)infosModelLast.countBuy,infosModelLast.cashPrice];
    } else if (productNum >= infosModelFirst.countBuy) {
        _vipTJLabel.text = [NSString stringWithFormat:@"%ld件(含)以上%.2f元/件", (long)infosModelFirst.countBuy,infosModelFirst.cashPrice];
    } else {
        for (NSInteger i = (arr.count - 1) ; i >= 0; i--) {
            PriceInfos *infosModel = (PriceInfos *)arr[i];
            if (productNum < infosModel.countBuy) {
                _vipTJLabel.text = [NSString stringWithFormat:@"%ld件(含)以上%.2f元/件", (long)infosModel.countBuy,infosModel.cashPrice];
                return;
            }
        }
    }
}

//设置初始化数据
-(void)setBaseData
{

    _dataSource = self.featureModel.data.rsMap.productTtributesMap.seriesAttributes;
    _selectedIndexPaths = [NSMutableArray array];
    _skuData=self.featureModel.data.rsMap.descartesCombinationMap.SKU;
    _filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
    _allPowerSet=[self  powerSetWithSkus:_skuData];
    // 寻找已选规格
    for (SeriesAttributesItem *items in _dataSource) {
        if (items.attributeValue.length != 0) {
           items.featureArray = [items.attributeValue componentsSeparatedByString:@","];
        }
    }
    NSLog(@"当前 code %@",self.detailModel.data.product.code);
    if (self.detailModel.data.product.code.length != 0) {
        NSArray *codeArray = [self.detailModel.data.product.code componentsSeparatedByString:@"_"];
        //当数据更新的时候 需要reloadData
        for (int i = 0; i <_dataSource.count ; i++) {
            SeriesAttributesItem *items = _dataSource[i];
            NSInteger section = i;
            NSInteger row = 0;
            for (int j = 0; j <items.featureArray.count ; j++) {
                if ([items.featureArray[j] isEqualToString:codeArray[i]]) {
                    row = j;
                    [_filter.selectedIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }
        }
    }

    [_filter reloadData];
    [self.collectionView reloadData];
}
/**
 计算所有包含库存的sku
 
 @param skus 服务器返回的所有的sku
 @return 有库存的sku
 */
-(NSMutableArray *)enoughStoreSkusWithSkus:(NSArray *)skus {
    
    NSMutableArray *enoughStoreSkus = [NSMutableArray array];
    
    for (NSInteger i = 0; i < skus.count; i ++) {
        
        SKUItem *skuModel = skus[i];
        if (skuModel.stock > 0) {
            
            [enoughStoreSkus addObject:skuModel];
        }
    }
    
    return enoughStoreSkus;
}
/**
 获取所有包含库存的幂集集合
 
 @param skus 包含库存的sku
 @return 去掉重复的子集的幂集集合
 */
-(NSMutableArray *)powerSetWithSkus:(NSMutableArray *)skus {
    
    NSMutableArray *enoughStoreSkus = [self enoughStoreSkusWithSkus:skus];
    
    // 包含所有的
    NSMutableArray *allPowerSet = [NSMutableArray array];
    
    for (NSInteger i = 0; i < enoughStoreSkus.count; i ++) {
        
        SKUItem *skuModel = enoughStoreSkus[i];
        
        NSArray *select_spec_ids = [skuModel.code componentsSeparatedByString:@"_"];
        for (NSString *sku in select_spec_ids) {
            [allPowerSet addObject:sku];
        }
//        [self powersetArray:[NSMutableArray arrayWithArray:select_spec_ids] index:0 set:@"" powerSet:allPowerSet ];
    }
   
    
    return allPowerSet;
}
//// 递归求单个sku的幂集
//-(void)powersetArray:(NSMutableArray *)array index:(NSInteger)index set:(NSString *)set powerSet:(NSMutableArray *)powerSet  {
//
//    NSString *tempString = set;
//
//    if (index >= array.count) {
//
//        NSLog(@"set = %@ ==%p",set,set);
//        if (set.length > 0 && ![powerSet containsObject:set]) {
//
//            [powerSet addObject:set];
//        }
//    } else {
//
//        [self powersetArray:array index:index+1 set:tempString powerSet:powerSet singleSkuPowset:singleSkuPowset]; // 每次需要set完整的版本
//        // 每次将temp数组的部分元素加到temp中
//        if (tempString.length > 0) {
//
//            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@",%@",array[index]]];
//
//        } else {
//
//            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@",array[index]]];
//        }
//
//        [self powersetArray:array index:index + 1 set:tempString powerSet:powerSet singleSkuPowset:singleSkuPowset]; // temp成为新的set
//        // 如果powerset的是时候一直i+1就等于把set数组一直置空
//    }
//}

#pragma mark -- collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SeriesAttributesItem *attributesItem=_dataSource[section];
    NSArray *array = [attributesItem.attributeValue componentsSeparatedByString:@","];
    return [array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    _CollectionViewHeight=_collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    [self  resetSubViewHeight];
//    collectionView.layoutIfNeede
//    collectionCellHeight = cell.collectionvView.contentSize.height
    NSString *identifier = [_cellIdentifierDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    
    if(identifier == nil){
        
        identifier = [NSString stringWithFormat:@"%@%@",PropertyCellID, [NSString stringWithFormat:@"%@", indexPath]];
        
        [_cellIdentifierDic setObject:identifier forKey:[NSString  stringWithFormat:@"%@",indexPath]];
        
        // 注册Cell（把对cell的注册写在此处）
        
        [_collectionView registerClass:[PropertyCell class] forCellWithReuseIdentifier:identifier];
        
    }
    PropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    PropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PropertyCellID forIndexPath:indexPath];
    SeriesAttributesItem *attributesItem=_dataSource[indexPath.section];
//    =_skuData[indexPath];
    NSArray *array = [attributesItem.attributeValue componentsSeparatedByString:@","];
    cell.propertyL.text = array[indexPath.row];
//    NSArray *data = _dataSource[indexPath.section][@"value"];
//    cell.propertyL.text = data[indexPath.row];
    
    if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
//        可选
        if ([_allPowerSet containsObject:cell.propertyL.text]) {
            [cell setTintStyleColor:[UIColor blackColor] type:@"可选"];
        }else
        {
           [cell setTintStyleColor:[UIColor lightGrayColor] type:@"不可选"];
        }
       
//        [cell reset:@"可选"];
    }else {
//        不可选
        [cell setTintStyleColor:[UIColor lightGrayColor] type:@"不可选"];
//         [cell reset:@"不可选"];
    }
//        选中
    if ([_filter.selectedIndexPaths containsObject:indexPath]) {
        [cell setTintStyleColor:[UIColor redColor] type:@"选中"];
//        [cell reset:@"选中"];
    }
    return cell;
}
//s设置高度
-(void)resetSubViewHeight
{

    if (HeaderHeight+_CollectionViewHeight+FootHeight+TabBarHeight>=ScreenH*0.7) {
          _CollectionViewHeight=ScreenH*0.7-HeaderHeight-FootHeight-TabBarHeight;
    }
    _subView.frame=CGRectMake(0, ScreenH-TabBarHeight-FootHeight-_CollectionViewHeight-HeaderHeight, ScreenW, HeaderHeight+_CollectionViewHeight+FootHeight+TabBarHeight);
    
    _collectionView.frame=CGRectMake(0, HeaderHeight, ScreenW, _CollectionViewHeight);

     _footView.frame=CGRectMake(0, HeaderHeight+_CollectionViewHeight, ScreenW, FootHeight);
    
    _buttton.frame = CGRectMake(0, HeaderHeight+_CollectionViewHeight+FootHeight, ScreenW, 50);
   
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PropertyHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PropertyHeaderID forIndexPath:indexPath];
        SeriesAttributesItem *attributesItem=_dataSource[indexPath.section];
//        NSArray *array = [attributesItem.attributeValue componentsSeparatedByString:@","];
        view.headernameL.text =attributesItem.attributeName;
//         view.headernameL.text = _dataSource[indexPath.section][@"name"];
        return view;
        
    }else {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerIdf" forIndexPath:indexPath];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(15, view.height-1, ScreenW-30, 1)];
        lable.backgroundColor=HEXCOLOR(0xEEEEEE);
        [view addSubview:lable];
        
        return view;
    }
    
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JYEqualCellSpaceFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SeriesAttributesItem *attributesItem=_dataSource[indexPath.section];
    NSArray *array = [attributesItem.attributeValue componentsSeparatedByString:@","];
    NSString *labStr=array[indexPath.row];
//   NSString *labStr=_dataSource[indexPath.section][@"value"][indexPath.row];
    CGSize size = [labStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil]];
    return CGSizeMake(size.width+30, kCellHeight);//待计算
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYEqualCellSpaceFlowLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 10;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYEqualCellSpaceFlowLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 10;

}
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JYEqualCellSpaceFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return   CGSizeMake(ScreenW-5, kHeaderHeight);
//    CGSizeZero
}
//边距设置:整体边距的优先级，始终高于内部边距的优先级 调整内容的边距(cell的左右上下缩进)
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//                       layout:(JYEqualCellSpaceFlowLayout *)collectionViewLayout
//       insetForSectionAtIndex:(NSInteger)section
//{
////    kCellMargins
//    return UIEdgeInsetsMake(kTopHeight, kCellMargins, kBootomHeight,kCellMargins);//分别为上、左、下、右
//}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JYEqualCellSpaceFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, kFootHeight);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [_filter didSelectedPropertyWithIndexPath:indexPath];
    [collectionView reloadData];
    [self  reloadHeaderViewData];
  
}

#pragma mark -- ORSKUDataFilterDataSource

- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return _dataSource.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    SeriesAttributesItem *attributesItem=_dataSource[section];
    NSArray *array = [attributesItem.attributeValue componentsSeparatedByString:@","];
     return array;
//    return _dataSource[section][@"value"];
}

- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return _skuData.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    SKUItem *skuItem=_skuData[row];
    NSString *condition =skuItem.code;
    return [condition componentsSeparatedByString:@"_"];
//    NSString *condition = _skuData[row][@"contition"];
//    return [condition componentsSeparatedByString:@","];
}
//赋予返回值
- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    SKUItem *skuItem=_skuData[row];
//    return @{@"price": [NSString stringWithFormat:@"%0.2f",skuItem.price] ,
//             @"stock": [NSString stringWithFormat:@"%ld",(long)skuItem.stock],
//             @"code": [NSString stringWithFormat:@"%@",skuItem.code],
//             @"jointPictrue": [NSString stringWithFormat:@"%@",skuItem.jointPictrue],
//             @"featureId": [NSString stringWithFormat:@"%ld",(long)skuItem.featureId],
//             @"endDate": [NSString stringWithFormat:@"%ld",(long)skuItem.endDate],
//             @"startDate": [NSString stringWithFormat:@"%ld",(long)skuItem.startDate],
//             };
    return @{@"price": [NSString stringWithFormat:@"%.2f",skuItem.price],
             @"intrinsicPrice": [NSString stringWithFormat:@"%.2f",skuItem.intrinsicPrice],
             @"stock": [NSString stringWithFormat:@"%ld",(long)skuItem.stock],
             @"code": [NSString stringWithFormat:@"%@",skuItem.code],
             @"jointPictrue": [NSString stringWithFormat:@"%@",skuItem.jointPictrue],
             @"featureId": [NSString stringWithFormat:@"%ld",(long)skuItem.featureId],
             @"endDate": [NSString stringWithFormat:@"%@",skuItem.endDate],
             @"startDate": [NSString stringWithFormat:@"%@",skuItem.startDate],
             @"purchasedQuantity": [NSString stringWithFormat:@"%ld",(long)skuItem.seckillInfo.purchasedQuantity],
             @"stockKill": [NSString stringWithFormat:@"%ld",(long)skuItem.seckillInfo.stock],
             @"purchaseLimitation": [NSString stringWithFormat:@"%ld",(long)skuItem.seckillInfo.purchaseLimitation],
              @"isSeckill": [NSString stringWithFormat:@"%ld",(long)skuItem.seckillInfo.isSeckill],
               @"noticeActivityStart": [NSString stringWithFormat:@"%ld",(long)skuItem.seckillInfo.noticeActivityStart],
             @"address": skuItem.address?skuItem.address:@"",
             @"jointPictrue": skuItem.jointPictrue?skuItem.jointPictrue:@"",
             };
    
//    NSDictionary *dic = _skuData[row];
//    return @{@"price": dic[@"price"],
//             @"store": dic[@"store"]};
}
//重制header头数据
-(void)reloadHeaderViewData
{
    NSMutableArray *stockArray=[[NSMutableArray alloc]init];
    NSMutableArray *priceArray=[[NSMutableArray alloc]init];
    for (SKUItem *iteam in _skuData) {
        [stockArray addObject:[NSNumber numberWithInteger:iteam.stock]];
        [priceArray addObject:[NSNumber numberWithFloat:iteam.price]];
    }
//总和
    CGFloat all_value=[[stockArray valueForKeyPath:@"@sum.floatValue"]floatValue];
   
//    平均数
//    CGFloat mid_value= [[priceArray valueForKeyPath:@"@avg.floatValue"]floatValue];
    
//    最大值
    CGFloat max_value =[[priceArray valueForKeyPath:@"@max.floatValue"]floatValue];
   
//    最小值
    CGFloat  min_value=[[priceArray valueForKeyPath:@"@min.floatValue"]floatValue];
   

    NSMutableArray *picList=[NSMutableArray new];
    if (self.detailModel.data.product.productPics.count>0) {
        for (int i=0; i<self.detailModel.data.product.productPics.count; i++) {
            ProductPicsItem *PicsItem= [self.detailModel.data.product.productPics objectAtIndex:i];
            NSString *str=[PicsItem.address get_sharImage];
           
            [picList addObject:str];
        }
    }
    if (self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count>0) {//有规格
        _changeNumberBtn.currentResult=self.filter.currentResult;
        _changeNumberBtn.dataSource=_dataSource;
    }else
    {//无规格
        _changeNumberBtn.currentResult=nil;
        _changeNumberBtn.dataSource=nil;
        SKUItem*sku=[self.featureModel.data.rsMap.descartesCombinationMap.SKU objectAtIndex:0];
        _changeNumberBtn.storkNum=sku.stock;
    }
    NSDictionary *dic = _filter.currentResult;
   
    if (dic == nil) {//[NSString stringWithFormat:@"¥%0.2f-",min_value]
        NSString *strPrice1 =[HFUntilTool thousandsFload:min_value];
        NSRange range1 = [strPrice1 rangeOfString:@"."];//匹配得到的下标
        NSMutableAttributedString *attributedText1= [MyUtil getAttributedWithString:strPrice1 Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range1.location)];
         NSString *strPrice2 =[HFUntilTool thousandsFload:max_value];
        NSRange range2 = [strPrice2 rangeOfString:@"."];//匹配得到的下标
        NSMutableAttributedString *attributedText2= [MyUtil getAttributedWithString:strPrice2 Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range2.location)];
//        NSMutableAttributedString *attributedTexttext=[[NSMutableAttributedString alloc]init];
        if (min_value!=max_value) {
              [attributedText1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"-"]];
             [attributedText1 appendAttributedString:attributedText2];
        }
        _priceL.attributedText=attributedText1;
//        _priceL.text = @"￥0.0";
        _storeL.text = [NSString stringWithFormat:@"库存%0.0f件",all_value];
//        _storeL.text = @"库存0件";
       
        if (picList.count>0) {
           [_imageView sd_setImageWithURL:[NSURL URLWithString:[picList objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            
        }else
        {
          _imageView.image=[UIImage imageNamed:@"SpTypes_default_image"];
         
        }
        if (_dataSource.count>0) {
             _selectedLable.text=@"请选择";
        }else
        {
             _selectedLable.text=@"";
        }
        
        return;
    }else
    {
        //      @"address": skuItem.address?skuItem.address:@"",图片路径
       //       @"jointPictrue": skuItem.jointPictrue?skuItem.jointPictrue:@"",裁切
        NSString *str=@"";
        NSString *address=dic[@"address"];
        NSString *jointPictrue=dic[@"jointPictrue"];
    
        if (address.length > 0) {
            
            NSString *str3 = [address substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,address,@"!SQ250"];
                }
            }else
            {
                str = [NSString stringWithFormat:@"%@%@",address,@"!SQ250"];
            }
              [_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        }else
        {
            if (picList.count>0) {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:[picList objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            }else
            {
                _imageView.image=[UIImage imageNamed:@"SpTypes_default_image"];
            }
        }
       

        NSString *strPrice1 =dic[@"price"];
       NSString *strPrice= [HFUntilTool thousandsFload:[strPrice1 floatValue]];
        NSRange range = [strPrice rangeOfString:@"."];//匹配得到的下标
        _priceL.attributedText = [MyUtil getAttributedWithString:strPrice Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
        //    _priceL.text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
         _storeL.text = [NSString stringWithFormat:@"库存%@件",dic[@"stock"]];
        _selectedLable.text=[NSString stringWithFormat:@"已选:%@",dic[@"code"]];
    }
    
}
//        HFPayMentViewController *vc = [[HFPayMentViewController alloc] initWithType:HFPayMentViewControllerEnterTypeNone];
#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button
{
    NSDictionary *dic = _filter.currentResult;
    if (self.featureModel.data.rsMap.productTtributesMap.seriesAttributes.count>0) {
        if (dic == nil) {
            
            [SVProgressHUD showInfoWithStatus:@"请选择 尺码"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
            
            return;
        }else if( [dic[@"stock"] isEqualToString:@"0"] ||dic[@"stock"]==nil)
        {
            [SVProgressHUD showInfoWithStatus:@"商品卖完了"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        }else if(num_> [dic[@"stock"] intValue])
        {
            [SVProgressHUD showInfoWithStatus:@"购买数量超过库存数"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        }else
        {
            NSString *active=@"0";
            if ([dic[@"isSeckill"] isEqualToString:@"1"]) {
                active=@"6";
            }
            //        商品ID。  商品规格。 商品数量
            NSDictionary *dicModel=@{@"sid":[HFCarShoppingRequest sid],
                                     @"terminal": @"P_TERMINAL_MOBILE",
                                     @"commodityId":self.productId,
                                     @"specifications":dic[@"featureId"],
                                     @"count": [NSString stringWithFormat:@"%ld",(long)num_],
                                     @"active":active,
                                     @"price":dic[@"price"],
                                     @"intrinsicPrice":dic[@"intrinsicPrice"],
                                     @"code":dic[@"code"],
                                     @"endDate": dic[@"endDate"]?dic[@"endDate"]:@"",
                                     @"startDate":dic[@"startDate"]?dic[@"startDate"]:@"",
                                     @"purchasedQuantity":dic[@"purchasedQuantity"],
                                     @"stockKill":dic[@"stockKill"],
                                     @"purchaseLimitation":dic[@"purchaseLimitation"],
                                     @"isSeckill":dic[@"isSeckill"],
                                     @"noticeActivityStart":dic[@"noticeActivityStart"],
                                     };
        
            if ([self.type isEqualToString: @"立即购买"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel ];
//                [self dismissViewControllerAnimated:YES completion:nil];
                 [self  tapGRAction];
            }
            if ([self.type isEqualToString: @"加入购物车"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel ];
//                [self dismissViewControllerAnimated:YES completion:nil];
                 [self  tapGRAction];
            }
            if ([self.type isEqualToString: @"选择规格"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel ];
//                [self dismissViewControllerAnimated:YES completion:nil];
                 [self  tapGRAction];
            }
            if ([self.type isEqualToString: @"购物车重置"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel];
//                [self dismissViewControllerAnimated:YES completion:nil];
                 [self  tapGRAction];
            }
            
        }
    }else
    {
        NSString *active=@"0";
        if ([dic[@"isSeckill"] isEqualToString:@"1"]) {
            active=@"6";
        }
        SKUItem*sku=[self.featureModel.data.rsMap.descartesCombinationMap.SKU objectAtIndex:0];
        NSString * purchasedQuantity=@"";
         NSString * stockKill=@"";
         NSString * purchaseLimitation=@"";
         NSString * isSeckill=@"";
         NSString * noticeActivityStart=@"";
        if (dic[@"purchasedQuantity"]) {
            purchasedQuantity=dic[@"purchasedQuantity"];
        }
        if (dic[@"stockKill"]) {
            stockKill=dic[@"stockKill"];
        }
        if (dic[@"purchaseLimitation"]) {
            purchaseLimitation=dic[@"purchaseLimitation"];
        }
        if (dic[@"isSeckill"]) {
            isSeckill=dic[@"isSeckill"];
        }
        if (dic[@"noticeActivityStart"]) {
            noticeActivityStart=dic[@"noticeActivityStart"];
        }
        NSDictionary *dicModel=@{@"sid":[HFCarShoppingRequest sid],
                                 @"terminal": @"P_TERMINAL_MOBILE",
                                 @"commodityId":self.productId,
                                 @"specifications":[NSString stringWithFormat:@"%ld",(long)sku.featureId],
                                 @"count": [NSString stringWithFormat:@"%ld",(long)num_],
                                 @"active":active,
                                 @"price":[NSString stringWithFormat:@"%.2f",sku.price],
                                 @"intrinsicPrice":[NSString stringWithFormat:@"%.2f",sku.intrinsicPrice],
                                 @"endDate": dic[@"endDate"]?dic[@"endDate"]:@"",
                                 @"startDate":dic[@"startDate"]?dic[@"startDate"]:@"",
                                 @"purchasedQuantity":purchasedQuantity,
                                 @"stockKill":stockKill,
                                 @"purchaseLimitation":purchaseLimitation,
                                 @"isSeckill":isSeckill,
                                 @"noticeActivityStart":noticeActivityStart,
                                 };
      
        if( [[NSString stringWithFormat:@"%ld",(long)sku.stock]isEqualToString:@"0"] ||[NSString stringWithFormat:@"%ld",(long)sku.stock]==nil)
        {
            [SVProgressHUD showInfoWithStatus:@"商品卖完了"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        }else if(num_> [[NSString stringWithFormat:@"%ld",(long)sku.stock] intValue])
        {
            [SVProgressHUD showSuccessWithStatus:@"购买数量超过库存数"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        }else
        {
            if ([self.type isEqualToString: @"立即购买"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel];
                //            [self dismissViewControllerAnimated:YES completion:nil];
                [self  tapGRAction];
            }
            if ([self.type isEqualToString: @"加入购物车"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel];
                //            [self dismissViewControllerAnimated:YES completion:nil];
                [self  tapGRAction];
            }
            if ([self.type isEqualToString: @"选择规格"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel];
                //            [self dismissViewControllerAnimated:YES completion:nil];
                [self  tapGRAction];
            }
            if ([self.type isEqualToString: @"购物车重置"]) {
                [self.Delegate selectedItemType:self.type dic:dicModel];
                //            [self dismissViewControllerAnimated:YES completion:nil];
                [self  tapGRAction];
            }
            
        }
        
    }
   
    
    
    
}
//展示规格数量数据
-(void)showReluerView:(NSString *)type storck:(NSInteger)storck;
{
    switch ([ type  integerValue]) {
        case 1:
            {
                [SVProgressHUD showInfoWithStatus:@"请选择 尺码"];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
            }
            break;
        case 2:////限购
        {
            NSDictionary *dic = _filter.currentResult;

            if ([dic[@"isSeckill"] isEqualToString:@"1"]&&dic[@"purchaseLimitation"]&&[dic[@"purchaseLimitation"] intValue]>0) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"不能大于限购数量%@件！",dic[@"purchaseLimitation"]]];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
            }else
            {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"不能大于限购数量%ld件！",(long)self.detailModel.data.purchaseLimitation]];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
            }

            
        }
            break;
        case 3:
        {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"购买数量超过%ld库存数",(long)storck]];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        }
            break;
            
            
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//手势
-(void)tapGRAction
{
    [self.Delegate   featureViewdismissVC];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
