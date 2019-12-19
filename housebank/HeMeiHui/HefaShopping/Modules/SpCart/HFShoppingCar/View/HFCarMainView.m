//
//  HFCarMainView.m
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarMainView.h"
#import "HFCarSectionHeaderView.h"
#import "HFTableViewCarBaseCell.h"
#import "HFCarEmptyGoodsView.h"
#import "HFFinalPriceView.h"
#import "HFCarViewModel.h"
#import "HFKeyBordView.h"
#import "HFCarGoodsCell.h"
#import "HFCarOutStockGoodsCell.h"
#import "HFAlertView.h"
@interface HFCarMainView () <UITableViewDataSource,UITableViewDelegate,HFTableViewCarBaseCellDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) HFCarEmptyGoodsView *emptyView;
@property(nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) HFFinalPriceView *finalPriceView;
@property (nonatomic,strong) HFCarViewModel *viewModel;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) NSMutableArray *editingSelectArray;
@property (nonatomic,assign) NSInteger total;
@property (nonatomic,assign) NSInteger losetotal;
@property (nonatomic,assign) NSInteger outNocktotal;
@property (nonatomic,assign) NSInteger editingtotal;
@property (nonatomic,assign) CGFloat totalPrice;

@property (nonatomic,assign) BOOL isSure;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) HFKeyBordView *keybordView;
@end

