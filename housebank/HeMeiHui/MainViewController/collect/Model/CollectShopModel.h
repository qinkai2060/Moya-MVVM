//
//  CollectShopModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface CollectShopItemModel : NSObject <NSCoding, JXModelProtocol>
@property (nonatomic, copy) NSString * productId; /** 产品id*/
@property (nonatomic, copy) NSString * title;     /** 产品名称*/
@property (nonatomic, copy) NSString * price;     /** 商品最低价格*/
@property (nonatomic, copy) NSString * cityName;  /** 城市*/
@property (nonatomic, copy) NSString * regionName;/** 区域*/
@property (nonatomic, copy) NSString * imagePath; /** 图片路径*/
@property (nonatomic, copy) NSString * active;    /** 是否团购*/
@property (nonatomic, strong)NSNumber * followCount;/** 总关注数*/
@property (nonatomic, copy) NSString * projectId;  /** 楼盘id对应newhouse_project里面id*/
@property (nonatomic, copy) NSString * createDate; /** 创建时间*/
@property (nonatomic, copy) NSString * jointPictrue; /** 图片拼接*/
@property (nonatomic, copy) NSString * shopsName;  /** 店铺名称*/
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * shopsType;
@end

@interface CollectShopModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSArray <CollectShopItemModel *> *dataSource;
@end

NS_ASSUME_NONNULL_END
