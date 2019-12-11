//
//  WARCommentsView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import "WARCommentsView.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
@implementation WARCommentsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.addBtn];
        [self addSubview:self.pushCommentsBtn];
        [self addSubview:self.likeBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.height.equalTo(@34);
            make.width.equalTo(@50);
        }];
        [self.pushCommentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.height.equalTo(@34);
            make.width.equalTo(@50);
        }];
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.pushCommentsBtn.mas_left);
                  make.top.equalTo(self);
            make.height.equalTo(@34);
            make.width.equalTo(@50);
        }];
    }
    return self;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage war_imageName:@"biaoqian" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }
    return _addBtn;
}
- (UIButton *)pushCommentsBtn{
    if (!_pushCommentsBtn) {
        _pushCommentsBtn = [[UIButton alloc] init];
        [_pushCommentsBtn setImage:[UIImage war_imageName:@"mesg" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }
    return _pushCommentsBtn;
}
- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        [_likeBtn setImage:[UIImage war_imageName:@"heart" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
          [_likeBtn setImage:[UIImage war_imageName:@"heart_pre" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
    }
    return _likeBtn;
}
@end
