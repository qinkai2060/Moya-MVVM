//
//  HFFamousGoodsBannerModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamousGoodsBannerModel.h"

@implementation HFFamousGoodsBannerModel
- (void)getData:(NSDictionary*)data {
    /*
     @property(nonatomic,copy)NSString *linkContent;
     @property(nonatomic,copy)NSString *imageth;
     @property(nonatomic,copy)NSString *bannerId;
     @property(nonatomic,copy)NSString *advertisingTitle;
     */
    self.imageth = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"imageth"]] description];
    self.linkContent = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"linkContent"]] description];
    self.linkType = [[HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"linkType"] description]]  integerValue];
    self.bannerId = [[HFUntilTool EmptyCheckobjnil:[[data valueForKey:@"id"] description]] description];
}
@end
