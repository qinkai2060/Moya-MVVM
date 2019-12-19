//
//  PersonInformationThirdUnitView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationThirdUnitView.h"

@interface PersonInformationThirdUnitView()

@property (nonatomic,weak)UILabel *nameLabel;

@end

@implementation PersonInformationThirdUnitView


- (void)setSubview {
    UILabel *nameLabel = [UILabel wd_labelWithText:@"证件图片:" font:WScale(14) textColorStr:@"#333333"];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *iconImageV = [UIImageView new];
    [iconImageV setImage:ImageLive(@"idCardDefault")];
    self.iconImageV = iconImageV;
    [self addSubview:iconImageV];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(WScale(15));
        make.top.mas_equalTo(self.mas_top).mas_offset(WScale(15));
    }];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel);
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(WScale(-15));
        make.width.mas_equalTo(WScale(110));
        make.height.mas_equalTo(WScale(50));
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(WScale(-15));
    }];
    
}

- (void)setUrlString:(NSString *)urlString {
    [super setUrlString:urlString];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:imageURL(urlString)] placeholderImage:ImageLive(@"idCardDefault")];
}

@end