@implementation HFCarMainView
- (instancetype)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {

    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.emptyView];
    [self addSubview:self.tableView];
    [self addSubview:self.finalPriceView];
    [self.finalPriceView setPrice:0.0];
    [self emptySwitch:self.viewModel.dataSource];
    [self addSubview:self.coverView];
    [self addSubview:self.keybordView];
}
- (void)emptySwitch:(NSArray*)dataSource {

    self.tableView.hidden = !dataSource.count; //!self.viewModel.dataSource.count;
   

    if(dataSource.count == 0 || self.total == 0) {
        self.finalPriceView.hidden = YES;//!self.viewModel.dataSource.count;
        self.isEditing = NO;
        [self.finalPriceView isEditing:NO];
        [self.finalPriceView clearState:YES];
        [self.editingSelectArray removeAllObjects];
        [self.finalPriceView isSelected:NO isEnabled:YES];
        [self.viewModel.resetEditingButtonStateSubjc sendNext:nil];
    }else {
        self.finalPriceView.hidden = NO;//
    }
 
    if (self.total < 0) {
        self.finalPriceView.hidden = YES;
        self.isEditing = NO;
        [self.finalPriceView isEditing:NO];
        [self.finalPriceView clearState:YES];
        [self.editingSelectArray removeAllObjects];
        [self.finalPriceView isSelected:NO isEnabled:YES];
        [self.viewModel.resetEditingButtonStateSubjc sendNext:nil];
        
    }
  
    
}
- (void)hh_bindViewModel {
    [self editingEnd];
    [self resetSelect];
    @weakify(self)
    [self.viewModel.editingSelectSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIButton *tempBtn = (UIButton*)x;
        [self resetState:tempBtn.selected];
        [self.tableView reloadData];
    }];
    [self.viewModel.editShopCountSubkjc subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
        if([x integerValue] !=1) {
            [MBProgressHUD showAutoMessage:@"修改数量失败"];
        }
    }];
    [self.viewModel.quickDeleteSubjc subscribeNext:^(id  _Nullable x) {
        [HFAlertView showAlertViewType:HFAlertViewTypeNone  title:@"确定删除选中商品吗?" detailString:@"" cancelTitle:@"取消" cancelBlock:^(HFAlertView *view){
            
        } sureTitle:@"确定" sureBlock:^(HFAlertView *view){
            HFShopingModel *model = (HFShopingModel*)x;
            for (HFStoreModel *stormodel in model.productList) {
                [self.editingSelectArray addObject:stormodel];
            }
            self.viewModel.shopID = [self ids];
            [self.viewModel.editDeleteCommand execute:nil];
        }];
      
    }];
    [self.viewModel.deleteSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        if ([self ids].length == 0) {
            [MBProgressHUD showAutoMessage:@"请选择商品"];
        }else {
            [HFAlertView showAlertViewType:HFAlertViewTypeNone  title:@"确定删除选中商品吗?" detailString:@"" cancelTitle:@"取消" cancelBlock:^(HFAlertView *view){
                
            } sureTitle:@"确定" sureBlock:^(HFAlertView *view){
                self.viewModel.shopID = [self ids];
                [self.viewModel.editDeleteCommand execute:nil];
            }];
          
        }

        NSLog(@"");
    }];
    [self.viewModel.favSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([self favids].length == 0) {
            [MBProgressHUD showAutoMessage:@"请选择商品"];
        }else {
            self.viewModel.ProductID = [self favids];
            self.viewModel.cardID = [self ids];
            [self.viewModel.editFavCommand execute:nil];
        }
     
    }];
    [self.viewModel.getCarInfo subscribeNext:^(id  _Nullable x) {
        @strongify(self);
            self.total = 0;
            self.losetotal = 0;
            self.outNocktotal = 0;
            self.editingtotal = 0;
            [self.selectArray removeAllObjects];
            [self.editingSelectArray removeAllObjects];
            self.emptyView.hidden = ((NSArray*)x).count;
     
            for (HFShopingModel *shoppIngModel in (NSArray*)x) {

                    self.total += shoppIngModel.totalShoppingCount;
                    self.editingtotal += shoppIngModel.totalShoppingCount;
            
                    self.outNocktotal += shoppIngModel.outStockCount;
                    self.losetotal   += shoppIngModel.loseCount;
                shoppIngModel.isEditing = self.isEditing;
                shoppIngModel.EditingSectionSelected = NO;
                for (HFStoreModel *storeModel in shoppIngModel.productList) {
                    storeModel.editing =  shoppIngModel.isEditing;
                    storeModel.editingRowSelected = NO;
                }
                
            }
            [self emptySwitch:((NSArray*)x)];
            [self.tableView reloadData];
        
    }];
    [self.viewModel.allSelectSubjc subscribeNext:^(id  _Nullable x) {
    
        if ([x isEqualToString:@"全不选"]) {
            if (self.isEditing) {
                 [self.editingSelectArray removeAllObjects];
            }else {
                 [self.selectArray removeAllObjects];
            }
            for (HFShopingModel *shopmodel in self.viewModel.dataSource) {
                if (self.isEditing) {
                    shopmodel.EditingSectionSelected = YES;
                }else {
                    shopmodel.isSectionSelected = YES;
                }
                
                for (HFStoreModel *storModel in shopmodel.productList) {
                    if (self.isEditing) {
                         storModel.editingRowSelected = YES;
                    }else {
                        storModel.isRowSelected = YES;
                    }
                    if (storModel.status != 1 && storModel.ContentMode != HFCarListTypeNoneStock && storModel.ContentMode != HFCarListTypeOverTime  ) {
                        if (self.isEditing) {
                            [self.editingSelectArray addObject:storModel];
                        }else{
                             [self.selectArray addObject:storModel];
                          
                        }
                    }
                }
            }
        }else {
            if (self.isEditing) {
                 [self.editingSelectArray removeAllObjects];
         
            }else {
                      [self.selectArray removeAllObjects];
            }
            for (HFShopingModel *shopmodel in self.viewModel.dataSource) {
                if (self.isEditing) {
                      shopmodel.EditingSectionSelected = NO;
                }else {
                     shopmodel.isSectionSelected = NO;
                }
              
                for (HFStoreModel *storModel in shopmodel.productList) {
                    if (self.isEditing) {
                         storModel.editingRowSelected = NO;
                    }else {
                         storModel.isRowSelected = NO;
                    }
                }
            }
        }
        [self.tableView reloadData];
    }];
  
    [self.viewModel.plusSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        if ([x isKindOfClass:[HFCarGoodsCell class]]) {
            NSIndexPath *indexpath = [self.tableView indexPathForCell:(HFCarGoodsCell*)x];
            HFShopingModel *shopModel = self.viewModel.dataSource[indexpath.section];
            HFStoreModel *storModel =  shopModel.productList[indexpath.row];
            storModel.shoppingCount++;
            if (storModel.purchaseLimitation !=0) {

                if ( storModel.shoppingCount< storModel.purchaseLimitation ) {
                    if (storModel.isRowSelected) {
                        [self.finalPriceView setPrice:[self.finalPriceView nowPrice]+storModel.pricePrice.cashPrice];
                    }
          
                }else {
                    [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"不能大于限购数量%ld件",storModel.purchaseLimitation]];
                    storModel.shoppingCount = storModel.purchaseLimitation;
                }
            }else {
                if (storModel.shoppingCount > storModel.stock ) {
                    [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"购买数量超出库存数%ld件",storModel.stock]];
                    storModel.shoppingCount = storModel.stock;
                    
              
                }else {
                    if ( storModel.shoppingCount > storModel.stock) {
                        if (storModel.isRowSelected) {
                            [self.finalPriceView setPrice:[self.finalPriceView nowPrice]+storModel.pricePrice.cashPrice];
                            
                        }
                    }
               
                }
            }
            self.viewModel.productId = storModel.storeId;
            self.viewModel.count = storModel.shoppingCount;
            [self.viewModel.editShopCountCommand execute:nil];
            [self.tableView reloadData];
        }
    }];//enterCommitPayMent
    [self.viewModel.enterCommitPayMent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.getCardDetialCommand execute:nil];
    }];
    [self.viewModel.minSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        if ([x isKindOfClass:[HFCarGoodsCell class]]) {
            NSIndexPath *indexpath = [self.tableView indexPathForCell:(HFCarGoodsCell*)x];
            HFShopingModel *shopModel = self.viewModel.dataSource[indexpath.section];
            HFStoreModel *storModel =  shopModel.productList[indexpath.row];
            storModel.shoppingCount--;
            if (storModel.isRowSelected) {
                [self.finalPriceView setPrice:[self.finalPriceView nowPrice]-storModel.pricePrice.cashPrice];
            }
            self.viewModel.productId = storModel.storeId;
            self.viewModel.count = storModel.shoppingCount;
            [self.viewModel.editShopCountCommand execute:nil];
            [self.tableView reloadData];
            
        }
    }];
    self.keybordView.sBlock = ^{
        @strongify(self);
        self.isSure = YES;
        [self endEditing:YES];
    };
    self.keybordView.cBlock = ^{
        @strongify(self);
        self.isSure = NO;
        [self endEditing:YES];
    };
    self.finalPriceView.didPayBlock = ^{
         @strongify(self);
        NSMutableArray *shoppingcartIdArr = [NSMutableArray array];
        NSMutableArray *commodityIdArr = [NSMutableArray array];
        for (HFStoreModel *model in self.selectArray) {
            [shoppingcartIdArr addObject:model.storeId];
            [commodityIdArr addObject:model.productId];
        }
        NSString *shoppingcartId = [shoppingcartIdArr componentsJoinedByString:@","];
        NSString *commodityId = [commodityIdArr componentsJoinedByString:@","];
        NSArray *parmeArr = @[shoppingcartId,commodityId];
        [self.viewModel.enterCommitPayMent sendNext:parmeArr];
    };
    [self notifaction];
}
- (void)resetSelect {
    @weakify(self);
    [self.viewModel.resetNetworkSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x integerValue] == 1) {
            [self.viewModel.getCardDetialCommand execute:nil];
        }else {
            [MBProgressHUD showAutoMessage:@"添加失败"];
        }
        
    }];

}
- (void)editingEnd {
     @weakify(self)
    [self.viewModel.endEditingSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (![x isEqualToString:@"请求失败"]) {
            [MBProgressHUD showAutoMessage:x];
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewModel.dataSource];
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:self.editingSelectArray];
            
            for (HFShopingModel *shoppModel in self.viewModel.dataSource) {
                NSInteger numCount = 0;
                NSMutableArray *productarray = [NSMutableArray arrayWithArray:shoppModel.productList];
                for (HFStoreModel *shoppIngStoreModel in shoppModel.productList) {
                    
                    for (HFStoreModel *editingStoreModel in arrayTemp) {
                        if ([editingStoreModel.storeId isEqualToString:shoppIngStoreModel.storeId]) {
                            if ([self.selectArray containsObject:editingStoreModel]) {
                                [self.selectArray removeObject:editingStoreModel];
                            }
                            [self.editingSelectArray removeObject:editingStoreModel];
                            
                            if (editingStoreModel.ContentMode == HFCarListTypeOverTime) {
                                self.losetotal--;
                            }else if (editingStoreModel.ContentMode == HFCarListTypeNoneStock) {
                                self.outNocktotal--;
                            }else {
                                self.editingtotal--;
                                self.total --;
                                NSLog(@"熟悉的%ld",self.total);
                            }
                            [productarray removeObject:shoppIngStoreModel];
                        }
                    }
                    if(shoppIngStoreModel.status !=2){
                        numCount ++;
                    }
                }
                
                shoppModel.totalShoppingCount = numCount;
                if(productarray.count != 0) {
                    shoppModel.productList = productarray;
                    shoppModel.totalShoppingCount = shoppModel.productList.count;
                    
                }else {
                    [array removeObject:shoppModel];
                }
                
            }
            self.viewModel.dataSource = array;
            [self.tableView reloadData];
            self.emptyView.hidden = self.viewModel.dataSource.count;
            [self emptySwitch:self.viewModel.dataSource];
            [self.viewModel.deleteFavEndingSubjc sendNext:self.viewModel.dataSource];
        }else {
            [MBProgressHUD showAutoMessage:x];
        }
        
    }];
}
- (void)resetState:(BOOL)isSelected {
    self.isEditing = isSelected;
    for (HFShopingModel *model in self.viewModel.dataSource) {
        model.isEditing = self.isEditing;
        model.EditingSectionSelected = NO;
        for (HFStoreModel *storeModel in model.productList) {
            storeModel.editing =  model.isEditing;
            storeModel.editingRowSelected = NO;
        }
    }
    if (self.isEditing) {
        [self.finalPriceView clearState:YES];
        [self.editingSelectArray removeAllObjects];
        [self.finalPriceView isSelected:NO isEnabled:YES];
    }else {
        [self.finalPriceView isSelected:(self.total==self.selectArray.count) isEnabled:self.selectArray.count];
    }
}

