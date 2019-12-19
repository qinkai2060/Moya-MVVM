//
//  HFComPouPriceView.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFComPouPriceView.h"
#import "HFComPouPriceCell.h"
@interface HFComPouPriceView ()<UITableViewDelegate,UITableViewDataSource,HFComPouPriceCellDelegate>
@property(nonatomic,strong)UIView *cornarView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)HFPayMentViewModel *viewmodel;
@property (nonatomic,strong)NSArray *datasource;
@end
@implementation HFComPouPriceView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewmodel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.cornarView];
    [self.cornarView addSubview:self.titleLb];
    [self.cornarView addSubview:self.closeBtn];
    [self.cornarView addSubview:self.tableView];
    self.cornarView.frame = CGRectMake(0, ScreenH, ScreenW, 417);
    self.titleLb.frame = CGRectMake(0, 0, ScreenW, 50);
    self.closeBtn.frame = CGRectMake(ScreenW-50, 0, 50, 50);
    self.tableView.frame = CGRectMake(0, 50, ScreenW,417-50);
   
}
- (void)hh_bindViewModel {
    self.titleLb.text = @"优惠方式";
    @weakify(self)
    [self.viewmodel.sendQuanSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
            // 资产抵扣数据源
            HFPaymentBaseModel *baseModel = (HFPaymentBaseModel*)x;

            NSDictionary *reg = @{@"name":@"注册券",@"select":@(self.viewmodel.allRegisterAmount>0),@"value":@(baseModel.regCoupon)};// 根据viewmodel的allRegisterAmount 当前的值来判断是否选中
            NSDictionary *disCount = @{@"name":@"抵扣券",@"select":@(self.viewmodel.allIntegralPrice>0),@"value":@(baseModel.allIntegralPrice)};// 根据viewmodel的allIntegralPrice 当前的值来判断是否选中
            NSDictionary *none =  @{@"name":@"不使用",@"select":@(!(self.viewmodel.allRegisterAmount>0||self.viewmodel.allIntegralPrice>0)),@"value":@(0)};
            NSArray *dataArr =  @[@{@"name":@"不使用",@"select":@(1),@"value":@(0)}];
            if (baseModel.regCoupon != 0&&baseModel.allIntegralPrice !=0) {
                dataArr = @[none,disCount,reg];
            }else if(baseModel.regCoupon != 0&&baseModel.allIntegralPrice ==0) {
               dataArr = @[none,reg];
            }else if (baseModel.regCoupon == 0&&baseModel.allIntegralPrice !=0){
               dataArr = @[none,disCount];
            }
            NSMutableArray *arrayM  = [NSMutableArray array];
            for (NSDictionary *dict in dataArr) {
                HFCompouModel *payModel = [[HFCompouModel alloc] init];
                payModel.name = [dict valueForKey:@"name"];
                payModel.select = [[dict valueForKey:@"select"] boolValue];
                payModel.value = [[dict valueForKey:@"value"] integerValue];
                [arrayM addObject:payModel];
            }
            self.datasource = arrayM;
        
        [self.tableView reloadData];
        
    }];
}
- (void)showCitySelector {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    statusBar.backgroundColor = [UIColor clearColor];
//    
    self.frame =  [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.hidden = NO;
    self.alpha = 0;

    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.cornarView.frame = CGRectMake(0, ScreenH-417, ScreenW, 417);
    }];
}
- (void)dissMiss {
    
    self.alpha = 1;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.cornarView.frame = CGRectMake(0, ScreenH, ScreenW, 417);
    }];

}
- (void)closeClick {
    [self dissMiss];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFCompouModel *commodel =  self.datasource[indexPath.row];
    if([commodel.name isEqualToString:@"不使用"]){
        return 45;
    }else {
      return commodel.value == 0 ?0:45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   HFComPouPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"spID" forIndexPath:indexPath];
   HFCompouModel *commodel =  self.datasource[indexPath.row];
    cell.compouModel = commodel;
    [cell dataSomthing];
    cell.delegate = self;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     HFCompouModel *dataModel =  self.datasource[indexPath.row];
 
    [self didSelectAndUnselectFunction:nil withModel:dataModel];
}
- (void)didSelectAndUnselectFunction:(HFComPouPriceCell *)cell2 withModel:(HFCompouModel *)dataModel{
    if (dataModel.select) {
        
    }else {
        if ([dataModel.name isEqualToString:@"不使用"]) {
            self.viewmodel.allIntegralPrice = 0.0;
            self.viewmodel.allRegisterAmount = 0.0;
            if (self.viewmodel.payMentModel.allIntegralPrice > 0 &&self.viewmodel.payMentModel.regCoupon > 0) {
                self.viewmodel.payMentModel.contentMode = HFOrderShopModelTypeMore;
            }else {
                self.viewmodel.payMentModel.contentMode = HFOrderShopModelTypeOne;
            }
        }else if ([dataModel.name isEqualToString:@"注册券"]) {
            if (dataModel.value == 0) {
                return;
            }
            self.viewmodel.allRegisterAmount = dataModel.value;
            self.viewmodel.allIntegralPrice = 0;
            self.viewmodel.payMentModel.contentMode = HFOrderShopModelTypeRegSelected;
        }else {
            if (dataModel.value == 0) {
                return;
            }
            self.viewmodel.allIntegralPrice = dataModel.value;
            self.viewmodel.allRegisterAmount = 0;
            self.viewmodel.payMentModel.contentMode = HFOrderShopModelTypeSelected;
        }
        for (HFCompouModel *model in self.datasource) {
            model.select = NO;
        }
        dataModel.select = YES;
        [self.tableView reloadData];
        
    }
    [self.viewmodel.getAllPriceCommand execute:nil];
    [self dissMiss];
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFComPouPriceCell class] forCellReuseIdentifier:@"spID"];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (UIView *)cornarView {
    if (!_cornarView) {
        _cornarView = [[UIView alloc] initWithFrame:CGRectMake(0, 214, ScreenW, ScreenH-214)];
        _cornarView.backgroundColor = [UIColor whiteColor];
    }
    return _cornarView;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-15-20, 15, 20, 20)];
        [_closeBtn setImage:[UIImage imageNamed:@"close666"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
@end
