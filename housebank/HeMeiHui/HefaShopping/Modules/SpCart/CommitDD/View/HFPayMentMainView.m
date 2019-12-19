//
//  HFPayMentMainView.m
//  housebank
//
//  Created by usermac on 2018/11/12.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPayMentMainView.h"
#import "HFPayMentCell.h"
#import "HFCarSectionHeaderView.h"
#import "HFAdressView.h"
#import "HFDisCoutSwitchView.h"
#import "HFCommitPayMentView.h"
#import "HFAdressTipsView.h"
#import "HFCommitConpouFooterView.h"
#import "HFComPouPriceView.h"
#import "HFAlertView.h"
#import "HFYHQView.h"
#import "HFTableViewnView.h"
@interface HFPayMentMainView () <UITableViewDataSource,UITableViewDelegate,HFPayMentCellDelegate>
@property(nonatomic,strong) HFTableViewnView *tableView;
@property(nonatomic,strong) HFAdressView *addresView;
@property(nonatomic,strong) HFAddressModel *addressModel;
@property(nonatomic,strong) HFDisCoutSwitchView *disCoutView;
@property(nonatomic,strong) HFCommitPayMentView *payMentView;
@property(nonatomic,strong) HFAdressTipsView *tipsAddressView;
@property(nonatomic,strong) HFCommitConpouFooterView *footerView;
@property(nonatomic,strong) HFPayMentViewModel *viewmodel;
@property(nonatomic,strong) HFComPouPriceView *compoview;
@property(nonatomic,strong) HFYHQView *yhqView;
@end
@implementation HFPayMentMainView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewmodel = (HFPayMentViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.addresView;
    [self addSubview:self.payMentView];
    [self addSubview:self.tipsAddressView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.yhqView];
    self.tipsAddressView.hidden = YES;
    
    self.payMentView.frame = CGRectMake(0, self.height-50, ScreenW, 50);
}
- (void)hh_bindViewModel {
    @weakify(self)
    // 地址的信号
    [self.viewmodel.addressSubj subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) {
            self.addressModel = nil;
//            self.viewmodel.addressmodel = nil;
            [HFAlertView showAlertViewType:1 title:@"您还没有收货地址" detailString:@"快去新增一个吧!" cancelTitle:@"返回" cancelBlock:^(HFAlertView *view){
                
            } sureTitle:@"新增地址" sureBlock:^(HFAlertView *view){
                [self.viewmodel.enterAddressOrEditingSubj sendNext:self.addressModel];
            }];
            [self.viewmodel.getDetialOrderCommand execute:nil];
            
        }else {
            [self requstData:(HFAddressModel *)x];
            [self.viewmodel.getDetialOrderCommand execute:nil];
            
        }
        self.tipsAddressView.frame = CGRectMake(0, self.payMentView.top-self.tipsAddressView.tipsheight, ScreenW, self.tipsAddressView.tipsheight);
    }];
    //
//    [self.viewmodel.getPostAgeSubjc subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        NSArray *arrayData = (NSArray*)x;
//        for (HFOrderShopModel *bigOrderWriteModel in self.viewmodel.payMentModel.shops) {
//            for (HFOrderShopModel *smallModel in arrayData) {
//                if ([bigOrderWriteModel.shopsId isEqualToString:smallModel.shopId]) {
//                    bigOrderWriteModel.shopAllPostages = smallModel.shopAllPostages;
//                }
//            }
//        }
//
//        CGFloat price = 0;
//        for (HFOrderShopModel *smallModel in arrayData) {
//            price+=smallModel.shopAllPostages;
//        }
//        self.viewmodel.postage = price;
//
//        [self.tableView reloadData];
//    }];
    [self.viewmodel.getAllPriceSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if(x) {
            
            // 区分礼包
            if (self.viewmodel.contentType == 3) {
                if (self.viewmodel.payMentModel.shops.count >0) {
                    HFOrderShopModel *bigOrderWriteModel = [self.viewmodel.payMentModel.shops firstObject];
                    bigOrderWriteModel.shopAllPostages = self.viewmodel.transportPrice;
                }
            }else {
                // 遍历获取店铺运费
                for (HFOrderShopModel *bigOrderWriteModel in self.viewmodel.payMentModel.shops) {
                    for (HFUserCouponModel *smallModel in self.viewmodel.payMentModel.userCouponList) {
                        if ([bigOrderWriteModel.shopsId integerValue] == smallModel.shopId) {
                            bigOrderWriteModel.shopAllPostages = smallModel.postage;
                            bigOrderWriteModel.shopsProductPrice = smallModel.singleShopSumPrice;
                            bigOrderWriteModel.couponPrice = smallModel.couponPrice;
                            bigOrderWriteModel.selectCoupouList = smallModel.selectCouponList;
                            bigOrderWriteModel.conpoumodel = smallModel;
                        }
                    }
                }
            }
            [self.tableView reloadData];
            HFPaymentBaseModel *model = (HFPaymentBaseModel*)x;
            
            self.footerView.hidden = model.isVIPPackage ?YES:NO;
            [self.tableView haveData];
        }else {
            if(self.viewmodel.payMentModel.shops.count == 0){
            [self.tableView setErrorImage:@"order" text:@"暂无数据"];
            }

        }

    }];
    // 订单初始化信号
    [self.viewmodel.orderDetialSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x != nil) {
            self.tableView.tableFooterView = self.footerView;
            [self.viewmodel.getAllPriceCommand execute:nil];
            [self.tableView haveData];
        }else {
            if (self.viewmodel.payMentModel.shops.count == 0){
             [self.tableView setErrorImage:@"order" text:@"暂无数据"];
            }
        }
    }];
    // 点击显示资产抵扣
    [self.viewmodel.didSelectQuanSubjc  subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.viewmodel.payMentModel.contentMode != HFOrderShopModelTypeNone) {
            [self.compoview showCitySelector];
            [self.viewmodel.sendQuanSubjc sendNext:self.viewmodel.payMentModel];
        }
    }];
    // 选泽优惠券并重新算价
    [self.viewmodel.selectYHQSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFOrderShopModel class]]) {
//            HFOrderShopModel *model = (HFOrderShopModel*)x;
//            HFOrderShopModel *oderModel =   [HFOrderShopModel userCouponData:model.shopId userCouponList:self.viewmodel.payMentModel.shops];
//            oderModel.selectCoupouList = model.selectCouponList;
            [self.tableView reloadData];
            [self.viewmodel.getAllPriceCommand execute:nil];
            
        }
