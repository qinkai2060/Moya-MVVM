//
//  WARFeedPopUpView.h
//  WARControl
//
//  Created by helaf on 2018/4/28.
//

#import <UIKit/UIKit.h>

@protocol WARFeedPopUpViewDelegate <NSObject>
- (CGFloat)currentValueOffset; //expects value in the range 0.0 - 1.0
- (void)animationDidStart;
@end



@interface WARFeedPopUpView : UIView

@property (weak, nonatomic) id <WARFeedPopUpViewDelegate> delegate;

- (UIColor *)color;
- (void)setColor:(UIColor *)color;
- (UIColor *)opaqueColor;

- (void)setTextColor:(UIColor *)textColor;
- (void)setFont:(UIFont *)font;
- (void)setString:(NSString *)string;

- (void)setAnimatedColors:(NSArray *)animatedColors;

- (void)setAnimationOffset:(CGFloat)offset;
- (void)setArrowCenterOffset:(CGFloat)offset;

- (CGSize)popUpSizeForString:(NSString *)string;

- (void)show;
- (void)hide;

@end
