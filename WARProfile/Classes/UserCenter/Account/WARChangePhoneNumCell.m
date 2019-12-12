//
//  WARChangePhoneNumCell.m
//  WARProfile
//
//  Created by Hao on 2018/6/28.
//

#import "WARChangePhoneNumCell.h"
#import "WARMacros.h"
#import "Masonry.h"

@implementation WARChangePhoneNumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cellTitleLabel = [[UILabel alloc] init];
        self.cellTitleLabel.font = [UIFont systemFontOfSize:16];
        self.cellTitleLabel.textColor = TextColor;
        [self.contentView addSubview:self.cellTitleLabel];
        
        self.textField = [[UITextField alloc] init];
        self.textField.textColor = TextColor;
        self.textField.font = kFont(16);
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:self.textField];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton setTitleColor:ThemeColor forState:UIControlStateNormal];
        [self.rightButton setBackgroundColor:UIColorWhite];
        [self.rightButton.titleLabel setFont:kFont(16)];
        [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.rightButton];
        
        [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(75);
            make.right.mas_equalTo(-75);
            make.centerY.equalTo(self.contentView);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.contentView);
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

- (void)rightButtonClick {
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

@end
