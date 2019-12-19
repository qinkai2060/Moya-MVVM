//
//  HFSilderView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSilderView.h"
@interface HFSilderView ()
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)NSString *low;
@property (nonatomic,copy)NSString *high;

@property(nonatomic,strong)UIView *trakView;
@property(nonatomic,strong)UIView *progressView;
@property(nonatomic,strong)UILabel *leftTopLable;
@property(nonatomic,strong)UILabel *rightTopLable;
@property(nonatomic,strong)UIImageView *leftThumb;
@property(nonatomic,strong)UIImageView *rightThumb;
@end
@implementation HFSilderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.trakView];
        [self addSubview:self.progressView];
        [self addSubview:self.leftThumb];
        [self addSubview:self.rightThumb];
        [self addSubview:self.leftTopLable];
        [self addSubview:self.rightTopLable];
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self.leftThumb addGestureRecognizer:leftPan];
        UIPanGestureRecognizer *rightpan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self.rightThumb addGestureRecognizer:rightpan];
    }
    return self;
}
- (void)panAction:(UIPanGestureRecognizer*)pan {
    CGPoint point = [pan translationInView:self];
    CGRect rect  = self.progressView.frame;
    CGFloat realScale = self.trakView.width/(1050*1.0);

    if ([pan.view isKindOfClass:[UIImageView class]]) {
       UIImageView *pv = (UIImageView*)pan.view;
        CGPoint newCenter = CGPointMake(pv.center.x+point.x,  pv.center.y);
        if ([pv isEqual:self.leftThumb]) {
            newCenter.x = MAX(newCenter.x, 20/2);
            CGFloat max = self.rightThumb.left-realScale+20/2-20;
            newCenter.x = MIN(newCenter.x, max);
            self.leftTopLable.centerX = newCenter.x;
        }else {
            newCenter.x =  MIN(newCenter.x, self.frame.size.width-20/2);
            CGFloat minX = self.leftThumb.right-realScale+20/2;
            newCenter.x = MAX(newCenter.x, minX);
            self.rightTopLable.centerX = newCenter.x;
            
        }
        pv.center = newCenter;
        
        self.progressView.frame = CGRectMake(self.leftThumb.centerX, rect.origin.y, self.rightThumb.center.x-self.leftThumb.centerX, 3);
        [pan setTranslation:CGPointZero inView:self];
        if (pan.state == UIGestureRecognizerStateBegan) {
            if ([self.delegate respondsToSelector:@selector(silderView:low:hight:state:)]) {
                [self.delegate silderView:self low:self.low hight:self.high state:HFSilderViewStateBegan];
            }
            self.rightTopLable.hidden = NO;
            self.leftTopLable.hidden = NO;
        }else if (pan.state == UIGestureRecognizerStateChanged) {
            NSUInteger width = 1050 - 0;
            NSUInteger left  = 0+ (self.progressView.left - self.trakView.x)/self.trakView.width * width;
            NSUInteger right  = 0 + (self.progressView.right - self.trakView.x)/self.trakView.width * width;
            NSArray *title = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300",@"350",@"400",@"450",@"500",@"550",@"600",@"650",@"700",@"750",@"800",@"850",@"900",@"950",@"1000",@"不限"];
            
            self.leftTopLable.text  = [NSString stringWithFormat:@"¥%@", title[left/50]];
            self.rightTopLable.text = [NSString stringWithFormat:@"¥%@",title[right/50]];
            self.low = title[left/50];
            self.high = title[right/50];
            if ([self.delegate respondsToSelector:@selector(silderView:low:hight:state:)]) {
                [self.delegate silderView:self low:title[left/50] hight:title[right/50] state:HFSilderViewStateChange];
            }
     
        }else {
            self.rightTopLable.hidden = YES;
            self.leftTopLable.hidden = YES;
            if (CGRectIntersectsRect(self.leftThumb.frame, self.rightThumb.frame) ) {
                [self bringSubviewToFront:pv];
            }
            NSInteger rate = (NSInteger)(round((newCenter.x-20/2)/realScale));
            newCenter.x = rate*1.0*realScale+10-5;
            pv.center = newCenter;
            self.progressView.frame = CGRectMake(self.leftThumb.centerX, rect.origin.y, self.rightThumb.center.x-self.leftThumb.centerX, 3);
            if ([self.delegate respondsToSelector:@selector(silderView:low:hight:state:)]) {
                [self.delegate silderView:self low:self.low hight:self.high state:HFSilderViewStateEnd];
            }
            
        }
    }
    
    
}
- (void)setMaxValue:(NSInteger)maxValue withMinValue:(NSInteger)minValue {
    
        [UIView animateWithDuration:0.25 animations:^{
            NSUInteger width = 1050 - 0;
            CGFloat i =    minValue/(width*1.0)*self.trakView.width+self.trakView.x -0;
            CGFloat i2 =    maxValue/(width*1.0)*self.trakView.width+self.trakView.x -0;
            self.progressView.left = i;
            self.progressView.width = i2 - i;
            NSArray *title = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300",@"350",@"400",@"450",@"500",@"550",@"600",@"650",@"700",@"750",@"800",@"850",@"900",@"950",@"1000",@"不限"];
            self.leftTopLable.text  = [NSString stringWithFormat:@"¥%@", title[minValue/50]];
            self.rightTopLable.text = [NSString stringWithFormat:@"¥%@",title[maxValue/50]];
            self.leftTopLable.centerX  =  i+10 ;
            self.rightTopLable.centerX = i2 +10;
            self.leftThumb.centerX = i+10;
            self.rightThumb.centerX = i2+10;
        }];
    
}

