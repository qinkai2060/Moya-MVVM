//
//  ProductFeatureModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/20.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol SKUItem

@end

@protocol SeriesAttributesItem


@end
NS_ASSUME_NONNULL_BEGIN
@interface SKUItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger            featureId;//规格ID
@property (nonatomic , copy) NSString              * code;//规格名称
@property (nonatomic , assign) NSInteger              stock;//库存
@property (nonatomic , assign) CGFloat              price;//销售价
@property (nonatomic , assign) CGFloat              intrinsicPrice;//原价（划线价）
@property (nonatomic , assign) CGFloat      singleUserNumber;//单人限购数量-弃用
@property (nonatomic , copy) NSString            *startDate;//开始时间
@property (nonatomic , copy) NSString            *endDate;//结束时间
@property (nonatomic , assign) CGFloat          promotionPrice;//促销价
@property (nonatomic , copy)   NSString         * address;//规格图片地址
@property (nonatomic , copy)   NSString         * jointPictrue;//图片裁剪
@property (nonatomic , copy)   NSString         *promotionTag;//促销标识
@property (nonatomic , assign) BOOL              redPacket;//是否红包商品-弃用
@property (nonatomic , assign) BOOL              welfare;//是否为福利商品（true：是，false：否）

@property (nonatomic , strong) SeckillInfo         *seckillInfo;
@end


@interface DescartesCombinationMap :NSObject<NSCoding>
@property (nonatomic , strong) NSArray <SKUItem>              * SKU;//展示每个类型的库存等信息

@end


@interface SeriesAttributesItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              featureDetailId;//商品属性详细ID
@property (nonatomic , assign) NSInteger              productHisId;//商品ID
@property (nonatomic , assign) NSInteger              productAttributesId;
@property (nonatomic , copy) NSString              * attributeValue;//展示小规格需自己，点切割出list//属性类值
@property (nonatomic , copy) NSArray              * featureArray;
@property (nonatomic , copy) NSString              * status;//状态 (1：生效，2：已加挂(废弃)，3：已失效)
@property (nonatomic , assign) NSInteger              inserttime;//插入时间
@property (nonatomic , copy) NSString              * insertuser;//创建人
@property (nonatomic , copy) NSString              *updatetime;//更新时间
@property (nonatomic , copy) NSString              *updateuser;//更新人
@property (nonatomic , copy) NSString              * attributeName;//属性类名
@property (nonatomic , assign) NSInteger              attributeGroup;//属性组（1：基本属性，2：系列属性）

@end


@interface ProductTtributesMap :NSObject<NSCoding>
@property (nonatomic , strong) NSArray <SeriesAttributesItem>              * seriesAttributes;

@end


@interface RsMap :NSObject<NSCoding>
@property (nonatomic , strong) DescartesCombinationMap              * descartesCombinationMap;//库存
@property (nonatomic , strong) ProductTtributesMap              * productTtributesMap;//规格大list

@end


@interface FeatureModelDetail :NSObject<NSCoding>
@property (nonatomic , strong) RsMap              * rsMap;

@end


@interface ProductFeatureModel :SetBaseModel

@property (nonatomic , strong) FeatureModelDetail            * data;

@end


NS_ASSUME_NONNULL_END
