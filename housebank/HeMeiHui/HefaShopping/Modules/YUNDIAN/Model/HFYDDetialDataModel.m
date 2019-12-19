//
//  HFYDDetialDataModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDDetialDataModel.h"

@implementation HFYDDetialDataModel

@end
@implementation HFYDDetialTopDataModel
- (void)getData:(id)dict {
    self.ids = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"id"]] integerValue];
    self.shopsType = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopsType"]] integerValue];
    self.shopsName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopsName"]];
    self.userId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"userId"]] integerValue];
    self.mobile = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"mobile"]] integerValue];
    self.provinceId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"provinceId"]] integerValue];
    self.cityId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"cityId"]] integerValue];
    self.regionId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"regionId"]] integerValue];
    self.blockId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"blockId"]] integerValue];
    self.townId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"townId"]] integerValue];
    self.address = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"address"]];
    self.shopLogoUrl = [NSString stringWithFormat:@"%@%@!YS",[[[ManagerTools shareManagerTools] appInfoModel] imageServerUrl],[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopLogoUrl"]]];//
    if ([[dict valueForKey:@"shopImagesList"] isKindOfClass:[NSArray class]]) {
        NSArray *array = [dict valueForKey:@"shopImagesList"];
        self.bgUrl = [NSString stringWithFormat:@"%@%@!YS",[[[ManagerTools shareManagerTools] appInfoModel] imageServerUrl],[HFUntilTool EmptyCheckobjnil:[[array firstObject] valueForKey:@"imgUrl"]]];
    }
    
    self.pointLng = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"pointLng"]];
    self.pointLat = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"pointLat"]];
//    self.cartCount = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"cartCount"]] integerValue];
//    self.hasConcerned = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"hasConcerned"]] integerValue];
//    self.concernedCount = [HFYDDetialTopDataModel concernedCountCovert:[[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"concernedCount"]] description]];
    self.consumptionPerPerson = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"consumptionPerPerson"]];
    self.star = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"star"]];
    self.maxIntegralRatio = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"maxIntegralRatio"]] floatValue];
    if ([[dict valueForKey:@"shopImagesList"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *imageListDict in [dict valueForKey:@"shopImagesList"] ) {
            HFYDImagModel *imageModel = [[HFYDImagModel alloc] init];
            [imageModel getData:imageListDict];
            [tempArray addObject:imageModel];
        }
        self.shopImagesList = [tempArray copy];
    }
    CGFloat shopNameH =   [HFUntilTool boundWithStr:self.shopsName blodfont:20 maxSize:CGSizeMake(ScreenW-15-44-10, 56)].height;
    if (shopNameH > 28) {
        shopNameH = 56;
    }else {
        shopNameH = 28;
    }
    CGFloat locationH =  [HFUntilTool boundWithStr:self.address font:16 maxSize:CGSizeMake(ScreenW-15-20-8-56, 40)].height;
    self.HeaderHight = 210+shopNameH+8+16+10+0.5+10+locationH+5+18+10+8;
}
+ (NSString*)concernedCountCovert:(NSString*)concernedCount {
    if (concernedCount.length > 5) {
        return [NSString stringWithFormat:@"%.f万关注",[concernedCount floatValue]/10000];
    }else if(concernedCount.length == 0) {
        return @"暂无关注";
    }else {
        return [NSString stringWithFormat:@"%@人关注",concernedCount];
    }
}
@end
@implementation HFYDImagModel
- (void)getData:(id)dict{
    self.imageId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"id"]] integerValue];
    self.relateType = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"relateType"]] integerValue];
    self.relateId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"relateId"]] integerValue];
    self.showType = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"showType"]] integerValue];
    self.showOrder = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"showOrder"]] integerValue];
    ManagerTools *tool = [ManagerTools shareManagerTools];
    self.imgUrl = [NSString stringWithFormat:@"%@%@!YS",tool.appInfoModel.imageServerUrl,[[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"imgUrl"]] description]];
}
@end
@implementation HFYDDetialLeftDataModel
- (void)getData:(id)dict {

    self.classificationName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"classificationName"]];
    if ([[dict valueForKey:@"productList"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *productDict in [dict valueForKey:@"productList"]) {
            HFYDDetialRightDataModel *model = [[HFYDDetialRightDataModel alloc] init];
            [model getData:productDict];
            [tempArray addObject:model];
        }
        self.productList = [tempArray copy];
        self.rowHight = 24 + [HFUntilTool boundWithStr:self.classificationName font:14 maxSize:CGSizeMake(86-30, 40)].height;
    }

}


