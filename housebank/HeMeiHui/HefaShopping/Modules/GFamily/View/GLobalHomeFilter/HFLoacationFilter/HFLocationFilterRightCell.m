//
//  HFLocationFilterRightCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLocationFilterRightCell.h"

@implementation HFLocationFilterRightCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titelb];
        [self.contentView addSubview:self.selectGouImageView];
        [self.contentView addSubview:self.viewline];
    }
    return self;
}
- (void)doMessageSomething {
    self.titelb.frame = CGRectMake(15, 0, ScreenH-15-15-15-12, 45);
    self.selectGouImageView.frame = CGRectMake(self.contentView.width-12-15, (40-15)*0.5, 15, 15);
    self.viewline.frame = CGRectMake(0, 45-0.5, self.contentView.width, 0.5);
    
    self.titelb.text = self.model.title;

    self.titelb.textColor =self.model.isSelected ? [UIColor colorWithHexString:@"FF6600"]:[UIColor colorWithHexString:@"333333"];
    self.selectGouImageView.hidden = !(self.model.isSelected);
    
}
- (UILabel *)titelb {
    if (!_titelb) {
        _titelb = [[UILabel alloc] init];
        _titelb.font = [UIFont systemFontOfSize:14];
    }
    return _titelb;
}
- (UIImageView *)selectGouImageView {
    if (!_selectGouImageView) {
        _selectGouImageView = [[UIImageView alloc] init];
        _selectGouImageView.image = [UIImage imageNamed:@"selected_gou"];
        _selectGouImageView.hidden = YES;
    }
    return _selectGouImageView;
}
- (UIView *)viewline {
    if (!_viewline) {
        _viewline = [[UIView alloc]init];
        _viewline.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _viewline;
}

@end
