//
//  JLSliderView.h
//  WQHCarJob
//
//  Created by job on 16/12/5.
//  Copyright © 2016年 job. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol HFFIlterPriceCenterViewDelegate <NSObject>

-(void)sliderViewDidSliderLeft:(NSUInteger )leftValue right:(NSUInteger )rightValue;

@end





typedef NS_ENUM(NSInteger, HFFIlterPriceCenterViewType) {
    //滑动的在轴上
   HFFIlterPriceCenterViewTypeCenter = 0,
   HFFIlterPriceCenterViewTypeBottom = 1,
};



@interface HFFIlterPriceCenterView : UIView

@property (strong, nonatomic) UIColor *thumbColor;

@property (strong, nonatomic) UIColor *bgColor;

@property (assign, nonatomic) NSUInteger minValue;


@property (assign, nonatomic) NSUInteger maxValue;

@property (assign, nonatomic) HFFIlterPriceCenterViewType sliderType;

@property (assign, nonatomic, readonly) NSUInteger currentMinValue;

@property (assign, nonatomic, readonly) NSUInteger currentMaxValue;

@property (assign, nonatomic) id<HFFIlterPriceCenterViewDelegate> delegate;


-(instancetype)initWithFrame:(CGRect)frame sliderType:(HFFIlterPriceCenterViewType )type;

- (void)setMaxValue:(NSInteger)maxValue withMinValue:(NSInteger)minValue;



@end
