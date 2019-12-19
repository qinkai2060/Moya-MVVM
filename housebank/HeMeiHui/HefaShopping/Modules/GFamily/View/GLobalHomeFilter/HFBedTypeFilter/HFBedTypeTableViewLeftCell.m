//
//  HFBedTypeTableViewLeftCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFBedTypeTableViewLeftCell.h"

@implementation HFBedTypeTableViewLeftCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titelb];

    }
    return self;
}
- (void)doMessageSomething {
    self.titelb.frame = CGRectMake(00, 0,125, 45);
    self.titelb.backgroundColor =self.bedModel.isSelected ? [UIColor colorWithHexString:@"FFFFFF"]:[UIColor colorWithHexString:@"f4f4f4"];
    self.titelb.text = self.bedModel.title;
  
}
- (UILabel *)titelb {
    if (!_titelb) {
        _titelb = [[UILabel alloc] init];
        _titelb.font = [UIFont systemFontOfSize:14];
        _titelb.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titelb;
}

@end
