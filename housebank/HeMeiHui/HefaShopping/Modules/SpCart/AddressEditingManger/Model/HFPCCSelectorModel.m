//
//  HFPCCSelectorModel.m
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPCCSelectorModel.h"

@implementation HFPCCSelectorModel
- (void)getData:(NSDictionary*)obj {
    self.ids = [[HFUntilTool EmptyCheckobjnil:[obj objectForKey:@"id"]] integerValue];
    self.name = [HFUntilTool EmptyCheckobjnil:[obj objectForKey:@"name"]] ;
    self.shortName = [HFUntilTool EmptyCheckobjnil:[obj objectForKey:@"shortName"]];
    self.parentId = [[HFUntilTool EmptyCheckobjnil:[obj objectForKey:@"id"]] integerValue];
    self.level = [[HFUntilTool EmptyCheckobjnil:[obj objectForKey:@"level"]] integerValue];
    self.cityCode = [HFUntilTool EmptyCheckobjnil:[obj objectForKey:@"cityCode"]] ;
    
}
@end
