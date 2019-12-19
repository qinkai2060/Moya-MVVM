//
//  CollectShopViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectShopViewModel.h"
#import "CollectShopModel.h"
#import "EmptyModel.h"
#define collectShopKey @"cache.shop"
@implementation CollectShopViewModel
@synthesize mutableSource = _mutableSource ;

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

    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        [self loadNewWork];
    }else {
        [self loadFromCache];
    }
}

- (void)loadNewWork {
    
    @weakify(self);
    [[self loadRequest_collectProduct]subscribeNext:^(NSMutableArray * x) {
        @strongify(self);
        self.mutableSource = x;
        
        if (self.mutableSource.count == 0) {
            self.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
        }else {
            /** 添加缓存*/
            if (self.mutableSource) {
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.mutableSource];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:collectShopKey];
            }
        }
    }];
}

/** 从缓存中拿取*/
- (void)loadFromCache {
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:collectShopKey];
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

- (RACSignal *)loadRequest_collectProduct {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *params = @{
                             @"followType":@"SHOP",
                             @"pageNo":@1,
                             @"sid":objectOrEmptyStr(sidStr)
                             };
    
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/getMyfollow"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                NSDictionary * productDic = [dataDic objectForKey:@"lmf"];
                NSArray * listarray = [productDic objectForKey:@"list"];
                NSMutableArray * dataSource = [NSMutableArray array];
                [listarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * itemDic = listarray[idx];
                    CollectShopModel *productModel = [[CollectShopModel alloc]init];
                    productModel.dataSource = @[[CollectShopItemModel modelWithJSON:itemDic]];
                    [dataSource addObject:productModel];
                }];
                
                [subject sendNext:dataSource];
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

- (RACSignal *)deleteProductCollectWithProuctID:(NSString *)productId projectId:(NSString *)projectId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *params = @{
                            @"followType":@"SHOP",
                             @"projectId":objectOrEmptyStr(projectId),
                             @"sid":objectOrEmptyStr(sidStr),
                             @"shopUserId":objectOrEmptyStr(productId),
                             @"terminal":@"P_TERMINAL_MOBILE"
                             };
    RACSubject * subject = [RACSubject subject];
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/addMyfollow"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
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
