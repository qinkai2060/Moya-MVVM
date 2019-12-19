//
//  MyEmplyDataTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyEmplyDataTableViewCell.h"
@interface MyEmplyDataTableViewCell ()
@property (nonatomic, strong) UIImageView * img;
@end

@implementation MyEmplyDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       [self createView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    
    self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_empty"]];
    [self.contentView addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(50);
        make.size.mas_equalTo(CGSizeMake(44, 50));
    }];
    
    self.alertLabel = [[UILabel alloc] init];
    [self.contentView  addSubview:self.alertLabel];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"    未搜到结果" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.alertLabel.attributedText = string;
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}

- (void)reloadString:(NSString *)string {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.alertLabel.attributedText = attributeString;
    if (self.imageString) {
        self.img.image = [UIImage imageNamed:objectOrEmptyStr(self.imageString)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
