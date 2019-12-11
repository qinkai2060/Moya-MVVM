//
//  WARMomentCircleProgressView.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/26.
//

#import <UIKit/UIKit.h>

@interface WARMomentCircleProgressView : UIView <CAAnimationDelegate>

@property (nonatomic, copy) void (^fillChangedBlock)(WARMomentCircleProgressView *progressView, BOOL filled, BOOL animated);
@property (nonatomic, copy) void (^didSelectBlock)(WARMomentCircleProgressView *progressView);
@property (nonatomic, copy) void (^progressChangedBlock)(WARMomentCircleProgressView *progressView, CGFloat progress);

@property (nonatomic, strong) UIView *centralView;
@property (nonatomic, assign) BOOL fillOnTouch UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)addFill;

@property (nonatomic, strong) UILongPressGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign) CGFloat longPressDuration;
@property (nonatomic, assign) BOOL longPressCancelsSelect;
@property (nonatomic, copy) void (^didLongPressBlock)(WARMomentCircleProgressView *progressView);

@end
