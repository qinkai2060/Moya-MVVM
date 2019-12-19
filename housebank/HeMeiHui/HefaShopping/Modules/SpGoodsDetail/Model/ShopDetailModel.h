//
//  ShopDetailModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/19.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol HOUSE_MODULEItem

@end

@protocol PRODUCT_MODULEItem

@end

NS_ASSUME_NONNULL_BEGIN
@interface ShopInfo :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * mobilePhone;
@property (nonatomic , copy) NSString              *imagePath;
@property (nonatomic , copy) NSString              * shopImagePath;
@property (nonatomic , copy) NSString              * jointPictrue;
@property (nonatomic , assign) NSInteger              shopsId;
@property (nonatomic , copy) NSString              * shopsName;
@property (nonatomic , copy) NSString              * isFollow;
@property (nonatomic , assign) NSInteger              vermicelliNumberDefalut;
@property (nonatomic , assign) NSInteger              vermicelliNumberFollow;
@property (nonatomic , assign) NSInteger              isBetterBusiness;
@property (nonatomic , copy) NSString              * shareUrl;
@property (nonatomic , assign) NSInteger              isWelfare;

@end


@interface ShopInfomation :NSObject<NSCoding>
@property (nonatomic , strong) ShopInfo              * shopInfo;

@end


@interface HOUSE_MODULEItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , copy) NSString              * imagePath;

@end


@interface PRODUCT_MODULEItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , copy) NSString              * productName;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * regionName;
@property (nonatomic , copy) NSString              * blockName;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) CGFloat              salesCount;
@property (nonatomic , assign) NSInteger              stockCount;
@property (nonatomic , assign) NSInteger              productState;
@property (nonatomic , copy) NSString              * jointPictrue;
@property (nonatomic , copy) NSString              * classifyName;
@property (nonatomic , copy) NSString              * secondName;
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , assign) NSInteger              thirdId;
@property (nonatomic , assign) NSInteger              secondId;
@property (nonatomic , assign) NSInteger              firstId;
@property (nonatomic , copy) NSString              * ownerName;
@property (nonatomic , assign) NSInteger              agtProductGroupId;
@property (nonatomic , assign) NSInteger              singleProductState;
@property (nonatomic , assign) NSInteger              brandId;
@property (nonatomic , assign) NSInteger              initialNumber;
@property (nonatomic , assign) NSInteger              classId;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , assign) NSInteger              purchaseNum;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , assign) NSInteger              state;
@property (nonatomic , assign) NSInteger              operTime;
@property (nonatomic , copy) NSString              * createTimeStr;
@property (nonatomic , copy) NSString              * operTimeStr;
@property (nonatomic , assign) CGFloat              cashPrice;//原价
@property (nonatomic , assign) CGFloat              intrinsicPrice;//促销价钱
@property (nonatomic , assign) NSInteger              commodityType;
@property (nonatomic , assign) NSInteger              offlineShopId;
@property (nonatomic , assign) NSInteger              provinceId;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger              regionId;
@property (nonatomic , assign) NSInteger              profitType;
@property (nonatomic , assign) NSInteger              isBetterBusiness;

@end


@interface ShopDetailData :NSObject<NSCoding>
@property (nonatomic , strong) ShopInfomation              * shopInfomation;
@property (nonatomic , strong) NSArray <HOUSE_MODULEItem>              * HOUSE_MODULE;
@property (nonatomic , strong) NSArray <PRODUCT_MODULEItem>           * PRODUCT_MODULE;

@end


@interface ShopDetailModel :SetBaseModel

@property (nonatomic , strong) ShopDetailData       * data;

@end

NS_ASSUME_NONNULL_END
