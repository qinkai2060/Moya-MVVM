//
//  HFPayMentViewModel.m
//  housebank
//
//  Created by usermac on 2018/11/13.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPayMentViewModel.h"
#import "HFPaymentBaseModel.h"
@implementation HFPayMentViewModel
- (void)hh_initialize {
    @weakify(self);
    [self.getDetialAddressCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.addressSubj sendNext:x];
        
    }];
    
    [self.getDetialOrderCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.orderDetialSubjc sendNext:x];
        
    }];
    [self.getPostPriceCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.getPostAgeSubjc sendNext:x];
        
    }];
    [self.getAllPriceCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.getAllPriceSubjc sendNext:x];
    }];
    [self.commitOrderCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.commitOrderSubjc sendNext:x];
    }];
}


- (void)setOrderWriteParams:(NSDictionary *)orderWriteParams {
    
        if (self.contentType == HFOrderShopModelTypeCar) { // 购物车过来
            _orderWriteParams = @{@"shoppingcartId":self.shoppingcartId,@"commodityId":@(0),@"specifications":@"",@"count":@(1),@"sid":[HFCarShoppingRequest sid],@"ignoreLogin":@(0),@"activeId":@(0),@"terminal":@"P_TERMINAL_MOBILE"};
        }else { // 非购物车过来
                _orderWriteParams = orderWriteParams;
            self.commodityId = [[HFUntilTool EmptyCheckobjnil:[self.orderWriteParams valueForKey:@"commodityId"]] description];
            self.active = [[HFUntilTool EmptyCheckobjnil:[self.orderWriteParams valueForKey:@"active"]] integerValue];
            self.countNumber = [[HFUntilTool EmptyCheckobjnil:[self.orderWriteParams valueForKey:@"count"]] integerValue];
            self.specifications = [[HFUntilTool EmptyCheckobjnil:[self.orderWriteParams valueForKey:@"specifications"]] description] ;
            self.shoppingcartId = [HFUntilTool EmptyCheckobjnil:[self.orderWriteParams valueForKey:@"shoppingcartId"]];
            self.tuanId = [HFUntilTool EmptyCheckobjnil:[[self.orderWriteParams valueForKey:@"parentOpenGroupId"] description]];
        }

    
}



