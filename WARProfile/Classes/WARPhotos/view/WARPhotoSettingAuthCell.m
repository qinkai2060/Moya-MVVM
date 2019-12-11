//
//  WARPhotoSettingAuthCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoSettingAuthCell.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
//#import "UIColor+WARCategory.h"
#import "WARConfigurationMacros.h"
@implementation WARPhotoSettingAuthCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self.contentView addSubview:self.imageGouV];
    [self.contentView addSubview:self.authNamelb];
    [self.contentView addSubview:self.lineView];
    [self.imageGouV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(19);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    [self.authNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageGouV.mas_right).offset(11);
        make.top.equalTo(self.contentView).offset(16);
        make.height.equalTo(@16);
        make.width.equalTo(@150);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}
- (UIImageView *)imageGouV{
    if (!_imageGouV){
        _imageGouV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"personal_set_tick" curClass:self curBundle:@"WARProfile.bundle"]];
    }
    return _imageGouV;
}
- (UILabel *)authNamelb{
    if (!_authNamelb) {
        _authNamelb = [[UILabel alloc] init];
        _authNamelb.textColor = SubTextColor;
        _authNamelb.font = [UIFont systemFontOfSize:16];
        
    }
    return _authNamelb;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView .backgroundColor = SeparatorColor;
    }
    return _lineView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
