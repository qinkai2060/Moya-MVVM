//
//  HeaderViewTableViewCell.m
//  Pzb
//
//  Created by 张磊 on 15/11/24.
//  Copyright © 2015年 张磊. All rights reserved.
//

#import "HeaderViewTableViewCell.h"

@implementation HeaderViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label];

        self.line2 = [[UIView alloc] init];
        self.line2.backgroundColor = HEXCOLOR(0XFFFFFF);
        [self addSubview:self.line2];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.7);
    }];

}
@end