- (void)setCityId:(NSString *)cityId {
    if (cityId.length == 0) {
        _cityId = @"";
    }else{
        _cityId = cityId;
    }
}
- (void)setRegionId:(NSString *)regionId {
    if (regionId.length == 0) {
        _regionId = @"";
    }else {
        _regionId = regionId;
    }
}
- (RACSubject *)selectYHQSubjc {
    if (!_selectYHQSubjc) {
        _selectYHQSubjc = [[RACSubject alloc] init];
    }
    return _selectYHQSubjc;
}
- (RACSubject *)getAllPriceSubjc {
    if (!_getAllPriceSubjc) {
        _getAllPriceSubjc = [[RACSubject alloc] init];
    }
    return _getAllPriceSubjc;
}
- (RACSubject *)getPostAgeSubjc {
    if (!_getPostAgeSubjc) {
        _getPostAgeSubjc = [[RACSubject alloc] init];
    }
    return _getPostAgeSubjc;
}
- (RACSubject *)orderDetialSubjc {
    if (!_orderDetialSubjc) {
        _orderDetialSubjc = [[RACSubject alloc] init];
    }
    return _orderDetialSubjc;
}
- (RACSubject *)didSelectQuanSubjc {
    if (!_didSelectQuanSubjc) {
        _didSelectQuanSubjc = [[RACSubject alloc] init];
    }
    return _didSelectQuanSubjc;
}
- (RACSubject *)sendQuanSubjc {
    if (!_sendQuanSubjc) {
        _sendQuanSubjc = [[RACSubject alloc] init];
    }
    return _sendQuanSubjc;
}
- (RACSubject *)showYHQSubjc {
    if (!_showYHQSubjc) {
        _showYHQSubjc = [[RACSubject alloc] init];
    }
    return _showYHQSubjc;
}
- (RACSubject *)enterAddressOrEditingSubj {
    if (!_enterAddressOrEditingSubj) {
        _enterAddressOrEditingSubj = [[RACSubject alloc] init];
    }
    return _enterAddressOrEditingSubj;
}
- (RACSubject *)addressSubj {
    if (!_addressSubj) {
        _addressSubj = [[RACSubject alloc] init];
    }
    return _addressSubj;
}
- (RACSubject *)resetAddressSubjc {
    if(!_resetAddressSubjc){
        _resetAddressSubjc = [[RACSubject alloc] init];
    }
    return _resetAddressSubjc;
}
- (RACSubject *)enterStoreSubjc {
    if (!_enterStoreSubjc) {
        _enterStoreSubjc = [[RACSubject alloc] init];
    }
    return _enterStoreSubjc;
}
- (RACSubject *)commitSubjc {
    if (!_commitSubjc) {
        _commitSubjc = [[RACSubject alloc] init];
    }
    return _commitSubjc;
}
- (RACSubject *)commitOrderSubjc {
    if (!_commitOrderSubjc) {
        _commitOrderSubjc = [[RACSubject alloc] init];
    }
    return _commitOrderSubjc;
}
- (RACCommand *)getDetialAddressCommand {
    @weakify(self);
    if (!_getDetialAddressCommand) {
        _getDetialAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                  @strongify(self);
               NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/findReceiptAddress"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    NSDictionary *dict = (NSDictionary*)request.responseObject;
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[[[dict valueForKey:@"data"] valueForKey:@"receiptAddressList"] valueForKey:@"list"]  isKindOfClass:[NSArray class]]) {
                            NSArray *dataArray =   [[[dict valueForKey:@"data"] valueForKey:@"receiptAddressList"] valueForKey:@"list"];
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDefault == YES"];
                            NSArray *dataNewArr =    [dataArray filteredArrayUsingPredicate:predicate];
                            if (dataNewArr.count == 0) {
                                [subscriber sendNext:nil];
                                [subscriber sendCompleted];
                            }else {
                                HFAddressModel *model = [[HFAddressModel alloc] init];
                                [model getDict:[dataNewArr firstObject]];
                                self.addressmodel = model;
                                [subscriber sendNext:model];
                                [subscriber sendCompleted];
                            }
                            
                  
                        }else{
                            self.addressmodel = nil;
                            [subscriber sendNext:nil];
                           
                            [subscriber sendCompleted];
                        }
                    }else {
                        self.addressmodel = nil;
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _getDetialAddressCommand;
}
- (RACCommand *)getDetialOrderCommand {
    @weakify(self);
    if (!_getDetialOrderCommand) {
        _getDetialOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/initOrderWrite"];
                NSString *requetUrl = utrl;// 非VIP礼包
                 YTKRequestSerializerType requestType = YTKRequestSerializerTypeHTTP;
                NSDictionary *dictParms = self.orderWriteParams;
                if (self.contentType == HFOrderShopModelTypeVipPackage) {
                    // VIP礼包
                    requestType = YTKRequestSerializerTypeJSON;
                       NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/vip/order/gift/init"];
                    requetUrl = utrl;
     
                    dictParms  = @{@"receivingAddressId":self.addressmodel.ids.length == 0 ?@"":self.addressmodel.ids
                                  ,@"terminal":@"P_TERMINAL_MOBILE",@"productInfo":@{@"productId":@(self.commodityId.integerValue),@"specificationId":@(self.specifications.integerValue),@"productCount":@(self.countNumber)} ,@"sid":[HFCarShoppingRequest sid]};
                }
              
                [HFCarRequest requsetUrl:requetUrl withRequstType:YTKRequestMethodPOST requestSerializerType:requestType params:dictParms success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSDictionary *dict = (NSDictionary*)request.responseObject;
                    if ([[dict valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                        HFPaymentBaseModel *paybaseModel = [[HFPaymentBaseModel alloc] init];
                        if (self.contentType == HFOrderShopModelTypeVipPackage) {
                            // VIP礼包
                            paybaseModel.isVIPPackage = YES;
                            [paybaseModel getDataVipPg:[dict valueForKey:@"data"]];
                        }else {
                          [paybaseModel getData:[dict valueForKey:@"data"]];
                        }
              
                        self.payMentModel = paybaseModel;
                        [subscriber sendNext:self.payMentModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];

                return nil;
            }];
        }];
    }
    return _getDetialOrderCommand;
}
- (RACCommand *)getAllPriceCommand {
    @weakify(self)
    if (!_getAllPriceCommand) {
        _getAllPriceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
               NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/order-price"];
                NSString *requetUrl = [NSString stringWithFormat:@"%@?sid=%@",utrl,[HFCarShoppingRequest sid]];
                NSMutableArray *conpoulist = [NSMutableArray array];
                NSDictionary *dict = @{};
                YTKRequestSerializerType requestType = YTKRequestSerializerTypeJSON;
                if (self.contentType == HFOrderShopModelTypeVipPackage) {
                    requestType = YTKRequestSerializerTypeJSON;
                     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/vip/order/gift/calculated-price"];
                    requetUrl = utrl;
                    dict = @{@"receivingAddressId":self.addressmodel.ids.length == 0 ?@"": @(self.addressmodel.ids.integerValue),@"terminal":@"P_TERMINAL_MOBILE",@"useCouponType":@(0),@"productInfo":@{@"productId":@(self.commodityId.integerValue),@"specificationId":@(self.specifications.integerValue),@"productCount":@(self.countNumber)}  ,@"sid":[HFCarShoppingRequest sid]};
                }else {
                    for (HFOrderShopModel *model in self.payMentModel.shops) {
                        if (model.conpoumodel.recommend!=YES &&model.conpoumodel) {
                            NSMutableDictionary *dict =[NSMutableDictionary dictionary];
                            [dict setObject:@(model.conpoumodel.shopId )forKey:@"shopId"];
                            [dict setObject:[NSString stringWithFormat:@"%ld",model.conpoumodel.currenConpouId] forKey:@"couponId"];
                            [conpoulist addObject:dict];
                        }
                    }
                    
                 dict   =   @{@"cityId":@([self.cityId integerValue]),@"regionId":@([self.regionId integerValue]),@"shoppingcartId":self.shoppingcartId.length == 0?@"":self.shoppingcartId,@"allIntegralPrice":@(self.allIntegralPrice),@"registerAmount":[NSNumber numberWithFloat:self.allRegisterAmount],@"active":@(self.active),@"terminal":@"P_TERMINAL_MOBILE",@"commodityId":self.commodityId.length ==0 ?@"":@(self.commodityId.integerValue),@"specifications":self.specifications.length==0 ?@"":self.specifications,@"count":@(self.countNumber),@"couponParams":conpoulist};
                }
                [HFCarRequest requsetUrl: requetUrl withRequstType:YTKRequestMethodPOST requestSerializerType:requestType params: dict
 success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                        if (self.contentType == HFOrderShopModelTypeVipPackage) {
                            self.payMentModel.allPrice = [[HFUntilTool EmptyCheckobjnil:[[[dict valueForKey:@"data"]  valueForKey:@"order"] valueForKey:@"totalPrice"]] floatValue];// VIP礼包的总价
                            self.transportPrice = [[HFUntilTool EmptyCheckobjnil:[[[dict valueForKey:@"data"]  valueForKey:@"order"] valueForKey:@"transportPrice"]] floatValue];// VIP礼包的运费
                        }else {
                            // 初始化给这个
                            self.payMentModel.allPrice = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"data"] valueForKey:@"allPrice"]] floatValue];
                            self.payMentModel.allIntegralPrice = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"data"] valueForKey:@"allIntegralPrice"]] floatValue];
                            self.payMentModel.regCoupon = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"data"] valueForKey:@"allRegisterAmount"]] floatValue];
                            // 区分资产抵扣的显示类型
                            if (self.allIntegralPrice >0 &&self.payMentModel.allIntegralPrice>0) {
                                // 只有在他选中的时候值变化之后他重新赋值
                                self.payMentModel.contentMode =  HFOrderShopModelTypeSelected;
                                self.allIntegralPrice = self.payMentModel.allIntegralPrice;
                            }else if (self.allRegisterAmount >0 &&self.payMentModel.regCoupon>0) {
                                self.payMentModel.contentMode =  HFOrderShopModelTypeRegSelected;
                                 self.allRegisterAmount = self.payMentModel.regCoupon;
                            }else if((self.payMentModel.allIntegralPrice>0 &&self.allIntegralPrice==0)&&(self.payMentModel.regCoupon>0 &&self.allRegisterAmount==0)) {
                                self.payMentModel.contentMode =  HFOrderShopModelTypeMore;
                            }else if(self.payMentModel.allIntegralPrice == 0 &&self.payMentModel.regCoupon == 0) {
                                self.payMentModel.contentMode =  HFOrderShopModelTypeNone;
                            }else {
                                self.payMentModel.contentMode =  HFOrderShopModelTypeOne;
                            }
                            if ([[[dict valueForKey:@"data"] valueForKey:@"shopOverallPrice"] isKindOfClass:[NSArray class]]) {
                                NSArray *postAge = [[dict valueForKey:@"data"] valueForKey:@"shopOverallPrice"];
                                NSMutableArray *userConPouList =[NSMutableArray array];
                                for (NSDictionary *dict in postAge) {
                                    HFUserCouponModel *paybaseModel = [[HFUserCouponModel alloc] init];
                                    [paybaseModel getData:dict];
                                    [userConPouList addObject:paybaseModel];
                                }
                                self.payMentModel.userCouponList = [userConPouList copy];
                            }
                        }
                        [subscriber sendNext:self.payMentModel];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _getAllPriceCommand;
}

