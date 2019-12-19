//
//  HMLiveBaseCell.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMLiveBaseCell.h"

@implementation HMLiveBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSubviews];
        
    }
    return self;
}

- (void)setSubviews {
    
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
