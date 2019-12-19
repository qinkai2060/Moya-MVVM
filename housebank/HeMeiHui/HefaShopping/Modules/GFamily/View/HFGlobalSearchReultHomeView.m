//
//  HFGlobalSearchReultHomeView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobalSearchReultHomeView.h"
#import "HFSelectConditionsView.h"
#import "HFGlobalFamilyViewModel.h"
#import "HFGlobalFamilyCell.h"
#import "HFFilterBoxBaseView.h"
#import "HFFilterRecommendModel.h"
#import "HFFilterBedTypeModel.h"
#import "HFFilterLocationModel.h"
#import "HFFilterPriceModel.h"
#import "HFTableViewnView.h"
#import "HFConfitionIndexPath.h"

@interface HFGlobalSearchReultHomeView ()<UITableViewDelegate,UITableViewDataSource,HFSelectConditionsViewDelegate,HFFilterBoxBaseViewDelegate>
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@property(nonatomic,strong)HFSelectConditionsView *conditionView;
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,assign)BOOL isload;
@property(nonatomic,strong)NSArray<HFHotelDataModel*> *dataSource;
@property (nonatomic, strong) NSMutableArray<HFShowFilterModel*> *conditionArray;
@property (nonatomic, strong) NSMutableArray *symbolArray;
@end
@implementation HFGlobalSearchReultHomeView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.conditionArray = [NSMutableArray array];
    self.symbolArray = [NSMutableArray array];
    [self conditionArrayData];
    [self addSubview:self.conditionView];
    [self addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}
