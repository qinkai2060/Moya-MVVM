//
//  WARPhotoKeyBordSiginView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/13.
//

#import "WARPhotoKeyBordSiginView.h"
#import "UIColor+WARCategory.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#define DRDEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DRDEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DRTopDistin(r) ((SYSTEMVERSION) ? (20 + (r)) : (r))
#define DRhzbeishu (DRDEVICE_WIDTH / 320)
#define DRhzbeishu_iphone6 (DRDEVICE_WIDTH / 375)  //667
#define DRhzbeishu_iphone6p (DRDEVICE_WIDTH / 414)
#define DRhzbeishu_iphone6_H (DRDEVICE_HEIGHT / 667)  //667
@implementation WARPhotoKeyBordSiginView
//@"MessageInputView.bundle/WARMessageInputView.bundle"keyboard_emotion keyboard_add
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.smileV];
        [self addSubview:self.addImgV];
        [self addSubview:self.inputBtn];
        [self addSubview:self.sendlb];
        [self.smileV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@25);
            make.left.equalTo(self).offset(7);
              make.centerY.equalTo(self);
        }];
        [self.addImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.smileV.mas_right).offset(5);
             make.centerY.equalTo(self);
            make.width.height.equalTo(@25);
        }];
        [self.sendlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@35);
            make.top.equalTo(self).offset(7.5);
            make.right.equalTo(self).offset(-7);
        }];
        [self.inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addImgV.mas_right).offset(10);
            make.right.equalTo(self.sendlb.mas_left).offset(-10);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
        }];
   
    }
    return self;
}
- (UIImageView *)smileV{
    if (!_smileV) {
        _smileV = [[UIImageView alloc] init];//keyboard_add
        _smileV.image = [UIImage war_imageName:@"camera_addadd" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _smileV.alpha = 0.4;
    }
    return _smileV;
}
- (UIImageView *)addImgV{
    if (!_addImgV) {
        _addImgV = [[UIImageView alloc] init];
        _addImgV.image = [UIImage war_imageName:@"camera_expressionbiaoqing" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _addImgV.alpha = 0.4;
        
    }
    return _addImgV;
}
- (UIButton *)inputBtn{
    if (!_inputBtn) {
        _inputBtn = [[UIButton alloc] init];
        _inputBtn.layer.cornerRadius = 6;
        _inputBtn.layer.masksToBounds = YES;
        _inputBtn.layer.borderWidth = 1.0f;
        _inputBtn.enabled = NO;
        _inputBtn.layer.borderColor = [[UIColor colorWithHexString:@"FFFFFF"opacity:0.4] CGColor];
        [_inputBtn setTitle:@"说点什么吧" forState:UIControlStateNormal];
        [_inputBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF" opacity:0.4] forState:UIControlStateNormal];
        _inputBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _inputBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -180*DRhzbeishu_iphone6, 0, 0);
        _inputBtn.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" opacity:0.15];
        
    }
    return _inputBtn;
}
- (UILabel *)sendlb{
    if (!_sendlb) {
        _sendlb = [[UILabel alloc] init];
        _sendlb.text = @"发送";
        _sendlb.font = [UIFont systemFontOfSize:15];
        _sendlb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _sendlb;
}
@end
