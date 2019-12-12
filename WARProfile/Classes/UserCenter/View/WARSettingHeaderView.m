//
//  WARSettingHeaderView.m
//  Pods
//
//  Created by huange on 2017/8/9.
//
//

#import "WARSettingHeaderView.h"

#import "Masonry.h"
#import "WARMacros.h"

#define leftMargin 15

@implementation WARSettingHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = ThreeLevelTextColor;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(leftMargin);
        make.trailing.equalTo(self).with.offset(-leftMargin);
        make.bottom.equalTo(self).with.offset(-6.5);
        make.height.mas_equalTo(14);
    }];
}

@end


@implementation WARSettingsFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = ThreeLevelTextColor;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(leftMargin);
        make.trailing.equalTo(self).with.offset(-leftMargin);
        make.top.equalTo(self).with.offset(6.5);
//        make.height.mas_equalTo(20);
    }];
}

@end
