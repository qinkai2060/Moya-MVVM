//
//  WARNavgationCutsomBar.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import "WARNavgationCutsomBar.h"
#import "WARMacros.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARConfigurationMacros.h"
@implementation WARNavgationCutsomBar
- (instancetype)initWithTile:(NSString*)title rightTitle:(NSString*)rightTitle alpha:(CGFloat)alpha backgroundColor:(UIColor*)color rightHandler:(void(^)())rightHander leftHandler:(void(^)())leftHandler{
    self = [self init];
    [self.rightbutton setTitle:rightTitle forState:UIControlStateNormal];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    self.backgroundColor = color;
    self.leftHandler = leftHandler;
    self.rightHandler = rightHander;
    if (rightTitle.length == 0) {
        self.rightbutton.hidden = YES;
    }
    
    return self;
}
- (instancetype)init{
    if(self = [super init]){
        [self addSubview:self.backView];
        [self addSubview:self.button];
        [self addSubview:self.rightbutton];
        [self addSubview:self.titleButton];
        [self addSubview:self.lineButton];
        [self addSubview:self.progressBtn];
        [self addSubview:self.failiConV];
         [self addSubview:self.countLb];
        [self setLayout];
    }
    return self;
}
- (void)setLayout{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.backView.backgroundColor = NavBarBarTintColor;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@44);
        make.height.equalTo(@30);
    }];
    [self.rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@65);
        make.height.equalTo(@30);
    }];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-14);
        make.width.equalTo(@200);
        make.height.equalTo(@15);
        
    }];
    [self.lineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.bottom.equalTo(self);
    }];
    [self.progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.right.equalTo(self.rightbutton.mas_left).offset(-8);
        make.bottom.equalTo(self).offset(-8);
    }];
    [self.failiConV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.left.equalTo(self.progressBtn.mas_right).offset(-15);
        make.bottom.equalTo(self.progressBtn.mas_bottom).offset(-15);
    }];
    self.failiConV.hidden = YES;
    self.countLb.hidden = YES;
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.left.equalTo(self.progressBtn.mas_right).offset(-15);
        make.bottom.equalTo(self.progressBtn.mas_bottom).offset(-15);
    }];
}
- (void)lefttHandlerClick:(UIButton*)btn{
    if (self.leftHandler) {
        self.leftHandler();
    }
}
- (void)rightHandlerClick:(UIButton*)btn{
    if (self.rightHandler) {
        self.rightHandler();
    }
}
-(void)setDl_alpha:(CGFloat)dl_alpha
{
    _dl_alpha = dl_alpha;
    self.backView.alpha = dl_alpha;

}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor =[UIColor whiteColor];
    }
    return _backView;
}
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setImage:[UIImage war_imageName:@"personal_photo_return" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(lefttHandlerClick:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _button;
}
- (UIButton *)rightbutton{
    if (!_rightbutton) {
        _rightbutton = [[UIButton alloc] init];
//        [_rightbutton setImage:[UIImage war_imageName:@"" curClass:self curBundle:@""] forState:UIControlStateNormal];
        [_rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightbutton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightbutton addTarget:self action:@selector(rightHandlerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightbutton;
}
- (UIButton *)progressBtn {
    if (!_progressBtn) {
        _progressBtn = [[UIButton alloc] init];
      //  [_progressBtn setImage:[UIImage war_imageName:@"shoucang_back" curClass:[self class] curBundle:@"WARChat.bundle"] forState:UIControlStateNormal];
          _progressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _progressBtn;
}
- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] init];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
    return _titleButton;
}
- (UIButton *)lineButton{
    if (!_lineButton) {
        _lineButton = [[UIButton alloc] init];
        [_lineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lineButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _lineButton.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
    }
    return _lineButton;
}
- (UIImageView *)failiConV {
    if (!_failiConV) {
        _failiConV = [[UIImageView alloc] init];
        _failiConV.image = [UIImage war_imageName:@"jingshi" curClass:[self class] curBundle:@"WARProfile.bundle"];
    }
    return _failiConV;
}
- (UILabel *)countLb {
    if (!_countLb) {
        _countLb =[[UILabel alloc] init];
        _countLb.textColor = [UIColor whiteColor];
        _countLb.textAlignment = NSTextAlignmentCenter;
        _countLb.font = kFont(8);
        _countLb.backgroundColor = [UIColor colorWithHexString:@"F2604D"];
        _countLb.text = @"7";
        _countLb.layer.cornerRadius = 8;
        _countLb.layer.masksToBounds = YES;
    }
    return _countLb;
}
@end
