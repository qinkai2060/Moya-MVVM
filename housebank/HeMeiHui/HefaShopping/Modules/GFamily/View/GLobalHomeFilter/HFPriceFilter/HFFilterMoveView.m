//
//  HFFilterMoveView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/17.
//  Copyright © 2019 hefa. All rights reserved.
//

//
//  JLSliderMoveView.m
//  WQHCarJob
//
//  Created by job on 16/12/5.
//  Copyright © 2016年 job. All rights reserved.
//

#import "HFFilterMoveView.h"
#import "UIView+Frame.h"



typedef enum : NSUInteger {
    HFFilterMoveViewTypeLeft,
    HFFilterMoveViewTypeRight,
    HFFilterMoveViewTypeNone,
} HFFilterMoveViewType;

@interface HFFilterMoveView  () {
    CGFloat  iconwidth;
}

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;

//是否重合
@property (assign, nonatomic) BOOL isCoincide;
@property (assign, nonatomic) HFFilterMoveViewType slideType;
@property (assign, nonatomic) CGFloat coincideX;
@property (assign, nonatomic) CGFloat startX;


//@property (assign, nonatomic) CGFloat startLeftX;
//@property (assign, nonatomic) CGFloat startRightX;

@end


@implementation HFFilterMoveView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.userInteractionEnabled = YES;
        iconwidth = self.height;

        self.leftLabel = [self creatLabelWithFrame:CGRectMake(0, 0, iconwidth, self.height)];
        self.leftLabel.userInteractionEnabled = YES;
        self.leftLabel.tag = 100;
        [self addSubview:self.leftLabel];
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doLeftPanGesture:)];
        [self.leftLabel addGestureRecognizer:leftPan];
        
        
        self.rightLabel = [self creatLabelWithFrame:CGRectMake(self.width - iconwidth, 0, iconwidth, self.height)];
        self.rightLabel.userInteractionEnabled = YES;
        self.rightLabel.tag = 101;
        [self addSubview:self.rightLabel];
        
        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doLeftPanGesture:)];
        [self.rightLabel addGestureRecognizer:rightPan];
        
        self.leftPosition  = self.leftLabel.centerX;
        self.rightPosition = self.rightLabel.centerX;
    }
    return self;
}




