//
//  HFAddressModel.m
//  housebank
//
//  Created by usermac on 2018/11/20.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAddressModel.h"
@implementation HFAddressModel
- (void)getDict:(NSDictionary*)dictData {
    /*
     blockId = 203;
     blockName = "\U897f\U57ce\U533a";
     cityId = 1;
     cityName = "\U5317\U4eac\U5e02";
     completeAddress = "\U5317\U4eac\U5e02 \U5317\U4eac\U5e02 \U897f\U57ce\U533a \U65b0\U8857\U53e3\U8857\U9053\U529e\U4e8b\U5904";
     detailAddress = "\U4f7f\U52b2\U9886";
     id = 734;
     isDefault = 0;
     provinceId = 0;
     provinceName = "<null>";
     receiptName = "\U4f30\U8ba1\U5feb\U4e86";
     receiptPhone = 17196431886;
     regionId = 2;
     regionName = "\U5317\U4eac\U5e02";
     townId = 218;
     townName = "\U65b0\U8857\U53e3\U8857\U9053\U529e\U4e8b\U5904";
     */
    self.ids  = [[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"id"]] description];
    self.blockId = [[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"blockId"] ] description];
    self.regionId =  [[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"regionId"] ] description];
    self.cityId = [[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"cityId"]] description];
    self.townId = [[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"townId"]] description];
    self.receiptName = [HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"receiptName"]];
    self.cityName = [HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"cityName"] ];
    self.regionName =  [HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"regionName"]];
    self.blockName = [HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"blockName"]];
    self.townName = [HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"townName"]];
     self.detailAddress = [HFUntilTool EmptyCheckobjnil:[NSString stringWithFormat:@"%@",[dictData valueForKey:@"detailAddress"] ]];
    if (![dictData.allKeys containsObject:@"completeAddress"]) {
        self.completeAddress =[NSString stringWithFormat:@"%@%@",[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"addressName"]],[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"detailAddress"]]] ;
    }else{
        self.completeAddress =[NSString stringWithFormat:@"%@",[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"completeAddress"]]];
    }
    
     self.receiptPhone = [HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"receiptPhone"]];
     self.defalutAddress  = [[HFUntilTool EmptyCheckobjnil:[dictData valueForKey:@"isDefault"]] boolValue];
    CGSize size;
    if (self.defalutAddress&&self.fromeSource == 0) {
        size = CGSizeMake(ScreenW-40-45, 45);
    }else {
       size = CGSizeMake(ScreenW-15-45, 45);
    }
    CGFloat detialAddress = [HFUntilTool boundWithStr:self.completeAddress font:12 maxSize:size].height;
    self.rowheght = 40+detialAddress+10;
    
}
@end
