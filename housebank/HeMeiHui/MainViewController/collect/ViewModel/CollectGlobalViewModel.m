//
//  CollectGlobalViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectGlobalViewModel.h"
#import "CollectGlobalModel.h"
#define collectGlobalKey @"cache.global"
#import "HFCarRequest.h"
#import "EmptyModel.h"
@interface CollectGlobalViewModel ()
@property (nonatomic, assign) NSInteger index;
@end

@implementation CollectGlobalViewModel

@synthesize mutableSource = _mutableSource ;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _refreshUISubject = [RACSubject new];
        _index = 1;
        [self loadData];
    }
    return self;
}
- (void)loadData {
    
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        [self loadNewWork];
    }else {
        [self loadFromCache];
    }
}

- (void)loadNewWork {
    
    @weakify(self);
    [[self loadRequest_GlobalHome]subscribeNext:^(NSMutableArray * x) {
        @strongify(self);
        self.mutableSource = x;
        
        if (self.mutableSource.count == 0) {
            self.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
        }else {
            /** 添加缓存*/
            if (self.mutableSource) {
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.mutableSource];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:collectGlobalKey];
            }
        }
    }];
}

/** 从缓存中拿取*/
- (void)loadFromCache {
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:collectGlobalKey];
    NSMutableArray * mutaleArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.mutableSource = mutaleArray;
}

-(void)setMutableSource:(NSMutableArray *)mutableSource {
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

- (RACSignal *)loadRequest_GlobalHome {
    
    self.index = 1;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *params = @{
                             @"pageSize":@"10",
                             @"pageNo":[NSString stringWithFormat:@"%ld",self.index],
                             @"sid":objectOrEmptyStr(sidStr)
                             };
    @weakify(self);
    RACSubject * subject = [RACSubject subject];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"house./user/myFollowHouse/selectAllFollow"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                @strongify(self);
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                NSArray * allFollowArray = [dataDic objectForKey:@"AllFollows"];
                [self.mutableSource removeAllObjects];
                
                [allFollowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * itemDic = allFollowArray[idx];
                    CollectGlobalModel *productModel = [[CollectGlobalModel alloc]init];
                    productModel.dataSource = @[[CollectGlobalItemModel modelWithJSON:itemDic]];
                    [self.mutableSource addObject:productModel];
                }];
                [subject sendNext:self.mutableSource];
                [subject sendCompleted];
                
            }else {
                NSError *error = [NSError errorWithDomain:@"collect.product" code:0 userInfo:@{@"error":[jsonDic objectForKey:@"msg"]}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return  subject;
}

- (RACSignal *)loadMoreRequest_GlobalHome{
    
    self.index ++;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *params = @{
                             @"pageSize":@"10",
                             @"pageNo":[NSString stringWithFormat:@"%ld",self.index],
                             @"sid":objectOrEmptyStr(sidStr)
                             };
    @weakify(self);
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"house./user/myFollowHouse/selectAllFollow"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            @strongify(self);
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                NSArray * allFollowArray = [dataDic objectForKey:@"AllFollows"];
            
                [allFollowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSDictionary * itemDic = allFollowArray[idx];
                    CollectGlobalModel *productModel = [[CollectGlobalModel alloc]init];
                    productModel.dataSource = @[[CollectGlobalItemModel modelWithJSON:itemDic]];
                    [self.mutableSource addObject:productModel];
                }];
                [subject sendNext:[RACTuple tupleWithObjects:self.mutableSource,allFollowArray, nil]];
                [subject sendCompleted];
                
            }else {
                NSError *error = [NSError errorWithDomain:@"collect.product" code:0 userInfo:@{@"error":[jsonDic objectForKey:@"msg"]}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return  subject;
}


- (RACSignal *)deleteProductCollectWithHotelld:(NSString *)hotelld {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"house./user/hotelinfo/disAttentionHotel"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?hotelId=%@&checkBefore=1&sid=%@",utrl,objectOrEmptyStr(hotelld),objectOrEmptyStr(sidStr)] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                [subject sendNext:@1];
                [subject sendCompleted];
            }else {
                [subject sendNext:@0];
                [subject sendCompleted];
            }
        }

    } error:^(__kindof YTKBaseRequest * _Nonnull request) {

        NSLog(@"");
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
