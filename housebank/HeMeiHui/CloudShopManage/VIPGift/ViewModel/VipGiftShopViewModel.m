//
//  VipGiftShopViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftShopViewModel.h"
#import "VipGiftShopModel.h"
#import "HFDBHandler.h"
@interface VipGiftShopViewModel ()
@property (nonatomic, assign) NSInteger pageIndex;
@end
@implementation VipGiftShopViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageIndex = 1;
    }
    return self;
}

- (RACSignal *)load_AllRequestData {

    RACSubject * subject = [RACSubject subject];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./product/vip/gift/selectVipPackageProductUpgrade"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
            NSMutableArray * silverArray = [NSMutableArray array];
            NSMutableArray * platinumArray = [NSMutableArray array];
            NSMutableArray * diamondsArray = [NSMutableArray array];
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                [self.dataSource removeAllObjects];
            });
            /** 银等级*/
            if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"silverList"]) {
                NSArray * silverList = [dataDic objectForKey:@"silverList"];
                if (silverList) {
                    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
                        [silverList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict =silverList[idx];
                            VipGiftShopModel * model = [VipGiftShopModel modelWithJSON:dict];
                            [silverArray addObject:model];
                        }];
                    });
                }
            }
            /** 白金等级*/
            if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"platinumList"]) {
                NSArray * platinumList = [dataDic objectForKey:@"platinumList"];
                if (platinumList) {
                    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
                        [platinumList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict =platinumList[idx];
                            VipGiftShopModel * model = [VipGiftShopModel modelWithJSON:dict];
                            [platinumArray addObject:model];
                        }];
                    });
                }
            }
            /**钻石等级*/
            if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"diamondsIdsList"]) {
                NSArray * diamondsIdsList = [dataDic objectForKey:@"diamondsIdsList"];
                if (diamondsIdsList) {
                    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
                        [diamondsIdsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict =diamondsIdsList[idx];
                            VipGiftShopModel * model = [VipGiftShopModel modelWithJSON:dict];
                            [diamondsArray addObject:model];
                        }];
                    });
                  
                }
            }
            /** 合并数据源*/
            dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
                NSMutableDictionary * silverDic = [NSMutableDictionary dictionary];
                NSMutableDictionary * splatinumDic = [NSMutableDictionary dictionary];
                NSMutableDictionary * diamondsDic = [NSMutableDictionary dictionary];
                /**根据每层数据源个数进行判定，如果大于6的个数，那么就再次分组*/
                if(self.dataSource.count>0){
                    [self.dataSource removeAllObjects];
                }
                if (silverArray.count > 0) {
                   NSArray * newSilverArray = [self splitArray:silverArray withSubSize:6];
                   [silverDic setValue:newSilverArray forKey:@"silverArray"];
                   [self.dataSource addObject:silverDic];
                }
                if (platinumArray.count > 0) {
                   NSArray * newPlatinumArray = [self splitArray:platinumArray withSubSize:6];
                   [splatinumDic setValue:newPlatinumArray forKey:@"platinumArray"];
                   [self.dataSource addObject:splatinumDic];
                }
                if (diamondsArray.count > 0) {
                   NSArray * newDiamondsArray = [self splitArray:diamondsArray withSubSize:6];
                   [diamondsDic setValue:newDiamondsArray forKey:@"diamondsArray"];
                   [self.dataSource addObject:diamondsDic];
                }
                [subject sendNext:self.dataSource];
                [subject sendCompleted];
            });
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.clode" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}

- (RACSignal *)loadVIPProductsShow {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"pageNo":@1,
                              @"pageSize":@10
                              };
    self.pageIndex = 1;
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./product/vip/gift/selectVipPackageProductInfo"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"productInfoList"]) {
                    NSArray * productArray = [dataDic objectForKey:@"productInfoList"];
                    if (productArray) {
                        
                        dispatch_group_t group = dispatch_group_create();
                        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                            [self.dataSource removeAllObjects];
                        });
                         NSMutableArray * productDetail = [NSMutableArray array];
                        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                            [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSDictionary * dict =productArray[idx];
                                VipGiftShopModel * model = [VipGiftShopModel modelWithJSON:dict];
                                [productDetail addObject:model];
                            }];
                            self.dataSource = [productDetail mutableCopy];
                            [subject sendNext:self.dataSource];
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

- (RACSignal *)loadVIP_MoreProductsShow {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    self.pageIndex ++;
    NSDictionary * params = @{
                              @"pageNo":@(self.pageIndex),
                              @"pageSize":@10
                              };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./product/vip/gift/selectVipPackageProductInfo"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"productInfoList"]) {
                    NSArray * productArray = [dataDic objectForKey:@"productInfoList"];
                    if (productArray) {
                        [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict =productArray[idx];
                            VipGiftShopModel * model = [VipGiftShopModel modelWithJSON:dict];
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

/** Vip礼包头部*/
- (RACSignal *)load_requestHeadData {
    
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./vipUser/selectBrokerConfig"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"result"]) {
                    NSDictionary * jsonContent = [dataDic objectForKey:@"result"];
                    if (jsonContent.allKeys.count > 0) {
                
                        NSArray * AppData = [jsonContent objectForKey:@"AppData"];
                       __block NSDictionary * giftDic = [NSDictionary dictionary];
                        [AppData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dic = AppData[idx];
                            if ([dic.allKeys containsObject:@"name"] && [[dic objectForKey:@"name"] isEqualToString:@"modules_top_banner"]) {
                                giftDic = dic.copy;
                                *stop = YES;
                                [subject sendNext:giftDic];
                                [subject sendCompleted];
                            }
                        }];
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

- (RACSignal *)load_shareRequest {
    RACSubject * subject = [RACSubject subject];
    NSString * imageValue =[[[HFDBHandler selectLoginData] valueForKey:@"imagePath"]class] == [NSNull class]?@"":[[HFDBHandler selectLoginData] valueForKey:@"imagePath"];
    NSString * nameValue =[[[HFDBHandler selectLoginData] valueForKey:@"name"]class] == [NSNull class]?@"":[[HFDBHandler selectLoginData] valueForKey:@"name"];

    NSDictionary*dic;
    if ([imageValue isEqualToString:@""]) {
        dic=@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_vip_gift",@"extras":[@{@"name":objectOrEmptyStr([nameValue  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])} jsonStringEncoded]};
    }else
    {
        if (imageValue.length > 0) {
            NSString *str3 = [imageValue substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,imageValue,@"!SQ250"];
                    imageValue=imageUrl;
                }
            } else {
                imageValue=imageValue;
            }
        }
        dic=@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_vip_gift",@"extras":[@{@"headImagePath":objectOrEmptyStr(imageValue),@"name":objectOrEmptyStr([nameValue  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])} jsonStringEncoded]};
    }
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
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
