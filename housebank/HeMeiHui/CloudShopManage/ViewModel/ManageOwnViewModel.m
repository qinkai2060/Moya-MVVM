
//
//  ManageOwnViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOwnViewModel.h"
#import "ManageOwnModel.h"
#import "ManageSellEndModel.h"
#import "EmptyModel.h"
@implementation ManageOwnViewModel
@synthesize mutableSource = _mutableSource;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _refreshUISubject = [RACSubject new];
        [self loadData];
    }
    return self;
}

- (void)loadData {

}

- (RACSignal *)loadRequest_sellDataWithShopID:(NSString *)shopID Type:(NSString *)type pageNo:(NSInteger)pageNo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"pageNo":[NSString stringWithFormat:@"%ld",pageNo],
                              @"pageSize":@"20",
                              @"shopId":objectOrEmptyStr(shopID),
                              @"status":type
                              };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/my-product-list/get"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"list"]) {
                    NSArray * listArray = [dataDic objectForKey:@"list"];
                    
                    // 判断数据源  type 状态 0下架 1在售
                    dispatch_group_t group = dispatch_group_create();
                    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                        [self.mutableSource removeAllObjects];
                    });
                    
                    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                        if ([type isEqualToString:@"1"]) {
                            [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                ManageOwnModel * model = [ManageOwnModel modelWithDictionary:listArray[idx]];
                                [self.mutableSource addObject:model];
                            }];
                        }else if ([type isEqualToString:@"0"]) {
                            [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                ManageSellEndModel * model = [ManageSellEndModel modelWithDictionary:listArray[idx]];
                                [self.mutableSource addObject:model];
                            }];
                        }
                        [subject sendNext:self.mutableSource];
                        [subject sendCompleted];
                    });
                    
                }else {
                    [subject sendNext:@[]];
                    [subject sendCompleted];
                }
                
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.myshop" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.myshop" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)loadMore_sellDataWithShopID:(NSString *)shopID Type:(NSString *)type pageNo:(NSInteger)pageNo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"pageNo":[NSString stringWithFormat:@"%ld",pageNo],
                              @"pageSize":@"20",
                              @"shopId":objectOrEmptyStr(shopID),
                              @"status":type
                              };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/my-product-list/get"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                 if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"list"]) {
                     NSArray * listArray = [dataDic objectForKey:@"list"];
                     // 判断数据源  type 状态 0下架 1在售
                     if ([type isEqualToString:@"1"]) {
                         [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             ManageOwnModel * model = [ManageOwnModel modelWithDictionary:listArray[idx]];
                             [self.mutableSource addObject:model];
                         }];
                     }else if ([type isEqualToString:@"0"]) {
                         [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             ManageSellEndModel * model = [ManageSellEndModel modelWithDictionary:listArray[idx]];
                             [self.mutableSource addObject:model];
                         }];
                     }
                     [subject sendNext:[RACTuple tupleWithObjects:listArray,self.mutableSource, nil]];
                     [subject sendCompleted];
                 }else {
                     [subject sendNext:[RACTuple tupleWithObjects:@[],self.mutableSource, nil]];
                     [subject sendCompleted];
                 }
                     
            }else {
                     
                     NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                     NSError *error = [NSError errorWithDomain:@"manage.myshop" code:0 userInfo:@{@"error":errorString}];
                     [subject sendError:error];
                }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.myshop" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)down_selectShop:(NSString *)shopId productArray:(nonnull NSArray *)productArray {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSMutableArray * downArray = [NSMutableArray array];
    [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [downArray addObject:@{@"microProductId":productArray[idx]}];
    }];
    NSDictionary * params = @{
                              @"shopId":(shopId?shopId:objectOrEmptyStr(self.shopID)),
                              @"products":downArray,
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/lower-shelf"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                [subject sendNext:@"success"];
                [subject sendCompleted];
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.clode" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)putAway_selectShop:(NSString *)shopId productArray:(nonnull NSArray *)productArray {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    
    NSMutableArray * putArray = [NSMutableArray array];
    [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [putArray addObject:@{@"microProductId":productArray[idx]}];
    }];
    NSDictionary * params = @{
                              @"shopId":(shopId?shopId:objectOrEmptyStr(self.shopID)),
                              @"type":@"1",
                              @"products":putArray,
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/up-shelf"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                [subject sendNext:@"success"];
                [subject sendCompleted];
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.clode" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)TopShopWithProductID:(NSString *)productID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"id":objectOrEmptyStr(productID),
                              };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/topping"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                [subject sendNext:@"success"];
                [subject sendCompleted];
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.clode" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)loadRequest_shareTheOrederWithProductID:(NSString *)productID {
   
    RACSubject * subject = [RACSubject subject];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_cloud_goods_detail ",@"extras":[@{@"mocriShopId":self.shopID,@"productId":objectOrEmptyStr(productID),@"shopId":objectOrEmptyStr(self.shopID)} jsonStringEncoded]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
            [subject sendNext:[request.responseObject valueForKey:@"data"]];
            [subject sendCompleted];
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

- (void)setMutableSource:(NSMutableArray *)mutableSource {
    _mutableSource = mutableSource;
    [self.refreshUISubject sendNext:self.mutableSource];
}
- (NSInteger)jx_numberOfSections {
    return 1;
}

- (NSInteger)jx_numberOfRowsInSection:(NSInteger)section {
    return self.mutableSource.count;
}

- (id<JXModelProtocol>)jx_modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.mutableSource[indexPath.row];
}

- (CGFloat)jx_heightAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self jx_modelAtIndexPath:indexPath];
    return model.height;
}

- (NSMutableArray *)mutableSource {
    if (!_mutableSource) {
        _mutableSource = [NSMutableArray array];
    }
    return _mutableSource;
}
@end
