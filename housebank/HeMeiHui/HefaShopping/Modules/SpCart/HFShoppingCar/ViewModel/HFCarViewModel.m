//
//  HFCarViewModel.m
//  housebank
//
//  Created by usermac on 2018/11/6.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarViewModel.h"
#import "HFShopingModel.h"
@implementation HFCarViewModel
- (void)hh_initialize {
    @weakify(self);
    [self.getCardDetialCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.getCarInfo sendNext:x];
        
    }];
    [self.editFavCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.endEditingSubjc sendNext:x];
        
    }];
    [self.editDeleteCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.endEditingSubjc sendNext:x];
        
    }];
    [self.resetSpecialCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.resetNetworkSubjc sendNext:x];
        
    }];
    [self.editShopCountCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        [self.editShopCountSubkjc sendNext:x];
        
    }];
}
- (RACSubject *)editShopCountSubkjc {
    if (!_editShopCountSubkjc) {
        _editShopCountSubkjc = [[RACSubject alloc] init];
    }
    return _editShopCountSubkjc;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (RACSubject *)enterCommitPayMent {
    if (!_enterCommitPayMent) {
        _enterCommitPayMent = [RACSubject subject];
    }
    return _enterCommitPayMent;
}
- (RACSubject *) enterStoreSubjc {
    if (!_enterStoreSubjc) {
        _enterStoreSubjc = [RACSubject subject];
    }
    return _enterStoreSubjc;
}
- (RACSubject *)getCarInfo {
    
    if (!_getCarInfo) {
        _getCarInfo = [RACSubject subject];
    }
    return _getCarInfo;
    
}
- (RACSubject *)quickDeleteSubjc {
    if (!_quickDeleteSubjc) {
        _quickDeleteSubjc = [[RACSubject alloc] init];
    }
    return _quickDeleteSubjc;
}
- (RACSubject *)allSelectSubjc {
    if (!_allSelectSubjc) {
        _allSelectSubjc = [[RACSubject alloc] init];
    }
    return _allSelectSubjc;
}
- (RACSubject *)plusSubjc {
    if (!_plusSubjc) {
        _plusSubjc = [[RACSubject alloc] init];
    }
    return _plusSubjc;
}
- (RACSubject *)minSubjc {
    if (!_minSubjc) {
        _minSubjc = [[RACSubject alloc] init];
    }
    return _minSubjc;
}
- (RACSubject *)editingSelectSubjc {
    if (!_editingSelectSubjc) {
        _editingSelectSubjc = [[RACSubject alloc] init];
    }
    return _editingSelectSubjc;
}
- (RACSubject *)favSubjc {
    if (!_favSubjc) {
        _favSubjc = [[RACSubject alloc] init];
    }
    return _favSubjc;
}
- (RACSubject *)deleteSubjc {
    if (!_deleteSubjc) {
        _deleteSubjc = [[RACSubject alloc] init];
    }
    return _deleteSubjc;
}
- (RACSubject *)resetNetworkSubjc {
    if (!_resetNetworkSubjc) {
        _resetNetworkSubjc = [[RACSubject alloc] init];
    }
    return _resetNetworkSubjc;
}
- (RACSubject *)endEditingSubjc {
    if (!_endEditingSubjc) {
        _endEditingSubjc = [[RACSubject alloc] init];
    }
    return _endEditingSubjc;
}
- (RACSubject *)enterDetailSubjc {
    if (!_enterDetailSubjc) {
        _enterDetailSubjc = [[RACSubject alloc] init];
    }
    return _enterDetailSubjc;
}
- (RACSubject *)resetSpecialsSubjc {
    if (!_resetSpecialsSubjc) {
        _resetSpecialsSubjc = [[RACSubject alloc] init];
    }
    return _resetSpecialsSubjc;
}
- (RACSubject *)goCategorySubjc {
    if (!_goCategorySubjc) {
        _goCategorySubjc = [[RACSubject alloc] init];
    }
    return _goCategorySubjc;
}
- (RACSubject *)deleteFavEndingSubjc {
    if (!_deleteFavEndingSubjc) {
        _deleteFavEndingSubjc = [[RACSubject alloc] init];
        
    }
    return _deleteFavEndingSubjc;
}
- (RACSubject *)resetEditingButtonStateSubjc {
    if (!_resetEditingButtonStateSubjc) {
        _resetEditingButtonStateSubjc = [[RACSubject alloc] init];
        
    }
    return _resetEditingButtonStateSubjc;
}
- (RACCommand *)getCardDetialCommand {
    @weakify(self);
    if (!_getCardDetialCommand) {
        _getCardDetialCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/getShoppingCartDetail"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                        NSMutableArray *datasouceTemp = [NSMutableArray array];
                        NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                        if ([[[dict valueForKey:@"data"] valueForKey:@"shops"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dictShops in [[dict valueForKey:@"data"] valueForKey:@"shops"]){
                                HFShopingModel *shoppingModel = [[HFShopingModel alloc] init];
                               
                                [shoppingModel getData:dictShops];
                                 shoppingModel.contentMode = shoppingModel.contentMode;
//                                if (shoppingModel.productList.count >0) {
                                     [datasouceTemp addObject:shoppingModel];
                              //  }
                               
                            }
                            NSMutableArray *tempArray =[ NSMutableArray arrayWithArray:datasouceTemp];
                            NSMutableArray *loseArr = [NSMutableArray array];
                            for (HFShopingModel *model in tempArray) {
                                for (HFStoreModel *storemodel in model.loseeproductList) {
                                    storemodel.ContentMode = HFCarListTypeOverTime;
                                    [loseArr addObject:storemodel];
                                    if (model.productList.count <=0 || model.productList == nil) {
                                        [datasouceTemp removeObject:model];
                                    }
                                }
                            }
                            NSMutableArray *guolvtempArr = [NSMutableArray arrayWithArray:datasouceTemp];
                            for (HFShopingModel *model in datasouceTemp) {
                                if (model.productList.count == 0 ) {
                                     [guolvtempArr removeObject:model];
                                }
                            }
                            self.dataSource = guolvtempArr;
                            if (loseArr.count != 0) {
                                HFShopingModel *shoppingModel = [[HFShopingModel alloc] init];
                                shoppingModel.contentMode = HFCarListTypeOverTime;
                                shoppingModel.productList = loseArr;
                                [datasouceTemp addObject:shoppingModel];
                            }
                        }
                        self.dataSource = datasouceTemp;
                    }
                    [subscriber sendNext:self.dataSource];
                    [subscriber sendCompleted];
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:self.dataSource];
                    [subscriber sendCompleted];
                    NSLog(@"❤️1️⃣");
                }];
                return nil;
            }];
        }];
    }
    return _getCardDetialCommand;
}
- (RACCommand *)editShopCountCommand {

    if (!_editShopCountCommand) {
        _editShopCountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/modifyShoppingCartCommodityCount"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"count":@(self.count),@"id":self.productId.length == 0 ?@"":self.productId,@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                      NSDictionary *dict = request.responseJSONObject;
                    if ([[dict valueForKey:@"state"]  integerValue] == 1) {
                        [subscriber sendNext:@(1)];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(0)];
                        [subscriber sendCompleted];
                    }
                    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(0)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _editShopCountCommand;
}
- (RACCommand *)editDeleteCommand {
    if (!_editDeleteCommand) {
        _editDeleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
              @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/clearShoppingCartCommodity"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"id":self.shopIDS,@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSDictionary *dict = request.responseJSONObject;
                    if ([[dict valueForKey:@"state"]  integerValue] == 1) {
                        [subscriber sendNext:@"删除成功"];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@"请求失败"];
                        [subscriber sendCompleted];
                    }
                
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"请求失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _editDeleteCommand;
}
- (RACCommand *)editFavCommand {
    if (!_editFavCommand) {
        _editFavCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/shoppingCartProductCollectHM"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"ids":self.ProductID.length ==0?@"":self.ProductID,@"cartIds":self.cardID.length == 0?@"":self.cardID,@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSDictionary *dict = request.responseJSONObject;
                    if ([[dict valueForKey:@"state"]  integerValue] == 1) {
                        [subscriber sendNext:@"成功移入收藏夹\n你可以在'我的-我的关注'看到"];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@"请求失败"];
                        [subscriber sendCompleted];
                    }
                  
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"请求失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _editFavCommand;
}
- (RACCommand *)resetSpecialCommand {
    if (!_resetSpecialCommand) {
        _resetSpecialCommand =  [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                if (!self.resetSpecialPrams) {
                    return nil;
                }
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/reelectShoppingCart"];
                [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:self.resetSpecialPrams success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSDictionary *dict = request.responseJSONObject;
                    
                    if([[dict valueForKey:@"state"] integerValue] == 1) {
                        [subscriber sendNext:@(1)];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(0)];
                        [subscriber sendCompleted];
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(0)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];

    }
    return _resetSpecialCommand;
}
- (NSString *)shopIDS {
    return self.shopID.length == 0 ?@"":self.shopID;
}
- (NSString*)cardIDs {
   return self.cardID.length == 0 ?@"":self.cardID;
}
@end

