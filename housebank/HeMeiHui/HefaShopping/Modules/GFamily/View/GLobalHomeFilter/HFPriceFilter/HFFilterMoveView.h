//
//  JLSliderMoveView.h
//  WQHCarJob
//
//  Created by job on 16/12/5.
//  Copyright © 2016年 job. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HFFilterMoveView;
typedef NS_ENUM(NSInteger, HFFilterMoveViewState) {
    //滑动的在轴上
    HFFilterMoveViewStateBegin = 0,
    HFFilterMoveViewStateIng = 1,
    HFFilterMoveViewStateEnd = 2,
};


@protocol HFFilterMoveViewDelegate <NSObject>

-(void)slidMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat) rightPosition;

-(void)slidMovedView:(HFFilterMoveView*)moveView andRightState:(HFFilterMoveViewState) state;

-(void)slidDidEndMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat) rightPosition;


@end





@interface HFFilterMoveView : UIView
@property (assign, nonatomic) CGFloat   leftPosition;
@property (assign, nonatomic) CGFloat   rightPosition;
@property (assign, nonatomic) BOOL isRound;
@property (assign, nonatomic) HFFilterMoveViewState state;
@property (strong, nonatomic) UIColor *thumbColor;
@property (weak,   nonatomic) id <HFFilterMoveViewDelegate> delegate;
- (void)setLeftPosition:(CGFloat)leftPosition withRightPostion:(CGFloat)rightPostion;
@end
