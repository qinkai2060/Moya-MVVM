//
//  HFHotelSearchViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewController.h"
@class HFHotelSearchViewController;
typedef enum : NSUInteger  {
    HFHotelSearchViewControllerDefault = 1000,
    HFHotelSearchViewControllerOther
}HFHotelSearchViewControllerType;
NS_ASSUME_NONNULL_BEGIN
@protocol HFHotelSearchViewControllerDelegate <NSObject>

- (void)hotelViewController:(HFHotelSearchViewController*)viewController keyWord:(NSString*)keyWord;

@end
@interface HFHotelSearchViewController : HFViewController
@property(nonatomic,weak)id<HFHotelSearchViewControllerDelegate> delegate;
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel withType:(HFHotelSearchViewControllerType)type;
- (void)setUpKeyWord:(NSString *)keyWord;
@end

NS_ASSUME_NONNULL_END
