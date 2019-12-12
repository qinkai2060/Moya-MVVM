//
//  WARCreatMaskCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/16.
//

#import "WARCreatMaskCell.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"
#import "UIColor+WARCategory.h"
@implementation WARCreatMaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
      [self.contentView addSubview:self.titlelb];
      [self.contentView addSubview:self.iconImg];
      [self.contentView addSubview:self.selectImgBtn];
      [self.contentView addSubview:self.lineV];
     [self.contentView addSubview:self.maskName];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(21);
        make.height.equalTo(@14);
        make.width.equalTo(@45);
    }];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titlelb.mas_right).offset(16);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@40);
    }];
  
    [self.selectImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@23);
    }];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-18);
        make.height.equalTo(@1);
    }];
    [self.maskName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(16);
        make.right.equalTo(self.selectImgBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@13);
    }];
}
- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.font = kFont(12);
        _titlelb.textColor = [UIColor colorWithHexString:@"d9d9dc"];
          _titlelb.text = WARLocalizedString(@"王大炮");
    }
    return _titlelb;
}
- (UILabel *)maskName{
    if (!_maskName) {
        _maskName = [[UILabel alloc] init];
        _maskName.font = kFont(12);
        _maskName.textColor = [UIColor colorWithHexString:@"333333"];
        _maskName.text = WARLocalizedString(@"王大炮");
    }
    return _maskName;
}
- (UIButton *)selectImgBtn{
    if (!_selectImgBtn) {
        _selectImgBtn = [[UIButton alloc] init];
        [_selectImgBtn setImage:[UIImage war_imageName:@"newgroup_select_n" curClass:self curBundle:@"WARContacts.bundle"] forState:UIControlStateNormal];
        [_selectImgBtn setImage:[UIImage war_imageName:@"newgroup_select_y" curClass:self curBundle:@"WARContacts.bundle"] forState:UIControlStateSelected];
    }
    return _selectImgBtn;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineV;
}
- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.backgroundColor = [UIColor colorWithHexString:@"d9d9dc"];
        _iconImg.layer.cornerRadius = 5;
        _iconImg.layer.masksToBounds = YES;
    }
    return _iconImg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectImgBtn.selected = selected;

    // Configure the view for the selected state
}

@end
