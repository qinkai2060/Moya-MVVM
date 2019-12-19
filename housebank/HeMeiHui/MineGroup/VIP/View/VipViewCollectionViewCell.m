//
//  VipViewCollectionViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipViewCollectionViewCell.h"

@implementation VipViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc] init];
//        self.imgView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.imgView];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.font = [UIFont systemFontOfSize:13];
//        self.titleLable.text = @"上海余文乐";
        self.titleLable.textColor = HEXCOLOR(0x666666);
        [self addSubview:self.titleLable];
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(self);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
}
@end
