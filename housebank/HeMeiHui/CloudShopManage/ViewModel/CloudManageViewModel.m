
//
//  CloudManageViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudManageViewModel.h"
#import "EmptyModel.h"
#import "CloudManageModel.h"
@implementation CloudManageViewModel
@synthesize dataSource  = _dataSource ;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _refreshUISubject = [RACSubject new];
        self.shopTypes = NoWeiShop;
        [self loadData];
    }
    return self;
}

- (void)loadData {
//    @weakify(self);
//    [[self loadRequest_ShopList]subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        self.dataSource = (NSArray *)x;
//    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.refreshUISubject sendNext:self.dataSource];
}

- (NSInteger)jx_numberOfSections {
    return 1;
}

- (NSInteger)jx_numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (id<JXModelProtocol>)jx_modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row];
}

- (CGFloat)jx_heightAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self jx_modelAtIndexPath:indexPath];
    return model.height;
}

- (shopTypes)judgeShopTypes {
    return self.shopTypes;
}

- (RACSignal *)loadRequest_ShopList {
    self.shopTypes = NoWeiShop;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"pageNo":@1,
                              @"pageSize":@100,
                              @"type":@2,
                              @"showAll":@1
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/list"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,objectOrEmptyStr(utrl),sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
             NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                  if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"shops"]){
                      
                      NSArray * shopsArray = [dataDic objectForKey:@"shops"];
                      NSMutableArray * dataSource = [NSMutableArray array];
                      [shopsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          NSDictionary * jsonDic = shopsArray[idx];
                          if (jsonDic) {
                              CloudManageModel * shopModel = [[CloudManageModel alloc]init];
                              shopModel.dataSource = @[[CloudManageItemModel modelWithJSON:jsonDic]];
                              [dataSource addObject:shopModel];
                              
                              // 判断有没有微店
                              if ([[jsonDic objectForKey:@"shopType"]  isEqual: @3]) {
                                  self.shopTypes = haveWeiShop;
                              }
                          }
                      }];
                      [subject sendNext:dataSource];
                      [subject sendCompleted];
                  }else {
                      [subject sendNext:@[]];
                      [subject sendCompleted];
                  }
                
            }else {
                NSError *error = [NSError errorWithDomain:@"cloud.shop" code:0 userInfo:@{@"error":[jsonDic objectForKey:@"msg"]}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

/** 二维码*/
- (RACSignal *)create_shopQrcode:(NSString *)shopID shopType:(NSString *)shopType {
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/qrcode"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@/%@/%@",CloudeEnvironment,utrl,shopID,objectOrEmptyStr(shopType)] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * codeDic = [jsonDic objectForKey:@"data"];
                if ([codeDic.allKeys containsObject:@"url"]) {
                    [subject sendNext:[codeDic objectForKey:@"url"]];
                    [subject sendCompleted];
                }
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}
@end
