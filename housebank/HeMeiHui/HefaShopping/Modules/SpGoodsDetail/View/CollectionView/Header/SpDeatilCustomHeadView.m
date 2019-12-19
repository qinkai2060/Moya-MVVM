//
//  SpGoodBaseViewController.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import "SpDeatilCustomHeadView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface SpDeatilCustomHeadView ()

/* 猜你喜欢 */
@property (strong ,nonatomic) UILabel *guessMarkLabel;


@end

@implementation SpDeatilCustomHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _guessMarkLabel = [[UILabel alloc] init];
    _guessMarkLabel.text = @"猜你喜欢";
    _guessMarkLabel.font = PFR15Font;
    [self addSubview:_guessMarkLabel];
    
    _guessMarkLabel.frame = CGRectMake(DCMargin, 0, 200, self.dc_height);
}

#pragma mark - Setter Getter Methods


@end
