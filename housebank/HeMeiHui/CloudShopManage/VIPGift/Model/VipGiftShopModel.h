//
//  VipGiftShopModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VipGiftShopModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * jointPictrue;
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, strong) NSNumber * cashPrice;
@property (nonatomic, copy) NSString * giftName;
@property (nonatomic, copy) NSString * productID;
@end

NS_ASSUME_NONNULL_END