@end
@implementation HFYDDetialRightDataModel
- (void)getData:(id)dict {
    self.productId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productId"]] integerValue];
    self.productName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productName"]] ;
    self.productSubtitle = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productSubtitle"]] ;
    self.productSort = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productSort"]]  integerValue];
    self.cashPrice = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"cashPrice"]]  floatValue];
    self.productSpecificationsId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productSpecificationsId"]]  integerValue];
    self.imgUrl = [NSString stringWithFormat:@"%@%@!YS",[[[ManagerTools shareManagerTools] appInfoModel] imageServerUrl],[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"imgUrl"]]]  ;
    self.productClassificationId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productClassificationId"]]  integerValue];
    self.productClassificationName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productClassificationName"]]  ;
    self.productMaxIntegralRatio = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productMaxIntegralRatio"]]  floatValue] ;
    self.totalSaleVolume = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"totalSaleVolume"]]  integerValue];
    self.rowHight = 15+[HFUntilTool boundWithStr:self.productName blodfont:16 maxSize:CGSizeMake(ScreenW-86-12-72-12-12, 40)].height+4+16+10+16+20;
    self.yiMCount = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"cartCount"]] integerValue];
}
@end
@implementation HFYDDetialRariseDataModel

+ (NSArray*)dataSource {

    HFYDDetialRariseDataModel  *model = [[HFYDDetialRariseDataModel alloc] init];
    model.iconUrl = @"";
    model.nickName = @"孙红军";
    model.dateStr = @"2019-08-12";
    model.usersLevel = @"4";
    model.contentStr = @"非常棒的民宿，小区很干净，房子装修好，住着舒服。 附近就有地铁与商圈，便利店，房东也很热情 。";
    model.imageUrlsArray = @[@"1",@"2",@"3"];
    NSInteger count = model.imageUrlsArray.count % 3;
    CGFloat row = 0;
    if (count == 0) {
        row = (model.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+5*(model.imageUrlsArray.count/3-1);
    }else {
        row = (model.imageUrlsArray.count/3+1)*((ScreenW-30-10)/3)+5*(model.imageUrlsArray.count/3);
    }
    CGFloat height  = model.contentStr.length == 0 ? 0: [HFUntilTool boundWithStr: model.contentStr font:14 maxSize:CGSizeMake(ScreenW-30, MAXFLOAT)].height;
    model.rowHight = 25+30+15+height+row+10+5;

    HFYDDetialRariseDataModel  *model1 = [[HFYDDetialRariseDataModel alloc] init];
    model1.iconUrl = @"";
    model1.nickName = @"孙红军";
    model1.dateStr = @"2019-08-12";
    model1.usersLevel = @"2";
    model1.contentStr = @"非常棒的民宿，小区很干净，房子装修好，住着舒服。 附近就有地铁与商圈，便利店，房东也很热情 。";
    model1.imageUrlsArray = @[];
    NSInteger count1 = model1.imageUrlsArray.count % 3;
    CGFloat row1 = 0;
    if (count1 == 0) {
        if (model1.imageUrlsArray.count/3 == 0) {
                   row1 = (model1.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+0;
        }else {
         row1 = (model1.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+5*(model1.imageUrlsArray.count/3-1);
        }
 
    }else {
        row1 = (model1.imageUrlsArray.count/3+1)*((ScreenW-30-10)/3)+5*(model1.imageUrlsArray.count/3);
    }
    CGFloat height1  = model1.contentStr.length == 0 ? 0: [HFUntilTool boundWithStr: model1.contentStr font:14 maxSize:CGSizeMake(ScreenW-30, MAXFLOAT)].height;
    model1.rowHight = 25+30+15+height1+row1+10+5;
    HFYDDetialRariseDataModel  *model2 = [[HFYDDetialRariseDataModel alloc] init];
    model2.iconUrl = @"";
    model2.nickName = @"孙红军";
    model2.dateStr = @"2019-08-12";
    model2.usersLevel = @"3";
    model2.contentStr = @"";
    model2.imageUrlsArray = @[@"1",@"2",@"3",@"4",@"5",@"1",@"2",@"3",@"4"];
    NSInteger count2 = model2.imageUrlsArray.count % 3;
    CGFloat row2 = 0;
    if (count2 == 0) {
        row2 = (model2.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+5*(model2.imageUrlsArray.count/3-1);
    }else {
        row2 = (model2.imageUrlsArray.count/3+1)*((ScreenW-30-10)/3)+5*(model2.imageUrlsArray.count/3);
    }
    CGFloat height2  = model2.contentStr.length == 0 ? 0: [HFUntilTool boundWithStr: model2.contentStr font:14 maxSize:CGSizeMake(ScreenW-30, MAXFLOAT)].height;
    model2.rowHight = 25+30+15+height2+row2+10+5;
    HFYDDetialRariseDataModel  *model3 = [[HFYDDetialRariseDataModel alloc] init];
    model3.iconUrl = @"";
    model3.nickName = @"孙红军";
    model3.dateStr = @"2019-08-12";
    model3.usersLevel = @"0";
    model3.contentStr = @"非常棒的民宿，小区很干净，房子装修好，住着舒服。";
    model3.imageUrlsArray = @[@"1",@"2",@"3",@"4",@"5"];
    NSInteger count3 = model3.imageUrlsArray.count % 3;
    CGFloat row3 = 0;
    if (count3 == 0) {
        row3 = (model3.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+5*(model3.imageUrlsArray.count/3-1);
    }else {
        row3 = (model3.imageUrlsArray.count/3+1)*((ScreenW-30-10)/3)+5*(model3.imageUrlsArray.count/3);
    }
    CGFloat height3  = model3.contentStr.length == 0 ? 0: [HFUntilTool boundWithStr: model3.contentStr font:14 maxSize:CGSizeMake(ScreenW-30, MAXFLOAT)].height;
    model3.rowHight = 25+30+15+height3+row3+10+5;
    return @[model,model1,model2,model3];
}
- (void)getData:(id)dict {
    
}
@end
@implementation HFWDInfoModel
- (void)getData:(id)dict {
    self.shopsId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopsId"]] integerValue];
    if ([[[dict valueForKey:@"productList"] valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
        NSArray *productList =  [[dict valueForKey:@"productList"] valueForKey:@"list"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dataDict in productList) {
            HFWDProductListModel *model = [[HFWDProductListModel alloc] init];
            [model getData:dataDict];
            [tempArray addObject:model];
        }
        self.productList = [tempArray copy];
    }
}
@end
@implementation HFWDProductListModel
- (void)getData:(id)dict {
    self.productId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productId"]] integerValue];
    self.productName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productName"]] ;
    self.productSubtitle = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productSubtitle"]] ;
    self.productSort = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productSort"]]  integerValue];
    self.cashPrice = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"cashPrice"]]  floatValue];
    self.productSpecificationsId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productSpecificationsId"]]  integerValue];
    self.imgUrl = [NSString stringWithFormat:@"%@%@!YS",[[[ManagerTools shareManagerTools] appInfoModel] imageServerUrl],[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"imgUrl"]]]  ;
    self.productClassificationId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productClassificationId"]]  integerValue];
    self.productClassificationName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productClassificationName"]]  ;
    self.productMaxIntegralRatio = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productMaxIntegralRatio"]]  floatValue] ;
    self.totalSaleVolume = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"totalSaleVolume"]]  integerValue];
    
}

