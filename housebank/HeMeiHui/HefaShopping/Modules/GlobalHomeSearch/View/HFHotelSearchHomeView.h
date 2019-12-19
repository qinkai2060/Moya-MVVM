//
//  HFHotelSearchHomeView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"

@class HFHistoryModel;
@class HFHotelSearchHomeView;
@protocol HFHotelSearchHomeViewDelegate <NSObject>
- (void)hotelSearchHomeView:(HFHotelSearchHomeView*)searchHomeView searchKey:(HFHistoryModel*)model;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HFHotelSearchHomeView : HFView
@property(nonatomic,weak)id <HFHotelSearchHomeViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