-(UILabel *)creatLabelWithFrame:(CGRect )frame {
    UILabel *label =  [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return  label;
}

//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch  = [touches anyObject];
//    CGPoint  point  = [touch locationInView:self];
//    //    NSLog(@"正在");
//    if ([self.delegate respondsToSelector:@selector(slidMovedView:andRightState:)]) {
//        [self.delegate slidMovedView:self andRightState:HFFilterMoveViewStateIng];
//    }
//    if(self.isCoincide){
//        if (point.x > self.coincideX +1 ) {
//            self.slideType = HFFilterMoveViewTypeRight;
//            self.isCoincide = NO;
//        }
//        if (point.x < self.coincideX -1 ) {
//            self.slideType = HFFilterMoveViewTypeLeft;
//            self.isCoincide = NO;
//        }
//        return;
//    }
//    //超出滑动的位置则不可以控制---- 左边的位置大于右边的位置不能滑动
//    if (point.y>self.height) {
//        return;
//    }
//    //当滑动的位置不在两个
//    if (self.slideType == HFFilterMoveViewTypeRight) {
//        return;
//    }
//    //当滑动左边的时候
//    if (self.slideType == HFFilterMoveViewTypeLeft ) {
//
//        CGFloat maxRight = self.rightLabel.centerX;
//        if (point.x < maxRight || self.rightLabel.centerX > self.leftLabel.centerX) {
//            self.leftLabel.centerX = point.x;
//            if (self.leftLabel.centerX < iconwidth/2) {
//                self.leftLabel.centerX = iconwidth/2;
//            }
//            if (self.leftLabel.centerX > self.rightLabel.centerX) {
//                self.leftLabel.centerX = self.rightLabel.centerX;
//            }
//            self.leftPosition = self.leftLabel.centerX ;
//            //            NSLog(@"左边%f",self.leftPosition);
//            if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
//                [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
//            }
//        }
//    }
//    //当滑动右边的时候
//    if (self.slideType == HFFilterMoveViewTypeRight) {
//        CGFloat maxLeft = self.leftLabel.centerX;
//        if (point.x > maxLeft || self.rightLabel.centerX > self.leftLabel.centerX) {
//            self.rightLabel.centerX = point.x;
//            if (self.rightLabel.centerX > self.width-iconwidth/2) {
//                self.rightLabel.centerX = self.width-iconwidth/2;
//            }
//            if (self.leftLabel.centerX > self.rightLabel.centerX) {
//                self.rightLabel.centerX = self.leftLabel.centerX;
//            }
//            self.rightPosition = self.rightLabel.centerX ;
//            if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
//                [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
//            }
//
//        }
//    }
//
//}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"开始点击");
//    if ([self.delegate respondsToSelector:@selector(slidMovedView:andRightState:)]) {
//        [self.delegate slidMovedView:self andRightState:HFFilterMoveViewStateBegin];
//    }
//    UITouch *touch  = [touches anyObject];
//    CGPoint  point  = [touch locationInView:self];
//    self.startX = point.x;
//    //当手指点中下面的滑条时，才能滑动
//
//    //如果重合
//    if (self.rightLabel.centerX-5<self.leftLabel.centerX    &&  self.leftLabel.centerX< self.rightLabel.centerX+5 )  {
//        self.isCoincide = YES;
//        self.coincideX  = point.x;
//        return;
//    }else {
//        self.isCoincide = NO;
//    }
//
//    //手指放在左边范围
//    if (point.x <self.leftLabel.right && point.x >self.leftLabel.left) {
//        self.slideType = HFFilterMoveViewTypeLeft;
//    }else  if (point.x <self.rightLabel.right && point.x >self.rightLabel.left) {
//        self.slideType = HFFilterMoveViewTypeRight;
//    }else {
//        self.slideType = HFFilterMoveViewTypeNone;
//    }
//
//
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if ([self.delegate respondsToSelector:@selector(slidMovedView:andRightState:)]) {
//        [self.delegate slidMovedView:self andRightState:HFFilterMoveViewStateEnd];
//    }
//    if ([self.delegate respondsToSelector:@selector(slidDidEndMovedLeft:andRightPosition:)]) {
//        [self.delegate slidDidEndMovedLeft:self.leftPosition  andRightPosition:self.rightPosition];
//    }
//
//}
//
//
//-(void)setIsRound:(BOOL)isRound {
//    _isRound = isRound;
//    if (isRound) {
//        self.leftLabel.size    = CGSizeMake(self.height, self.height);
//        self.leftLabel.layer.cornerRadius = self.leftLabel.height /2;
//        self.rightLabel.size = CGSizeMake(self.height, self.height);
//        self.rightLabel.layer.cornerRadius = self.rightLabel.height /2;
//    }
//}
//-(void)setThumbColor:(UIColor *)thumbColor {
//    _thumbColor = thumbColor;
//    _leftLabel.backgroundColor = thumbColor;
//    _rightLabel.backgroundColor = thumbColor;
//}
//
//- (void)setLeftPosition:(CGFloat)leftPosition withRightPostion:(CGFloat)rightPostion {
//    self.leftLabel.centerX = leftPosition;
//    self.rightLabel.centerX = rightPostion;
//    self.leftPosition  = self.leftLabel.centerX;
//    self.rightPosition = self.rightLabel.centerX;
//    if (self.rightLabel.centerX-5<self.leftLabel.centerX    &&  self.leftLabel.centerX< self.rightLabel.centerX+5 )  {
//        self.isCoincide = YES;
//        //        self.coincideX  = point.x;
//        //        return;
//    }else {
//        self.isCoincide = NO;
//    }
//}

-(void)doLeftPanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGFloat startX = 0.0;
    CGPoint point = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        startX = gesture.view.centerX;
        
    }if (gesture.state == UIGestureRecognizerStateChanged) {
//            if ([self.delegate respondsToSelector:@selector(slidMovedView:andRightState:)]) {
//                [self.delegate slidMovedView:self andRightState:HFFilterMoveViewStateIng];
//            }
//            if(self.isCoincide){
//                if (point.x > self.coincideX +1 ) {
//                    self.slideType = HFFilterMoveViewTypeRight;
//                    self.isCoincide = NO;
//                }
//                if (point.x < self.coincideX -1 ) {
//                    self.slideType = HFFilterMoveViewTypeLeft;
//                    self.isCoincide = NO;
//                }
//                return;
//            }
            //超出滑动的位置则不可以控制---- 左边的位置大于右边的位置不能滑动
//            if (point.y>self.height) {
//                return;
//            }
            //当滑动的位置不在两个
//            if (self.slideType == HFFilterMoveViewTypeRight) {
//                return;
//            }
            //当滑动左边的时候
            if (gesture.view.tag == 100 ) {
                 NSLog(@"走了左");
                CGFloat maxRight = self.rightLabel.centerX;
                if (point.x < maxRight || self.rightLabel.centerX > self.leftLabel.centerX) {
                    self.leftLabel.centerX = point.x+startX;
                    if (self.leftLabel.centerX < iconwidth/2) {
                        self.leftLabel.centerX = iconwidth/2;
                    }
                    if (self.leftLabel.centerX > self.rightLabel.centerX) {
                        self.leftLabel.centerX = self.rightLabel.centerX;
                    }
                    self.leftPosition = self.leftLabel.centerX ;
                    //            NSLog(@"左边%f",self.leftPosition);
//                    if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
//                        [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
//                    }
                }
            }
        if (gesture.view.tag == 101) {
            NSLog(@"走了右");
            CGFloat maxLeft = self.leftLabel.centerX;
            //            self.rightLabel.centerX = MIN(self.rightLabel.centerX +point.x, self.width-iconwidth/2);
            if (point.x > maxLeft || self.rightLabel.centerX > self.leftLabel.centerX) {
                 NSLog(@"走了右");
                self.rightLabel.centerX = point.x;
                if (self.rightLabel.centerX > self.width-iconwidth/2) {
                    self.rightLabel.centerX = self.width-iconwidth/2;
                }
                if (self.leftLabel.centerX > self.rightLabel.centerX) {
                    self.rightLabel.centerX = self.leftLabel.centerX;
                }
                self.rightPosition = self.rightLabel.centerX ;
                //                    if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
                //                        [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
                //                    }
                
            }
        }
        
    }if (gesture.state == UIGestureRecognizerStateEnded) {
        
    }
    
}

-(void)doRightPanGesture:(UIPanGestureRecognizer *)gesture {
    NSLog(@"走了doRightPanGesture");
//    CGFloat startX = 0.0;
    CGPoint point = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
//        startX = gesture.view.centerX;
        
    }if (gesture.state == UIGestureRecognizerStateChanged) {
        
        
        //当滑动右边的时候
        if (gesture.view.tag == 101) {
            NSLog(@"走了右");
            CGFloat maxLeft = self.leftLabel.centerX;
//            self.rightLabel.centerX = MIN(self.rightLabel.centerX +point.x, self.width-iconwidth/2);
            if (point.x > maxLeft || self.rightLabel.centerX > self.leftLabel.centerX) {
                self.rightLabel.centerX = point.x;
                if (self.rightLabel.centerX > self.width-iconwidth/2) {
                    self.rightLabel.centerX = self.width-iconwidth/2;
                }
                if (self.leftLabel.centerX > self.rightLabel.centerX) {
                    self.rightLabel.centerX = self.leftLabel.centerX;
                }
                self.rightPosition = self.rightLabel.centerX ;
                //                    if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
                //                        [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
                //                    }
                
            }
        }
        
    }if (gesture.state == UIGestureRecognizerStateEnded) {
        
    }
}

@end
