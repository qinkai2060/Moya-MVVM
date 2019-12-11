//
//  WARTagCollectionCell.m
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import "WARTagCollectionCell.h"

@implementation WARTagCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.layer.cornerRadius = self.frame.size.height/2;
        self.contentView.layer.borderColor = COLOR_WORD_GRAY_9.CGColor;
        self.contentView.layer.borderWidth = 0.5;
        
        [self createTitleLabel];
    }
    
    return self;
}

- (void)createTitleLabel {
    self.tagLabel = [UILabel new];
    self.tagLabel.textColor = COLOR_WORD_GRAY_9;
    self.tagLabel.font = [UIFont systemFontOfSize:12];
    self.tagLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView .mas_leading).with.offset(8);
        make.trailing.equalTo(self.contentView .mas_trailing).with.offset(-8);
        make.top.equalTo(self.contentView .mas_top).with.offset(0);
        make.height.equalTo(self.contentView);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (_isSelected) {
        self.tagLabel.textColor = COLOR_WORD_Theme;
        self.contentView.layer.borderColor = COLOR_WORD_Theme.CGColor;
    }else {
        self.tagLabel.textColor = COLOR_WORD_GRAY_9;
        self.contentView.layer.borderColor = COLOR_WORD_GRAY_9.CGColor;
    }
}


@end



@implementation WAREmptyCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createTitleLabel];
    }
    
    return self;
}

- (void)createTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = COLOR_WORD_GRAY_9;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView .mas_leading).with.offset(0);
        make.trailing.equalTo(self.contentView .mas_trailing).with.offset(0);
        make.top.equalTo(self.contentView .mas_top).with.offset(0);
        make.height.equalTo(self.contentView);
    }];
}

@end
