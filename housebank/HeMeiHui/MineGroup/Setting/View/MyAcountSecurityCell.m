//
//  MyAcountSecurityCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyAcountSecurityCell.h"

@implementation MyAcountSecurityCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
}
- (void)creatcellView
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.cornerView];
    [self.cornerView addSubview:self.titleL];
    [self.cornerView addSubview:self.imgNext];
    self.titleL.frame = CGRectMake(15, 13,100, 20);
    self.imgNext.frame = CGRectMake(ScreenW-15-20, 15, 15, 15);
}

- (UIView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
        _cornerView. backgroundColor = [UIColor whiteColor];
    }
    return _cornerView;
}
- (UIImageView *)imgNext{
    if (!_imgNext) {
        _imgNext = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right>"]];
    }
    return _imgNext;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"主标题";
        _titleL.font = PFR16Font;
        _titleL.textColor = HEXCOLOR(0x333333);
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
@end
