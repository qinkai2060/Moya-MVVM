//
//  HFDataModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFDataModel.h"

@implementation HFDataModel

/**
 <#Description#>@property(nonatomic,assign)NSInteger productId;
 @property(nonatomic,assign)NSInteger shopId;
 @property(nonatomic,assign)NSInteger productLevel;
 @property(nonatomic,assign)NSInteger singleProductState;
 @property(nonatomic,assign)NSInteger specificationsId;
 @property(nonatomic,assign)NSInteger stock;
 @property(nonatomic,assign)CGFloat cashPrice;
 
 @property(nonatomic,strong)NSString *firstClassifyName;
 @property(nonatomic,strong)NSString *imageUrl;
 @property(nonatomic,strong)NSString *jointPictrue;
 @property(nonatomic,strong)NSString *productName;
 @property(nonatomic,strong)NSString *shopName;
 @property(nonatomic,strong)NSString *productSubtitle;
 @property(nonatomic,strong)NSString *thirdClassifyName;
 @property(nonatomic,strong)NSString *secondClassifyName;
 */
- (void)getDataObj:(id)obj {
    
    self.productId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productId"] description]] integerValue];
     self.famousProudctId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"id"] description]] integerValue];
     self.shopId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"shopId"] description]] integerValue];
    self.productLevel = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productLevel"] description]] integerValue];
    self.singleProductState = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"singleProductState"] description]] integerValue];
    self.specificationsId = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"specificationsId"] description]] integerValue];
    self.stock = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"stock"] description]] integerValue];
    self.cashPrice = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"cashPrice"] description]] floatValue];
    self.firstClassifyName = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"firstClassifyName"] description]] ;
     self.imageUrl = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"imageUrl"] description]] ;
     self.jointPictrue = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"jointPictrue"] description]] ;
     self.productName = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productName"] description]] ;
     self.shopName = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"shopName"] description]] ;
     self.productSubtitle = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"productSubtitle"] description]] ;
    self.thirdClassifyName = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"thirdClassifyName"] description]] ;
    self.secondClassifyName = [HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"secondClassifyName"] description]] ;
    self.useRegisterCoupon = [[HFUntilTool EmptyCheckobjnil:[[obj valueForKey:@"useRegisterCoupon"] description]] boolValue];
    
}
@end
