//
//  GroupViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "GroupViewModel.h"
#import "MyGroupModel.h"
#import "HFCarRequest.h"
#import "EmptyModel.h"
#define groupPurches @"cache.group"
@implementation GroupViewModel
@synthesize mutableSource   = _mutableSource;

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
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        [self loadNewWork];
    }else {
//        [self loadFromCache];
    }
}

- (void)loadNewWork {
    @weakify(self);
    [[self loadRequest_GroupPurchaseWithType:@"OPEN" pageNo:1] subscribeNext:^(NSMutableArray * x) {
        @strongify(self);
        self.mutableSource = x;
        
        if (self.mutableSource.count == 0) {
            self.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
        }
//        /** 添加缓存*/
//        if (self.mutableSource) {
//            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.mutableSource];
//            [[NSUserDefaults standardUserDefaults] setObject:data forKey:groupPurches];
//        }
    }];
}

//
///** 从缓存中拿取*/
//- (void)loadFromCache {
//    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:groupPurches];
//    NSMutableArray * mutaleArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    self.mutableSource = mutaleArray;
//}

- (void)setMutableSource:(NSMutableArray *)mutableSource {
    _mutableSource = mutableSource;
    [self.refreshUISubject sendNext:mutableSource];
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

- (RACSignal *)loadRequest_GroupPurchaseWithType:(NSString *)type pageNo:(NSInteger)pageNo {
    
    NSDictionary *params = @{
                             @"type":objectOrEmptyStr(type),
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo],
                             @"pageSize":@"20",
                             @"sid":objectOrEmptyStr([HFCarShoppingRequest sid])
                             };
    
    RACSubject * subject = [RACSubject subject];
    @weakify(self);
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/openGroup/selectUserOpenGroup"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                
                NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                NSArray * openGroupArray = [dataDic objectForKey:@"openGroupList"];
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                    [self.mutableSource removeAllObjects];
                });

                dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                    [openGroupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        MyGroupModel * myGroupModel = [[MyGroupModel alloc]init];
                        NSDictionary * dict = openGroupArray[idx];
                        myGroupModel.dataSource = @[[MyGroupItemModel modelWithDictionary:dict]];
                        [self.mutableSource addObject:myGroupModel];
                    }];
                    
                    [subject sendNext:self.mutableSource];
                    [subject sendCompleted];
                });
                
            }else {
                NSError *error = [NSError errorWithDomain:@"collect.group" code:0 userInfo:@{@"error":[jsonDic objectForKey:@"msg"]}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"collect.group" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return  subject;
}

- (RACSignal *)loadMoreRequest_GroupPurchaseWithType:(NSString *)type pageNo:(NSInteger)pageNo {
    
    NSDictionary *params = @{
                             @"type":objectOrEmptyStr(type),
                             @"pageNo":[NSString stringWithFormat:@"%ld",pageNo],
                             @"pageSize":@"20",
                             @"sid":objectOrEmptyStr([HFCarShoppingRequest sid])
                             };
    
    RACSubject * subject = [RACSubject subject];
    @weakify(self);
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/openGroup/selectUserOpenGroup"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                
                NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                NSArray * openGroupArray = [dataDic objectForKey:@"openGroupList"];
                
                [openGroupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MyGroupModel * myGroupModel = [[MyGroupModel alloc]init];
                    NSDictionary * dict = openGroupArray[idx];
                    myGroupModel.dataSource = @[[MyGroupItemModel modelWithDictionary:dict]];
                    [self.mutableSource addObject:myGroupModel];
                }];
                
                [subject sendNext:[RACTuple tupleWithObjects:openGroupArray,self.mutableSource, nil]];
                [subject sendCompleted];
            }else {
                NSError *error = [NSError errorWithDomain:@"collect.group" code:0 userInfo:@{@"error":[jsonDic objectForKey:@"msg"]}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"collect.group" code:0 userInfo:@{@"error":@"网络状况不好,记载失败!"}];
        [subject sendError:error];
    }];
    return  subject;
}

- (NSMutableArray *)mutableSource {
    if (!_mutableSource) {
        _mutableSource = [NSMutableArray array];
    }
    return _mutableSource;
}
@end
