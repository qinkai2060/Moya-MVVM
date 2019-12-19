//
//  ManageSelectViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageSelectViewModel.h"
#import "ManageSelectShopModel.h"
@interface ManageSelectViewModel ()
@property (nonatomic, assign) NSInteger pageNum;
@end
@implementation ManageSelectViewModel
@synthesize mutableSource = _mutableSource;
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.pageNum = 1;
         _refreshUISubject = [RACSubject new];
          [self loadData];
    }
    return self;
}

- (void)loadData {
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

- (RACSignal *)loadRequest_product_list:(NSString *)shopID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    self.pageNum = 1;
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"shopId":objectOrEmptyStr(shopID),
                              @"pageNo":@1,
                              @"pageSize":@10,
                              @"sid":sidStr
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/product-list/get"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@",CloudeEnvironment,utrl] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * data = [jsonDic objectForKey:@"data"];
                if (![data isEqual:[NSNull null]] && data.allKeys.count > 0 && [data.allKeys containsObject:@"list"]) {
                    NSArray * listArray = [data objectForKey:@"list"];
                    dispatch_group_t group = dispatch_group_create();
                    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                        [self.mutableSource removeAllObjects];
                    });
                    
                    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                        [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            ManageSelectShopModel * itemModel = [ManageSelectShopModel modelWithJSON:listArray[idx]];
                            [self.mutableSource addObject:itemModel];
                        }];
                        [subject sendNext:self.mutableSource];
                        [subject sendCompleted];
                    });
                }else {
                    [subject sendNext:@[]];
                    [subject sendCompleted];
                }
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,记载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.clod" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.clode" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)loadMore_productList:(NSString *)shopID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    self.pageNum ++;
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"shopId":objectOrEmptyStr(shopID),
                              @"pageNo":@(self.pageNum),
                              @"pageSize":@10,
                              @"sid":sidStr
                              };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/product-list/get"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@",CloudeEnvironment,utrl] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"list"]) {
                    NSArray * listArray = [dataDic objectForKey:@"list"];
                    
                    [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary * jsonDic = listArray[idx];
                        ManageSelectShopModel * itemModel = [ManageSelectShopModel modelWithJSON:jsonDic];
                        [self.mutableSource addObject:itemModel];
                    }];
                    
                    [subject sendNext:[RACTuple tupleWithObjects:listArray,self.mutableSource, nil]];
                    [subject sendCompleted];
                }else {
                    [subject sendNext:[RACTuple tupleWithObjects:@[],self.mutableSource, nil]];
                    [subject sendCompleted];
                }
                
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,记载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.clod" code:0 userInfo:@{@"error":errorString}];
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
    NSDictionary * params = @{
                              @"shopId":(shopId?shopId:objectOrEmptyStr(self.shopID)),
                              @"type":@"0",
                              @"products":productArray,
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

- (NSMutableArray *)mutableSource {
    if (!_mutableSource) {
        _mutableSource = [NSMutableArray array];
    }
    return _mutableSource;
}
@end
