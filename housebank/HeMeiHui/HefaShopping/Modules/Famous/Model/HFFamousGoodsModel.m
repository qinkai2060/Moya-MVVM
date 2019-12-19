//
//  HFFamousGoodsModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamousGoodsModel.h"

@implementation HFFamousGoodsModel
- (void)getDataObj:(id)obj {
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
    self.productId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productId"] description]] integerValue];
    self.classifications = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"classifications"] description]] integerValue];
    self.productName = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productName"] description]] ;
    self.famousProudctId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"id"] description]] integerValue];
    self.productLevel = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productLevel"] description]] integerValue];
    self.productSubtitle = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productSubtitle"] description]];
    self.productImage = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productImage"] description]];
    self.specificationsId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"specificationsId"] description]] integerValue];
    self.cashPrice = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"cashPrice"] description]] floatValue];
    self.promotionPrice = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"promotionPrice"] description]] floatValue];
    self.productSubtitle = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productSubtitle"] description]] ;
    self.promotionTag = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"promotionTag"] ];
    
}
@end
