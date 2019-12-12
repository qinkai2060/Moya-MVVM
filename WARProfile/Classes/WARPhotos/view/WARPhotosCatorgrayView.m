//
//  WARPhotosCatorgrayView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import "WARPhotosCatorgrayView.h"
#import "WARMacros.h"
#import "UIColor+WARCategory.h"
#import "WARConfigurationMacros.h"
#import "Masonry.h"
#define hzbeishu_iphone6 (kScreenWidth / 375)
@implementation WARPhotosCatorgrayView

- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake((kScreenWidth-(52)*3)*0.5, 22, (52)*3, 24);
    if (self = [super initWithFrame:frame]) {
//       / self.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:self.photoBtn];
        [self addSubview:self.albumBtn];
        [self addSubview:self.videoBtn];
        [self addSubview:self.firstView];
        [self addSubview:self.secondView];
         self.photoBtn.selected = YES;
        [self setLayout];
        self.selectBtn = self.photoBtn;
        self.selectBtn.layer.cornerRadius = (hzbeishu_iphone6*52)*0.2;
        self.selectBtn.layer.masksToBounds = YES;
        [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectBtn.backgroundColor = [UIColor colorWithHexString:@"ADB1BE"];
    
    }
    return self;
}

- (void)setLayout{
    CGFloat w = (hzbeishu_iphone6*52);
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.equalTo(@24);
        make.width.equalTo(@(w));
    }];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.photoBtn.mas_right);
        make.height.equalTo(@18);
        make.width.equalTo(@1);
    }];
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView.mas_right);
        make.top.equalTo(self);
        make.height.equalTo(@24);
        make.width.equalTo(@(w));
    }];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.albumBtn.mas_right);
        make.height.equalTo(@18);
        make.width.equalTo(@1);
    }];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondView.mas_right);
        make.top.equalTo(self);
        make.height.equalTo(@24);
        make.width.equalTo(@(w));
    }];
}
- (void)selectClick:(UIButton*)btn {
    if (btn.selected) {
        return;
    }
   btn.selected = YES;
    NDLog(@"%s",__func__);
    if (self.selectBtn) {
        
        self.selectBtn.selected = NO;
        self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"d9d9d9"] CGColor];
         [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"] forState:UIControlStateNormal];
        self.selectBtn.backgroundColor = [UIColor clearColor];
        self.selectBtn = nil;
        
    }
    if (btn.selected) {
        
        self.selectBtn = btn;
        self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"00d8b7"] CGColor];
        self.selectBtn.backgroundColor = [UIColor colorWithHexString:@"ADB1BE"];
         [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectBtn.layer.cornerRadius = (52)*0.2;
        self.selectBtn.layer.masksToBounds = YES;
    }
    if ([self.delegate respondsToSelector:@selector(photosCatorgrayView:didSelectIndex:)]) {
        [self.delegate photosCatorgrayView:self didSelectIndex:btn.tag - 10000];
    }
}

- (UIView *)firstView {
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        _firstView.backgroundColor = [UIColor clearColor];
    }
    return _firstView;
}
- (UIView *)secondView {
    if (!_secondView) {
        _secondView = [[UIView alloc] init];
        _secondView.backgroundColor = [UIColor clearColor];
    }
    return _secondView;
}
- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] init];
        [_photoBtn setTitle:WARLocalizedString(@"相册") forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"] forState:UIControlStateNormal];

        _photoBtn.titleLabel.font = kFont(14);
      
        [_photoBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        _photoBtn.tag = 10000;
        
    }
    return _photoBtn;
}
- (UIButton *)albumBtn {
    if (!_albumBtn) {
        _albumBtn = [[UIButton alloc] init];
        [_albumBtn setTitle:WARLocalizedString(@"照片") forState:UIControlStateNormal];
        [_albumBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"] forState:UIControlStateNormal];

        _albumBtn.titleLabel.font = kFont(14);
  
        [_albumBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        _albumBtn.tag = 10001;
    }
    return _albumBtn;
}
- (UIButton *)videoBtn {
    if (!_videoBtn) {
        _videoBtn = [[UIButton alloc] init];
        [_videoBtn setTitle:WARLocalizedString(@"视频") forState:UIControlStateNormal];
        [_videoBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"] forState:UIControlStateNormal];
         _videoBtn.titleLabel.font = kFont(14);
        [_videoBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        _videoBtn.tag = 10002;
    }
    return _videoBtn;
}
@end
