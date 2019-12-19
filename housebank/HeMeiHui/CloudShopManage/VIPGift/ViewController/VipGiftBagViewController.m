//
//  VipGiftBagViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftBagViewController.h"
#import "VipGiltBagCollectionViewCell.h"
#import "VipGiftBagHeadView.h"
#import "VipGiftShopViewModel.h"
#import "EmptyModel.h"
#import "SpGoodsDetailViewController.h"
#import "VipGiftShopModel.h"
#import "VipGiftFotterView.h"
#import "VIPGiftSelectHeadView.h"
#import "VIPGiftSelectViewCell.h"
@interface VipGiftBagViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView     * giftCollectView;
@property (nonatomic, strong) VipGiftShopViewModel * shopViewModel;
@property (nonatomic, strong) NSMutableDictionary  * AllSectionDic;
@property (nonatomic, strong) NSArray * headArray;
@property (nonatomic, strong) NSMutableDictionary * selectDic;
@end

@implementation VipGiftBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.giftCollectView registerClass:[VipGiftBagHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.giftCollectView registerClass:[VipGiftFotterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"fotter"];
    [self.view addSubview:self.giftCollectView];
    
    @weakify(self);
    self.giftCollectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.shopViewModel load_AllRequestData]subscribeNext:^(NSMutableArray *x) {
            @strongify(self);
            if (x) {
                [self setCommonsSelectDic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.giftCollectView reloadData];
                });
            }
            [self.giftCollectView.mj_header endRefreshing];
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            [self.giftCollectView.mj_header endRefreshing];
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        }];
    }];
        
    [self.giftCollectView.mj_header beginRefreshing];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#101010"];
    [self.navigationController.navigationBar setHidden:YES];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"VIP礼包";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
       
    UIButton * item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item1];
    item1.frame = CGRectMake(kWidth-60, 0, 50, 50);
    item1.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item1 setImage:[UIImage imageNamed:@"cloud_tui"] forState:UIControlStateNormal];
    @weakify(self);
    [[item1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[self.shopViewModel load_shareRequest]subscribeNext:^(NSDictionary * x) {
            if (x) {
                NSDictionary *dic = @{
                                      @"shareDesc":objectOrEmptyStr([x objectForKey:@"shareDesc"]),
                                      @"shareImageUrl":[NSURL URLWithString:objectOrEmptyStr([x objectForKey:@"shareImageUrl"])],
                                      @"shareTitle":objectOrEmptyStr([x objectForKey:@"shareTitle"]),
                                      @"shareUrl":objectOrEmptyStr([x objectForKey:@"shareUrl"]),
                                      @"longUrl":@"",
                                      @"shareWeixinUrl":objectOrEmptyStr([x objectForKey:@"shareUrl"]),
                                      @"justUrl":@(YES)
                                      };
                [ShareTools  shareWithContent:dic];
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        }];
    }];
}

#pragma mark ----------- collectionView  Delegate . dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.shopViewModel.dataSource.count;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary * rowDic = self.shopViewModel.dataSource[section];
    NSArray * rowArray = rowDic.allValues;
    return rowArray.count;
}

// 取得当前分区的数据源
- (NSArray * )returnOwnSectionArray:(NSInteger)section {
    NSDictionary * rowDic = self.shopViewModel.dataSource[section];
    NSString * keys = rowDic.allKeys[0];
    // 进行分区判定
    NSArray * rowArray = rowDic.allValues[0];
    NSArray * itemArray;
    NSInteger index;
    if ([keys isEqualToString:@"silverArray"]) {
        index = [[self.AllSectionDic objectForKey:@"silverArray"] integerValue];
        itemArray = rowArray[index];
    }else if ([keys isEqualToString:@"platinumArray"]){
        index = [[self.AllSectionDic objectForKey:@"platinumArray"] integerValue];
        itemArray = rowArray[index];
    }else if ([keys isEqualToString:@"diamondsArray"]){
        index = [[self.AllSectionDic objectForKey:@"diamondsArray"] integerValue];
        itemArray = rowArray[index];
    }
    return  itemArray;
}

