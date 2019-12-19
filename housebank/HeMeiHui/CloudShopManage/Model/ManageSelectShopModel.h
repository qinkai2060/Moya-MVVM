//
//  ManageSelectShopModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageSelectShopModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * productId;   // 商品ID
@property (nonatomic, copy) NSString * productName; // 商品名称
@property (nonatomic, copy) NSString * imgUrl;      // 商品图片
@property (nonatomic, copy) NSString * profit;      // 收益
@property (nonatomic, copy) NSString * price;       // 销售价格
@property (nonatomic, copy) NSString * sharerProfitPrice;

@end

NS_ASSUME_NONNULL_END
