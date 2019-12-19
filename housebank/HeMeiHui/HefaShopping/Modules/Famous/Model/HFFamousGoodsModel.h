//
//  HFFamousGoodsModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFFamousGoodsModel : NSObject
/**
 "id": 75,
 "productId": 10,
 "productName": "iphone 8 plus",
 "productSubtitle": "iphone 8 plus大促销",
 "productImage": "/user/community/1529047766/ftjkr9631erwkm0j.jpg",
 "classifications": "1880",
 "specificationsId": 10,
 "cashPrice": 6000,
 "promotionPrice": null,
 "productLevel": null,
 "promotionTag": null
 */
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,assign)NSInteger famousProudctId;
@property(nonatomic,assign)NSInteger shopId;
@property(nonatomic,assign)NSInteger productLevel;
@property(nonatomic,assign)NSInteger specificationsId;
@property(nonatomic,assign)CGFloat cashPrice;
@property(nonatomic,assign)CGFloat promotionPrice;
@property(nonatomic,strong)NSString *promotionTag;
@property(nonatomic,strong)NSString *productImage;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productSubtitle;
@property(nonatomic,assign)NSInteger classifications;

- (void)getDataObj:(id)obj;
@end

NS_ASSUME_NONNULL_END
