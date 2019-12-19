//
//  HFCommitPayModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCommitPayModel.h"

@implementation HFCommitPayModel
- (void)getData:(NSDictionary*)data {
    self.userId = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"userId"]] integerValue];
    self.shopsImgUrl = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopsImgUrl"]];
    self.totalPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"totalPrice"]] floatValue];
    self.orderNo = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"orderNo"]];
    self.shopsName = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"shopsName"]];
}
@end
