//
//  HFPCCSelectoryCell.m
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPCCSelectoryCell.h"

@implementation HFPCCSelectoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.signImagV];
    }
    return self;
}
- (void)dosomthing {
    self.titleLb.text = self.model.name;
    if (self.model.selected) {
        self.titleLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        self.signImagV.hidden = NO;
    }else{
        self.titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        self.signImagV.hidden = YES;
    }
    CGSize size = [self.titleLb sizeThatFits:CGSizeMake(ScreenW-60, 30)];
    self.titleLb.frame = CGRectMake(15, 10, size.width, 30);
    self.signImagV.frame = CGRectMake(self.titleLb.right+5, 10, 15, 15);
    self.signImagV.centerY = self.titleLb.centerY;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:13];
    }
    return _titleLb;
}
- (UIImageView *)signImagV {
    if (!_signImagV) {
        _signImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_sign"]];
    }
    return _signImagV;
}
@end
