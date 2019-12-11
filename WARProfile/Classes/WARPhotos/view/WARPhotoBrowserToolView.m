//
//  WARPhotoBrowserToolView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/11.
//

#import "WARPhotoBrowserToolView.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "UIColor+WARCategory.h"
@implementation WARPhotoBrowserToolView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.goComentsBtn];
        [self addSubview:self.clickLikeBtn];
        [self addSubview:self.goDescrptionBtn];
//        [self addSubview:self.goMoreBtn];
//        [self.goMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-5);
//            make.width.equalTo(@55);
//            make.height.equalTo(@30);
//            make.top.equalTo(self);
//        }];
        [self.goComentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];
        [self.clickLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.goComentsBtn.mas_left).offset(-5);
            make.width.equalTo(@50);
            make.height.equalTo(@30);
            make.top.equalTo(self);
        }];
        [self.goDescrptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(self);
        }];

    }
    return self;
    
}
- (UIButton *)goDescrptionBtn{
    if (!_goDescrptionBtn) {
        _goDescrptionBtn = [[UIButton alloc] init];
        [_goDescrptionBtn setImage:[UIImage war_imageName:@"camera_describe" curClass:[self class]curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_goDescrptionBtn setTitle:@"添加描述" forState:UIControlStateNormal];
        [_goDescrptionBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF" opacity:0.6] forState:UIControlStateNormal];
        _goDescrptionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _goDescrptionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _goDescrptionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);

    }
    return _goDescrptionBtn;
}
- (UIButton *)clickLikeBtn{
    if (!_clickLikeBtn) {
        _clickLikeBtn = [[UIButton alloc] init];
        [_clickLikeBtn setImage:[UIImage war_imageName:@"camera_heart" curClass:[self class]curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_clickLikeBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF" opacity:0.6] forState:UIControlStateNormal];
        _clickLikeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _clickLikeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
    }
    return _clickLikeBtn;
}
- (UIButton *)goComentsBtn{
    if (!_goComentsBtn) {
        _goComentsBtn = [[UIButton alloc] init];//camera_heart
        [_goComentsBtn setImage:[UIImage war_imageName:@"camera_comment" curClass:[self class]curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
     
        [_goComentsBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF" opacity:0.6] forState:UIControlStateNormal];
        _goComentsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _goComentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _goComentsBtn;
}
//- (UIButton *)goMoreBtn{
//    if (!_goMoreBtn) {
//        _goMoreBtn = [[UIButton alloc] init];//camera_heart
//        [_goMoreBtn setImage:[UIImage war_imageName:@"camera_gengduo" curClass:[self class]curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
//        
//    }
//    return _goMoreBtn;
//}
@end