- (RACCommand *)getPostPriceCommand {
    if (!_getPostPriceCommand) {
        _getPostPriceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @weakify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/getPostage1"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"shoppingcartId":self.shoppingcartId,@"productId":@(self.commodityId.integerValue),@"cityId":@(self.addressmodel.cityId.integerValue),@"count":@(self.countNumber),@"sid":[HFCarShoppingRequest sid],@"regionId":@(self.addressmodel.regionId.integerValue),@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSDictionary *dict = (NSDictionary*)request.responseObject;
                    NSMutableArray *array = [NSMutableArray array];
                    if ([[dict valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                        if ([[[dict valueForKey:@"data"] valueForKey:@"postage"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *shopDic in [[dict valueForKey:@"data"] valueForKey:@"postage"]) {
                                HFOrderShopModel *paybaseModel = [[HFOrderShopModel alloc] init];
                                [paybaseModel getData:shopDic];
                                [array addObject:paybaseModel];
                            }
                            [subscriber sendNext:array];
                            [subscriber sendCompleted];
                        }
                 }
                    
            } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _getPostPriceCommand;
}

- (RACCommand *)commitOrderCommand {
    if (!_commitOrderCommand) {
        _commitOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)

                NSInteger usetype = 0;
                NSMutableDictionary *dict2 =[NSMutableDictionary dictionary];
                NSDictionary *prams = @{};
                  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/addOrder"];
                NSString *requestUrl = [NSString stringWithFormat:@"%@?sid=%@",utrl,[HFCarShoppingRequest sid]];
                YTKRequestSerializerType requestType = YTKRequestSerializerTypeHTTP;
                if (self.contentType == HFOrderShopModelTypeVipPackage) {
                  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/vip/order/gift/create"];
                    requestUrl = utrl;
                    requestType = YTKRequestSerializerTypeJSON;
                    prams = @{@"receivingAddressId":@(self.addressmodel.ids.integerValue),@"terminal":@"P_TERMINAL_MOBILE",@"useCouponType":@(0),@"shareUserId":@(0),@"productInfo":@{@"productId":@(self.commodityId.integerValue),@"specificationId":@(self.specifications.integerValue),@"productCount":@(self.countNumber)}  ,@"sid":[HFCarShoppingRequest sid]};
                }else {
                    if ( self.payMentModel.contentMode == HFOrderShopModelTypeSelected) {
                        usetype = 1;
                    }else if(self.payMentModel.contentMode == HFOrderShopModelTypeRegSelected){
                        usetype = 4;
                    }
                    for (HFOrderShopModel *model in self.payMentModel.shops) {
                        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
                        if (model.conpoumodel.currenConpouId>0) {
                            [dict setObject:[NSString stringWithFormat:@"%ld",model.conpoumodel.currenConpouId]forKey:[NSString stringWithFormat:@"%ld",model.conpoumodel.shopId]];
                            [dict2 setValuesForKeysWithDictionary:dict];
                        }
                    }
                      NSMutableDictionary *dictRemark = [[NSMutableDictionary alloc] init];
                    if (self.remarks.count >0) {
                      
                        [dictRemark setObject:self.remarks forKey:@"shopId"];
                    }
                    prams =@{
                             @"terminal":@"P_TERMINAL_MOBILE",
                             @"shoppingcartId":self.shoppingcartId.length == 0 ?@"":self.shoppingcartId,
                             @"name":self.addressmodel.receiptName.length == 0 ?@"":self.addressmodel.receiptName,
                             @"phone":self.addressmodel.receiptPhone.length == 0 ?@"":self.addressmodel.receiptPhone,
                             @"address":self.addressmodel.completeAddress.length==0 ?@"":self.addressmodel.completeAddress,
                             @"count":@(self.countNumber),
                             @"addressId":@(self.addressmodel.ids.integerValue),
                             @"cityId":@(self.addressmodel.cityId.integerValue),
                             @"regionId":@([self.addressmodel.regionId integerValue]),
                             @"blockId":@(self.addressmodel.blockId.integerValue),
                             @"townId":@(self.addressmodel.townId.integerValue),
                             @"identity":self.payMentModel.identity?:@"",
                             @"active":@(self.active),
                             @"productGroupId":@(0),
                             @"useType":@(usetype),
                             @"orderType":@(2),
                             @"useIntegral":[NSString stringWithFormat:@"%f",self.allIntegralPrice],
                             @"regCoupon":[NSString stringWithFormat:@"%f",self.allRegisterAmount],
                             @"tutorId":@(0),
                             @"shareUserId":@(0),
                             @"agentId":@(0),
                             @"parentOpenGroupId":self.tuanId.length == 0 ? @"":@(self.tuanId.integerValue), @"specifications":self.contentType==HFOrderShopModelTypeCar?@(-1):@((self.specifications.integerValue==0?0:self.specifications.integerValue)),@"commodityId":self.contentType==HFOrderShopModelTypeCar?@(-1):@(self.commodityId.integerValue),
                             @"remarks":[self.remarksDict modelToJSONString].length == 0 ?@"":[self.remarksDict modelToJSONString],@"couponStr": [[dict2 jsonStringEncoded] length] ==0 ?@"":[dict2 jsonStringEncoded]};
                }
                [HFCarRequest requsetUrl:requestUrl withRequstType:YTKRequestMethodPOST requestSerializerType:requestType params:prams success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = request.responseObject;
                        if ([[dict valueForKey:@"state"] integerValue] == 1) {
                            if([[dict valueForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                                if ([[[dict valueForKey:@"data"]  valueForKey:@"orderInfoList"] isKindOfClass:[NSArray class]]) {
                                    NSArray *array = [[dict valueForKey:@"data"]  valueForKey:@"orderInfoList"];
                                    NSMutableArray *tempArr = [NSMutableArray array];
                                    for (NSDictionary *dataDict in array) {
                                        HFCommitPayModel *commtiModel = [[HFCommitPayModel alloc] init];
                                        [commtiModel getData:dataDict];
                                        [tempArr addObject:commtiModel.orderNo];
                                        
                                    }
                                    [subscriber sendNext:[tempArr componentsJoinedByString:@","]];
                                    [subscriber sendCompleted];
                                }else {
                                    if ([[[dict valueForKey:@"data"] valueForKey:@"orderNo"] isKindOfClass:[NSString class]]){
                                        [subscriber sendNext:[[dict valueForKey:@"data"] valueForKey:@"orderNo"]];
                                        [subscriber sendCompleted];
                                    }else {
                                        [subscriber sendNext:@(2)];
                                        [subscriber sendCompleted];
                                    }

                                }
                            }
                            
                        }else {
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                        
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];

         
                return nil;
            }];
        }];
    }
    return _commitOrderCommand;
}

@end
