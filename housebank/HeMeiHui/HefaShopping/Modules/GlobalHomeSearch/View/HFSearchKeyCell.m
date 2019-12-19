//
//  HFSearchKeyCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSearchKeyCell.h"

@implementation HFSearchKeyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.label];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 50-0.5, ScreenW-30, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
        [self.contentView addSubview:lineView];
    }
    return self;
}
- (void)doMessgaeSomthing {
    self.label.frame = CGRectMake(15, 0, ScreenW-30, 50);
    self.label.text = self.model.historyStr;
    
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor colorWithHexString:@"666666"];
        _label.font = [UIFont systemFontOfSize:14];
        
    }
    return _label;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
