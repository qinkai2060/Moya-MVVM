//
//  ManageOrderViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOrderViewModel.h"
#import "ManageOrderModel.h"
#import "ManageOrderListModel.h"
@interface ManageOrderViewModel ()
@property (nonatomic, assign) NSInteger pageIndex;
@end
@implementation ManageOrderViewModel
@synthesize mutableSource = _mutableSource;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageIndex = 1;
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
    return self.mutableSource.count;
}

- (NSInteger)jx_numberOfRowsInSection:(NSInteger)section {
    ManageOrderModel *model  = self.mutableSource[section];
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        return 1;
    }
    return model.orderProductList.count;
}

- (id<JXModelProtocol>)jx_modelAtIndexPath:(NSIndexPath *)indexPath {
    ManageOrderModel *model  = self.mutableSource[indexPath.section];
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        return model;
    }
    NSArray * productArray = model.orderProductList;
    return productArray[indexPath.row];
}

- (CGFloat)jx_heightAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self jx_modelAtIndexPath:indexPath];
    return model.height;
}

- (RACSignal *)loadRequest_orderListWith {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"pageNo":@1,
                              @"pageSize":@10
                              };
    self.pageIndex = 1;
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/list"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
         if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
             NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
            if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"productOrderInfoList"]) {
                NSArray * productOrderInfoList = [dataDic objectForKey:@"productOrderInfoList"];
                if (productOrderInfoList) {
                    
                    dispatch_group_t group = dispatch_group_create();
                    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                        [self.mutableSource removeAllObjects];
                    });
                    
                    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                        [productOrderInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict =productOrderInfoList[idx];
                            ManageOrderModel * model = [ManageOrderModel modelWithJSON:dict];
                            NSMutableArray * productDetail = [NSMutableArray array];
                            
                            NSArray * prodictArray = [dict objectForKey:@"orderProductList"];
                            [prodictArray enumerateObjectsUsingBlock:^(ManageOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                ManageOrderListModel * detailModel = [ManageOrderListModel modelWithJSON:prodictArray[idx]];
                                [productDetail addObject:detailModel];
                            }];
                            
                            model.orderProductList = productDetail.copy;
                            [self.mutableSource addObject:model];
                        }];
                        [subject sendNext:self.mutableSource];
                        [subject sendCompleted];
                    });
                }
            }else {
                [subject sendNext:@[]];
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

- (RACSignal *)loadRequestMore_orderListWith {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    self.pageIndex ++;
    NSDictionary * params = @{
                              @"pageNo":@(self.pageIndex),
                              @"pageSize":@10
                              };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/list"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
              if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"productOrderInfoList"]) {
                  NSArray * productOrderInfoList = [dataDic objectForKey:@"productOrderInfoList"];
                  if (productOrderInfoList) {
                      [productOrderInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          NSDictionary * dict =productOrderInfoList[idx];
                          ManageOrderModel * model = [ManageOrderModel modelWithJSON:dict];
                          NSMutableArray * productDetail = [NSMutableArray array];
                          
                          NSArray * prodictArray = [dict objectForKey:@"orderProductList"];
                          [prodictArray enumerateObjectsUsingBlock:^(ManageOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                              ManageOrderListModel * detailModel = [ManageOrderListModel modelWithJSON:prodictArray[idx]];
                              [productDetail addObject:detailModel];
                          }];
                          
                          model.orderProductList = productDetail.copy;
                          [self.mutableSource addObject:model];
                      }];
                      [subject sendNext:[RACTuple tupleWithObjects:productOrderInfoList,self.mutableSource, nil]];
                      [subject sendCompleted];
                  }
              }else {
                  [subject sendNext:[RACTuple tupleWithObjects:@[],self.mutableSource, nil]];
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

- (NSMutableArray *)mutableSource {
    if (!_mutableSource) {
        _mutableSource = [NSMutableArray array];
    }
    return _mutableSource;
}
@end
