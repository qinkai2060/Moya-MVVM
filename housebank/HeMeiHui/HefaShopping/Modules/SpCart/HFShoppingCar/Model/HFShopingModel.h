//
//  HFShopingModel.h
//  housebank
//
//  Created by usermac on 2018/11/7.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarBaseModel.h"
@class HFGoodsPriceModel;
NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSInteger,HFCarListType) {
    HFCarListTypeDefualt = 1,
    HFCarListTypeOverTime = 2,// 失效
    HFCarListTypeNoneStock = 3// 重选
};
@interface HFShopingModel : HFCarBaseModel

@property(nonatomic,assign) NSInteger totalShoppingCount;
@property(nonatomic,strong)NSMutableArray *productList;
@property(nonatomic,strong)NSMutableArray *loseeproductList;
/**
 商铺 ID
 */
@property(nonatomic,copy)  NSString *shopsId;

/**
 商铺名称
 */
@property(nonatomic,copy)  NSString *shopsName;

/**
 用户ID
 */
@property(nonatomic,copy)  NSString *userId;
/**
 是否正在编辑状态
 */
@property(nonatomic,assign)  BOOL isEditing;
/**
 正在编辑状态下的选中
 */
@property(nonatomic,assign)  BOOL EditingSectionSelected;
/**
 非在编辑状态下的选中
 */
@property(nonatomic,assign)  BOOL isSectionSelected;
/**
 购买数量
 */
@property(nonatomic,assign) NSInteger outStockCount;
/**
 购买数量
 */
@property(nonatomic,assign) NSInteger loseCount;

@property(nonatomic,assign)  NSInteger   sectionCont;

@property(nonatomic,assign) HFCarListType contentMode;

@end
@interface HFStoreModel :NSObject

/**
 限购
 */
@property(nonatomic,assign)  NSInteger purchaseLimitation;

@property(nonatomic,assign)  CGFloat rowHeight;

@property(nonatomic,assign)  NSInteger stock;

@property(nonatomic,assign)  BOOL singleProductState;

@property(nonatomic,copy)  NSString *identifier;
/**
 是否在编辑
 */
@property(nonatomic,assign)  BOOL editing;
/**
 在编辑状态下的选中
 */
@property(nonatomic,assign)  BOOL editingRowSelected;
/**
 非在编辑状态下的选中
 */
@property(nonatomic,assign)  BOOL isRowSelected;

@property(nonatomic,assign)  BOOL   minEnableD;

@property(nonatomic,assign)  NSInteger   rowCont;
/**
 产品类别
 */
@property(nonatomic,copy) NSString *classifyName;
/**
 产品类别
 */
@property(nonatomic,copy) NSString *deliveryAddress;
/**
 商铺 ID
 */
@property(nonatomic,copy)  NSString *shopsId;

/**
 商家地址
 */
@property(nonatomic,copy) NSString *storeId;
/**
 现金体验价
 */
@property(nonatomic,copy) NSString *experiencePrice;

/**
 销售价
 */
@property(nonatomic,copy) NSString *price;

/**
 产品ID
 */
@property(nonatomic,copy) NSString *productId;

/**
 产品主图
 */
@property(nonatomic,copy) NSString *productPic;
/**
 产品规格
 */
@property(nonatomic,copy) NSDictionary *productspMap;

/**
 购买数量
 */
@property(nonatomic,assign) NSInteger shoppingCount;

/**
 标题
 */
@property(nonatomic,copy) NSString *title;

/**
 规格ID
 */
@property(nonatomic,copy) NSString *typeId;

/**
 规格名称
 */
@property(nonatomic,copy) NSString *typeTitle;//productLevel
/**
 几类商品
 */
@property(nonatomic,assign) NSInteger productLevel;
/**
 标签
 */
@property(nonatomic,copy) NSString *promotionTag;
/**
 几类商品
 */
@property(nonatomic,copy) NSString *productLevelStr;

/**
 是否过期
 */
@property(nonatomic,assign) NSInteger status;

@property(nonatomic,copy)NSString *commodityId;
@property(nonatomic,copy)NSString *specifications;
@property(nonatomic,copy)NSString *countStr;
@property(nonatomic,copy)NSString *resetprice;
@property(nonatomic,copy)NSString *code;

@property(nonatomic,assign) HFCarListType ContentMode;
@property(nonatomic,strong) HFGoodsPriceModel *pricePrice;

- (void)getData:(NSDictionary *)data;
@end
@interface HFGoodsPriceModel:NSObject
@property(nonatomic,copy)  NSString *promotionTag;
/**
团购销售价
 */
@property(nonatomic,assign) CGFloat activeCashPrice;

/**
团购结束日期
 */
@property(nonatomic,copy) NSString *activeEndDate;

/**
 团购成本价
 */
@property(nonatomic,assign) CGFloat activePrice;

/**
 团购开始日期
 */
@property(nonatomic,copy) NSString *activeStartDate;

/**
 现金体验价
 */
@property(nonatomic,assign) CGFloat cashPrice;

/**
 结束日期
 */
@property(nonatomic,copy) NSString *endDate;

/**
 原价
 */
@property(nonatomic,assign) CGFloat intrinsicPrice;

/**
 成本价
 */
@property(nonatomic,assign) CGFloat price;

/**
 销售类型
 */
@property(nonatomic,assign) NSInteger priceType;

/**
 商品规格ID
 */
@property(nonatomic,copy) NSString *productSpecificationsId;

/**
 结算
 */
@property(nonatomic,assign) CGFloat rebate;

/**
 销售价
 */
@property(nonatomic,assign) CGFloat salePrice;

/**
 开始日期
 */
@property(nonatomic,copy) NSString *startDate;

/**
 是否过期
 */
@property(nonatomic,assign) BOOL overdue;
- (void)getData:(NSDictionary *)data;
@end
NS_ASSUME_NONNULL_END
