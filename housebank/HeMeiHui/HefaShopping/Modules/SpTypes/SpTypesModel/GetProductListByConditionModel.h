//
//  GetProductListByConditionModel.h
//  housebank
//
//  Created by liqianhong on 2018/11/1.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
// 商品列表页 model
NS_ASSUME_NONNULL_BEGIN

@interface GetProductListByConditionModel : NSObject

@property (nonatomic, assign) NSInteger cellIndexRow;
@property (nonatomic, strong) NSString *promotionTag;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productSubtitle;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *blockName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *salesPrice;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *salesCount;
@property (nonatomic, strong) NSString *stockCount;
@property (nonatomic, strong) NSString *productState;
@property (nonatomic, strong) NSString *productStateName;
@property (nonatomic, strong) NSString *jointPictrue;
@property (nonatomic, strong) NSString *code1;
@property (nonatomic, strong) NSString *code2;
@property (nonatomic, strong) NSString *code3;
@property (nonatomic, strong) NSString *code4;
@property (nonatomic, strong) NSString *code5;
@property (nonatomic, strong) NSString *classifyName;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *thirdId;
@property (nonatomic, strong) NSString *secondId;
@property (nonatomic, strong) NSString *firstId;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *agtProductGroupId;
@property (nonatomic, strong) NSString *singleProductState;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *selfCode;
@property (nonatomic, strong) NSString *barCode;
@property (nonatomic, strong) NSString *initialNumber;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *purchaseNum;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *operTime;
@property (nonatomic, strong) NSString *createTimeStr;
@property (nonatomic, strong) NSString *operTimeStr;
@property (nonatomic, strong) NSString *cashPrice;
@property (nonatomic, strong) NSString *salesCashPrice;
@property (nonatomic, strong) NSString *commodityType;
@property (nonatomic, strong) NSArray *productSpecificationList;
@property (nonatomic, strong) NSString *otoName;
@property (nonatomic, strong) NSString *productSort;
@property (nonatomic, strong) NSString *offlineShopId;
@property (nonatomic, strong) NSString *purchaseLimitationState;
@property (nonatomic, strong) NSString *welfareProductState;
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *shopArea;
@property (nonatomic, strong) NSString *shopsName;
@property (nonatomic, strong) NSString *profitType;
@property (nonatomic, strong) NSString *purchaseNotes;
@property (nonatomic, strong) NSString *maxBuyNum;
@property (nonatomic, strong) NSString *isPutaway;
@property (nonatomic, strong) NSString *isBetterBusiness;
@property (nonatomic, strong) NSString *runStartTime;
@property (nonatomic, strong) NSString *runEndTime;
@property (nonatomic, strong) NSString *submitTime;
@property (nonatomic, strong) NSString *isRedPacket;
@property (nonatomic, strong) NSString *distribution;
@property (nonatomic, strong) NSArray *productPriceEntryList; // 判断是否是促销
@property (nonatomic, strong) NSString *shopsId;
@property (nonatomic, strong) NSString *productLevel; // 1 2 类

@end

NS_ASSUME_NONNULL_END
