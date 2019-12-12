//
//  WARUserSettingSwitchCell.m
//  WARProfile
//
//  Created by Hao on 2018/6/20.
//

#import "WARUserSettingSwitchCell.h"
#import "WARMacros.h"
#import "Masonry.h"

@implementation WARUserSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cellTitleLabel = [[UILabel alloc] init];
        self.cellTitleLabel.font = [UIFont systemFontOfSize:16];
        self.cellTitleLabel.textColor = TextColor;
        [self.contentView addSubview:self.cellTitleLabel];
        
        self.cellDetailLabel = [[UILabel alloc] init];
        self.cellDetailLabel.font = [UIFont systemFontOfSize:14];
        self.cellDetailLabel.textColor = ThreeLevelTextColor;
        [self.contentView addSubview:self.cellDetailLabel];
        
        self.item = [[UISwitch alloc] init];
        self.item.onTintColor = ThemeColor;
        [self.item addTarget:self action:@selector(switchValueChange) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.item];
        
        [self.cellTitleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10.5);
        }];
        
        [self.cellDetailLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(34);
        }];
        
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self);
        }];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = SeparatorColor;
        [self.contentView addSubview:lineV];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)switchValueChange {
    if (self.switchBlock) {
        self.switchBlock(self.item.on);
    }
}
@end
