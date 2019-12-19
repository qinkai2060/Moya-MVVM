//
//  HFYDDetialDataModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HFYDDetialRightDataModel;
@class HFYDDetialTopDataModel;
@class HFYDImagModel;
@class HFYDDetialLeftDataModel;
@class HFWDInfoModel;
@class HFWDProductListModel,HFYDCarProductModel;
@interface HFYDDetialDataModel : NSObject
@property(nonatomic,strong)HFYDDetialTopDataModel *shopsBaseInfo;
@property(nonatomic,strong)NSArray<HFYDDetialLeftDataModel*> *o2oProductInfo;
@property(nonatomic,strong)NSArray *wdList;
@property(nonatomic,assign)BOOL isContainWD;

@end
@interface HFYDDetialTopDataModel : NSObject
@property(nonatomic,assign)NSInteger ids;
@property(nonatomic,assign)NSInteger shopsType;
@property(nonatomic,copy)NSString *shopsName;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)NSInteger mobile;
@property(nonatomic,assign)NSInteger provinceId;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)NSInteger regionId;
@property(nonatomic,assign)NSInteger blockId;
@property(nonatomic,assign)NSInteger townId;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *pointLng;
@property(nonatomic,copy)NSString *pointLat;
@property(nonatomic,copy)NSString *consumptionPerPerson;
@property(nonatomic,copy)NSString *star;
@property(nonatomic,assign)CGFloat maxIntegralRatio;
@property(nonatomic,copy)NSArray<HFYDImagModel*> *shopImagesList;
@property(nonatomic,assign)CGFloat HeaderHight;
@property(nonatomic,assign)NSInteger cartCount;
@property(nonatomic,assign)NSInteger hasConcerned;
@property(nonatomic,assign)NSInteger wdShopId;
@property(nonatomic,copy)NSString *shopLogoUrl;
@property(nonatomic,copy)NSString *bgUrl;
@property(nonatomic,copy)NSString *concernedCount;
- (void)getData:(id)dict;
@end

@interface HFYDImagModel :NSObject
@property(nonatomic,assign)NSInteger imageId;
@property(nonatomic,assign)NSInteger relateType;
@property(nonatomic,assign)NSInteger relateId;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,assign)NSInteger showType;
@property(nonatomic,assign)NSInteger showOrder;
- (void)getData:(id)dict;
@end

@interface HFYDDetialLeftDataModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSArray<HFYDDetialRightDataModel*> *rightData;

@property(nonatomic,copy)NSString *classificationName;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)NSArray<HFYDDetialRightDataModel*> *productList;
@property(nonatomic,assign)NSInteger saleCount;
@property(nonatomic,assign)CGFloat rowHight;

- (void)getData:(id)dict;
@end

@interface HFYDDetialRightDataModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,assign)NSInteger saleCount;
@property(nonatomic,assign)NSInteger yiMCount;
@property(nonatomic,assign)NSInteger addCount;
@property(nonatomic,assign)NSInteger stock;
@property(nonatomic,assign)CGFloat orignPrice;


@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productSubtitle;
@property(nonatomic,assign)NSInteger productSort;
@property(nonatomic,assign)CGFloat cashPrice;
@property(nonatomic,assign)NSInteger productSpecificationsId;
@property(nonatomic,assign)NSInteger productClassificationId;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *productClassificationName;
@property(nonatomic,assign)CGFloat productMaxIntegralRatio;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)NSInteger totalSaleVolume;
@property(nonatomic,assign)CGFloat rowHight;
- (void)getData:(id)dict;
@end
@interface HFYDDetialRariseDataModel : NSObject
@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *dateStr;
@property(nonatomic,copy)NSString *usersLevel;
@property(nonatomic,copy)NSString *contentStr;
@property(nonatomic,copy)NSArray *imageUrlsArray;
@property(nonatomic,assign)CGFloat rowHight;
+ (NSArray*)dataSource;
- (void)getData:(id)dict;
@end
@interface HFWDInfoModel:NSObject
@property(nonatomic,assign)NSInteger shopsId;
@property(nonatomic,copy)NSArray<HFWDProductListModel*> *productList;

@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)CGFloat rowHight;
- (void)getData:(id)dict;
@end
@interface HFWDProductListModel :NSObject
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productSubtitle;
@property(nonatomic,assign)NSInteger productSort;
@property(nonatomic,assign)CGFloat cashPrice;
@property(nonatomic,assign)NSInteger productSpecificationsId;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,assign)NSInteger productClassificationId;
@property(nonatomic,copy)NSString *productClassificationName;
@property(nonatomic,assign)CGFloat productMaxIntegralRatio;
@property(nonatomic,assign)NSInteger totalSaleVolume;
@property(nonatomic,assign)CGFloat rowHeight;
- (void)getData:(id)dict;
@end
@interface HFYDCarModel:NSObject
@property(nonatomic,assign)NSInteger carId;
@property(nonatomic,assign)NSInteger shopsId;
@property(nonatomic,copy)NSString *shopsName;
@property(nonatomic,assign)NSInteger shopsType;
@property(nonatomic,assign)NSInteger productTypesCount;
@property(nonatomic,assign)NSInteger productCount;//productDetails
@property(nonatomic,copy)NSArray<HFYDCarProductModel*> *productDetails;//商品列表
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)CGFloat tbHeight;
- (void)getData:(id)dict;
@end
@interface HFYDCarProductModel:NSObject
@property(nonatomic,assign)NSInteger carSubId;
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,assign)NSInteger specificationId;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *specifications;
@property(nonatomic,assign)NSInteger productCount;
@property(nonatomic,assign)CGFloat totalAmount;//总价
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *jointPictrue;
@property(nonatomic,assign)NSInteger stock;
@property(nonatomic,assign)CGFloat maxIntegralRatio;
@property(nonatomic,assign)CGFloat registerCouponRatio;
@property(nonatomic,assign)NSInteger supplierShopId;
@property(nonatomic,assign)CGFloat costPrice;
@property(nonatomic,assign)CGFloat productWeight;
@property(nonatomic,assign)NSInteger addShoppingCartType;
@property(nonatomic,assign)NSInteger commodityType;
@property(nonatomic,assign)NSInteger microProductStatus;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger productState;
@property(nonatomic,assign)CGFloat rowHeight;
- (void)getData:(id)dict;
@end
@interface HFYDSpecificationsModel : NSObject
@property(nonatomic,copy)NSArray *attrSpecList;
@property(nonatomic,copy)NSArray *specificationList;
@property(nonatomic,copy) NSDictionary *productspMap;

- (void)getData:(id)dict;
@end
NS_ASSUME_NONNULL_END
