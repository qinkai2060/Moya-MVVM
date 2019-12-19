//
//  HFHightEndGoodsViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHightEndGoodsViewModel.h"
#import "HFDataModel.h"
@implementation HFHightEndGoodsViewModel
- (void)hh_initialize {
    self.pageNum = 1;
    @weakify(self)
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.dataSendSubjc sendNext:x];
    }];
    [self.shareCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.shareSubjc sendNext:x];
    }];
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
- (RACCommand *)dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                  NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/m/product-welfare/direct-supply-list"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageNo":@(self.pageNum),@"pageSize":@(10),@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    YTKRequest *base = (YTKRequest*)request;
                    if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                        if ([[request.responseJSONObject valueForKey:@"state"] integerValue] == 1) {
                            if ([[request.responseJSONObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]] &&[[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"list"]isKindOfClass:[NSArray class]]) {
                                NSArray *originData  = [[request.responseJSONObject valueForKey:@"data"] valueForKey:@"list"];
                                NSMutableArray *endingData = [[NSMutableArray alloc] init];
                                for (NSDictionary *dict in originData) {
                                    HFDataModel *dataModel = [[HFDataModel alloc] init];
                                    [dataModel getDataObj:dict];
                                    dataModel.tag = [HFUntilTool EmptyCheckobjnil:[[request.responseJSONObject valueForKey:@"data"] valueForKey:@"tag"]];
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
    return _dataCommand;
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
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageTag":@"fy_mall_direct_boutique",@"sid":[HFCarShoppingRequest sid],@"terminal":[HFCarRequest terminal]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
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
