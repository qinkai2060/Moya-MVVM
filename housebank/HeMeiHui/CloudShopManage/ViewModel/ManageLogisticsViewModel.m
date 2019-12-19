//
//  ManageLogisticsViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageLogisticsViewModel.h"
#import "ManageLogticsModel.h"
#import "EmptyModel.h"
#import "ManageLogticsListModel.h"
@implementation ManageLogisticsViewModel
@synthesize dataSource = _dataSource;
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

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.refreshUISubject sendNext:self.dataSource];
}

- (NSInteger)jx_numberOfSections {
    return 1;
}

- (NSInteger)jx_numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count == 0) {
        return 0;
    }
    ManageLogticsModel * logticsModel = self.dataSource[0];
    if (logticsModel.listArray.count > 0) {
        return logticsModel.listArray.count;
    }
    return 1;
}

- (id<JXModelProtocol>)jx_modelAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        ManageLogticsModel * logticsModel = self.dataSource[0];
        if (logticsModel.listArray.count > 0) {
            return logticsModel.listArray[indexPath.row];
        }else {
            return [EmptyModel new];
        }
    }
    return [EmptyModel new];
}

- (CGFloat)jx_heightAtIndexPath:(NSIndexPath *)indexPath {

    id<JXModelProtocol> model = [self jx_modelAtIndexPath:indexPath];
    return model.height;
}

- (RACSignal *)loadRequest_logisticsDetailSource:(NSString *)logisticsID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"id":logisticsID
                              };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/view/logistics"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
          if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
              NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
               NSMutableArray * dataSource = [NSMutableArray array];
              if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"orderDeliverGoods"]) {
                  
                  NSDictionary * orderDeliverGoods = [dataDic objectForKey:@"orderDeliverGoods"];
                  ManageLogticsModel * model = [ManageLogticsModel modelWithJSON:orderDeliverGoods];
                  
                 if (![orderDeliverGoods isEqual:[NSNull null]] && orderDeliverGoods.allKeys.count > 0 && [orderDeliverGoods.allKeys containsObject:@"logisticsData"]) {
                    if (![[orderDeliverGoods objectForKey:@"logisticsData"] isEqual:[NSNull null]]) {
                        NSError *jsonError;
                        NSString * jsonString = [orderDeliverGoods objectForKey:@"logisticsData"];
                        if (jsonString.length > 0) {
                            NSData *jsonData = [[orderDeliverGoods objectForKey:@"logisticsData"] dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary *logisticsData = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingAllowFragments) error:&jsonError];
                            
                            if ([logisticsData.allKeys containsObject:@"showapi_res_body"]) {
                                NSDictionary * allDic = [logisticsData objectForKey:@"showapi_res_body"];
                                model.mailNo = objectOrEmptyStr([allDic objectForKey:@"mailNo"]);
                                model.expTextName = objectOrEmptyStr([allDic objectForKey:@"expTextName"]);
                                
                                if ([allDic.allKeys containsObject:@"data"]) {
                                    NSArray * listArray = [allDic objectForKey:@"data"];
                                    NSMutableArray * listMutableArray = [NSMutableArray array];
                                    [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        ManageLogticsListModel * itemModel = [ManageLogticsListModel modelWithJSON:listArray[idx]];
                                        [listMutableArray addObject:itemModel];
                                    }];
                                    model.listArray = listMutableArray.mutableCopy;
                                }
                            }
                        }
                        
                    }
                  }
                  [dataSource addObject:model];
                  self.dataSource = dataSource.copy;
                  [subject sendNext:dataSource];
                  [subject sendCompleted];
              }else {
                  [subject sendNext:@[]];
                  [subject sendCompleted];
              }
        }else{
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


@end
