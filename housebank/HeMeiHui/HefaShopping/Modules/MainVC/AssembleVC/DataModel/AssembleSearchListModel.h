//
//  AssembleSearchListModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/3.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"

@protocol SearchListModel//不带*号

@end
@protocol ProductPriceEntryListItem//不带*号

@end

NS_ASSUME_NONNULL_BEGIN
@interface ProductPriceEntryListItem :NSObject
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , assign) NSInteger              priceType;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , assign) NSInteger              startDate;
@property (nonatomic , assign) NSInteger              endDate;

@end


@interface SearchListModel :NSObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , assign) NSInteger              activeType;
@property (nonatomic , assign) NSInteger              activeNum;
@property (nonatomic , copy) NSString              * activeTitle;
@property (nonatomic , copy) NSString              * activeSubtitle1;
@property (nonatomic , copy) NSString              * activeSubtitle2;
@property (nonatomic , assign) NSInteger              startDate;
@property (nonatomic , assign) NSInteger              endDate;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , copy) NSString              * jointPicture;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , assign) NSInteger              naturalPrice;
@property (nonatomic , assign) NSInteger              salesCount;
@property (nonatomic , assign) NSInteger              commodityType;
@property (nonatomic , assign) NSInteger              promotionType;
@property (nonatomic , strong) NSArray <ProductPriceEntryListItem>              * productPriceEntryList;
@property (nonatomic , assign) NSInteger              submitTime;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              updateTime;

@end


@interface AssembleSearchListModel :SetBaseModel

@property (nonatomic , strong) NSArray <SearchListModel>              * data;

@end


NS_ASSUME_NONNULL_END
