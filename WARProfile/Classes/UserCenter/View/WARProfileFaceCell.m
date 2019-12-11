//
//  WARProfileFaceCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/16.
//

#import "WARProfileFaceCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
@implementation WARProfileFaceCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.imageView addSubview:self.defaultView];
        [self.defaultView addSubview:self.defaultLabel];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.imageView);
            make.height.mas_equalTo(18);
        }];
        [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.defaultView);
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }
}

- (void)setMaskModel:(WARProfileMasksModel *)maskModel{
    _maskModel = maskModel;
    [self.imageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(79, 79), maskModel.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.defaultView.backgroundColor = SecondaryColor;
    self.defaultLabel.text = WARLocalizedString(@"公开");
    self.defaultView.hidden = !maskModel.defaults;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 3;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [[UIView alloc] init];
        _defaultView.hidden = YES;
    }
    return _defaultView;
}

- (UILabel *)defaultLabel{
    if(!_defaultLabel){
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.font = [UIFont systemFontOfSize:11];
        _defaultLabel.textColor = [UIColor whiteColor];
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultLabel;
}

@end
