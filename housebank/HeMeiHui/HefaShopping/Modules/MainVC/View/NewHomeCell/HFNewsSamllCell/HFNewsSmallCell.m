//
//  HFNewsSmallCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/2.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNewsSmallCell.h"

@implementation HFNewsSmallCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self hh_setsubviews];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setsubviews];
    }
    return self;
}
- (void)hh_setsubviews {
    [self.contentView addSubview:self.titleLb];
}
- (void)getData {
    self.titleLb.text = self.newsModel.title;
    self.titleLb.frame = CGRectMake(0, 0, self.contentView.width, 40);
}
- (void)getDatalive {
    self.titleLb.text = self.newsLiveModel.title;
    self.titleLb.frame = CGRectMake(0, 0, self.contentView.width, 40);
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor colorWithHexString:@"494949"];
        _titleLb.font = [UIFont systemFontOfSize:14];
    }
    return _titleLb;
}
@end
