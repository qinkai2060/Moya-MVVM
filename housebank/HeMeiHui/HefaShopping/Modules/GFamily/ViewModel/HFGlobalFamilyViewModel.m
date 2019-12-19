//
//  HFGlobalFamilyViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobalFamilyViewModel.h"
#import "HFHotelDataModel.h"
#import "HFFilterLocationModel.h"

@implementation HFGlobalFamilyViewModel
- (RACCommand *)getHotelDataCommand {
    if (!_getHotelDataCommand) {
        _getHotelDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"search.hotelinfo/search"];
                if (getUrlStr) {
                    getUrlStr =getUrlStr;
                }
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageNo":@(self.pageNo),@"keyword":self.keyword,@"bookStart":self.bookStar,@"bookEnd":self.bookEnd,@"localPointLng":self.localPointLng.length == 0 ?@"":self.localPointLng,@"localPointLat":self.localPointLat.length == 0?@"":self.localPointLat,@"minPrice":self.minPrice,@"maxPrice":[self.maxPrice isEqualToString:@"不限"]?@"":self.maxPrice,@"star":self.star,@"distance":self.distance,@"cityId":self.cityId,@"regionId":self.regionId,@"bedType":self.bedType,@"breakfastType":self.breakfastType,@"orderByType":self.orderByType,@"sid":[HFCarShoppingRequest sid]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSArray class]]) {
                        NSArray *array = [request.responseObject valueForKey:@"data"];
                        NSLog(@"%@",array);
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dict in array) {
                            HFHotelDataModel *hotelModel = [[HFHotelDataModel alloc] init];
                            [hotelModel getData:dict];
                            [tempArray addObject:hotelModel];
                        }
                        [subscriber sendNext:tempArray];
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
    return _getHotelDataCommand;
}
- (RACCommand *)getRegionDatCommand {
    if (!_getRegionDatCommand) {
        _getRegionDatCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./data/queryRegionsByParentId"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"parentId":@(self.cityId.integerValue)} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSArray class]]) {
                        NSArray *array = request.responseObject;
                        NSMutableArray *tempArray = [NSMutableArray array];
                        HFFilterLocationModel *suzbchuangModel = [[HFFilterLocationModel alloc] init];
                        suzbchuangModel.title = @"不限";
                        suzbchuangModel.isSelected = YES;
                        suzbchuangModel.parentId = [self.cityId integerValue];
                        suzbchuangModel.regionId = 0;
                        [tempArray addObject:suzbchuangModel];
                        for (NSDictionary *dict in array) {
                            HFFilterLocationModel *hotelModel = [[HFFilterLocationModel alloc] init];
                            [hotelModel getDataDict:dict];
                            [tempArray addObject:hotelModel];
                        }
                        [subscriber sendNext:tempArray];
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
    return _getRegionDatCommand;
}
- (void)hh_initialize {
    [self inializeRequstPrams];
    @weakify(self);
    [self.getHotelDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.hotelDataSubjc sendNext:x];
    }];
    [self.getRegionDatCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.regionDataSubjc sendNext:x];
    }];
}
- (void)inializeRequstPrams {
    self.pageNo = 1;
    self.keyword = @"";
    self.bookStar = @"";
    self.bookEnd = @"";
    self.localPointLat = @"";
    self.localPointLng = @"";
    self.minPrice = @"0";
    self.maxPrice = @"";
    self.star = @"0";
    self.distance = @"";
    self.cityId = @"";
    self.regionId = @"";
    self.bedType = @"";
    self.breakfastType = @"";
    self.orderByType = @"";
    
}
- (RACSubject *)hotelDataSubjc {
    if (!_hotelDataSubjc) {
        _hotelDataSubjc = [[RACSubject alloc] init];
    }
    return _hotelDataSubjc;
}
- (RACSubject *)getCitySubjc {
    if (!_getCitySubjc) {
        _getCitySubjc = [[RACSubject alloc] init];
    }
    return _getCitySubjc;
}
- (RACSubject *)getDateSubjc {
    if (!_getDateSubjc) {
        _getDateSubjc = [[RACSubject alloc] init];
    }
    return _getDateSubjc;
}
- (RACSubject *)getSearchSubjc {
    if (!_getSearchSubjc) {
        _getSearchSubjc = [[RACSubject alloc] init];
    }
    return _getSearchSubjc;
}
- (RACSubject *)regionDataSubjc {
    if (!_regionDataSubjc) {
        _regionDataSubjc = [[RACSubject alloc] init];
    }
    return _regionDataSubjc;
}
- (RACSubject *)getKeyWordSubjc {
    if (!_getKeyWordSubjc) {
        _getKeyWordSubjc = [[RACSubject alloc] init];
    }
    return _getKeyWordSubjc;
}
- (RACSubject *)setKeyWordSubjc {
    if (!_setKeyWordSubjc) {
        _setKeyWordSubjc = [[RACSubject alloc] init];
    }
    return _setKeyWordSubjc;
}
- (RACSubject *)didDetailSubjc {
    if (!_didDetailSubjc) {
        _didDetailSubjc = [[RACSubject alloc] init];
    }
    return _didDetailSubjc;
}
- (RACSubject *)didScreenSubjc {
    if (!_didScreenSubjc) {
        _didScreenSubjc = [[RACSubject alloc] init];
    }
    return _didScreenSubjc;
}
@end