@end
@implementation HFYDCarModel
- (void)getData:(id)dict{
    self.carId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"id"]] integerValue];
    self.shopsId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopsId"]] integerValue];
    self.shopsType = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopsType"]] integerValue];
    self.productTypesCount = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productTypesCount"]] integerValue];
    self.productCount = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productCount"]] integerValue];
    self.status = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"state"]] integerValue];
    self.shopsName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"shopsName"]];
    if ([[dict valueForKey:@"productDetails"] isKindOfClass:[NSArray class]]) {
        NSArray *carProductList = [dict valueForKey:@"productDetails"];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:carProductList.count];
        for (NSDictionary *dataDict in carProductList) {
            HFYDCarProductModel *model = [[HFYDCarProductModel alloc] init];
            [model getData:dataDict];
            self.tbHeight += model.rowHeight;
            [tempArray addObject:model];
            
        }
        self.productDetails = [tempArray copy];
    }
    
}
@end
@implementation HFYDCarProductModel
- (void)getData:(id)dict{
    self.carSubId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"id"]] integerValue];
    self.productId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productId"]] integerValue];
    self.specificationId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] integerValue];
    self.productName = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productName"]];
    self.specifications = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specifications"]];
    self.productState = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productState"]] integerValue];
    self.productCount = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productCount"]] integerValue];
    self.totalAmount = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"totalAmount"]] floatValue];
    self.price = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"price"]] floatValue];
    self.imgUrl = [NSString stringWithFormat:@"%@%@!YS",[[[ManagerTools shareManagerTools] appInfoModel] imageServerUrl],[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"imgUrl"]]] ;
    self.jointPictrue = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"jointPictrue"]];
    self.status = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"status"]] integerValue];
    self.stock = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"stock"]] integerValue];
    self.maxIntegralRatio = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"maxIntegralRatio"]] floatValue];
    self.registerCouponRatio = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"registerCouponRatio"]] floatValue];
    self.supplierShopId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"supplierShopId"]] integerValue];
    self.costPrice = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"costPrice"]] floatValue];
    self.productWeight = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"productWeight"]] floatValue];
    self.addShoppingCartType = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"addShoppingCartType"]] integerValue];
    self.commodityType = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"commodityType"]] integerValue];
    self.microProductStatus = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"microProductStatus"]] integerValue];
  self.rowHeight =   [HFUntilTool boundWithStr:self.specifications font:12 maxSize:CGSizeMake(ScreenW-20-24-24-28-20-80-10, MAXFLOAT)].height+21+22+5+20;

}
@end
@implementation HFYDSpecificationsModel