- (UIView *)trakView {
    if (!_trakView) {
        _trakView = [[UIView alloc] initWithFrame:CGRectMake(20/2, 20/2+25, self.frame.size.width-20, 3)];
        _trakView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
        _trakView.layer.cornerRadius = 3 / 2;
    }
    return _trakView;
}
- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(20/2, 20/2+25, self.frame.size.width-20, 3)];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"FF6600"];
    }
    return _progressView;
}
- (UIImageView *)leftThumb {
    if (!_leftThumb) {
        _leftThumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 20, 20)];
        _leftThumb.image = [UIImage imageNamed:@"filter_signRound"];
        _leftThumb.userInteractionEnabled = YES;
    }
    return _leftThumb;
}
- (UIImageView *)rightThumb {
    if (!_rightThumb) {
        _rightThumb = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 25, 20, 20)];
        _rightThumb.image = [UIImage imageNamed:@"filter_signRound"];
         _rightThumb.userInteractionEnabled = YES;
    }
    return _rightThumb;
}
- (UILabel *)leftTopLable {
    if (!_leftTopLable) {
        _leftTopLable = [[UILabel alloc] initWithFrame:CGRectMake(self.leftThumb.centerX, 5, 40, 15)];
        _leftTopLable.backgroundColor = [UIColor colorWithHexString:@"333333"];
        _leftTopLable.textColor = [UIColor colorWithHexString:@"ffffff"];
        _leftTopLable.font = [UIFont systemFontOfSize:12];
        _leftTopLable.textAlignment = NSTextAlignmentCenter;
        _leftTopLable.layer.cornerRadius = 2;
        _leftTopLable.layer.masksToBounds = YES;
        _leftTopLable.text = @"0";
        _leftTopLable.centerX = self.leftThumb.centerX;
        _leftTopLable.hidden = YES;
    }
    return _leftTopLable;
}
- (UILabel *)rightTopLable {
    if (!_rightTopLable) {
        _rightTopLable = [[UILabel alloc] initWithFrame:CGRectMake(self.rightThumb.centerX, 5, 40, 15)];
        _rightTopLable.backgroundColor = [UIColor colorWithHexString:@"333333"];
        _rightTopLable.textColor = [UIColor colorWithHexString:@"ffffff"];
        _rightTopLable.font = [UIFont systemFontOfSize:12];
        _rightTopLable.textAlignment = NSTextAlignmentCenter;
        _rightTopLable.layer.cornerRadius = 2;
         _rightTopLable.layer.masksToBounds = YES;
        _rightTopLable.text = @"不限";
        _rightTopLable.centerX =self.rightThumb.centerX;
        _rightTopLable.hidden = YES;
        
    }
    return _rightTopLable;
}
@end
