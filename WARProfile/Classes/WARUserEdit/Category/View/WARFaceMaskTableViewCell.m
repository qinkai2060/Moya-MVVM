//
//  WARFaceMaskTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARFaceMaskTableViewCell.h"

#import "Masonry.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

#import "WARFaceMaskModel.h"

#define kFaceImgSize CGSizeMake(58, 58)

@interface WARFaceMaskTableViewCell()
/** 形象 */
@property (nonatomic, strong) UILabel *faceNameLab;
/** 图片 */
@property (nonatomic, strong) UIImageView *faceImgV;
/** 姓名 */
@property (nonatomic, strong) UILabel *nameLab;
/** 年龄 */
@property (nonatomic, strong) UILabel *ageLab;
/** 年龄背景图 */
@property (nonatomic, strong) UIImageView *ageIV;
/** 星座 */
@property (nonatomic, strong) UIImageView *constellationIV;
/** 个性签名 */
@property (nonatomic, strong) UILabel *signatureLab;
@end
@implementation WARFaceMaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.faceNameLab];
    [self.contentView addSubview:self.faceImgV];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.ageIV];
    [self.ageIV addSubview:self.ageLab];
    [self.contentView addSubview:self.constellationIV];
    [self.contentView addSubview:self.signatureLab];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.font = kFont(14);
    lab.textColor = RGB(153, 153, 153);
    lab.text = WARLocalizedString(@"形象");
    [self.contentView addSubview:lab];
    
    UIImageView *rightImgV = [[UIImageView alloc]init];
    rightImgV.image = [UIImage war_imageName:@"list_more" curClass:self curBundle:@"WARProfile.bundle"];
    [self.contentView addSubview:rightImgV];
    
    
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(13);
    }];
    
    [rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.faceNameLab);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.faceNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImgV.mas_left).offset(-13);
        make.top.mas_equalTo(13);
    }];
    
  

    [self.faceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kFaceImgSize);
        make.top.equalTo(lab.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-20);
    }];
    
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.faceImgV.mas_right).offset(10);
        make.top.equalTo(self.faceImgV.mas_top).offset(4);
    }];
    
    
    [self.ageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.nameLab);
        make.left.equalTo(self.nameLab.mas_right).offset(8);
    }];
    
    [self.ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.ageIV);
    }];
    
    [self.constellationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ageLab);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.ageLab.mas_right).offset(4);
    }];
 
    
    [self.signatureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab);
//        make.top.equalTo(self.nameLab.mas_bottom).offset(12).priorityHigh();
        make.bottom.equalTo(self.faceImgV);
        make.right.mas_equalTo(-12);
    }];
    

}

- (void)configureFaceMaskModel:(WARFaceMaskModel *)faceMaskModel{
    self.faceNameLab.text = faceMaskModel.faceName;
    [self.faceImgV sd_setImageWithURL:kPhotoUrlWithImageSize(kFaceImgSize, faceMaskModel.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLab.text = faceMaskModel.nickname;
    self.signatureLab.text = faceMaskModel.signature;
}


#pragma mark - getter methods
- (UILabel *)faceNameLab{
    if (!_faceNameLab) {
        _faceNameLab = [[UILabel alloc]init];
        _faceNameLab.font = kFont(14);
        _nameLab.textColor = RGB(51, 51, 51);
    }
    return _faceNameLab;
}

- (UIImageView *)faceImgV{
    if (!_faceImgV) {
        _faceImgV = [[UIImageView alloc]init];
    }
    return _faceImgV;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = kFont(16);
        _nameLab.textColor = COLOR_WORD_GRAY_3;
    }
    return _nameLab;
}

- (UILabel *)signatureLab {
    if (!_signatureLab) {
        _signatureLab = [UILabel new];
        _signatureLab.font = kFont(12);
        _signatureLab.textColor = COLOR_WORD_GRAY_9;
    }
    return _signatureLab;
}
- (UILabel *)ageLab {
    if (!_ageLab) {
        _ageLab = [UILabel new];
        _ageLab.font = kFont(8);
        _ageLab.textColor = kColor(whiteColor);
        _ageLab.textAlignment = NSTextAlignmentCenter;
        //        _ageLab.layer.cornerRadius = 3;
        //        _ageLab.layer.masksToBounds = YES;
        _ageLab.backgroundColor = kColor(clearColor);
    }
    return _ageLab;
}

- (UIImageView *)ageIV{
    if (!_ageIV) {
        _ageIV = [[UIImageView alloc]init];
        _ageIV.contentMode = UIViewContentModeCenter;
    }
    return _ageIV;
}


- (UIImageView *)constellationIV {
    if (!_constellationIV) {
        _constellationIV = [[UIImageView alloc] init];
        _constellationIV.contentMode = UIViewContentModeCenter;
    }

    return _constellationIV;
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




@interface WARNoFaceMaskTableViewCell()
@property (nonatomic, strong) UIImageView *rightImgV;

@property (nonatomic, strong) UILabel *aLab;
@property (nonatomic, strong) UILabel *bLab;
@end
@implementation WARNoFaceMaskTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    [self.contentView addSubview:self.aLab];
    [self.contentView addSubview:self.bLab];
    [self.contentView addSubview:self.rightImgV];
    
    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(8, 15));
        make.centerY.equalTo(self.aLab);
    }];
    
    [self.aLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.bLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImgV.mas_left).offset(-20);
        make.left.equalTo(self.aLab.mas_right);
        make.top.bottom.equalTo(self.aLab);
    }];
    
}

#pragma mark - getter methods
- (UILabel *)aLab{
    if (!_aLab) {
        _aLab = [[UILabel alloc]init];
        _aLab.font = kFont(14);
        _aLab.textColor =RGB(153, 153, 153);
        _aLab.text = WARLocalizedString(@"形象");
    }
    return _aLab;
}

- (UILabel *)bLab{
    if (!_bLab) {
        _bLab = [[UILabel alloc]init];
        _bLab.font = kFont(14);
        _bLab.textColor =RGB(153, 153, 153);
        _bLab.text = WARLocalizedString(@"请选择分组展示的形象");
    }
    return _bLab;
}

- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage war_imageName:@"list_more" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _rightImgV;
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