//          [self.tableView reloadData];
        
    }];
    // 提交订单
    [self.viewmodel.commitSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self textEndWithTextField];
        if (self.addressModel == nil) {
            [HFAlertView showAlertViewType:1 title:@"您还没有收货地址" detailString:@"快去新增一个吧!" cancelTitle:@"返回" cancelBlock:^(HFAlertView *view){
                
            } sureTitle:@"新增地址" sureBlock:^(HFAlertView *view){
                [self.viewmodel.enterAddressOrEditingSubj sendNext:self.addressModel];
            }];
        }else {
            [MBProgressHUD showActiveMessage:@"提交中....." view:self timer:1];
            [self.viewmodel.commitOrderCommand execute:nil];
        }
        
    }];
}
- (void)requstData:(HFAddressModel*)modeldata {
    HFAddressModel *model = modeldata;
    self.viewmodel.cityId = model.cityId;
    self.viewmodel.regionId= model.regionId;
    self.addressModel= model;
    [self.tableView reloadData];
    
}
- (void)textEndWithTextField {
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    for (HFOrderShopModel *orderShopModel in self.viewmodel.payMentModel.shops) {
        if (orderShopModel.textContent.length>0&&orderShopModel.shopsId.length>0) {
            [dict2 setObject:orderShopModel.textContent forKey:orderShopModel.shopsId];
            [arrayM addObject:dict2];
        }
    }
    self.viewmodel.remarksDict = [dict2 copy];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewmodel.payMentModel.shops.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFOrderShopModel *orderShopModel = self.viewmodel.payMentModel.shops[indexPath.section];
    
    return orderShopModel.isVIPPackage ? 45*3+6+100*orderShopModel.commodityList.count+5:45*4+6+100*orderShopModel.commodityList.count+5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFPayMentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    HFOrderShopModel *orderShopModel = self.viewmodel.payMentModel.shops[indexPath.section];
    cell.model = orderShopModel;
    [cell doMessageSomthing];
    cell.delegate = self;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    v.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HFCarSectionHeaderView *view = [[HFCarSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35) WithViewModel:self.viewmodel];
    HFOrderShopModel *orderShopModel = self.viewmodel.payMentModel.shops[section];
    view.ordermodel = orderShopModel;
    view.type = HFCarSectionHeaderViewTypePayMent;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y >= self.addresView.height) {
        self.tipsAddressView.hidden = NO;
    }else{
        self.tipsAddressView.hidden = YES;
    }
    
}
- (void)paymentCell:(HFPayMentCell *)cell model:(HFOrderShopModel *)model {
    if(model.isVIPPackage) return;
    [self.viewmodel.showYHQSubjc sendNext:model];
    [self.yhqView showCar];
}
- (void)dealloc {
    [self.yhqView remove];
}
- (HFCommitPayMentView *)payMentView {
    if (!_payMentView) {
        _payMentView = [[HFCommitPayMentView alloc] initWithFrame:CGRectZero WithViewModel:self.viewmodel];
    }
    return _payMentView;
}
- (HFAdressTipsView *)tipsAddressView {
    if (!_tipsAddressView) {
        _tipsAddressView = [[HFAdressTipsView alloc] initWithFrame:CGRectZero WithViewModel:self.viewmodel];
    }
    return _tipsAddressView;
}
- (HFDisCoutSwitchView *)disCoutView {
    if (!_disCoutView) {
        _disCoutView = [[HFDisCoutSwitchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 46) WithViewModel:self.viewmodel];
        _disCoutView.backgroundColor = [UIColor whiteColor];
    }
    return _disCoutView;
}
- (HFAdressView *)addresView {
    if (!_addresView) {
        _addresView = [[HFAdressView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0) WithViewModel:self.viewmodel];
        
    }
    return _addresView;
}
- (HFTableViewnView *)tableView {
    if (_tableView == nil) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFPayMentCell class] forCellReuseIdentifier:@"cellID"];
        
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (HFCommitConpouFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[HFCommitConpouFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 210) WithViewModel:self.viewmodel];
        //_footerView.backgroundColor = [UIColor redColor];
        _footerView.hidden = YES;
    }
    return _footerView;
}
- (HFComPouPriceView *)compoview {
    if (!_compoview) {
        _compoview = [[HFComPouPriceView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW) WithViewModel:self.viewmodel];
    }
    return _compoview;
}
- (HFYHQView *)yhqView {
    if (!_yhqView) {
        _yhqView = [[HFYHQView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewmodel];
        _yhqView.hidden = YES;
    }
    return _yhqView;
}
@end
