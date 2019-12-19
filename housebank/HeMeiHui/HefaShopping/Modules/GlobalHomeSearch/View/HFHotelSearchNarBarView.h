//
//  HFHotelSearchNarBarView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "SpeakTextField.h"
@class HFHotelSearchNarBarView;
@protocol HFHotelSearchNarBarViewDelegate <NSObject>
- (void)hotelSearchNarBarView:(HFHotelSearchNarBarView*)barView keyWord:(NSString*)keyWord;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HFHotelSearchNarBarView : HFView
@property(nonatomic,strong)SpeakTextField *textFiled;
@property(nonatomic,weak)id<HFHotelSearchNarBarViewDelegate> delegate;
- (void)setUpKeyWord:(NSString *)keyWord;
- (void)becomeVIPFirstResponse;
- (void)loseFirstRespone;
@end

NS_ASSUME_NONNULL_END
