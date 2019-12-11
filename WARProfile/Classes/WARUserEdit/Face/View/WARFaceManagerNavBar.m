//
//  WARFaceManagerNavBar.m
//  WARContacts
//
//  Created by Hao on 2018/7/20.
//

#import "WARFaceManagerNavBar.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"

@implementation WARFaceManagerNavBar

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.backImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.backArrowButon];
    [self addSubview:self.saveButton];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(WAR_IS_IPHONE_X ? 33 + 24 : 33);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-10);
    }];
    [self.backArrowButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(9);
        make.width.height.mas_equalTo(25);
    }];
}

- (void)backArrowButonClick {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)saveButtonClick {
    if (self.saveBlock) {
        self.saveBlock();
    }
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorWhite;
        _titleLabel.font = kFont(17);
        _titleLabel.text = WARLocalizedString(@"编辑不同形象");
    }
    return _titleLabel;
}

- (UIButton *)backArrowButon{
    if(!_backArrowButon){
        _backArrowButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backArrowButon setImage:[UIImage war_imageName:@"back_s" curClass:self.class curBundle:@"WARContacts.bundle"] forState:UIControlStateNormal];
        [_backArrowButon addTarget:self action:@selector(backArrowButonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backArrowButon;
}

- (UIButton *)saveButton{
    if(!_saveButton){
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:WARLocalizedString(@"保存") forState:UIControlStateNormal];
        [_saveButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont:kFont(15)];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton sizeToFit];
    }
    return _saveButton;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.backgroundColor = NavBarBarTintColor;
    }
    return _backImageView;
}

@end
