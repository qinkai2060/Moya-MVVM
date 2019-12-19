//
//  HFPaymentBaseModel.m
//  housebank
//
//  Created by usermac on 2018/11/13.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPaymentBaseModel.h"

@implementation HFPaymentBaseModel
- (void)getData:(NSDictionary *)data {
    self.allPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"allPrice"]] floatValue];
    self.shopids = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shops"]];
    self.identity = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"identity"]];
    if ([[data valueForKey:@"availableAntegral"] isKindOfClass:[NSNull class]]) {
        self.availableAntegral = 0;
    }else {
        self.availableAntegral = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"availableAntegral"]] floatValue];
    }

    NSMutableArray *shopsTempArray = [NSMutableArray array];
    NSMutableArray *productids = [NSMutableArray array];
    if ([[data valueForKey:@"shops"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in [data valueForKey:@"shops"]) {
            HFOrderShopModel *ordershopModel = [[HFOrderShopModel alloc] init];
            ordershopModel.isVIPPackage = self.isVIPPackage;
            [ordershopModel getData:dict];
            if (ordershopModel.productIds.length != 0) {
                [productids addObject:ordershopModel.productIds];
            }
  
            [shopsTempArray addObject:ordershopModel];
        }
    }
    self.productIds = [productids componentsJoinedByString:@","];
    self.shops = [shopsTempArray copy];
     NSMutableArray *userCouponListTempArray = [NSMutableArray array];
    if ([[data valueForKey:@"userCouponList"] isKindOfClass:[NSArray class]])  {
        for (NSDictionary *dict in [data valueForKey:@"userCouponList"]) {
            HFUserCouponModel *userCouponModel = [[HFUserCouponModel alloc] init];
            [userCouponModel getData:dict];
            [userCouponListTempArray addObject:userCouponModel];
        }
        self.userCouponList = [userCouponListTempArray copy];
    }
    
}
- (void)getDataVipPg:(NSDictionary*)data {
    self.allPrice = [[HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"shops"] valueForKey:@"totalPrice"]] floatValue];

    NSLog(@"价格🐩-----%@",[[data valueForKey:@"shops"] valueForKey:@"totalPrice"]);
    NSMutableArray *shopsTempArray = [NSMutableArray array];
    NSMutableArray *productids = [NSMutableArray array];
//    if ([[data valueForKey:@"shops"] isKindOfClass:[NSArray class]]) {
//        for (NSDictionary *dict in [data valueForKey:@"shops"]) {
            HFOrderShopModel *ordershopModel = [[HFOrderShopModel alloc] init];
            ordershopModel.isVIPPackage = self.isVIPPackage;
            [ordershopModel getData:[data valueForKey:@"shops"]];
            if (ordershopModel.productIds.length != 0) {
                [productids addObject:ordershopModel.productIds];
            }
            
            [shopsTempArray addObject:ordershopModel];
//        }
//    }
    self.productIds = [productids componentsJoinedByString:@","];
    self.shops = [shopsTempArray copy];
    NSMutableArray *userCouponListTempArray = [NSMutableArray array];
    if ([[data valueForKey:@"userCouponList"] isKindOfClass:[NSArray class]])  {
        for (NSDictionary *dict in [data valueForKey:@"userCouponList"]) {
            HFUserCouponModel *userCouponModel = [[HFUserCouponModel alloc] init];
            [userCouponModel getData:dict];
            [userCouponListTempArray addObject:userCouponModel];
        }
        self.userCouponList = [userCouponListTempArray copy];
    }
}
+ (HFUserCouponModel*)userCouponData:(NSInteger)shopId  userCouponList:(NSArray*)couponList {
    if (shopId != 0) {
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"shopId = %ld",shopId];
        if ( [[couponList filteredArrayUsingPredicate:prd] firstObject]) {
            return (HFUserCouponModel*)[[couponList filteredArrayUsingPredicate:prd] firstObject];
        }
    }
    return nil;
}
@end
@implementation HFOrderShopModel
- (void)getData:(NSDictionary *)data {
    self.shopsId = [NSString stringWithFormat:@"%@",[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopsId"]]];
    self.shopsName = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopsName"]];
      NSMutableArray *productTempArray = [NSMutableArray array];
    CGFloat shopAllPrice = 0;
    NSMutableArray *productIds = [NSMutableArray array];
    id obj = [data valueForKey:@"commodityList"];
    if (self.isVIPPackage) {
        obj = [data valueForKey:@"products"];
    }

    for (NSDictionary *dict in obj) {
        HFProuductModel *productModel = [[HFProuductModel alloc] init];
        productModel.isVIPPackage = self.isVIPPackage;
        productModel.contentMode = self.contentMode;
        [productModel getData:dict];
        if (productModel.productid.length > 0) {
            [productIds addObject:productModel.productid];
        }
        self.count = productModel.count;
        shopAllPrice += (productModel.price*productModel.count);
        [productTempArray addObject:productModel];
    }
    if (productIds.count != 0) {
        self.productIds =  [productIds componentsJoinedByString:@","];
    }else {
        self.productIds = @"";
    }
    self.commodityList = [productTempArray copy];

    
    self.shopId =[NSString stringWithFormat:@"%@",[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopId"]]];
    if (self.isVIPPackage) {
        self.shopsProductPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"totalPrice"]] floatValue];
        self.shopAllPostages = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"transportPrice"]] floatValue];
    }else {
        self.shopsProductPrice = shopAllPrice;
        self.shopAllPostages = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopAllPostages"]] floatValue];
    }

    self.shopName = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopName"]];
    NSLog(@"");
}
+ (HFOrderShopModel*)userCouponData:(NSInteger)shopId  userCouponList:(NSArray*)shopList {
    if (shopId != 0) {
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"shopsId = %@",[NSString stringWithFormat:@"%ld",shopId]];
        if ( [[shopList filteredArrayUsingPredicate:prd] firstObject]) {
            return (HFOrderShopModel*)[[shopList filteredArrayUsingPredicate:prd] firstObject];
        }
    }
    return nil;
}
@end
@implementation HFProuductModel
- (void)getData:(NSDictionary *)data {
    /**
     imgPath 图片
     specificationsId 规格id
     name 商品titile
     count 商品数量
     price 价格
     productid 商品id
     specifications 规格参数
     */
   // NSLog(@"商品titile%@",[data valueForKey:@"name"]);
    self.imgPath = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"imgPath"]];
    self.specificationsId = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"specificationsId"]];
    if([data.allKeys containsObject:@"name"]){
            self.name = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"name"]];
    }else {
         self.name = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"productName"]];
    }
        
    if (self.isVIPPackage) {
        self.count = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"productCount"]] integerValue];
    }else {
        self.count = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"count"]] integerValue];
    }
    
    self.price = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"price"]] floatValue];
    self.productid = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"productId"]] description];
    self.specifications = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"specifications"]];
    self.postage = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"postage"]] floatValue];
    self.code1 =  [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"code1"]] description];
    self.code2 =  [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"code2"]] description];
    self.code3 =  [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"code3"]] description];
    self.code4 =  [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"code4"]] description];
    self.code5 =  [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"code5"]] description];
    if (self.code1.length != 0) {
    NSMutableArray *mutableArr =   [NSMutableArray array];
        [mutableArr addObject:self.code1];
        if (self.code2.length !=0 ) {
             [mutableArr addObject:self.code2];
            if (self.code3.length != 0) {
                 [mutableArr addObject:self.code3];
                if (self.code4.length != 0) {
                    [mutableArr addObject:self.code4];
                    if (self.code5.length !=0) {
                        [mutableArr addObject:self.code5];
                    }
                }
            }
        }
        if (mutableArr.count != 0) {
            self.typeTitle = [mutableArr componentsJoinedByString:@"-"];
        }
       
    }

}
@end
@implementation HFCompouModel



