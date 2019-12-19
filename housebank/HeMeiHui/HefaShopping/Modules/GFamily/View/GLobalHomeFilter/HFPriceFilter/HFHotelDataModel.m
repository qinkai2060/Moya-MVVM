//
//  HFHotelDataModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHotelDataModel.h"

@implementation HFHotelDataModel
- (void)getData:(NSDictionary *)obj {
    self.hotelId =  [[[HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"id"]]  description] integerValue];
    self.hotelName = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"hotelName"]];
    self.imageUrl = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"imageUrl"]];
    self.jointPicture = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"jointPicture"]];
    self.starName = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"starName"]];
    self.renovationDate = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"renovationDate"]];
    self.address = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"address"]];
    if ([[obj valueForKey:@"commentScore"] isKindOfClass:[NSNumber class]]) {
         self.commentScore = [[obj valueForKey:@"commentScore"] integerValue];
    }
    if ([[obj valueForKey:@"commentNum"] isKindOfClass:[NSNumber class]]) {
        self.commentNum = [[obj valueForKey:@"commentNum"] integerValue];
    }
    if ([[obj valueForKey:@"star"] isKindOfClass:[NSNumber class]]) {
        self.star = [[obj valueForKey:@"star"] integerValue];
    }

    if ([[obj valueForKey:@"cityId"] isKindOfClass:[NSNumber class]]) {
        self.cityId = [[obj valueForKey:@"cityId"] integerValue];
    }
    if ([[obj valueForKey:@"regionId"] isKindOfClass:[NSNumber class]]) {
        self.regionId = [[obj valueForKey:@"regionId"] integerValue];
    }
    if ([[obj valueForKey:@"price"] isKindOfClass:[NSNumber class]]) {
        self.price = [[obj valueForKey:@"price"] integerValue];
    }
    if ([[obj valueForKey:@"distance"] isKindOfClass:[NSNumber class]]) {
        self.distance = [[obj valueForKey:@"distance"] integerValue];
    }
    if ([[obj valueForKey:@"pointLat"] isKindOfClass:[NSNumber class]]) {
        self.pointLat = [[obj valueForKey:@"pointLat"] integerValue];
    }
    if ([[obj valueForKey:@"pointLng"] isKindOfClass:[NSNumber class]]) {
        self.pointLng = [[obj valueForKey:@"pointLng"] integerValue];
    }


}
@end
