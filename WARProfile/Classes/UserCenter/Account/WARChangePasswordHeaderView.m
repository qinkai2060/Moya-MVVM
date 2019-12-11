//
//  WARChangePasswordHeaderView.m
//  Pods
//
//  Created by huange on 2017/8/7.
//
//

#import "WARChangePasswordHeaderView.h"

#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "WARMacros.h"

@implementation WARChangePasswordHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}


- (void)initUI {
    [self createTitleLabel];
}


- (void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor =  HEXCOLOR(0x666666);
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.height.mas_equalTo(40);
        make.leading.equalTo(self).with.offset(15);
//        make.width.mas_equalTo(self.mas_width).offset(-30);
        make.width.mas_equalTo(kScreenWidth - 15 * 2);
    }];
}

@end
