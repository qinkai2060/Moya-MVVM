//
//  WARSettingFooterView.m
//  Pods
//
//  Created by huange on 2017/8/4.
//
//

#import "WARUserSettingFooterView.h"
#import "UIImage+Color.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "ReactiveObjC.h"


@interface WARUserSettingFooterView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation WARUserSettingFooterView

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString*)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:title];
    }
    
    return self;
}

- (void)initUI:(NSString *)title {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.cornerRadius = 22.0;
    self.button.clipsToBounds = YES;
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setBackgroundImage:[UIImage imageWithColor:RGB(0,216,183)] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.titleLabel.font = kFont(15);
    [self addSubview:self.button];
    
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).with.offset(15);
        make.trailing.equalTo(self.mas_trailing).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    
    @weakify(self);
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonAction)]) {
            [self.delegate clickButtonAction];
        }
        
        return [RACSignal empty];
    }];
}

- (void)setButtonEnable:(BOOL)buttonEnable {
    _buttonEnable = buttonEnable;
    
    self.button.enabled = buttonEnable;
}

@end
