//
//  CollectViewModel+loadData.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectViewModel+loadData.h"
#import "CollectProductModel.h"
@implementation CollectViewModel (loadData)
- (RACSignal *)loadRequest_collectProduct {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *params = @{
                             @"followType":@"MALL",
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
                NSArray * productArray = [dataDic objectForKey:@"productInfoList"];
                NSMutableArray * dataSource = [NSMutableArray array];
                [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * itemDic = productArray[idx];
                    CollectProductModel *productModel = [[CollectProductModel alloc]init];
                    productModel.dataSource = @[[CollectProductItemModel modelWithJSON:itemDic]];
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
        [subject sendError:request.error];
    }];
    return  subject;
}

- (RACSignal *)deleteProductCollectWithProuctID:(NSString *)productId projectId:(NSString *)projectId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *params = @{
                             @"followType":@"MALL",
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

@end
