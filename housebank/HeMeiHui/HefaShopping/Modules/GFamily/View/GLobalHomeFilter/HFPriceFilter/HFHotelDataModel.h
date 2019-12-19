//
//  HFHotelDataModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFHotelDataModel : NSObject
@property(nonatomic,assign)NSInteger hotelId;
@property(nonatomic,copy)NSString *hotelName;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *jointPicture;
@property(nonatomic,assign)NSInteger commentScore;
@property(nonatomic,assign)NSInteger commentNum;
@property(nonatomic,assign)NSInteger star;
@property(nonatomic,copy)NSString *starName;
@property(nonatomic,copy)NSString *renovationDate;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)NSInteger regionId;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,assign)NSInteger distance;
@property(nonatomic,assign)CGFloat pointLng;
@property(nonatomic,assign)CGFloat pointLat;
- (void)getData:(NSDictionary *)obj;
@end

NS_ASSUME_NONNULL_END
