//
//  HFAddressListViewModel.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAddressListViewModel.h"
#import "HFPCCSelectorModel.h"
@implementation HFAddressListViewModel
- (void)hh_initialize {
    @weakify(self)
    self.regionId = 778937;
    self.level = 1;
    self.validSigal = [[RACSignal combineLatest:@[RACObserve(self, model.receiptName),RACObserve(self, model.receiptPhone),RACObserve(self, model.detailAddress),RACObserve(self, model.partAddress)] reduce:^id _Nonnull(NSString *receiptName,NSString *receiptPhone,NSString *detailAddress,NSString *partAddress){
         @strongify(self)
        return @(receiptName.length >0&&receiptPhone.length >0&&detailAddress.length >0&&partAddress.length >0);
        
    }] distinctUntilChanged];
    [self.addressListComand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.addressSubjc sendNext:x];
    }];
    [self.addressEditComand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.addressEditSubjc sendNext:x];
    }];
    [self.defualtAddressCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.resultSubjc sendNext:x];
    }];
    [self.deleteAddressCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.deleteSubjc sendNext:x];
    }];
    [self.regionCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.regionsubject sendNext:x];
    }];
}

- (RACCommand *)addressListComand {
    @weakify(self);
    if (!_addressListComand) {
        _addressListComand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/findReceiptAddress"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    NSDictionary *dict = (NSDictionary*)request.responseObject;
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[[[dict valueForKey:@"data"] valueForKey:@"receiptAddressList"] valueForKey:@"list"]  isKindOfClass:[NSArray class]]) {
                            NSArray *dataArray =   [[[dict valueForKey:@"data"] valueForKey:@"receiptAddressList"] valueForKey:@"list"];
                            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:dataArray.count];
                            for (NSDictionary *data in dataArray) {
//                                if ([[data valueForKey:@"completeAddress"] description].length != 0) {
                                    HFAddressModel *model = [[HFAddressModel alloc] init];
                                    [model getDict:data];
                                     model.fromeSource = self.fromeSource;
                                    [tempArray addObject:model];
                              //  }
                            }
                            [subscriber sendNext:[tempArray copy]];
                            [subscriber sendCompleted];
                        }else{
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    NSLog(@"❤️1️⃣");
                }];
                return nil;
            }];
        }];
    }
    return _addressListComand;
}
- (RACCommand *)defualtAddressCommnd {
    if (!_defualtAddressCommnd) {
        _defualtAddressCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
              NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/setDefalutAddress"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"id":self.addressid.length == 0 ?@"id":self.addressid,@"defalutAddress":@"1"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
    
                }];
                return nil;
            }];
        }];
    }
    return _defualtAddressCommnd;
}
- (RACCommand *)regionCommand {
    if (!_regionCommand) {
        _regionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                 NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./data/region"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"regionId":@(self.regionId),@"level":@(self.level)} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSArray class]]) {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dict in request.responseObject) {
                            HFPCCSelectorModel *mode = [[HFPCCSelectorModel alloc] init];
                            [mode getData:dict];
                            [tempArray addObject:mode];
                        }
                        [subscriber sendNext:tempArray];
                        [subscriber sendCompleted];
                    }
                  
                 
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    
                }];
                return nil;
            }];
        }];
    }
    return _regionCommand;
}
- (RACCommand *)deleteAddressCommnd {
    if (!_deleteAddressCommnd) {
        _deleteAddressCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
              NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/delReceiptAddressById"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"id":self.addressid.length == 0 ?@"id":self.addressid,@"defalutAddress":@"1"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"1"];
                    [subscriber sendCompleted];
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"0"];
                    [subscriber sendCompleted];
                    
                }];
                return nil;
            }];
        }];
    }
    return _deleteAddressCommnd;
}
- (void)setSource:(NSInteger)source {
    _source = source;
}
- (RACCommand *)addressEditComand {
    if (!_addressEditComand) {
        _addressEditComand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSDictionary *dict = [NSDictionary dictionary];
                      NSString *detailAddress = [NSString stringWithFormat:@"%@-%@",self.model.partAddress,self.model.detailAddress];
                if (self.source == 1) {
              
                    dict = @{@"id":self.model.ids.length == 0?@"":self.model.ids,@"receiptName":self.model.receiptName.length == 0?@"":self.model.receiptName,@"receiptPhone":self.model.receiptPhone.length == 0?@"":@(self.model.receiptPhone.integerValue),@"zipCode":self.model.zipCode.length == 0?@"":@(self.model.zipCode.integerValue),@"detailAddress":self.model.detailAddress.length == 0?@"":self.model.detailAddress,@"addressName":detailAddress,@"cityId":self.model.cityId.length == 0?@"":@(self.model.cityId.integerValue),@"regionId":self.model.regionId.length == 0?@"":@(self.model.regionId.integerValue),@"blockId":self.model.blockId.length == 0?@(0):@(self.model.blockId.integerValue),@"townId":self.model.townId.length == 0?@(0):@(self.model.townId.integerValue),@"defalutAddress":@"1",@"sid":[HFCarShoppingRequest sid]};
                }else {
                    dict = @{@"receiptName":self.model.receiptName.length == 0?@"":self.model.receiptName,@"receiptPhone":self.model.receiptPhone.length == 0?@"":@(self.model.receiptPhone.integerValue),@"zipCode":self.model.zipCode.length == 0?@"":@(self.model.zipCode.integerValue),@"detailAddress":self.model.detailAddress.length == 0?@"":self.model.detailAddress,@"addressName":detailAddress,@"cityId":self.model.cityId.length == 0?@"":@(self.model.cityId.integerValue),@"regionId":self.model.regionId.length == 0?@"":@(self.model.regionId.integerValue),@"blockId":self.model.blockId.length == 0?@(0):@(self.model.blockId.integerValue),
                        @"townId":self.model.townId.length ==0  ?@(0):@(self.model.townId.integerValue)
                             ,@"defalutAddress":@"1",@"sid":[HFCarShoppingRequest sid]};
                }
  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/addorUpdatereceiptAddress"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dict success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]] ) {
                        if ([[request.responseObject valueForKey:@"state"] integerValue] == 1) {
                            [subscriber sendNext:@"1"];
                            [subscriber sendCompleted];
                        }else {
                            [subscriber sendNext:[request.responseObject valueForKey:@"msg"]];
                            [subscriber sendCompleted];
                        }
                    }else {
                        [subscriber sendNext:@"请求异常"];
                        [subscriber sendCompleted];
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"请求异常"];
                    [subscriber sendCompleted];
                }];
                return nil;
