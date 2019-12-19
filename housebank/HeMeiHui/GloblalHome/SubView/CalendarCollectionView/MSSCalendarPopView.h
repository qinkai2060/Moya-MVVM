//
//  MSSCalendarPopView.h
//  Test
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSSCalendarPopViewArrowPosition)
{
    MSSCalendarPopViewArrowPositionLeft = 0,
    MSSCalendarPopViewArrowPositionMiddle,
    MSSCalendarPopViewArrowPositionRight
};

@interface MSSCalendarPopView : UIView

@property (nonatomic,copy)NSString *topLabelText;
@property (nonatomic,copy)NSString *bottomLabelText;

- (instancetype)initWithSideView:(UIView *)sideView arrowPosition:(MSSCalendarPopViewArrowPosition)arrowPosition;

- (void)showWithAnimation;

@end
