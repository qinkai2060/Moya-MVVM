//
//  VoiceTouchView.m
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import "VoiceTouchView.h"
#import "Masonry.h"
@interface VoiceTouchView ()
@property (nonatomic, assign) BOOL     isBegan;
@property (nonatomic, strong) NSTimer  *timer;
@end
@implementation VoiceTouchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.isBegan = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 19;
        self.areaY=-40;
        self.clickTime=0.5;
        [self addSubview:self.voiceBtn];
        [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
#pragma mark -- delegate
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(self.voiceBtn.selected) {
        return YES;
    }else {
        return [super pointInside:point withEvent:event];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.clickTime target:self selector:@selector(timeAction) userInfo:nil repeats:NO];
    self.timer = timer;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.voiceBtn.isSelected) {
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (point.y > self.areaY) {
            if (self.down) {
                self.down();
            }
//             NSLog(@"下滑");
        }else {
            if (self.upglide) {
                self.upglide();
            }
//             NSLog(@"上滑");
        }
        NSLog(@"%@",NSStringFromCGPoint([touch locationInView:self]));
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.voiceBtn.selected) {
        if (self.touchEnd) {
            self.touchEnd();
        }
    }
    self.voiceBtn.selected = NO;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timeAction{
    if (self.touchBegan) {
        self.touchBegan();
    }
    self.voiceBtn.selected = YES;
    [self.timer invalidate];
}

-(UIButton *)buttonWithImagename:(NSString *)imageName  forControlEvents:(UIControlEvents)controlEvents  title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark -- lazy
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _voiceBtn.userInteractionEnabled = NO;
        [_voiceBtn setTitle:@"按住说出你要找的商品" forState:UIControlStateNormal];
//        _voiceBtn.backgroundColor = ;
        [_voiceBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#4D88FF"]] forState:UIControlStateNormal];
        [_voiceBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#3764C1"]] forState:UIControlStateHighlighted];
        _voiceBtn.titleLabel.font = kFONT(14);
        [_voiceBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.cornerRadius = 19;
        _voiceBtn.layer.borderWidth = 1;
        _voiceBtn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        [_voiceBtn setImage:[UIImage imageNamed:@"Vip_voice"] forState:UIControlStateNormal];
        _voiceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    }
    return _voiceBtn;
}


//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
