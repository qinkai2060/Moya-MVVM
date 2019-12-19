//
//  HFVIPViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPViewModel.h"
#import "HFSectionModel.h"
@implementation HFVIPViewModel
- (void)hh_initialize {
    self.keyWord = @"";
    self.classId = @"";
    self.pageNo = 1;
    @weakify(self)
    [self.homeMainCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.homeMainSubjc sendNext:x];
    }];
    [self.VipSearchCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.VipSearchSubjc sendNext:x];
    }];
    [self.getHotkeyCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.getHotkeySubjc sendNext:x];
    }];
    [self.VipShareCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.VipShareSubjc sendNext:x];
    }];
}
- (RACCommand *)VipShareCommand {
    if (!_VipShareCommand) {
        _VipShareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_vip_goods_home"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
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
    return _VipShareCommand;
}
- (RACCommand *)homeMainCommand {
    if (!_homeMainCommand) {
        _homeMainCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           @weakify(self)
            return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
              NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./vip/product/mall/selectBrokerConfig"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"result"] valueForKey:@"AppData"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = [[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"result"] valueForKey:@"AppData"];
                        //                [HFSectionModel jsonSerialize:array];
                        @strongify(self)
                        array = [HFSectionModel jsonSerialize:array isVip:YES];
                        self.classCategoryModel = [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentMode == 14"]] firstObject];
                        self.hotkeyModel = [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentMode == 16"]] firstObject];
                        NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
                        [temp removeObject:self.classCategoryModel];
                        [temp removeObject:self.hotkeyModel];
                        [subscriber sendNext:temp];
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
    return _homeMainCommand;
}
- (RACCommand *)VipSearchCommand {
    if (!_VipSearchCommand) {
        _VipSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [HFVIPViewModel loadCategoryDataPageNo:self.pageNo keyWord:self.keyWord classId:self.classId success:^(YTKBaseRequest *request) {
                    if ([[request.responseObject valueForKey:@"data"] isKindOfClass:[NSArray class]] &&[[request.responseObject valueForKey:@"state"] integerValue] == 1) {
                        NSArray *array =  [request.responseObject valueForKey:@"data"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDict in array) {
                            HFVIPModel *model = [[HFVIPModel alloc] init];
                            [model getData:dataDict];
                            [tempArray addObject:model];
                        }
                        [subscriber sendNext:tempArray];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
            
                } error:^(YTKBaseRequest *request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _VipSearchCommand;
}
- (RACCommand *)getHotkeyCommand {
    if (!_getHotkeyCommand) {
        _getHotkeyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
              NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./vip/product/mall/selectVipMallPageHotWord"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSDictionary *dicthotKey = [request.responseJSONObject valueForKey:@"data"]  ;
                    if ([[dicthotKey valueForKey:@"result"] isKindOfClass:[NSArray class]]) {
                        HFSectionModel *section = [[HFSectionModel alloc] init];
                        HFHotKeyModel *hotkeyModel = [[HFHotKeyModel alloc] init];
                        [hotkeyModel getVipData:dicthotKey];
                        section.dataModelSource = @[hotkeyModel];
                        // 二段
                        HFHotKeyModel *keyModel = [[HFHotKeyModel alloc] init];
                        keyModel.dataSource = [section.dataModelSource firstObject].dataArray;
                        keyModel.type = @"热门搜索";
                        HFHotKeyModel *historyModel = [[HFHotKeyModel alloc] init];
                        historyModel.type = @"搜索历史";
                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"] isKindOfClass:[NSArray class]]) {
                            NSArray *array =   [[NSSet setWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"]] allObjects];
                            NSMutableArray *tempArray = [NSMutableArray array];
                            for (NSString *key in array) {
                                HFHotKeyModel *model = [[HFHotKeyModel alloc] init];
                                model.mainTitle = key;
                                [tempArray addObject:model];
                            }
                            historyModel.dataSource =  [[tempArray reverseObjectEnumerator] allObjects];
                        }else {
                            historyModel.dataSource = @[];
                        }
                        //最终的数据
                        NSArray *temArray = @[];
                        if (historyModel.dataSource.count != 0) {
                            temArray = @[keyModel,historyModel];
                            [subscriber sendNext:temArray];
                            [subscriber sendCompleted];
                        }else {
                            temArray = @[keyModel];
                            [subscriber sendNext:temArray];
                            [subscriber sendCompleted];
                        }
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
    return _getHotkeyCommand;
}
+ (void)loadCategoryDataPageNo:(NSInteger)pageNo keyWord:(NSString*)keyWord classId:(NSString *)classId success:(void(^)(YTKBaseRequest *request))success error:(void(^)(YTKBaseRequest *request))error {
    /**
     @{@"pageNo":@(pageNo),@"sid":@"",@"keyword":@"",@"minPrice":@"",@"maxPrice":@"",@"orderByNewGoods":@"",@"orderByPrice":@"",@"orderBySalesCount":@"",@"cityId":@"",@"classId":@""}
     */
    keyWord = ((keyWord.length == 0 || [keyWord isEqualToString:@"全部"])  ?@"":keyWord);
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"search.vip/goods/search"];
    if (getUrlStr) {
        getUrlStr =getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageNo":@(pageNo),@"sid":@"",@"classId":classId} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        error(request);
    }];
}
- (RACSubject *)VipShareSubjc {
    if (!_VipShareSubjc) {
        _VipShareSubjc = [[RACSubject alloc] init];
    }
    return _VipShareSubjc;
}
- (RACSubject *)getHotkeySubjc {
    if (!_getHotkeySubjc) {
        _getHotkeySubjc =[[RACSubject alloc] init];
    }
    return _getHotkeySubjc;
}
- (RACSubject *)homeMainSubjc {
    if (!_homeMainSubjc) {
        _homeMainSubjc =[[RACSubject alloc] init];
    }
    return _homeMainSubjc;
}
- (RACSubject *)VipSearchSubjc {
    if (!_VipSearchSubjc) {
        _VipSearchSubjc =[[RACSubject alloc] init];
    }
    return _VipSearchSubjc;
}
- (RACSubject *)enterSearchSubjc {
    if (!_enterSearchSubjc) {
        _enterSearchSubjc = [[RACSubject alloc] init];
    }
    return _enterSearchSubjc;
}
- (RACSubject *)didBrowserSubjc {
    if (!_didBrowserSubjc) {
        _didBrowserSubjc = [[RACSubject alloc] init];
    }
    return _didBrowserSubjc;
}
- (RACSubject *)didFashionSubjc {
    if (!_didFashionSubjc) {
        _didFashionSubjc = [[RACSubject alloc] init];
    }
    return _didFashionSubjc;
}
- (RACSubject *)didVideoSubjc {
    if (!_didVideoSubjc) {
        _didVideoSubjc = [[RACSubject alloc] init];
    }
    return _didVideoSubjc;
}
- (RACSubject *)didGoodsSubjc {
    if (!_didGoodsSubjc) {
        _didGoodsSubjc = [[RACSubject alloc] init];
    }
    return _didGoodsSubjc;
}
- (NSMutableDictionary *)getAllKey {
    if (!_getAllKey) {
        _getAllKey = [NSMutableDictionary dictionary];
    }
    return _getAllKey;
}
@end