- (void)getData:(id)dict {
    self.attrSpecList = [dict valueForKey:@"attrSpecList"];
    self.specificationList = [dict valueForKey:@"specificationList"];
    NSMutableArray *tempList = [NSMutableArray array];
     NSMutableArray *tempspecificationList = [NSMutableArray array];
    for (NSDictionary *dict in self.attrSpecList) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        if ([[dict valueForKey:@"attributeValues"] isKindOfClass:[NSArray class]]) {
            NSArray *array =  [dict valueForKey:@"attributeValues"];
            [tempDict setValue: [array componentsJoinedByString:@","] forKey:@"attributeValue"];
        }
        [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"attributeId"]] forKey:@"id"];
        [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"attributeName"]] forKey:@"attributeName"];
        [tempList addObject:tempDict];
    }
     for (NSDictionary *dict in self.specificationList) {
         NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
         [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"id"];
         [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"attributeValue"]] forKey:@"code"];
         [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"costPrice"]] forKey:@"intrinsicPrice"];
         [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"jointPictrue"]] forKey:@"jointPictrue"];
         [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"salePrice"]] forKey:@"price"];
//          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"promotionPrice"];
//          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"promotionTag"];
//          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"redPacket"];
//          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"singleUserNumber"];
//          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"startDate"];
          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"stock"]] forKey:@"stock"];
          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationId"]] forKey:@"welfare"];
          [tempDict setValue:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"specificationImageUrl"]] forKey:@"address"];
          [tempspecificationList addObject:tempDict];
     }
    
    self.specificationList = [tempspecificationList copy];
    self.attrSpecList = [tempList copy];
    NSDictionary *rsMap = @{@"descartesCombinationMap":@{@"SKU":self.specificationList },@"productTtributesMap":@{@"seriesAttributes":self.attrSpecList}};
    self.productspMap = rsMap;
}

@end