- (NSArray *)getSectionFirstArray:(NSInteger)section {
    NSDictionary * sectionDic = self.shopViewModel.dataSource[section];
    NSArray * rowArray = sectionDic.allValues[0];
    NSArray * itemArray = rowArray.copy;
    return itemArray;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"UICollectionCell";
    VIPGiftSelectViewCell * cell=  [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.shopViewModel.dataSource.count > indexPath.section) {
        NSArray * rowArray = [self getSectionFirstArray:indexPath.section];
        [cell setUpDataSouce:rowArray withSection:indexPath.section];
    }

    /** 下拉刷新之后 将滑到对应的位置*/
    NSString * keys = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSArray * scrollArray = [self.selectDic objectForKey:keys];
    [scrollArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * value = scrollArray[idx];
        if ([value isEqualToString:@"1"]) {
            if (cell.pageBlcok) {
                cell.pageBlcok(idx);
            }
        }
    }];
    
    @weakify(self);
    cell.scrolleBlock = ^(NSInteger index, NSInteger section) {
        @strongify(self);
        NSMutableArray * selectArray  = [[NSMutableArray alloc]init];
        selectArray = @[@"0",@"0",@"0"].mutableCopy;
//        [self.AllSectionDic setObject:[NSString stringWithFormat:@"%ld",index] forKey:sectionString];
        [selectArray replaceObjectAtIndex:index withObject:@"1"];
        [self.selectDic setObject:selectArray forKey:[NSString stringWithFormat:@"%ld",(long)section]];
        NSArray * itemArray = [self getSectionFirstArray:section];
        
        VipGiftBagHeadView * headViewnew = (VipGiftBagHeadView *) [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [headViewnew.headSelectView changeSelectBtnImage:self.selectDic withDataSource:itemArray];
    };
    
    cell.popNextBlock = ^(VipGiftShopModel * _Nonnull itemModel) {
        @strongify(self);
        if (itemModel) {
            SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
            SpGoodsDetailVC.productId=objectOrEmptyStr(itemModel.productID);
            SpGoodsDetailVC.isVipGiftPackage = YES;
            SpGoodsDetailVC.goodsType=DirectSupplyGoodsDetailStyle;
            [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
        }
    };

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * rowDic = self.shopViewModel.dataSource[indexPath.section];
    NSArray * rowArray = rowDic.allValues[0];
    NSArray * itemArray = rowArray[0]; // 取第一个数据为准
    if (itemArray.count%2==0){
        return CGSizeMake(kWidth-30, 252*(itemArray.count/2));
    }else {
        return CGSizeMake(kWidth-30, 252*(itemArray.count/2+1));
    }
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

//同一行两个cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(10, 15, 10, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - 头部视图大小
//第二步
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    /** 第一个区头需要配置广告图*/
    CGSize size;
    NSDictionary * rowDic = self.shopViewModel.dataSource[section];
    NSArray * rowArray = rowDic.allValues[0];
    /**看每个分区数据有几组，1组以上，那么将按钮显示出来，高度也得跟着变*/
    if (section == 0) {
        if (rowArray.count > 1) {
            size = CGSizeMake(kWidth, 287);
        }else {
            size = CGSizeMake(kWidth, 255);
        }
    }else {
        if (rowArray.count > 1) {
             size = CGSizeMake(kWidth, 87);
        }else {
             size = CGSizeMake(kWidth, 55);
        }
    }
    return size;
}

#pragma mark - 设置区尾高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    /** 最后的才添加区尾*/
    CGSize size;
    if (section == self.shopViewModel.dataSource.count-1) {
        size = CGSizeMake(kWidth, 945);
    }else {
        size = CGSizeMake(kWidth, 0);
    }
    return size;
}

#pragma mark - 头部视图内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    
    // 区头
    if (kind == UICollectionElementKindSectionHeader) {
        VipGiftBagHeadView * headView = (VipGiftBagHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        NSDictionary * itemDic = self.shopViewModel.dataSource[indexPath.section];
        if (itemDic) {
           [headView setHeadDic:itemDic withIndexPath:indexPath.section];}
        @weakify(self);
        NSArray * itemArray = [self getSectionFirstArray:indexPath.section];
        
        __weak VIPGiftSelectHeadView * selectView =  headView.headSelectView;
        [selectView changeSelectBtnImage:self.selectDic withDataSource:itemArray];
        
        /** 选择区头按钮后  刷新数据*/
       selectView.callHeadBlock = ^(NSInteger index, NSString * _Nonnull sectionString, NSInteger section) {
           @strongify(self);
           NSMutableArray * selectArray  = [[NSMutableArray alloc]init];
           selectArray = @[@"0",@"0",@"0"].mutableCopy;
           [self.AllSectionDic setObject:[NSString stringWithFormat:@"%ld",index] forKey:sectionString];
           [selectArray replaceObjectAtIndex:index withObject:@"1"];
           [self.selectDic setObject:selectArray forKey:[NSString stringWithFormat:@"%ld",section]];
          
           NSArray * itemArray = [self getSectionFirstArray:section];
           [selectView changeSelectBtnImage:self.selectDic withDataSource:itemArray];

           VIPGiftSelectViewCell * newSelectedCell = (VIPGiftSelectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
           if (newSelectedCell.pageBlcok) {
                newSelectedCell.pageBlcok(index);
           }
        };
        
        reusableView = headView;
    }
    
    // 区尾
    if (kind == UICollectionElementKindSectionFooter) {
        VipGiftFotterView *footerView = (VipGiftFotterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"fotter" forIndexPath:indexPath];
            reusableView = footerView;
    }
    return reusableView;
}

#pragma mark -- lazy load
- (UICollectionView *)giftCollectView {
    if (!_giftCollectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((kWidth-30),237);
        _giftCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, ScreenW, kHeight-STATUSBAR_NAVBAR_HEIGHT) collectionViewLayout:flowLayout];
        _giftCollectView.backgroundColor = [UIColor colorWithHexString:@"#100700"];
        _giftCollectView.dataSource = self;
        _giftCollectView.delegate = self;
        _giftCollectView.showsHorizontalScrollIndicator = NO;
        _giftCollectView.showsVerticalScrollIndicator = NO;
        [_giftCollectView registerClass:[VIPGiftSelectViewCell class] forCellWithReuseIdentifier:@"UICollectionCell"];
        _giftCollectView.pagingEnabled = NO;
    }
    return _giftCollectView;
}

