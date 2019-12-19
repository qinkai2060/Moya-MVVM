//
//  SpNoHasCommentCollectionViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpNoHasCommentCollectionViewCell.h"

@implementation SpNoHasCommentCollectionViewCell
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

  
    
    self.label = [[UILabel alloc] init];
    self.label.font = PFR14Font;
    self.label.textColor=HEXCOLOR(0x999999);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"暂无评价";
    [self addSubview:self.label ];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.line];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.height.mas_offset(0.8);
    }];
}

@end
