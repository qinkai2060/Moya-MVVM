//
//  CustomOrderTypeCollectionViewCell.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "CustomOrderTypeCollectionViewCell.h"
@implementation CustomOrderTypeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selecteLable = [[UILabel alloc] init];
        self.selecteLable.textAlignment = NSTextAlignmentCenter;
        self.selecteLable.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        self.selecteLable.layer.borderWidth = 0.8;
        self.selecteLable.textColor = HEXCOLOR(0x333333);
        self.selecteLable.font = [UIFont systemFontOfSize:14];
        [self.selecteLable.layer setCornerRadius:15];
        [self.selecteLable setClipsToBounds:YES];
        [self addSubview:self.selecteLable];
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [self.selecteLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
}
@end
