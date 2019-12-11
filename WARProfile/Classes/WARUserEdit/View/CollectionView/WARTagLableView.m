//
//  WARTagLableView.m
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import "WARTagLableView.h"

@implementation WARTagLableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createTitleLabel];
    }
    
    return self;
}

- (void)createTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = COLOR_WORD_GRAY_3;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).with.offset(15);
        make.width.equalTo(self.mas_width).dividedBy(2);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.height.mas_equalTo(40);
    }];
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = COLOR_WORD_Theme;
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_rightLabel];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).dividedBy(2);
            make.trailing.equalTo(self.mas_trailing).with.offset(-15);
            make.top.equalTo(self.mas_top).with.offset(5);
            make.height.mas_equalTo(40);
        }];
    }
    
    return _rightLabel;
}

@end
