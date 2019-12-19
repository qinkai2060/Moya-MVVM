//
//  HFSilderView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger  {
    HFSilderViewStateBegan,
    HFSilderViewStateChange,
    HFSilderViewStateEnd,
}HFSilderViewState;
@class HFSilderView;
@protocol HFSilderViewDelegate <NSObject>

- (void)silderView:(HFSilderView*)view low:(NSString*)low hight:(NSString*)hight state:(HFSilderViewState)state;

@end


@interface HFSilderView : UIView
@property(nonatomic,weak)id<HFSilderViewDelegate> delegate;
- (void)setMaxValue:(NSInteger)maxValue withMinValue:(NSInteger)minValue;

@end
