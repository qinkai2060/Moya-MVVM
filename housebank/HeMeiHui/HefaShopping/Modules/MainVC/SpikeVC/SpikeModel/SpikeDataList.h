//
//  SpikeDataList.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol ListItemmodel//不带*号

@end

NS_ASSUME_NONNULL_BEGIN
@interface ListItemmodel :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              productId;//商品Id
@property (nonatomic , copy) NSString              * productName;//商品名称
@property (nonatomic , copy) NSString              * productSubtitle;//商品副标题
@property (nonatomic , copy) NSString              * productImage;//商品图片
@property (nonatomic , copy) NSString              * classifications;//商品分类
@property (nonatomic , assign) NSInteger              specificationsId;
@property (nonatomic , assign) NSInteger              stock;//库存
@property (nonatomic , assign) NSInteger              purchasedQuantity;//已卖掉数量
@property (nonatomic , assign) float              progress;//销售进度
@property (nonatomic , assign) float              cashPrice;//销售价
@property (nonatomic , assign) float              promotionPrice;//促销价
@property (nonatomic , copy) NSString              *stateStr;
@end


@interface Spikes :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              pageNum;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , assign) NSInteger              startRow;
@property (nonatomic , assign) NSInteger              endRow;
@property (nonatomic , assign) NSInteger              total;
@property (nonatomic , assign) NSInteger              pages;
@property (nonatomic , strong) NSArray <ListItemmodel>              * list;
@property (nonatomic , assign) NSInteger              firstPage;
@property (nonatomic , assign) NSInteger              prePage;
@property (nonatomic , assign) NSInteger              nextPage;
@property (nonatomic , assign) NSInteger              lastPage;
@property (nonatomic , assign) BOOL              isFirstPage;
@property (nonatomic , assign) BOOL              isLastPage;
@property (nonatomic , assign) BOOL              hasPreviousPage;
@property (nonatomic , assign) BOOL              hasNextPage;
@property (nonatomic , assign) NSInteger              navigatePages;
@property (nonatomic , strong) NSArray <NSNumber *>              * navigatepageNums;

@end


@interface Data :NSObject<NSCoding>
@property (nonatomic , strong) Spikes              * spikes;

@end


@interface SpikeDataList :SetBaseModel
@property (nonatomic , strong) Data              * data;

@end


NS_ASSUME_NONNULL_END
