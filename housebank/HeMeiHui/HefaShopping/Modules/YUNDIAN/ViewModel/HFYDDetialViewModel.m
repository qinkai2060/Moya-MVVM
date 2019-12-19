//
//  HFYDDetialViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDDetialViewModel.h"

@implementation HFYDDetialViewModel
- (void)hh_initialize {
    self.shopId = @"";
    @weakify(self)
    [self.ydDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.ydDataSubjc sendNext:x];
    }];
    [self.ydfollowCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.ydfollowSubjc sendNext:x];
    }];
    [self.shareCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.shareSubjc sendNext:x];
    }];
    
    
//    [self.getShopfollowCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self.getShopfollowSubjc sendNext:x];
//    }];
    [self.selectSpecialIDCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.selectSpecialIDSubjc sendNext:x];
    }];
    [self.addOrminCarCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.rightModel.addCount = 0;
        [self.addOrminCarSubjc sendNext:x];
    }];
    [self.selectCarCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.selectCarSubjc sendNext:x];
    }];
    [self.wdDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.wdDataSubjc sendNext:x];
    }];
    
}
- (RACCommand *)ydDataCommand {
    if (!_ydDataCommand) { // ,[HFCarShoppingRequest sid] &sid =%@
        _ydDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/detail/get"];
                [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@/%ld?sid=%@",CloudeEnvironment,utrl,[self.shopId integerValue],[HFCarShoppingRequest sid]] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if (!request.responseJSONObject) {
                        return;
                    }
                    NSDictionary *shopsBaseInfo = [[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"shopsBaseInfo"];
                    NSDictionary *microProductInfo = [[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"microProductInfo"];
                    NSDictionary *o2oProductInfo = [[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"o2oProductInfo"];
      
                    if ([[request.responseJSONObject  valueForKey:@"data"]isKindOfClass:[NSDictionary class]]&&[[request.responseJSONObject  valueForKey:@"state"] integerValue] == 1) {
                        HFYDDetialDataModel *baseModel = [[HFYDDetialDataModel alloc] init];
                        if (shopsBaseInfo) {
                            HFYDDetialTopDataModel *model = [[HFYDDetialTopDataModel alloc] init];
                            [model getData:shopsBaseInfo];
                            self.shopId = model.ids==0?@"":[NSString stringWithFormat:@"%ld",model.ids];
                            model.hasConcerned = [[HFUntilTool EmptyCheckobjnil:[[request.responseJSONObject  valueForKey:@"data"]  valueForKey:@"hasConcerned"]] integerValue];
                            model.cartCount =  [[HFUntilTool EmptyCheckobjnil:[[request.responseJSONObject  valueForKey:@"data"]  valueForKey:@"cartCount"]] integerValue];
                            
                            baseModel.shopsBaseInfo = model;
                        }
                        
                        if (o2oProductInfo) {
                            if ([[o2oProductInfo valueForKey:@"classificationList"] isKindOfClass:[NSArray class]]) {
                                NSMutableArray *tempArray = [NSMutableArray array];
                                NSInteger i = 0;
                                for (NSDictionary *productDict in [o2oProductInfo valueForKey:@"classificationList"]) {
                                    HFYDDetialLeftDataModel *model = [[HFYDDetialLeftDataModel alloc] init];
                                    [model getData:productDict];
                                    [tempArray addObject:model];
                                    if (i == 0) {
                                        model.selected = YES;
                                    }
                                    i++;
                                }
                                
                                baseModel.o2oProductInfo = [tempArray copy];
                            }
                        }
                        if (microProductInfo) {
                            baseModel.shopsBaseInfo.wdShopId = [[HFUntilTool EmptyCheckobjnil:[[[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"microProductInfo"] valueForKey:@"shopsId"]] integerValue];
                            
                            if ([[[microProductInfo valueForKey:@"productList"] valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
                                HFYDDetialLeftDataModel *leftModel = [[HFYDDetialLeftDataModel alloc] init];
                                leftModel.classificationName = @"热销";
                                NSMutableArray *tempArray = [NSMutableArray array];
                                for (NSDictionary *productDict in [[microProductInfo valueForKey:@"productList"] valueForKey:@"list"]) {
                                    HFYDDetialRightDataModel *model = [[HFYDDetialRightDataModel alloc] init];
                                    [model getData:productDict];
                                    [tempArray addObject:model];
                                }
                                leftModel.selected = YES;
                                leftModel.productList = [tempArray copy];
                                leftModel.rowHight = 24 + [HFUntilTool boundWithStr:leftModel.classificationName font:14 maxSize:CGSizeMake(86-30, 40)].height;
                                NSMutableArray *tempArray2 = [NSMutableArray arrayWithArray:baseModel.o2oProductInfo];
                                [tempArray2 insertObject:leftModel atIndex:0];
                                for (int i = 0; i<tempArray2.count; i++) {
                                    HFYDDetialLeftDataModel *leftModel = tempArray2[i];
                                    if (i == 0) {
                                        leftModel.selected = YES;
                                    }else {
                                        leftModel.selected = NO;
                                    }
                                }
                                baseModel.o2oProductInfo = [tempArray2 copy];
                            }
                        }
                        baseModel.isContainWD = baseModel.shopsBaseInfo.wdShopId == 0?NO:YES;
                        self.detialModel = baseModel;
                        [subscriber sendNext:baseModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    
                }];
                return nil;
            }];
           
        }];
    }
    return _ydDataCommand;
}
- (RACCommand *)addOrminCarCommand {
    if (!_addOrminCarCommand) {
        _addOrminCarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *dic = @{@"price":@(self.rightModel.cashPrice),
                                      @"productID":@(self.rightModel.productId),
                                      @"productTypeID":@(self.rightModel.productSpecificationsId),
                                      @"shoppingCount":@(self.rightModel.addCount),
                                      @"shopsId":self.shopId,
                                      @"shopsType":@(1),
                                      @"stealAge":@(1),
                                      @"channel":@(6),
                                      @"addType":@(1),
                                      @"sid":[HFCarShoppingRequest sid]
                                      };
               NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail./user/mircoshop-cart/save-product"];
                [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@e.com%@",CloudeEnvironment,utrl] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([[request.responseJSONObject  valueForKey:@"data"] isKindOfClass:[NSDictionary class]]&&[[request.responseJSONObject  valueForKey:@"state"] integerValue] ==1 ) {
                        [subscriber sendNext:[request.responseJSONObject  valueForKey:@"data"] ];
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
    return _addOrminCarCommand;
}

- (RACCommand *)shareCommand {
    if (!_shareCommand) {
        _shareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag": self.pageTage,@"extras":[@{@"shopId":self.shopId} jsonStringEncoded].length == 0 ?@"":[@{@"shopId":self.shopId} jsonStringEncoded]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        [subscriber sendNext:[request.responseObject valueForKey:@"data"]];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
        }];
        
    }
    return _shareCommand;
}
- (RACCommand *)selectCarCommand {
    if (!_selectCarCommand) {
        _selectCarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                 NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shopping-cart/list"];
                [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@",CloudeEnvironment,utrl] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"shopId":self.shopId,@"channel":@(6)} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseJSONObject valueForKey:@"data"]&&[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"details"] isKindOfClass:[NSArray class]]) {
                        NSArray *carDataList =  [[request.responseJSONObject valueForKey:@"data"] valueForKey:@"details"];
                        NSDictionary *dict = [carDataList firstObject];
                        HFYDCarModel  *carmodel = [[HFYDCarModel alloc] init];
                        [carmodel getData:dict];
                        self.carModel = carmodel;
                        [subscriber sendNext:carmodel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    
                    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    NSLog(@"");
                }];
                return nil;
                
            }];
            
        }];
    }
    return _selectCarCommand;
}
- (RACCommand *)wdDataCommand {
    if (!_wdDataCommand) {
        _wdDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                //http://192.168.20.36:8888/mock/93/m/retail/microshops/detail/{shopId}?sid={sid}
                //[NSString stringWithFormat:@"https://retail-api.ijiuyue.com/m/retail/microshops/detail/%ld?sid=%@",self.detialModel.shopsBaseInfo.wdShopId,[HFCarShoppingRequest sid]]
                 NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/detail/get"];
                [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@/%ld?sid=%@",CloudeEnvironment,utrl,[self.shopId integerValue],[HFCarShoppingRequest sid]] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([[request.responseJSONObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *shopsBaseInfo = [[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"shopsBaseInfo"];
                        NSDictionary *microProductInfo = [[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"microProductInfo"];
                        HFYDDetialDataModel *baseModel = [[HFYDDetialDataModel alloc] init];
                        if (shopsBaseInfo) {
                            HFYDDetialTopDataModel *model = [[HFYDDetialTopDataModel alloc] init];
                            [model getData:shopsBaseInfo];
                            self.shopId = model.ids==0?@"":[NSString stringWithFormat:@"%ld",model.ids];
                            model.hasConcerned = [[HFUntilTool EmptyCheckobjnil:[[request.responseJSONObject  valueForKey:@"data"]  valueForKey:@"hasConcerned"]] integerValue];
                            model.cartCount =  [[HFUntilTool EmptyCheckobjnil:[[request.responseJSONObject  valueForKey:@"data"]  valueForKey:@"cartCount"]] integerValue];
                             model.concernedCount = [HFYDDetialViewModel concernedCountCovert:[[HFUntilTool EmptyCheckobjnil:[[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"concernedCount"]] description]];
                            baseModel.shopsBaseInfo = model;
                        }
                        if (microProductInfo) {
                            baseModel.shopsBaseInfo.wdShopId = [[HFUntilTool EmptyCheckobjnil:[[[request.responseJSONObject  valueForKey:@"data"] valueForKey:@"microProductInfo"] valueForKey:@"shopsId"]] integerValue];
                            
                            if ([[[microProductInfo valueForKey:@"productList"] valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
                                NSMutableArray *tempArray = [NSMutableArray array];
                                for (NSDictionary *productDict in [[microProductInfo valueForKey:@"productList"] valueForKey:@"list"]) {
                                    HFYDDetialRightDataModel *model = [[HFYDDetialRightDataModel alloc] init];
                                    [model getData:productDict];
                                    [tempArray addObject:model];
                                }
                                baseModel.wdList = [tempArray copy];
                            }
                        }
                        [subscriber sendNext:baseModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    
                    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    NSLog(@"");
                }];
                return nil;
                
            }];
            
        }];
    }
    return _wdDataCommand;
}
+ (NSString*)concernedCountCovert:(NSString*)concernedCount {
    if (concernedCount.length >= 5) {
        return [NSString stringWithFormat:@"%.f万关注",[concernedCount floatValue]/10000];
    }else if(concernedCount.length == 0) {
        return @"暂无关注";
    }else {
        return [NSString stringWithFormat:@"%@人关注",concernedCount];
    }
}
- (RACCommand *)selectSpecialIDCommand {
    if (!_selectSpecialIDCommand) {
        _selectSpecialIDCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m_product_common_specifications"];
                [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@/%ld",CloudeEnvironment,utrl,self.productId] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"productId":@(self.productId)} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([[request.responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] integerValue] == 1 ) {
                        HFYDSpecificationsModel *Spmodel= [[HFYDSpecificationsModel alloc] init];
                        [Spmodel getData:[request.responseObject valueForKey:@"data"]];
                        [subscriber sendNext:Spmodel];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];

                    NSLog(@"");
                }];
                return nil;
                
            }];
            
        }];
    }
    return _selectSpecialIDCommand;
}
- (RACCommand *)ydfollowCommand {
    if (!_ydfollowCommand) {
        _ydfollowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/shop-follow/save"];
                [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@",CloudeEnvironment,utrl] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"shopId":self.shopId,@"isFollow":@(self.isFollow),@"followType":@"SHOP"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([[request.responseObject  valueForKey:@"data"] isKindOfClass:[NSDictionary class]]&&[[request.responseObject  valueForKey:@"data"] integerValue] == 1) {
                        [subscriber sendNext:[[request.responseObject  valueForKey:@"data"] valueForKey:@"isFollow"]];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                return nil;
                
            }];
        
        }];
    }
    return _ydfollowCommand;
}
//- (RACCommand *)getShopfollowCommand {
//    if (!_getShopfollowCommand) {
//        _getShopfollowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//
//            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                [HFCarRequest requsetUrl:@"https://retail-api.ijiuyue.com/user/retail/shops/getShopFollow" withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"shopId":self.shopId} success:^(__kindof YTKBaseRequest * _Nonnull request) {
//                    if ([request.responseJSONObject valueForKey:@"data"]&&[[request.responseJSONObject valueForKey:@"msg"] isEqualToString:@"success"]) {
//                        if ([[request.responseJSONObject valueForKey:@"data"] valueForKey:@"shopFollow"]) {
//                            [subscriber sendNext:[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"shopFollow"] valueForKey:@"isFollow"]];
//                            [subscriber sendCompleted];
//                        }else {
//                            [subscriber sendError:nil];
//                            [subscriber sendCompleted];
//                        }
//
//                    }
//                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
//                    [subscriber sendError:nil];
//                    [subscriber sendCompleted];
//                    NSLog(@"");
//                }];
//                return nil;
//
//            }];
//
//        }];
//    }
//    return _getShopfollowCommand;
//}
- (RACSubject *)wdDataSubjc {
    if (!_wdDataSubjc) {
        _wdDataSubjc = [[RACSubject alloc] init];;
    }
    return _wdDataSubjc;
}
- (RACSubject *)enterMapSubjc {
    if (!_enterMapSubjc) {
        _enterMapSubjc = [[RACSubject alloc] init];;
    }
    return _enterMapSubjc;
}
- (RACSubject *)selectCarSubjc {
    if (!_selectCarSubjc) {
        _selectCarSubjc = [[RACSubject alloc] init];;
    }
    return _selectCarSubjc;
}
- (RACSubject *)selectSpecialIDSubjc {
    if (!_selectSpecialIDSubjc) {
        _selectSpecialIDSubjc = [[RACSubject alloc] init];;
    }
    return _selectSpecialIDSubjc;
}
- (RACSubject *)addOrminCarSubjc {
    if (!_addOrminCarSubjc) {
        _addOrminCarSubjc = [[RACSubject alloc] init];;
    }
    return _addOrminCarSubjc;
}
- (RACSubject *)ydfollowSubjc {
    if (!_ydfollowSubjc) {
        _ydfollowSubjc = [[RACSubject alloc] init];
    }
    return _ydfollowSubjc;
}
- (RACSubject *)ydDataSubjc {
    if (!_ydDataSubjc) {
        _ydDataSubjc = [[RACSubject alloc] init];
    }
    return _ydDataSubjc;
}
- (RACSubject *)canscrollSubjc {
    if (!_canscrollSubjc) {
        _canscrollSubjc = [[RACSubject alloc] init];
    }
    return _canscrollSubjc;
}
- (RACSubject *)appcanscrollSubjc {
    if (!_appcanscrollSubjc) {
        _appcanscrollSubjc = [[RACSubject alloc] init];
    }
    return _appcanscrollSubjc;
}
- (RACSubject *)subCanSubjc {
    if (!_subCanSubjc) {
        _subCanSubjc = [[RACSubject alloc] init];
    }
    return _subCanSubjc;
}
- (RACSubject *)didProductSubjc {
    if (!_didProductSubjc) {
        _didProductSubjc = [[RACSubject alloc] init];
    }
    return _didProductSubjc;
}
- (RACSubject *)didApprriaseSubjc {
    if (!_didApprriaseSubjc) {
        _didApprriaseSubjc = [[RACSubject alloc] init];
    }
    return _didApprriaseSubjc;
}
- (RACSubject *)enterWDSubjc {
    if (!_enterWDSubjc) {
        _enterWDSubjc = [[RACSubject alloc] init];
    }
    return _enterWDSubjc;
}
- (RACSubject *)loginSubjc {
    if (!_loginSubjc) {
        _loginSubjc = [[RACSubject alloc] init];
    }
    return _loginSubjc;
}
- (RACSubject *)sendSelectedDataSubjc {
    if (!_sendSelectedDataSubjc) {
        _sendSelectedDataSubjc = [[RACSubject alloc] init];
    }
    return _sendSelectedDataSubjc;
}
- (RACSubject *)shareSubjc {
    if (!_shareSubjc) {
        _shareSubjc = [[RACSubject alloc] init];
    }
    return _shareSubjc;
}

/** 二维码*/
- (RACSignal *)create_shopQrcode:(NSString *)shopID shopType:(NSString *)shopType {
    NSString *str = @"";
    if ([shopType isEqualToString:@"2"]) {
        str = @"fy_newretail_shops";
    }else {
        str = @"fy_micro_shops";
    }
    
    RACSubject * subject = [RACSubject subject];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }

    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":str,@"extras":[@{@"shopId":shopID} jsonStringEncoded]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * codeDic = [jsonDic objectForKey:@"data"];
                if ([codeDic.allKeys containsObject:@"shareUrl"]) {
                    [subject sendNext:[codeDic objectForKey:@"shareUrl"]];
                    [subject sendCompleted];
                }
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }else {
            NSDictionary * jsonDic = request.responseObject;
            NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
            NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
            [subject sendError:error];
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}
@end
