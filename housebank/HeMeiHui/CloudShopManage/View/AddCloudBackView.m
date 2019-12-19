//
//  AddCloudBackView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "AddCloudBackView.h"

@implementation AddCloudBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        UIView *backView = [UIView new];
        backView.alpha = 0.5;
        backView.backgroundColor = [UIColor blackColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(kHeight - 200));
        }];
        
        self.addShopView = [[AddCloudShopView alloc]init];
        [self addSubview:self.addShopView];
        [self.addShopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@200);
        }];
        
        @weakify(self);
        [[self.addShopView.popBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.missBlock) {
                self.missBlock();
            }
        }];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.missBlock) {
        self.missBlock();
    }
}

- (void)popViewAnimation{
    CGFloat halfScreenWidth = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat halfScreenHeight = [[UIScreen mainScreen] bounds].size.height * 0.5;  // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    self.center = screenCenter;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,                                            CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.transform =  CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  self.transform = CGAffineTransformIdentity;
                                              }];
                         }];
    
}

- (void)closeAnimation {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
@end
