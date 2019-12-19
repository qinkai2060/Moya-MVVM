//
//  SaveShoppingCar.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/22.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol ShoppingCarData


@end
NS_ASSUME_NONNULL_BEGIN
@interface ShoppingCar :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              shoppingCarId;
@property (nonatomic , assign) NSInteger              productType;
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , assign) NSInteger              productSpecifications;
@property (nonatomic , assign) NSInteger              productNewPrice;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , assign) NSInteger              shopsId;
@property (nonatomic , assign) NSInteger              state;
@property (nonatomic , assign) NSInteger              createUser;
@property (nonatomic , assign) NSInteger              createDate;
@property (nonatomic , assign) NSInteger              productGroupId;
@property (nonatomic , assign) NSInteger              buyTuiUserId;
@property (nonatomic , assign) NSInteger              profitType;
@property (nonatomic , assign) NSInteger              isBetterBusiness;
@property (nonatomic , assign) NSInteger              cartShoppingType;

@end


@interface ShoppingCarData :NSObject<NSCoding>
@property (nonatomic , strong) ShoppingCar              * shoppingCar;
@property (nonatomic , assign) NSInteger              countShoppingCart;

@end


@interface SaveShoppingCar :SetBaseModel
@property (nonatomic , strong) ShoppingCarData              * data;

@end


NS_ASSUME_NONNULL_END