//
            }];
        }];
    }
    return _addressEditComand;
}
- (RACSubject *)resultSubjc {
    if (!_resultSubjc) {
        _resultSubjc = [[RACSubject alloc] init];
    }
    return _resultSubjc;
}

- (RACSubject *)addressSubjc {
    if (!_addressSubjc) {
        _addressSubjc = [[RACSubject alloc] init];
    }
    return _addressSubjc;
}
- (RACSubject *)addressEditSubjc {
    if (!_addressEditSubjc) {
        _addressEditSubjc = [[RACSubject alloc] init];
    }
    return _addressEditSubjc;
}
- (RACSubject *)didSelectSubjc {
    if (!_didSelectSubjc) {
        _didSelectSubjc = [[RACSubject alloc] init];
    }
    return _didSelectSubjc;
}
- (RACSubject *)addNewaddressSubjc {
    if (!_addNewaddressSubjc) {
        _addNewaddressSubjc = [[RACSubject alloc] init];
    }
    return _addNewaddressSubjc;
}
- (RACSubject *)editingOriginSubjc {
    if (!_editingOriginSubjc) {
        _editingOriginSubjc = [[RACSubject alloc] init];
    }
    return _editingOriginSubjc;
}
- (RACSubject *)editingSetSubjc {
    if (!_editingSetSubjc) {
        _editingSetSubjc = [[RACSubject alloc] init];
    }
    return _editingSetSubjc;
}
- (RACSubject *)deleteSubjc {
    if (!_deleteSubjc) {
        _deleteSubjc = [[RACSubject alloc] init];
    }
    return _deleteSubjc;
}
- (RACSubject *) regionsubject{
    if (!_regionsubject) {
        _regionsubject = [[RACSubject alloc] init];
    }
    return _regionsubject;
}
- (RACSubject *) didSelectregionsubject{
    if (!_didSelectregionsubject) {
        _didSelectregionsubject = [[RACSubject alloc] init];
    }
    return _didSelectregionsubject;
}


- (HFAddressModel*)model {
    if (!_model) {
        _model = [[HFAddressModel alloc] init];
    }
    return _model;
}
+ (BOOL)isContain:(NSString*)ids {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ids];
    NSArray *array = @[@"427150",
                       @"456790",@"457577",@"458076",@"458960",@"514145",@"514784",@"537575",@"537935",
                       @"538018", @"538247",@"538570",@"538821",@"539038",@"539179",@"539312",@"539522",
                       @"539725",@"539829",@"539937",@"540149", @"540282",@"540368",@"548551",@"548781",
                       @"549142",@"549470",@"549868",@"550389", @"550812",@"551180",@"551544",@"551820",
                       @"552116",@"552434",@"720308",@"720782",@"720984",@"721023",@"726816",@"730018",@"731703",
                       @"741122",@"741508",@"743609",@"749440",@"768927", @"774787",@"776659"];
    return   [array filteredArrayUsingPredicate:predicate].count;
}
@end