- (VipGiftShopViewModel *)shopViewModel {
    if(!_shopViewModel) {
        _shopViewModel = [[VipGiftShopViewModel  alloc]init];
    }
    return _shopViewModel;
}

- (NSArray *)headArray {
    if(!_headArray) {
        _headArray = [NSArray array];
    }
   return _headArray;
}

- (NSMutableDictionary *)AllSectionDic {
    if (!_AllSectionDic) {
        NSDictionary *dic = @{
                              @"silverArray":@"0",
                              @"platinumArray":@"0",
                              @"diamondsArray":@"0"
                              };
        _AllSectionDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return _AllSectionDic;
}

- (void)setCommonsSelectDic {
    NSDictionary *dic = @{
                          @"0":@[@"1",@"0",@"0"],
                          @"1":@[@"1",@"0",@"0"],
                          @"2":@[@"1",@"0",@"0"],
                          };
    self.selectDic = [NSMutableDictionary dictionaryWithDictionary:dic];
}

- (NSMutableDictionary *)selectDic {
    if (!_selectDic) {
        NSDictionary *dic = @{
                              @"0":@[@"1",@"0",@"0"],
                              @"1":@[@"1",@"0",@"0"],
                              @"2":@[@"1",@"0",@"0"],
                              };
        _selectDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return _selectDic;
}
#pragma mark -- 上拉加载 和 下拉刷新之前的逻辑
//    @weakify(self);
//    self.giftCollectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [[self.shopViewModel loadVIPProductsShow]subscribeNext:^(NSMutableArray * x) {
//            @strongify(self);
//            if (x.count == 0) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.noContentImageName = @"SpType_search_noContent";
//                    self.noContentText = @"抱歉，这个星球找不到呢！";
//                    [self showNoContentView];
//                    [self.giftCollectView reloadData];
//                });
//            }else {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     @strongify(self);
//                     [self.giftCollectView reloadData];
//                 });
//            }
//            [self.giftCollectView.mj_footer resetNoMoreData];
//            [self.giftCollectView.mj_header endRefreshing];
//        } error:^(NSError * _Nullable error) {
//            @strongify(self);
//            NSString * errorString = [error.userInfo objectForKey:@"error"];
//            [SVProgressHUD showErrorWithStatus:errorString];
//            [self.giftCollectView.mj_header endRefreshing];
//        }];
//
//        [[self.shopViewModel load_requestHeadData]subscribeNext:^(NSDictionary * x) {
//            @strongify(self);
//            if (x) {
//                if ([x.allKeys containsObject:@"isModuleShow"]) {
//                    BOOL isShow;
//                    if ([[HFUntilTool EmptyCheckobjnil:[x objectForKey:@"isModuleShow"]] isEqualToString:@"true"]) {
//                        isShow = YES;
//                    }else {
//                        isShow = NO;
//                    }
//                    if (isShow) {
//                        if ([x.allKeys containsObject:@"items"]) {
//                            @strongify(self);
//                            self.headArray = [x objectForKey:@"items"];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [self.giftCollectView reloadData];
//                            });
//                        }
//                    }else {
//                        self.headArray = @[];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.giftCollectView reloadData];
//                        });
//                    }
//                }
//            }
//        } error:^(NSError * _Nullable error) {
//            NSString * errorString = [error.userInfo objectForKey:@"error"];
//            [SVProgressHUD showErrorWithStatus:errorString];
//        }];
//    }];
//
//    /** 上拉加载*/
//    self.giftCollectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self);
//        [[self.shopViewModel loadVIP_MoreProductsShow] subscribeNext:^(RACTuple * x) {
//            /** 取加载增加的数据*/
//            NSArray * addSource = x.first;
//            if (addSource.count == 0) {
//                [self.giftCollectView.mj_footer endRefreshing];
//                [self.giftCollectView.mj_footer endRefreshingWithNoMoreData];
//                return;
//            }
//            /** 总数据*/
//            NSMutableArray * dataSource = x.last;
//            if (dataSource.count > 0 && dataSource) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.giftCollectView reloadData];
//                    [self.giftCollectView.mj_footer endRefreshing];
//                });
//            }
//        } error:^(NSError * _Nullable error) {
//            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
//            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
//        }];
//    }];
//
//    [self.giftCollectView.mj_header beginRefreshing];
@end