@end
@implementation HFShopSumPriceModel
- (void)getData:(NSDictionary *)data {

}

@end
@implementation HFUserCouponModel

- (void)getData:(NSDictionary *)data {
    self.shopId = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopId"]] integerValue];
    self.postage = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"postage"]] floatValue];
    self.integralPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"integralPrice"]] floatValue];
    self.couponPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"couponPrice"]] floatValue];
    self.singleShopSumPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"singleShopSumPrice"]] floatValue];
    NSMutableArray *notAvailablelist = [NSMutableArray array];
    NSMutableArray *availablelist = [NSMutableArray array];
    NSMutableArray<HFAvailableModel*> *selectArray = [NSMutableArray array];
    if ([[data valueForKey:@"userCouponsList"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in  [HFUserCouponModel userCouponDataUserCouponList:[data valueForKey:@"userCouponsList"] regex:1]) {
            HFAvailableModel *model = [[HFAvailableModel alloc] init];
            [model getData:dict];
            model.pastDue = NO;
            [availablelist addObject:model];
        }
        for (NSDictionary *dict in  [HFUserCouponModel userCouponDataUserCouponList:[data valueForKey:@"userCouponsList"] regex:0]) {
            HFAvailableModel *model = [[HFAvailableModel alloc] init];
            [model getData:dict];
            model.pastDue = YES;
            [notAvailablelist addObject:model];
        }
        for (NSDictionary *dict in  [HFUserCouponModel userCouponDataUserCouponList:[data valueForKey:@"userCouponsList"] selectregex:1]) {
            HFAvailableModel *model = [[HFAvailableModel alloc] init];
            [model getData:dict];
            model.pastDue = YES;
            [selectArray addObject:model];
        }
        
    }
    self.notAvailable = [notAvailablelist copy];
    self.available = [availablelist copy];
    self.selectCouponList= [selectArray copy];
    if (selectArray.count >0) {
        self.currenConpouId = [selectArray firstObject].couponReceiptId;
    }
 
    
}
+ (NSArray*)userCouponDataUserCouponList:(NSArray*)shopList regex:(NSInteger)regex {
    
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"useState = %ld",regex];
    return [shopList filteredArrayUsingPredicate:prd];
}
+ (NSArray*)userCouponDataUserCouponList:(NSArray*)shopList selectregex:(NSInteger)select {
    
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"selected = %ld",select];
    return [shopList filteredArrayUsingPredicate:prd];
}

@end
@implementation HFAvailableModel

- (void)getData:(NSDictionary *)data {
    self.availableId = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"id"]] description] integerValue];
    self.describe = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"describe"]] description];
    self.couponReceiptId = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"couponReceiptId"]] description] integerValue];
    self.method = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"method"]] description] integerValue];
    self.startTime = [self dataStr:[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"startTime"]] description]];
    self.endTime = [self dataStr:[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"endTime"]] description]];
    self.type =  [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"type"]] description] integerValue];
    self.withAmount = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"withAmount"]] description] integerValue];
    self.discountMoney = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"discountMoney"]] description] integerValue];
    self.useLimit = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"useLimit"]] description] integerValue];
    self.applyProduct = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"applyProduct"]] description] integerValue];
    self.title = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"title"]];
    self.selected = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"selected"]] description] integerValue];
}
- (NSString*)dataStr:(NSString*)number{
    
    NSDate *newdate =   [NSDate dateWithTimeIntervalSince1970:[number longLongValue]/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear fromDate:newdate];
    return    [NSString stringWithFormat:@"%zd.%02zd.%02zd.%02zd:%02zd",[components year],[components month],[components day],[components hour],[components minute]];
}
@end
