//
//  HFShopingModel.m
//  housebank
//
//  Created by usermac on 2018/11/7.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFShopingModel.h"

@implementation HFShopingModel
- (instancetype)init {
    if (self = [super init]) {
        self.productList = [[NSMutableArray alloc] init];
        self.loseeproductList = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)getData:(NSDictionary *)data {
    self.shopsId = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopsId"]];
    self.shopsName = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopsName"]];
    self.userId = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"userId"]];
    NSInteger totalShoppingCount = 0;// status 0无效的值 1 失效 2 重选 singleProductState 0 单规格 1 多规格
    if ([[data valueForKey:@"productList"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *productDict in [data valueForKey:@"productList"]) {
            HFStoreModel *storemodel = [[HFStoreModel alloc] init];
            [storemodel getData:productDict];
            storemodel.shopsId = self.shopsId;
            storemodel.ContentMode = HFCarListTypeDefualt;
            if (storemodel.status == 1 ) {
                [self.loseeproductList addObject:storemodel];
                storemodel.ContentMode  = HFCarListTypeOverTime;
                self.loseCount++;
            }else {
               if (storemodel.status != 2) {
                   NSLog(@"1");
                 
                   storemodel.ContentMode  = HFCarListTypeDefualt;
                    totalShoppingCount ++;
               }else {
                   self.outStockCount++;
                   storemodel.ContentMode  = HFCarListTypeNoneStock;
               }
                [self.productList addObject:storemodel];
                self.totalShoppingCount = totalShoppingCount;
            }
        
          
        }
        if (self.productList.count > 0) {
            self.contentMode = HFCarListTypeDefualt ;
        }else {
            self.contentMode = HFCarListTypeOverTime ;
        }
        
    }
    
}
@end
@implementation HFStoreModel
- (void)getData:(NSDictionary *)data {
    self.promotionTag = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"promotionTag"]];
    self.purchaseLimitation = [[HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"purchaseLimitation"] description]] integerValue];
    self.classifyName = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"classifyName"] description]];
    self.deliveryAddress = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"deliveryAddress"] description]];
    self.experiencePrice = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"experiencePrice"] description]];
    self.storeId = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"id"] description]];
    self.price =[NSString stringWithFormat:@"%f",[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"price"]] floatValue]];
    self.productId = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"productId"] description]];
    self.productPic = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"productPic"] description]];
    self.title = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"title"] description]];
    self.typeId = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"typeId"] description]];
    self.typeTitle = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"typeTitle"] description]];
    self.shoppingCount = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shoppingCount"]] integerValue];
    self.productLevel = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"productLevel"]] integerValue];
    self.stock = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"stock"]] integerValue];
    self.singleProductState = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"singleProductState"]] integerValue];
    if ([[data valueForKey:@"productspMap"] isKindOfClass:[NSDictionary class]]) {
        self.productspMap = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"productspMap"]] ;
    }
    if ([[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"status"]] intValue]  == 0) {
        self.status = 0;
    }else {
        self.status = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"status"]] integerValue] ;
    }
    if (self.singleProductState == NO && self.stock == 0) {
        self.status = 1;// 1是失效商品
    }
    if ((self.productLevel !=0 || self.promotionTag.length != 0)&&self.purchaseLimitation!=0) {
        self.rowHeight = 130+5+15+5;
    }else {
        self.rowHeight = 130;
    }
    if ([[data valueForKey:@"pricePrice"] isKindOfClass:[NSDictionary class]]) {
        HFGoodsPriceModel *gPriceModel = [[HFGoodsPriceModel alloc] init];
        [gPriceModel getData:[data valueForKey:@"pricePrice"]];
        self.pricePrice = gPriceModel;
    }
    self.productLevelStr = [HFUntilTool productLevelStr:self.productLevel];
    self.minEnableD = (self.shoppingCount == 1 )?NO:YES;
    self.identifier = [[NSUUID UUID] UUIDString];
    /**
     @property(nonatomic,copy)NSString *commodityId;
     @property(nonatomic,copy)NSString *specifications;
     @property(nonatomic,copy)NSString *countStr;
     @property(nonatomic,copy)NSString *resetprice;
     @property(nonatomic,copy)NSString *code;
     */
    self.commodityId = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"commodityId"]];
    self.specifications = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"specifications"]];
    self.countStr = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"count"]];
    self.resetprice = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"price"]];
    self.code = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"code"]];
}
//- (NSString*)productLevelStr:(NSInteger)productLevel {
//    if (productLevel == 1) {
//        return @"I";
//    }else if(productLevel == 2){
//         return @"II";
//    }else if (productLevel == 3){
//    
//        return @"III";
//    }
//    return @"";
//}
@end
@implementation HFGoodsPriceModel
- (void)getData:(NSDictionary *)data  {//
    self.promotionTag = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"promotionTag"]];
    self.activeCashPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"activeCashPrice"]] floatValue];
    self.activePrice     =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"activePrice"]]  floatValue];
    self.cashPrice       =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"cashPrice"]]  floatValue];
    self.intrinsicPrice  =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"intrinsicPrice"]]  floatValue];
    self.price           =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"price"]]  floatValue];
    self.priceType       =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"priceType"]]  integerValue];
    self.rebate          =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"rebate"]]  floatValue];//
    self.salePrice          =     [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"salePrice"]]  floatValue];
    self.activeEndDate   = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"activeEndDate"] description]];
    self.activeStartDate = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"activeStartDate"] description]];
    self.productSpecificationsId   = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"productSpecificationsId"] description]];
    self.startDate   = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"startDate"] description]];
    self.endDate   = [HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"endDate"] description]];
    if([[data valueForKey:@"endDate"] isKindOfClass:[NSNull class]]) {
        self.overdue = YES;
    }else {
        self.overdue =
        ([[NSDate dateWithTimeIntervalSince1970:[self.endDate longLongValue]/1000] compare:[NSDate date]] == NSOrderedDescending ? NO:YES);
    }
}
@end
