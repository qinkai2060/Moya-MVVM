//
//  PersonInformationFirstUnitView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationFirstUnitView.h"

@interface PersonInformationFirstUnitView()

@property (nonatomic,weak)UILabel *titleLabel;

@property (nonatomic,weak)UILabel *arrowLabel;

@end

@implementation PersonInformationFirstUnitView


- (void)setSubview {
    
    UIImageView *iconImageV = [UIImageView new];
    [self addSubview:iconImageV];
    self.iconImageV = iconImageV;
    iconImageV.layer.masksToBounds = YES;
    iconImageV.layer.cornerRadius = 25;
    
    UILabel *titleLabel = [UILabel wd_labelWithText:@"头像" font:WScale(14) textColorStr:@"#333333"];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *arrowLabel = [UILabel wd_labelWithText:@">" font:WScale(15) textColorStr:@"#D8D8D8"];
    [self addSubview:arrowLabel];
    self.arrowLabel = arrowLabel;
    self.arrowLabel.textAlignment = NSTextAlignmentRight;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImageV);
        make.leading.mas_equalTo(self).offset(15);
    }];
    
    [self.arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(WScale(-15));
        make.centerY.mas_equalTo(self.iconImageV);
        make.width.mas_equalTo(WScale(10));
    }];
    
    [self.iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.arrowLabel.mas_leading).mas_offset(WScale(-5));
        make.top.mas_equalTo(self.mas_top).mas_offset(WScale(15));
        make.width.height.mas_equalTo(WScale(50));
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(WScale(-15));
    }];
}

- (void)setContent:(NSString *)content {
    [super setContent:content];
    self.titleLabel.text = content;
}

- (void)setUrlString:(NSString *)urlString {
    [super setUrlString:urlString];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:imageURL(urlString)] placeholderImage:[UIImage imageNamed:@"idCardDefault"]];
}


@end
