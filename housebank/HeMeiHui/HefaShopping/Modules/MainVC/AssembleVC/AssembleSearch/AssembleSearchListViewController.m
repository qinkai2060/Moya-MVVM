//
//  AssembleSearchListViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleSearchListViewController.h"
#import "AssembleSearchListMainView.h"
#import "AssembleSearchViewController.h"
#import "SpTypesSearchNoContentMainView.h"


@interface AssembleSearchListViewController ()<searchTopViewDelegate,SpTypeSearchListDelegate,AssembleCateorySearchViewDelegate> //

@property (nonatomic, strong) AssembleSearchListMainView *listMainView;
@property (nonatomic, strong) NSMutableArray *listDataSource;
@property (nonatomic, assign) NSInteger currrentPage;

@property (nonatomic, strong) SpTypesSearchNoContentMainView *searchNoContentView;

@property (nonatomic, strong) NSString *totalNum;
// 1 低到高  2 高到低
@property (nonatomic, strong) NSString *salesNum;
// 1 低到高  2 高到低
@property (nonatomic, strong) NSString *priceNum;

@property (nonatomic, strong) NSString *cityId;

@end
@implementation AssembleSearchListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    // 默认选中综合
    if (self.isFristIn) {
        self.totalNum = @"2";
    }
    
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.isFristIn = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.listDataSource = [NSMutableArray arrayWithCapacity:1];
    [self createView];
    
    //    [self createNoContentView];
}

- (void)getListRequest{
    NSString *classIdStr = [NSString stringWithFormat:@"%@",self.classId];
    if (classIdStr.length <= 0 || [classIdStr isEqualToString:@" "]) {
        classIdStr = @"";
    }
    NSString *levelStr = [NSString stringWithFormat:@"%@",self.level];
    if (levelStr.length <= 0 || [levelStr isEqualToString:@" "]) {
        levelStr = @"";
    }
    if (!self.totalNum) {
        self.totalNum = @"";
    }
    if (!self.priceNum) {
        self.priceNum = @"";
    }
    if (!self.salesNum) {
        self.salesNum = @"";
    }
    if (!self.cityId) {
        self.cityId = @"";
    }
    
    if (!self.searchStr) {
        self.searchStr = @"";
    }
    NSDictionary *reqDic = @{
                             @"pageNo":[NSNumber numberWithInteger:_currrentPage],
                             @"pageSize":@20,
                             @"keyword":self.searchStr,
                             @"minPrice":@0,
                             @"maxPrice":@0,
                        @"orderByCombinationScore":self.totalNum,//综合得分 （1：升序，2：降序）
//                             @"orderByNewGoods":self.totalNum, // 新品优先：按照发布日期排序（1：升序，2：降序）
                             @"orderBySalesCount":self.salesNum, // 销量：按照销量排序（1：升序，2：降序）
                             @"orderByPrice":self.priceNum, // 售价：按照售价排序（1：升序，2：降序）
                             @"cityId":self.cityId,
                             @"level":levelStr, // 商品分类级别
                             @"classId":classIdStr,
                             @"promotionType":@"2",
        
                             };
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"search.mall/promotion/search"];
    if (getUrlStr) {
        getUrlStr =getUrlStr;
    }
    [self requestDataWithUrl:getUrlStr requestDic:reqDic];
}

- (void)refreshData {
    _currrentPage = 1;
    [self getListRequest];
    
    self.listMainView.searchView.searchTextField.text = self.searchStr;
}

- (void)loadMoreData {
    _currrentPage ++;
    [self getListRequest];
}

- (void)createView{
    //
    self.listMainView = [[AssembleSearchListMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit) withSearchStr:self.searchStr];
    [self.view addSubview:self.listMainView];
    // ScreenH - self.statusHeghit - self.buttomBarHeghit - 44
    
    self.listMainView.searchView.delegate = self;
    self.listMainView.topView.delegate = self;
    self.listMainView.delegate = self;
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    self.listMainView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    self.listMainView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
}

- (void)createNoContentView{
    self.searchNoContentView = [[SpTypesSearchNoContentMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit)];
    [self.view addSubview:self.searchNoContentView];
    
    self.searchNoContentView.assembleSearchView.delegate = self;
    self.searchNoContentView.topView.delegate = self;
}

#pragma mark topBtnDelegate ======
/**
 四个按钮的点击事件 btnTag为当前所选中的按钮的tag
 numState 为销量的状态值 当tag为销量时 此值有效
 priceState 为价格的状态值 当tag为价格时 此值有效
 */