- (void)notifaction {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillHide:(NSNotification*)noti {
    [UIView animateWithDuration:0.25 animations:^{
     self.keybordView.frame = CGRectMake(0, self.height-50, ScreenW, 50);
        self.keybordView.hidden = YES;
        self.coverView.hidden = YES;
    } completion:^(BOOL finished) {

        
    }] ;
}
- (void)keyboardWillShow:(NSNotification*)noti {
    NSLog(@"键盘r弹出");
    NSDictionary *info = [noti userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keybordView.hidden = NO;
    self.coverView.hidden = NO;
    CGFloat tabBarH = IS_iPhoneX ?34 :0;
    CGFloat offetY = ScreenH- endKeyboardRect.origin.y-tabBarH;
    CGFloat offetY2 = IS_iPhoneX ?172 :110;
    [UIView animateWithDuration:duration animations:^{
        self.keybordView.frame = CGRectMake(0, ScreenH-offetY-offetY2, ScreenW, 50);
    }];
    
}
- (NSString *)ids {
    NSMutableArray *array = [NSMutableArray array];
    if (self.editingSelectArray.count == 1) {
        HFStoreModel *model = [self.editingSelectArray firstObject];

        return model.storeId;
    }
    for (HFStoreModel *model in self.editingSelectArray) {
        [array addObject:model.storeId];
    }
    
    return array.count == 0 ?@"":[array componentsJoinedByString:@","];
}
- (NSString *)favids {
    NSMutableArray *array = [NSMutableArray array];
    if (self.editingSelectArray.count == 1) {
        HFStoreModel *model = [self.editingSelectArray firstObject];
        
        return model.productId;
    }
    for (HFStoreModel *model in self.editingSelectArray) {
        [array addObject:model.productId];
    }
    
    return array.count == 0 ?@"":[array componentsJoinedByString:@","];
}
- (void)cellBaseTextfiledBegainEditing:(HFTableViewCarBaseCell *)cell textfiled:(UITextField *)textField {
    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
        HFCarGoodsCell *carcell = (HFCarGoodsCell*)cell;
    if (cell.dataModel.shoppingCount != textField.text.integerValue) {
        HFShopingModel *shopingModel =  self.viewModel.dataSource[cellPath.section];
        HFStoreModel *storModel = shopingModel.productList[cellPath.row];
        if (self.isSure) {
            self.viewModel.productId = storModel.storeId;
            if (storModel.purchaseLimitation !=0) {
                
                if ( [carcell getTextFiledShoppingCount]< storModel.purchaseLimitation ) {
                    if (storModel.isRowSelected) {
                        [self.finalPriceView setPrice:[self.finalPriceView nowPrice]+storModel.pricePrice.cashPrice];
                    }
                    storModel.shoppingCount = [carcell getTextFiledShoppingCount];
                }else {
                    [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"不能大于限购数量%ld件",storModel.purchaseLimitation]];
                    storModel.shoppingCount = storModel.purchaseLimitation;
                }
            }else {
                if ([carcell getTextFiledShoppingCount] > storModel.stock ) {
                    [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"购买数量超出库存数%ld件",storModel.stock]];
                    storModel.shoppingCount = storModel.stock;
                    
                    
                }else {
                    if ( storModel.shoppingCount > storModel.stock) {
                        if (storModel.isRowSelected) {
                            [self.finalPriceView setPrice:[self.finalPriceView nowPrice]+storModel.pricePrice.cashPrice];
                            
                        }
                    }
                    
                    storModel.shoppingCount = [carcell getTextFiledShoppingCount];
                }
            }
    
                [self.viewModel.editShopCountCommand execute:nil];
            
            [self.tableView reloadRowsAtIndexPaths:@[cellPath] withRowAnimation:UITableViewRowAnimationNone];
        } else{
            [self.tableView reloadRowsAtIndexPaths:@[cellPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
- (void)cellWithdidSelectWithSpecifications:(HFTableViewCarBaseCell *)cell {
    HFCarOutStockGoodsCell *noneStockcell = (HFCarOutStockGoodsCell*)cell;
    
    [self.viewModel.resetSpecialsSubjc sendNext:noneStockcell.dataModel];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HFShopingModel *shopingModel =  self.viewModel.dataSource[section];
    return shopingModel.productList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFShopingModel *shopingModel =  self.viewModel.dataSource[indexPath.section];
    HFStoreModel *storeModel = shopingModel.productList[indexPath.row];
    return storeModel.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 数据
    HFShopingModel *shopingModel =  self.viewModel.dataSource[indexPath.section];
    HFStoreModel *storeModel = shopingModel.productList[indexPath.row];
    HFTableViewCarBaseCell *cell = NULL;
    Class renderClass = [HFTableViewCarBaseCell getRenderClassByMessageType:storeModel.ContentMode];
    if (!renderClass) {
        return [UITableViewCell new];
    }
    NSString* cellIndentifier = NSStringFromClass(renderClass);
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
     
        cell = [[renderClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];

        cell.selectionStyle=NO;
    }
    cell.delegate = self;
    cell.dataModel = storeModel;
    [cell doMessageRendering];
    @weakify(self);
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        @strongify(self);
        if (isSelected) {
            NSArray *selectedModels;
            if (self.isEditing) {
                 selectedModels = [NSArray arrayWithArray:self.editingSelectArray];
                  storeModel.editingRowSelected = NO;
            }else {
                 selectedModels = [NSArray arrayWithArray:self.selectArray];
                  storeModel.isRowSelected = NO;
            }
            for (HFStoreModel *model_item in selectedModels) {
                if ([model_item.identifier isEqualToString:storeModel.identifier]) {
                    if (self.isEditing) {
                         [self.editingSelectArray removeObject:model_item];
                    }else{
                         [self.selectArray removeObject:model_item];
                    }
                    break;
                }
            }
            [self.tableView reloadData];
        }else {
            if (self.isEditing) {
                storeModel.editingRowSelected = YES;
                [self.editingSelectArray addObject:storeModel];
            }else {
                storeModel.isRowSelected = YES;
                [self.selectArray addObject:storeModel];
            }
         
            [self.tableView reloadData];
        }
        CGFloat price = 0;
        if (self.isEditing) {
            [self.finalPriceView isSelected:(self.editingtotal==self.editingSelectArray.count) isEnabled:self.editingSelectArray.count];
        }else {
            for (HFStoreModel *model in self.selectArray) {
                price += (model.pricePrice.cashPrice*model.shoppingCount);
            }
            [self.finalPriceView setPrice:price];
            [self.finalPriceView isSelected:(self.total==self.selectArray.count) isEnabled:self.selectArray.count];
        }
    };
    cell.didPulsPhotoBlock = ^(HFTableViewCarBaseCell * plusCell) {
        @strongify(self);
        [self.viewModel.plusSubjc sendNext:plusCell];
    };
    cell.didMinPhotoBlock = ^(HFTableViewCarBaseCell * minCell) {
         @strongify(self);
        [self.viewModel.minSubjc sendNext:minCell];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HFCarSectionHeaderView *view = [[HFCarSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40) WithViewModel:self.viewModel];
    HFShopingModel *shopingModel =  self.viewModel.dataSource[section];
    [view setShoppingModel:shopingModel];
    @weakify(self)
    view.didSelectPhotoBlock = ^(BOOL isSelected) {
        @strongify(self)
        if (isSelected) {
            NSArray *selectedModels =  [NSArray arrayWithArray:shopingModel.productList];

            if (self.isEditing) {
                shopingModel.EditingSectionSelected = NO;
            }else {

                shopingModel.isSectionSelected = NO;
       
            }
            for (HFStoreModel *model_item in selectedModels) {
                if (self.isEditing) {
                    model_item.editingRowSelected = NO;
                    [self.editingSelectArray removeObject:model_item];
                }else {
                    model_item.isRowSelected = NO;
                    [self.selectArray removeObject:model_item];
                }
             
            }
            [self.tableView reloadData];
        }else {
            if (self.isEditing) {
                  shopingModel.EditingSectionSelected = YES;
            }else{
                  shopingModel.isSectionSelected = YES;
            }
          
            for (HFStoreModel *model_item in shopingModel.productList) {
                if (self.isEditing) {
                     model_item.editingRowSelected = YES;
                }else {
                     model_item.isRowSelected = YES;
                }
                if (self.isEditing) {
                    if (![self.editingSelectArray containsObject:model_item]&&model_item.ContentMode != HFCarListTypeNoneStock) {
                        [self.editingSelectArray addObject:model_item];
                    }
                }else {
                    if (![self.selectArray containsObject:model_item]&&model_item.ContentMode != HFCarListTypeNoneStock) {
                        [self.selectArray addObject:model_item];
                    }
                }
            }
            [self.tableView reloadData];
        }
    };
    if (self.isEditing) {
        if (self.editingtotal >0) {
              [self.finalPriceView isSelected:(self.editingtotal==self.editingSelectArray.count) isEnabled:self.editingSelectArray.count];
        }
      
    }else {
        CGFloat price = 0;
        for (HFStoreModel *model in self.selectArray) {
            price += (model.pricePrice.cashPrice*model.shoppingCount);
        }
        [self.finalPriceView setPrice:price];
        if(self.total >0) {
            [self.finalPriceView isSelected:(self.total==self.selectArray.count) isEnabled:self.selectArray.count];
        }
  
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    HFShopingModel *shopingModel =  self.viewModel.dataSource[indexPath.section];
    HFStoreModel *storeModel = shopingModel.productList[indexPath.row];
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        if (![self.editingSelectArray containsObject:storeModel]) {
            [self.editingSelectArray addObject:storeModel];
        }
          self.viewModel.shopID = storeModel.storeId;
        [self.viewModel.editDeleteCommand execute:nil];
      
    }];
    UITableViewRowAction *favRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (![self.editingSelectArray containsObject:storeModel]) {
            [self.editingSelectArray addObject:storeModel];
        }
        self.viewModel.ProductID = [self favids];
        self.viewModel.cardID = [self ids];
        [self.viewModel.editFavCommand execute:nil];
        
    }];
    favRoWAction.backgroundColor = [UIColor colorWithHexString:@"FF9900"];
    return @[deleteRoWAction,favRoWAction];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    footer.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFShopingModel *shopingModel =  self.viewModel.dataSource[indexPath.section];
    HFStoreModel *storeModel = shopingModel.productList[indexPath.row];
    [self.viewModel.enterDetailSubjc sendNext:storeModel];
}
- (void)isEditingPriceView:(BOOL)isEditing {
    
    [self.finalPriceView isEditing:isEditing];
}
- (void)hiddenKeyBord {
    [self endEditing:YES];
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (NSMutableArray *)editingSelectArray {
    if (!_editingSelectArray) {
        _editingSelectArray = [NSMutableArray array];
    }
    return _editingSelectArray;
}
- (HFCarEmptyGoodsView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[HFCarEmptyGoodsView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewModel];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height-50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
       _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (HFFinalPriceView *)finalPriceView {
    if (!_finalPriceView) {
//        CGFloat tabH = IS_iPhoneX ? 50+34:50;
        _finalPriceView = [[HFFinalPriceView alloc] initWithFrame:CGRectMake(0,self.height-50, ScreenW, 50) WithViewModel:self.viewModel];
        _finalPriceView.backgroundColor = [UIColor whiteColor];
    }
    return _finalPriceView;
}
- (HFKeyBordView *)keybordView {
    if (!_keybordView) {
        _keybordView  = [[HFKeyBordView alloc] initWithFrame:CGRectMake(0, self.height-50, ScreenW, 50) WithViewModel:nil];
        
        _keybordView.hidden = YES;
    }
    return _keybordView;
}
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.hidden = YES;
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBord)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}
@end
