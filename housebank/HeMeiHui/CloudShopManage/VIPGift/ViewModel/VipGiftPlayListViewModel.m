//
//  VipGiftPlayListViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftPlayListViewModel.h"
#import "VipGiftListModel.h"
@interface VipGiftPlayListViewModel ()
@property (nonatomic, assign) NSInteger pageIndex;
@end
@implementation VipGiftPlayListViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageIndex = 1;
    }
    return self;
}

- (RACSignal *)loadVIP_PlayListRequestShow {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"mark":@"App",
                              @"pageNo":@1,
                              @"pageSize":@10
                              };
    self.pageIndex = 1;
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./vip/product/video/selectAdminConfig"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                NSDictionary * headDic;
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"result"]) {
                     headDic = [dataDic objectForKey:@"result"];
                }
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"videoList"]) {
                    NSArray * productArray = [dataDic objectForKey:@"videoList"];
        
                    if (![productArray isEqual:[NSNull null]] &&[productArray count] > 0) {
                        
                        dispatch_group_t group = dispatch_group_create();
                        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                            [self.dataSource removeAllObjects];
                        });
                        NSMutableArray * productDetail = [NSMutableArray array];
                        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                            [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSDictionary * dict =productArray[idx];
                                VipGiftListModel * model = [VipGiftListModel modelWithJSON:dict];
                                [productDetail addObject:model];
                            }];
                            self.dataSource = [productDetail mutableCopy];

                            [subject sendNext:[RACTuple tupleWithObjects:objectOrEmptyStr(headDic),self.dataSource, nil]];
                            [subject sendCompleted];
                        });
                    }else {
                        [subject sendNext:[RACTuple tupleWithObjects:@{@"moduleStatus":@"1"},@[],nil]];
                        [subject sendCompleted];
                    }
                }else {
                    [subject sendNext:[RACTuple tupleWithObjects:objectOrEmptyStr(headDic),@[],nil]];
                    [subject sendCompleted];
                }
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

- (RACSignal *)loadMoreVIP_PlayListRequestShow {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    self.pageIndex ++;
    NSDictionary * params = @{
                              @"mark":@"App",
                              @"pageNo":@(self.pageIndex),
                              @"pageSize":@10
                              };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./vip/product/video/selectAdminConfig"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"videoList"]) {
                    NSArray * productArray = [dataDic objectForKey:@"videoList"];
                    if (productArray) {
                        [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict =productArray[idx];
                            VipGiftListModel * model = [VipGiftListModel modelWithJSON:dict];
                            [self.dataSource addObject:model];
                        }];
                        [subject sendNext:[RACTuple tupleWithObjects:productArray,self.dataSource, nil]];
                        [subject sendCompleted];
                    }
                }else {
                    [subject sendNext:[RACTuple tupleWithObjects:@[],self.dataSource, nil]];
                    [subject sendCompleted];
                }
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

- (RACSignal *)loadVIP_PlayDetailRequestWith:(NSString *)productID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./product/vip/wholesale/video/product"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@/%@?sid=%@",utrl,objectOrEmptyStr(productID),sidStr] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];

                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"result"]) {
                    NSDictionary * productDetail = [dataDic objectForKey:@"result"];
                    if (productDetail) {
                        [subject sendNext:productDetail];
                        [subject sendCompleted];
                    }
                }else {
                    NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                    NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                    [subject sendError:error];
                }
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

- (RACSignal *)load_shareVideoRequest {
    RACSubject * subject = [RACSubject subject];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_wholesale_video"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
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

- (NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
