//
//  JLSliderView.m
//  WQHCarJob
//
//  Created by job on 16/12/5.
//  Copyright © 2016年 job. All rights reserved.
//

#import "HFFIlterPriceCenterView.h"
#import "UIView+Frame.h"
#import "HFFilterMoveView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define iconwidth   40
#define iconheight  15
@interface HFFIlterPriceCenterView()<HFFilterMoveViewDelegate>

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) HFFilterMoveView *moveView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *leftTopLabel;
@property (strong, nonatomic) UILabel *rightTopLabel;


@property (assign, nonatomic) CGFloat moveVHeight;

@property (assign, nonatomic) CGFloat lineVHeight;

@property (assign, nonatomic, readwrite) NSUInteger currentMinValue;

@property (assign, nonatomic, readwrite) NSUInteger currentMaxValue;
@end

@implementation HFFIlterPriceCenterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame sliderType:(HFFIlterPriceCenterViewType )type {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        self.sliderType = type;
    }
    return self;
}



-(void)initView {
    self.moveVHeight = 20;
    self.lineVHeight = 3;
    self.userInteractionEnabled = YES;
    self.minValue = 0;
    self.maxValue = 1000;
    self.currentMinValue = 0;
    self.currentMaxValue = 1000;
    [self initMoveView];
    //顶部左边脚标
    self.leftTopLabel = [self  creatLabelWithFrame:CGRectMake(self.lineView.left - iconwidth/2 , 0, iconwidth, iconheight)];
//    self.leftTopLabel.hidden = YES;
    self.leftTopLabel.text = [NSString stringWithFormat:@"¥%lu", (unsigned long)self.minValue];
    [self addSubview:self.leftTopLabel];
    //顶部右边脚标
    self.rightTopLabel = [self  creatLabelWithFrame:CGRectMake(self.lineView.right - iconwidth/2 , 0, iconwidth, iconheight)];
//    self.rightTopLabel.hidden = YES;
    self.rightTopLabel.text = [NSString stringWithFormat:@"¥%lu", (unsigned long)self.maxValue];
    [self addSubview:self.rightTopLabel];
    
    
}

-(UILabel *)creatLabelWithFrame:(CGRect )frame {
    UILabel *label =  [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.font      = [UIFont systemFontOfSize:12];
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithHexString:@"333333"];
    return  label;
}





-(void)initMoveView {
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, kScreenWidth - 60, self.lineVHeight)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.layer.cornerRadius = self.bgView.height/2                                                            ;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
    [self addSubview:self.bgView];
    //改变颜色的线
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, kScreenWidth - 60, self.lineVHeight)];
    self.bgView.backgroundColor = [UIColor blueColor];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, kScreenWidth - 60, self.lineVHeight)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"FF6600"];
    self.lineView.layer.cornerRadius = self.lineView.height/2                                                            ;
    self.lineView.layer.masksToBounds = YES;
    [self addSubview:self.lineView];
    
    //手指移动的视图
    self.moveView = [[HFFilterMoveView alloc]initWithFrame:CGRectMake(self.lineView.left-self.moveVHeight/2 , self.lineView.bottom, self.lineView.width+self.moveVHeight, self.moveVHeight)];
    self.moveView.delegate = self;
    [self addSubview:self.moveView];
}

-(void)setSliderType:(HFFIlterPriceCenterViewType)sliderType {
    if (sliderType == HFFIlterPriceCenterViewTypeCenter) {
        self.moveView.centerY = self.lineView.centerY;
        self.moveView.isRound = YES;
    }else if (sliderType == HFFIlterPriceCenterViewTypeBottom){
        self.moveView.top = self.lineView.bottom+10;
        self.moveView.isRound = NO;
        self.moveView.thumbColor = [UIColor blueColor];
    }
}

-(void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    self.lineView.backgroundColor = thumbColor;
}

-(void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bgView.backgroundColor = bgColor;
}


#pragma mark --- 代理方法
-(void)slidMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat)rightPosition {
//    NSLog(@"%f",leftPosition);
    self.lineView.x = 30+leftPosition-10;
    self.lineView.width = rightPosition - leftPosition;
    NSLog(@"%f ---%f --- %f",leftPosition,rightPosition,self.lineView.width);
    self.leftTopLabel.centerX  = leftPosition + 30 -10;
    self.rightTopLabel.centerX = rightPosition + 30 - 10;
    
    NSUInteger width = self.maxValue - self.minValue;
    NSUInteger left  = self.minValue + (self.lineView.x - self.bgView.x)/self.bgView.width * width;
    NSUInteger right  = self.minValue + (self.lineView.right - self.bgView.x)/self.bgView.width * width;
    self.currentMinValue = left;
    self.currentMaxValue = right;
//    NSLog(@"%ld",left/50);
    NSArray *title = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300",@"350",@"400",@"450",@"500",@"550",@"600",@"650",@"700",@"750",@"800",@"850",@"900",@"950",@"1000",@"不限"];
    self.leftTopLabel.text  = [NSString stringWithFormat:@"¥%@", title[left/50]];
    self.rightTopLabel.text = [NSString stringWithFormat:@"¥%@",title[right/50]];
    
    
    if (self.lineView.width == 0) {
        self.lineView.width = 1;
    }
}
- (void)setMaxValue:(NSInteger)maxValue withMinValue:(NSInteger)minValue {
    
//    [UIView animateWithDuration:0.25 animations:^{
//        NSUInteger width = self.maxValue - self.minValue;
//        CGFloat i =    minValue/(width*1.0)*self.bgView.width+self.bgView.x -self.minValue-30+10;
//        CGFloat i2 =    maxValue/(width*1.0)*self.bgView.width+self.bgView.x -self.minValue-20;
//        self.lineView.x = 30+i-10;
//        self.lineView.width = i2 - i;
//
//        self.leftTopLabel.centerX  =  i + 30 -10;
//        self.rightTopLabel.centerX = i2 + 30 - 10;
//        [self.moveView setLeftPosition:i withRightPostion:i2];
//        [self slidMovedLeft:i andRightPosition:i2];
//    }];
    
}
-(void)slidDidEndMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat)rightPosition {
    
    if ([self.delegate respondsToSelector:@selector(sliderViewDidSliderLeft:right:)]) {
        [self.delegate sliderViewDidSliderLeft:[self.leftTopLabel.text integerValue] right:[self.rightTopLabel.text integerValue]];
    }
}


- (void)slidMovedView:(id)moveView andRightState:(HFFilterMoveViewState)state {
    if (state == HFFilterMoveViewStateBegin) {
        self.leftTopLabel.hidden = NO;
        self.rightTopLabel.hidden = NO;
    }
    if (state == HFFilterMoveViewStateIng) {
        self.leftTopLabel.hidden = NO;
        self.rightTopLabel.hidden = NO;
    }
    if (state == HFFilterMoveViewStateEnd) {
        self.leftTopLabel.hidden = YES;
        self.rightTopLabel.hidden = YES;
    }
}
@end
