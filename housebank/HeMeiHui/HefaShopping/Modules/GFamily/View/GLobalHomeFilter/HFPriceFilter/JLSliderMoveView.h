//
//  JLSliderMoveView.h
//  WQHCarJob
//
//  Created by job on 16/12/5.
//  Copyright © 2016年 job. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLSliderMoveView;
typedef NS_ENUM(NSInteger, JLSliderState) {
    //滑动的在轴上
    JLSliderStateBegin = 0,
    JLSliderStateIng = 1,
    JLSliderStateEnd = 2,
};




@protocol SlidMoveDelegate <NSObject>

-(void)slidMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat) rightPosition;

-(void)slidMovedView:(JLSliderMoveView*)moveView andRightState:(JLSliderState) state;


-(void)slidDidEndMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat) rightPosition;


@end





@interface JLSliderMoveView : UIView
@property (assign, nonatomic) CGFloat   leftPosition;
@property (assign, nonatomic) CGFloat   rightPosition;
@property (assign, nonatomic) JLSliderState   state;
@property (assign, nonatomic) BOOL isRound;
@property (strong, nonatomic) UIColor *thumbColor;
@property (weak,   nonatomic) id <SlidMoveDelegate> delegate;
- (void)setLeftPosition:(CGFloat)leftPosition withRightPostion:(CGFloat)rightPostion;
@end
