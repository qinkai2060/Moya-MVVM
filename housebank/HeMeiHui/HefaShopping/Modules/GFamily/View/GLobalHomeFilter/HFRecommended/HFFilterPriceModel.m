//
//  HFFilterPriceModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFilterPriceModel.h"

@implementation HFFilterPriceModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeStar];
}
+ (HFFilterPriceModel*)priceStarData {
    HFFilterPriceModel *priceModel = [[HFFilterPriceModel alloc] init];
    priceModel.type = HFShowFilterModelTypeStar;
    priceModel.minfloat = @"0";
    priceModel.maxfloat = @"不限";
    priceModel.starSelect = @"0";
    priceModel.star = 0;
    HFFilterPriceModel *price = [[HFFilterPriceModel alloc] init];
    price.title = @"价格";
    price.selectTitle = @"不限";
    price.minfloat = @"0";
    price.maxfloat = @"不限";
    HFFilterPriceModel *itemPrice = [[HFFilterPriceModel alloc] init];
    itemPrice.title = @"不限";
    itemPrice.isSelected = YES;
    itemPrice.minfloat = @"0";
    itemPrice.maxfloat = @"不限";
    HFFilterPriceModel *itemPrice1 = [[HFFilterPriceModel alloc] init];
    itemPrice1.title = @"¥0-100";
    itemPrice1.isSelected = NO;
    itemPrice1.minfloat = @"0";
    itemPrice1.maxfloat = @"100";
    HFFilterPriceModel *itemPrice2 = [[HFFilterPriceModel alloc] init];
    itemPrice2.title = @"¥100-150";
    itemPrice2.isSelected = NO;
    itemPrice2.minfloat = @"100";
    itemPrice2.maxfloat = @"150";
    HFFilterPriceModel *itemPrice3 = [[HFFilterPriceModel alloc] init];
    itemPrice3.title = @"¥150-300";
    itemPrice3.isSelected = NO;
    itemPrice3.minfloat = @"150";
    itemPrice3.maxfloat = @"300";
    HFFilterPriceModel *itemPrice4 = [[HFFilterPriceModel alloc] init];
    itemPrice4.title = @"¥300-500";
    itemPrice4.isSelected = NO;
    itemPrice4.minfloat = @"300";
    itemPrice4.maxfloat = @"500";
    HFFilterPriceModel *itemPrice5 = [[HFFilterPriceModel alloc] init];
    itemPrice5.title = @"¥500-900";
    itemPrice5.isSelected = NO;
    itemPrice5.minfloat = @"500";
    itemPrice5.maxfloat = @"900";
    HFFilterPriceModel *itemPrice6 = [[HFFilterPriceModel alloc] init];
    itemPrice6.title = @"¥900以上";
    itemPrice6.isSelected = NO;
    itemPrice6.minfloat = @"900";
    itemPrice6.maxfloat = @"不限";
    price.dataSource = @[itemPrice,itemPrice1,itemPrice2,itemPrice3,itemPrice4,itemPrice5,itemPrice6];
    
    HFFilterPriceModel *price1 = [[HFFilterPriceModel alloc] init];
    price1.title = @"星级";
    price1.star = 0;
    HFFilterPriceModel *itemStar = [[HFFilterPriceModel alloc] init];
    itemStar.title = @"不限";
    itemStar.isSelected = YES;
    itemStar.star = 0;
    HFFilterPriceModel *itemStar1 = [[HFFilterPriceModel alloc] init];
    itemStar1.title = @"经济连锁";
    itemStar1.isSelected = NO;
    itemStar1.star = 1;
    HFFilterPriceModel *itemStar2 = [[HFFilterPriceModel alloc] init];
    itemStar2.title = @"二星/其他";
    itemStar2.isSelected = NO;
    itemStar2.star = 2;
    HFFilterPriceModel *itemStar3 = [[HFFilterPriceModel alloc] init];
    itemStar3.title = @"三星/舒适";
    itemStar3.isSelected = NO;
    itemStar3.star = 3;
    HFFilterPriceModel *itemStar4 = [[HFFilterPriceModel alloc] init];
    itemStar4.title = @"四星/高档";
    itemStar4.isSelected = NO;
    itemStar4.star = 4;
    HFFilterPriceModel *itemStar5 = [[HFFilterPriceModel alloc] init];
    itemStar5.title = @"五星/豪华";
    itemStar5.isSelected = NO;
    itemStar5.star = 5;
    price1.dataSource = @[itemStar,itemStar1,itemStar2,itemStar3,itemStar4,itemStar5];
    price.viewHight = 250+50;
    price1.viewHight = 150;
    
    priceModel.dataSource = @[price,price1];
    priceModel.viewHight = 450;
    
    return priceModel;
}
+ (HFFilterPriceModel*)priceStarData2 {
    HFFilterPriceModel *priceModel = [[HFFilterPriceModel alloc] init];
    priceModel.type = HFShowFilterModelTypeStar;
    priceModel.minfloat = @"0";
    priceModel.maxfloat = @"不限";
    priceModel.starSelect = @"0";
    priceModel.selectTitle = @"¥不限";
    priceModel.starSelectTitle = @"不限";
    priceModel.star = 0;
    HFFilterPriceModel *price = [[HFFilterPriceModel alloc] init];
    price.title = @"价格";
    price.selectTitle = @"不限";
    price.minfloat = @"0";
    price.maxfloat = @"不限";
    HFFilterPriceModel *itemPrice = [[HFFilterPriceModel alloc] init];
    itemPrice.title = @"不限";
    itemPrice.isSelected = YES;
    itemPrice.minfloat = @"0";
    itemPrice.maxfloat = @"不限";
    HFFilterPriceModel *itemPrice1 = [[HFFilterPriceModel alloc] init];
    itemPrice1.title = @"¥0-100";
    itemPrice1.isSelected = NO;
    itemPrice1.minfloat = @"0";
    itemPrice1.maxfloat = @"100";
    HFFilterPriceModel *itemPrice2 = [[HFFilterPriceModel alloc] init];
    itemPrice2.title = @"¥100-150";
    itemPrice2.isSelected = NO;
    itemPrice2.minfloat = @"100";
    itemPrice2.maxfloat = @"150";
    HFFilterPriceModel *itemPrice3 = [[HFFilterPriceModel alloc] init];
    itemPrice3.title = @"¥150-300";
    itemPrice3.isSelected = NO;
    itemPrice3.minfloat = @"150";
    itemPrice3.maxfloat = @"300";
    HFFilterPriceModel *itemPrice4 = [[HFFilterPriceModel alloc] init];
    itemPrice4.title = @"¥300-500";
    itemPrice4.isSelected = NO;
    itemPrice4.minfloat = @"300";
    itemPrice4.maxfloat = @"500";
    HFFilterPriceModel *itemPrice5 = [[HFFilterPriceModel alloc] init];
    itemPrice5.title = @"¥500-900";
    itemPrice5.isSelected = NO;
    itemPrice5.minfloat = @"500";
    itemPrice5.maxfloat = @"900";
    HFFilterPriceModel *itemPrice6 = [[HFFilterPriceModel alloc] init];
    itemPrice6.title = @"¥900以上";
    itemPrice6.isSelected = NO;
    itemPrice6.minfloat = @"900";
    itemPrice6.maxfloat = @"不限";
    price.dataSource = @[];
    
    HFFilterPriceModel *price1 = [[HFFilterPriceModel alloc] init];
    price1.title = @"星级";
    price1.star = 0;
    HFFilterPriceModel *itemStar = [[HFFilterPriceModel alloc] init];
    itemStar.title = @"不限";
    itemStar.isSelected = YES;
    itemStar.star = 0;
    HFFilterPriceModel *itemStar1 = [[HFFilterPriceModel alloc] init];
    itemStar1.title = @"经济连锁";
    itemStar1.isSelected = NO;
    itemStar1.star = 1;
    HFFilterPriceModel *itemStar2 = [[HFFilterPriceModel alloc] init];
    itemStar2.title = @"二星/其他";
    itemStar2.isSelected = NO;
    itemStar2.star = 2;
    HFFilterPriceModel *itemStar3 = [[HFFilterPriceModel alloc] init];
    itemStar3.title = @"三星/舒适";
    itemStar3.isSelected = NO;
    itemStar3.star = 3;
    HFFilterPriceModel *itemStar4 = [[HFFilterPriceModel alloc] init];
    itemStar4.title = @"四星/高档";
    itemStar4.isSelected = NO;
    itemStar4.star = 4;
    HFFilterPriceModel *itemStar5 = [[HFFilterPriceModel alloc] init];
    itemStar5.title = @"五星/豪华";
    itemStar5.isSelected = NO;
    itemStar5.star = 5;
    price1.dataSource = @[itemStar,itemStar1,itemStar2,itemStar3,itemStar4,itemStar5];
    price.viewHight = 135;
    price1.viewHight = 150;
    
    priceModel.dataSource = @[price,price1];
    priceModel.viewHight = 135+150+50;
    
    return priceModel;
}
@end
