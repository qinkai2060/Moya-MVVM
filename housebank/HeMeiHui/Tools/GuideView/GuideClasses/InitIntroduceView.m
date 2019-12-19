//
//  InitIntroduceView.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "InitIntroduceView.h"

@interface InitIntroduceView ()

@property (nonatomic, strong) UIImageView *introImg1;
@property (nonatomic, strong) UIImageView *introImg2;

@end

@implementation InitIntroduceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initIntroduceView];
    }
    return self;
}

- (void)initIntroduceView{
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"IsShowIntroV"] isEqualToString:@"yes"]) {
        _introImg1 = [[UIImageView alloc] initWithFrame:self.bounds];
        _introImg1.userInteractionEnabled = YES;
        if (IS_iPhoneX) {
            _introImg1.image = [UIImage imageNamed:@"iPhone_XS_Max_step1"];
        } else {
            _introImg1.image = [UIImage imageNamed:@"HMH_introImage_step1"];
        }

        
        [self addSubview:_introImg1];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NextIntroImg)];
        tap1.numberOfTapsRequired = 1;
        [_introImg1 addGestureRecognizer:tap1];
        
        _introImg2 = [[UIImageView alloc] initWithFrame:self.bounds];
        _introImg2.hidden = YES;
        _introImg2.userInteractionEnabled = YES;
        if (IS_iPhoneX) {
            _introImg2.image = [UIImage imageNamed:@"iPhone_XS_Max_step2"];
        } else {
            _introImg2.image = [UIImage imageNamed:@"HMH_introImage_step2"];
        }

        [self addSubview:_introImg2];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeIntroImg)];
        tap2.numberOfTapsRequired = 1;
        [_introImg2 addGestureRecognizer:tap2];
    }
}

- (void)NextIntroImg{
    [_introImg1 removeFromSuperview];
    _introImg2.hidden = NO;
}

- (void)removeIntroImg{
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"IsShowIntroV"];
    [_introImg2 removeFromSuperview];
    [self.Delegate reSetTabBarHidden];
    [self removeFromSuperview];
}

@end
