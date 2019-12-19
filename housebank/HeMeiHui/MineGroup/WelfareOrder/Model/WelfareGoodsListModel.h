//
//  WelfareGoodsListModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelfareGoodsListModel : NSObject
@property (nonatomic, strong) NSNumber *shopId;//店铺id
@property (nonatomic, strong) NSString *shopName;//店铺名称
@property (nonatomic, strong) NSNumber *productId;//商品id
@property (nonatomic, strong) NSNumber *specificationsId;//规格id
@property (nonatomic, strong) NSString *productName;//商品名称
@property (nonatomic, strong) NSString *productSubtitle;//产品副标题
@property (nonatomic, strong) NSNumber *cashPrice;//成本价
@property (nonatomic, strong) NSNumber *stock;//库存
@property (nonatomic, strong) NSNumber *singleProductState;//是否单品(0 单品 1 系列商品)
@property (nonatomic, strong) NSNumber *useRegisterCoupon;//是否使用优惠券 1显示 其他隐藏
@property (nonatomic, strong) NSString *firstClassifyName;//一级名称
@property (nonatomic, strong) NSString *secondClassifyName;//二级名称
@property (nonatomic, strong) NSString *thirdClassifyName;//三级名称
@property (nonatomic, strong) NSString *imageUrl;//图片url
@property (nonatomic, strong) NSString *jointPictrue;//图片尾部拼接参数
@property (nonatomic, strong) NSNumber *productLevel;//商品等级 1：一级商品，2：二级商品，3：三级商品
@end

NS_ASSUME_NONNULL_END
