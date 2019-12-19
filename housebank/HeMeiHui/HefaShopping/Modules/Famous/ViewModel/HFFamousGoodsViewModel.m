//
//  HFFamousGoodsViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamousGoodsViewModel.h"
#import "HFFamousGoodsBannerModel.h"
#import "HFFamousGoodsModel.h"

@implementation HFFamousGoodsViewModel
- (void)hh_initialize {
    self.pageNum = 1;
    @weakify(self)
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.dataSendSubjc sendNext:x];
    }];
    [self.headerdataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.headerdataSendSubjc sendNext:x];
    }];
    [self.shareCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.shareSubjc sendNext:x];
    }];
}
- (RACSubject *)headerdataSendSubjc {
    if (!_headerdataSendSubjc) {
        _headerdataSendSubjc = [[RACSubject alloc] init];
    }
    return _headerdataSendSubjc;
}
- (RACSubject *)dataSendSubjc {
    if (!_dataSendSubjc) {
        _dataSendSubjc = [[RACSubject alloc] init];
    }
    return _dataSendSubjc;
}
- (RACSubject *)didSelectSubjc {
    if (!_didSelectSubjc) {
        _didSelectSubjc = [[RACSubject alloc] init];
    }
    return _didSelectSubjc;
}
- (RACSubject *)shareSubjc {
    if (!_shareSubjc) {
        _shareSubjc = [[RACSubject alloc] init];
    }
    return _shareSubjc;
}
- (RACSubject *)didBannerSubjc {
    if (!_didBannerSubjc) {
        _didBannerSubjc = [[RACSubject alloc] init];
    }
    return _didBannerSubjc;
}
- (RACCommand *)dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);//192.168.0.59:8088
                [HFCarRequest requsetUrl:self.requstURL withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:@{@"pageNo":@(self.pageNum)} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                        if ([[request.responseJSONObject valueForKey:@"state"] integerValue] == 1) {
                            NSDictionary *dataDict = [request.responseJSONObject valueForKey:@"data"];
                            if ([[request.responseJSONObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                                if ([dataDict.allKeys containsObject:@"panicBuyingList"]) {
                                    if ([[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"panicBuyingList"] valueForKey:@"list"]isKindOfClass:[NSArray class]]) {
                                        NSArray *originData  = [[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"panicBuyingList"] valueForKey:@"list"] ;
                                        NSMutableArray *endingData = [[NSMutableArray alloc] init];
                                        for (NSDictionary *dict in originData) {
                                            HFFamousGoodsModel *dataModel = [[HFFamousGoodsModel alloc] init];
                                            [dataModel getDataObj:dict];
                                            [endingData addObject:dataModel];
                                        }
                                        [subscriber sendNext:endingData];
                                        [subscriber sendCompleted];
                                    }
                                }else if ([dataDict.allKeys containsObject:@"famousDiscountList"]){
                                    if ([[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"famousDiscountList"] valueForKey:@"list"]isKindOfClass:[NSArray class]]) {
                                        NSArray *originData  = [[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"famousDiscountList"] valueForKey:@"list"] ;
                                        NSMutableArray *endingData = [[NSMutableArray alloc] init];
                                        for (NSDictionary *dict in originData) {
                                            HFFamousGoodsModel *dataModel = [[HFFamousGoodsModel alloc] init];
                                            [dataModel getDataObj:dict];
                                            [endingData addObject:dataModel];
                                        }
                                        [subscriber sendNext:endingData];
                                        [subscriber sendCompleted];
                                    }
                                }
                            }
                        }else {
                            [subscriber sendNext:@(2)];
                            [subscriber sendCompleted];
                        }
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _dataCommand;
}
- (NSString*)requstParmas {
    return self.requstPrams.length == 0?@"":self.requstPrams;
}
- (RACCommand *)headerdataCommand {
    if (!_headerdataCommand) {
        _headerdataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                 NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./Advertising/advertisingAllocationDetailListH5OrApp"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"mark":@"APP",@"seat":self.requstPrams} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                        if ([[request.responseJSONObject valueForKey:@"state"] integerValue] == 1) {
                            if ([[request.responseJSONObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]] &&[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"list"]isKindOfClass:[NSArray class]]) {
                                NSArray *originData  = [[request.responseJSONObject valueForKey:@"data"] valueForKey:@"list"];
                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 1"];
                                  NSArray *dataNewArr =    [originData filteredArrayUsingPredicate:predicate];
                                NSMutableArray *endingData = [[NSMutableArray alloc] init];
                                for (NSDictionary *dict in dataNewArr) {
                                    HFFamousGoodsBannerModel *dataModel = [[HFFamousGoodsBannerModel alloc] init];
                                    [dataModel getData:dict];
                                    [endingData addObject:dataModel];
                                }
                                [subscriber sendNext:endingData];
                                [subscriber sendCompleted];
                            }
                        }else {
                            [subscriber sendNext:@(2)];
                            [subscriber sendCompleted];
                        }
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _headerdataCommand;
}
- (RACCommand *)shareCommand {
    if (!_shareCommand) {
        _shareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageTag":self.pageTag.length == 0 ?@"":self.pageTag,@"sid":[HFCarShoppingRequest sid],@"terminal":[HFCarRequest terminal]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                        if ([[request.responseJSONObject valueForKey:@"state"] integerValue] == 1) {
                            if ([[request.responseJSONObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]] ) {
                             
                           
                                [subscriber sendNext:[request.responseJSONObject valueForKey:@"data"]];
                                [subscriber sendCompleted];
                            }
                        }else {
                            [subscriber sendNext:@(2)];
                            [subscriber sendCompleted];
                        }
                    }
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
@end