- (void)topBtnClickWithTag:(NSInteger)btnTag numState:(BOOL)numState priceState:(BOOL)priceState{
    if (btnTag ==0) { // 新品
        self.totalNum = @"2";
        self.salesNum = @"";
        self.priceNum = @"";
        self.cityId = self.cityId;
    } else if (btnTag == 1){ // 销量
        self.totalNum = @"";
        self.priceNum = @"";
        self.cityId = self.cityId;
        if (numState) {
            //            NSLog(@"销量 down down down");
            self.salesNum = @"2";
        } else {
            //            NSLog(@"销量 up up up");
            self.salesNum = @"1";
        }
    } else if (btnTag == 2){ // 价格
        self.totalNum = @"";
        self.salesNum = @"";
        self.cityId = self.cityId;
        
        if (priceState) {
            self.priceNum = @"2";
        } else {
            self.priceNum = @"1";
        }
    } else if (btnTag == 3){ // 发货地
        //        STShoppingAddressViewController *addVC = [[STShoppingAddressViewController alloc] init];
        //        [self.navigationController pushViewController:addVC animated:YES];
        
        ZJCityViewControllerOne *vc = [[ZJCityViewControllerOne alloc] initWithDataArray:nil withType:2];
        __weak typeof(self) weakSelf = self;
        [vc setupCityCellClickHandler:^(FindRegionsModel *model) {
            //NSLog(@"选中的城市是: %@", model.name);
            self.cityId = model.id;
            
            [self refreshData];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [self refreshData];
}

#pragma searchDelegate  ======
// 返回按钮的点击事件
- (void)backBtnClick{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SpAssembleViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tabelviewCell点击事件
- (void)searchListCellDidSelectRowAtIndexWithModel:(SearchListModel *)model{
    NSLog(@"%@",model);
    SearchListModel *dataItem=model;
    if (dataItem.endDate) {//结束日期有值
        self.spacEndDateTime=[NSString stringWithFormat:@"%ld",(long)dataItem.endDate];
        self.spacStarDateTime=[NSString stringWithFormat:@"%ld",(long)dataItem.startDate];
        //  设置倒计时时间
        NSString *nowTime=[MyUtil getNowTimeTimestamp3];
        self.spaceTime=[MyUtil compareTwoTime:self.spacEndDateTime time2:nowTime];
        self.starSpaceTime=[MyUtil compareTwoTime:nowTime time2:self.spacStarDateTime];
    }
    if ([self.spaceTime integerValue]>0&&[self.starSpaceTime integerValue]>0) {//活动中
        AssembleGoodDetailViewController *vc = [[AssembleGoodDetailViewController alloc] initWithModel:model];
        vc.assembleStyle=AssembleDetailStyle;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([self.spaceTime integerValue]<=0) {//已结束
        SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
        vc.productId= [NSString stringWithFormat:@"%ld",(long) dataItem.productId ];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([self.starSpaceTime integerValue]<0) {//即将开始
        AssembleGoodDetailViewController *vc = [[AssembleGoodDetailViewController alloc] initWithModel:model];
        vc.assembleStyle=AssembleDetailStyle;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

#pragma mark // cell上 进店按钮的点击事件
- (void)searchListToShopBtnClickWithModel:(SearchListModel *)model{
    if (!self.isLogin) {
        return;
    }
    ShopListViewController *shopVC = [[ShopListViewController alloc] init];
    shopVC.detailModel = [[GoodsDetailModel alloc] init];
    shopVC.detailModel.data = [[ProductDetail alloc] init];
    shopVC.detailModel.data.product = [[Product alloc] init];
//    shopVC.detailModel.data.product.shopId = [model.shopsId integerValue];
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark // 搜索按钮的点击事件 此处是跳转
- (void)searchBtnClick{
    AssembleSearchViewController *searchVC = [[AssembleSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

// 右侧消息按钮的点击事件
//- (void)searchRightBtnClick:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        [btn setImage:[UIImage imageNamed:@"spTypes_search_list"] forState:UIControlStateNormal];
//    } else {
//        [btn setImage:[UIImage imageNamed:@"spTypes_search_collection"] forState:UIControlStateNormal];
//    }
//}

#pragma mark 数据请求 =====get=====
- (void)requestDataWithUrl:(NSString *)urlStr requestDic:(NSDictionary *)dic{
    [self.listMainView.collectionView.mj_header endRefreshing];
    [self.listMainView.collectionView.mj_footer endRefreshing];
    [HFCarShoppingRequest requestURL:urlStr baseHeaderParams:nil requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
//             self.searchListModel=[[AssembleSearchListModel alloc]initWithDictionary:dict error:nil];
            self.searchListModel = [AssembleSearchListModel modelWithJSON:dict];
            [self getSeconddata:dict];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (self.listDataSource.count > 0) {
            [self.listDataSource removeAllObjects];
        }
        [self.listMainView.collectionView reloadData];
        
        self.noContentImageName = @"SpType_search_noContent";
        self.noContentText = @"抱歉，这个星球找不到呢！";
        [self showNoContentView];
    }];
}
// 列表
- (void)getSeconddata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        [self hideNoContentView];
        NSDictionary *dataDic = resDic[@"data"];
        if (_currrentPage == 1) {
            if (self.listDataSource.count > 0) {
                [self.listDataSource removeAllObjects];
            }
        }
       
        for (SearchListModel *model in self.searchListModel.data) {
            [self.listDataSource addObject:model];
        }
        
        if (self.listDataSource.count > 0) {
            [self hideNoContentView];
            [self.listMainView refreshViewWithData:self.listDataSource];
        } else {
            self.noContentImageName = @"SpType_search_noContent";
            self.noContentText = @"抱歉，这个星球找不到呢！";
            [self showNoContentView];
            [self.listMainView refreshViewWithData:self.listDataSource];
        }
    } else {
        if (self.listDataSource.count > 0) {
            [self.listDataSource removeAllObjects];
        }
        [self.listMainView.collectionView reloadData];
        
        self.noContentImageName = @"SpType_search_noContent";
        self.noContentText = @"抱歉，这个星球找不到呢！";
        [self showNoContentView];
    }
}


@end