//- (NSMutableArray *)symbolArray {
//    if (!_symbolArray) {
//        _symbolArray = [NSMutableArray array];
//    }
//    return _symbolArray;
//}
- (void)hh_bindViewModel {
    @weakify(self)
    self.conditionView.frame = CGRectMake(0, 0, ScreenW, 44);
    self.tableView.frame = CGRectMake(0, self.conditionView.bottom, ScreenW, self.height-44);
    [self.viewModel.hotelDataSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if ([x isKindOfClass:[NSArray class]]) {
            if (self.viewModel.pageNo == 1) {
                if (((NSArray*)x).count>0)  {
                    [self.tableView haveData];
                    NSArray *dataArray = (NSArray*)x;
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
                    [array removeAllObjects];
                    [array addObjectsFromArray:dataArray];
                    self.dataSource = array;
               
                }else {
                  NSArray *dataArray = (NSArray*)x;
                   self.dataSource = dataArray;
                    
                }
                [self.tableView reloadData];
                if (self.dataSource.count == 0) {
                    [self.tableView setErrorImage:erroImageStr text:@"抱歉,这个星球找不到呢!"];
                }
            }else {
              
                NSArray *dataArray = (NSArray*)x;
                if (dataArray.count > 0) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
                    [array addObjectsFromArray:dataArray];
                    self.dataSource = array;
                    [self.tableView reloadData];
                }else {
                    if (self.viewModel.pageNo >=0) {
                        self.viewModel.pageNo--;
                    }else {
                        self.viewModel.pageNo = 1;
                    }
                }
            }

        }
        if ([x isKindOfClass:[NSNumber class]]) {
            if (self.dataSource.count == 0) {
                [self.tableView setErrorImage:erroImageStr text:@"抱歉,这个星球找不到呢!"];
            }
        }
        self.isload= NO;
    }];
     [self.viewModel.getKeyWordSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self)
         if ([x isKindOfClass:[NSString class]]) {
             NSString *text = x;
             if (text.length > 0) {
                 
                 if ([[NSUserDefaults standardUserDefaults] objectForKey:@"historyKey"]) {
                     NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyKey"]];
                     [tempArray  addObject:text];
                     [[NSUserDefaults standardUserDefaults] setObject: tempArray forKey:@"historyKey"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                 }else {
                     NSMutableArray *temArray = [NSMutableArray arrayWithObject:text];
                     [[NSUserDefaults standardUserDefaults] setObject: temArray forKey:@"historyKey"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 
                 
             }
              self.viewModel.keyword = x;
             self.viewModel.pageNo = 1;
             [self.viewModel.getHotelDataCommand execute:nil];
         }
        
     }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (!self.isload) {
            
            [self reloadFooterMoreData];
        }
        
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (!self.isload) {
            self.viewModel.pageNo=1;
            [self reloadMoreData];
        }
        
    }];
    [self.viewModel.regionDataSubjc subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass: [NSArray class]]) {
            for (int i = 0; i < self.conditionArray.count; i ++) {
                if (i == 1) {
                    HFShowFilterModel *model = self.conditionArray[i];
                    HFFilterLocationModel *smodel = (HFFilterLocationModel*)model.dataSource[1];
                    smodel.dataSource = (NSArray*)x;
                    self.viewModel.regionId = @"";
                    model.viewHight = model.dataSource.count *45+45+50;
                    CGFloat maxHeight = 0;
                    for (HFFilterLocationModel *pmodel in model.dataSource ) {
                        maxHeight = MAX(model.viewHight, (8*45+45+50));
                    }
                    model.viewHight = maxHeight;
                    [self.conditionArray replaceObjectAtIndex:i withObject:model];
                    break;
                }
            }
        }
    }];
    
}
- (void)reloadFooterMoreData {
    self.isload = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.viewModel.pageNo++;
    [self.viewModel.getHotelDataCommand execute:nil];
}
- (void)reloadMoreData {
    self.isload = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.viewModel.getHotelDataCommand execute:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFGlobalFamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HFGlobalFamilyCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataSource[indexPath.row];
    [cell doMessageSommthing];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     HFHotelDataModel *model = self.dataSource[indexPath.row];
    [self.viewModel.didDetailSubjc sendNext:model];
}
- (void)selectConditionView:(HFSelectConditionsView *)conditionView didSelectBtnType:(HFShowFilterModelType)didType {
        HFFilterPriceModel *model = (HFFilterPriceModel*)[self.conditionArray firstObject];
        model.minfloat = self.viewModel.minPrice;
        model.maxfloat = (self.viewModel.maxPrice.length == 0 ||[self.viewModel.maxPrice isEqualToString:@"不限"] ) ?@"不限":self.viewModel.maxPrice;
        HFFilterPriceModel *first = (HFFilterPriceModel*)[model.dataSource firstObject];
        first.minfloat = self.viewModel.minPrice;
        first.maxfloat = (self.viewModel.maxPrice.length == 0 ||[self.viewModel.maxPrice isEqualToString:@"不限"] ) ?@"不限":self.viewModel.maxPrice;

        for (HFFilterPriceModel *smallModel in [[model.dataSource firstObject] dataSource]) {
            if ([smallModel.minfloat isEqualToString:first.minfloat]&&[smallModel.maxfloat isEqualToString:first.maxfloat]) {
                smallModel.isSelected = YES;
            }else {
                smallModel.isSelected = NO;
            }
        }
        [self.conditionArray replaceObjectAtIndex:0 withObject:model];
    HFFilterBoxBaseView *boxBaseView = [self.symbolArray firstObject];
    if (didType == boxBaseView.model.type) {
        [boxBaseView dismiss];
        [self.symbolArray removeAllObjects];
        return;
    }
    if (self.symbolArray.count) {
        [boxBaseView dismiss];
        [self.symbolArray removeAllObjects];
    }
    if (didType>=1000) {
        HFShowFilterModel *model = self.conditionArray[didType-1000];
        HFFilterBoxBaseView *boxBaseView = NULL;
        Class renderClass  =  [HFFilterBoxBaseView getRenderClassByMessageType:model.type];
        boxBaseView = [[renderClass alloc] initWithFilter:model];
        boxBaseView.delegate = self;
        [boxBaseView popupViewFromSourceFrame:self.conditionView.frame completion:^{
            
        }];
        [self.symbolArray addObject:boxBaseView];
    }
}
- (void)popupView:(HFFilterBoxBaseView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index isDelete:(BOOL)isDelete{
    if (popupView.isDelete == YES) {
        [self.conditionView clearBtnState];
    }
    if (isDelete) {
        [self.symbolArray removeAllObjects];
    }

    if (index == 1000) {

        HFShowFilterModel *model = self.conditionArray[index-1000];
        HFFilterPriceModel *pModel = [array firstObject];
        self.viewModel.maxPrice = [pModel.maxfloat isEqualToString:@"不限"] ?@"不限":pModel.maxfloat;
        self.viewModel.minPrice = pModel.minfloat.length == 0 ?@"": pModel.minfloat;
        self.viewModel.star = pModel.starSelect;

    }else if ( index == 1001) {
        HFShowFilterModel *model = self.conditionArray[index-1000];
        HFConfitionIndexPath *indexPath = [array firstObject];
        HFConfitionIndexPath *indexPathlast = [array lastObject];
        self.viewModel.distance = model.dataSource[indexPath.firstPath].dataSource[indexPath.secondPath].codeTile;
        HFFilterLocationModel *location =   (HFFilterLocationModel*)model.dataSource[indexPathlast.firstPath].dataSource[indexPathlast.secondPath];
        if (location.regionId == 0) {
             self.viewModel.regionId =@"";
        }else {
             self.viewModel.regionId =[NSString stringWithFormat:@"%ld",location.regionId];
        }
        NSLog(@"");
    }else if(index == 1002) {
        HFShowFilterModel *model = self.conditionArray[index-1000];
        HFConfitionIndexPath *indexPath = [array firstObject];
        HFConfitionIndexPath *indexPathlast = [array lastObject];
        self.viewModel.bedType = model.dataSource[indexPath.firstPath].dataSource[indexPath.secondPath].codeTile;
        self.viewModel.breakfastType = model.dataSource[indexPathlast.firstPath].dataSource[indexPathlast.secondPath].codeTile;
        NSLog(@"");
    }else {
        HFShowFilterModel *model = self.conditionArray[index-1000];
        HFConfitionIndexPath *indexPath = [array firstObject];
        self.viewModel.orderByType = model.dataSource[indexPath.firstPath].codeTile;
        
    }
    self.viewModel.pageNo=1;
    [self reloadMoreData];

}
- (void)conditionArrayData {
    [self.conditionArray  addObject:[HFFilterPriceModel priceStarData]];
    [self.conditionArray  addObject:[HFFilterLocationModel locationData]];
    [self.conditionArray  addObject:[HFFilterBedTypeModel bedData]];
    [self.conditionArray  addObject:[HFFilterRecommendModel recommendData]];
}
- (HFSelectConditionsView *)conditionView {
    if (!_conditionView) {
        _conditionView = [[HFSelectConditionsView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45) WithViewModel:self.viewModel];
        _conditionView.delegate = self;
    }
    return _conditionView;
}
- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, self.conditionView.bottom, ScreenW, self.height - 45) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFGlobalFamilyCell class] forCellReuseIdentifier:NSStringFromClass([HFGlobalFamilyCell class])];
    }
    return _tableView;
}
@end
