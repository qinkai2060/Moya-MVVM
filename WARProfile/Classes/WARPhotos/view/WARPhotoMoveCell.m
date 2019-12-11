//
//  WARPhotoMoveCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import "WARPhotoMoveCell.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
@implementation WARPhotoMoveCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.selectImgBtn];
        [self.contentView addSubview:self.fenmianImgV];
        [self.contentView addSubview:self.titlelb];
        [self.selectImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(52);
            make.width.height.equalTo(@40);
        }];
        [self.fenmianImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectImgBtn.mas_right).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.height.width.equalTo(@90);
        }];
        [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fenmianImgV.mas_right).offset(15);
            make.top.equalTo(self.contentView).offset(52);
            make.height.equalTo(@16);
            make.right.equalTo(self.contentView);
        }];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected) {
      
    }else{
   
    
    }
    
}
- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
- (void)SelectClick:(UIButton*)btn{
//    self.selectImgBtn.selected = !self.selectImgBtn.selected;
//    if (self.selectImgBtn.selected) {
//        self.model.isSelectBtn = YES;
//    }else{
//        self.model.isSelectBtn = NO;
//    }
//    if (self.selectImgBtn.selected) {
//        if (self.block) {
//            self.block(self.model.albumId);
//        }
//    }
}

- (void)setModel:(WARGroupModel *)model{
    _model = model;

    self.titlelb.text =[NSString stringWithFormat:@"%@ (%@)",model.name,model.pictureCount];
    if ([model.coverType isEqualToString:@"VIDEO"]) {
        [self.fenmianImgV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(kScreenWidth , 178),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth , 178))];;
    }else{
        [self.fenmianImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth , 178),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth , 178))];;
    }

}
- (UIButton *)selectImgBtn{
    if (!_selectImgBtn) {
        _selectImgBtn = [[UIButton alloc] init];
        [_selectImgBtn setImage:[UIImage war_imageName:@"choose" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_selectImgBtn setImage:[UIImage war_imageName:@"choose_pre" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
        _selectImgBtn.userInteractionEnabled = NO;
     //   [_selectImgBtn addTarget:self action:@selector(SelectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectImgBtn;
}

- (UIImageView *)fenmianImgV{
    if (!_fenmianImgV) {
        _fenmianImgV = [[UIImageView alloc] init];
        _fenmianImgV.contentMode = UIViewContentModeScaleAspectFill;
        _fenmianImgV.clipsToBounds = YES;
    }
   
    return _fenmianImgV;
}
- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.font = kFont(16);
        _titlelb.textColor = [UIColor blackColor];
        _titlelb.text = WARLocalizedString(@"一醉方休");
    }
    return _titlelb;
}
@end
