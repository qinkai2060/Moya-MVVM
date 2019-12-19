//
//  PersonInformationSecoundUnitView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationSecoundUnitView.h"

@interface PersonInformationSecoundUnitView()

@property (nonatomic,weak)UILabel *nameLabel;

@property (nonatomic,weak)UILabel *contentLabel;

@property (nonatomic,weak)UILabel *arrowLabel;

@end

@implementation PersonInformationSecoundUnitView

- (void)setSubview {
    
    UILabel *nameLabel = [UILabel wd_labelWithText:@"姓名:" font:WScale(14) textColorStr:@"#333333"];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *contentLabel = [UILabel wd_labelWithText:@"美女帅哥" font:WScale(14) textColorStr:@"#333333"];
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *arrowLabel = [UILabel wd_labelWithText:@">" font:WScale(15) textColorStr:@"#D8D8D8"];
    [self addSubview:arrowLabel];
    self.arrowLabel = arrowLabel;
    self.arrowLabel.textAlignment = NSTextAlignmentRight;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(WScale(15));
        make.leading.mas_equalTo(self.mas_leading).mas_offset(WScale(15));
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(WScale(-15));
    }];
    
    [self.arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(WScale(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(WScale(15));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self.arrowLabel.mas_leading).mas_offset(WScale(-5));
    }];
    
}

- (void)setContent:(NSString *)content {
    [super setContent:content];
    self.contentLabel.text = content;
    
    switch (self.currentType) {
        case PersonInformationType_Head:
        {
            
            break;
        }
        case PersonInformationType_Name:
        {
            
            break;
        }
        case PersonInformationType_Sex:
        {
            
            break;
        }
        case PersonInformationType_ContactPhone:
        {
            self.contentLabel.text = [content numberSuitScanf:content];
            break;
        }
        case PersonInformationType_RefillPhone:
        {
            self.contentLabel.text = [content numberSuitScanf:content];
            break;
        }
        case PersonInformationType_Email:
        {
          
            break;
        }
        case PersonInformationType_Address:
        {
           
            break;
        }
        case PersonInformationType_IDNumber:
        {
           
            break;
        }
        case PersonInformationType_IDPicture:
        {
            
            break;
        }
        case PersonInformationType_BankNubmer:
        {
           self.contentLabel.text = [content groupedString:content];
            break;
        }
            
        default:
            break;
    }
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.nameLabel.text = title;
}




@end
