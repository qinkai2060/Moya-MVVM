//
//  WARPhotoCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import "WARPhotoCell.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "WARAlertView.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
@implementation WARPhotoCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];

    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.coverPaperImgV];
    [self.coverPaperImgV addSubview:self.maskV];
    [self.coverPaperImgV addSubview:self.lockimgV];
    [self.coverPaperImgV addSubview:self.countLb];
   [self.contentView addSubview:self.titlelb];
     [self.coverPaperImgV addSubview:self.newCreatlb];
   //  [self.coverPaperImgV addSubview:self.Statelb];
    [self.coverPaperImgV addSubview:self.maskView];
    [self.coverPaperImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@(CellW));
    }];
    [self.maskV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.coverPaperImgV);
        make.height.equalTo(@25);
    }];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverPaperImgV.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.height.equalTo(@15);
    }];
    
    [self.lockimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverPaperImgV).offset(5);
        make.bottom.equalTo(self.coverPaperImgV).offset(-5);
        make.width.equalTo(@10);
        make.height.equalTo(@12.5);
    }];
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.coverPaperImgV).offset(-5);
        make.left.equalTo(self.lockimgV.mas_right).offset(5);
        make.height.equalTo(@15);
        
    }];
    [self.newCreatlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.coverPaperImgV);
        make.bottom.equalTo(self.coverPaperImgV).offset(-15);
        make.height.equalTo(@15);
    }];
//    [self.Statelb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.maskV.mas_top);
//        make.left.right.equalTo(self.coverPaperImgV);
//        make.height.equalTo(@15);
//    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@(CellW));
    }];
    
}
- (void)setModel:(WARGroupModel *)model{
    _model = model;
    
 CGSize size =  [ model.name boundingRectWithSize:CGSizeMake(CellW, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    if (size.height > 15) {
        [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverPaperImgV.mas_bottom).offset(8);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@15);
        }];
    }else{
        [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverPaperImgV.mas_bottom).offset(8);
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.height.equalTo(@15);
        }];
    }
    [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {

        make.height.equalTo(@(size.height));
    }];
    for (UIView *v in self.contentView.subviews) {
        if (v.tag == 1000) {
            [v removeFromSuperview];
        }
    }

    self.titlelb.text = WARLocalizedString(model.name);

    self.countLb.text = [NSString stringWithFormat:@"%ld%@",[model.pictureCount integerValue],WARLocalizedString(@"张")];
    if ([model.coverType isEqualToString:@"VIDEO"]) {
        [self.coverPaperImgV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(CellW ,CellW),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(CellW ,CellW))];
    }else{
        [self.coverPaperImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(CellW , CellW),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(CellW ,CellW))];
    }
   
    if (model.uploadArray.count > 0) {
        UILabel *statelb = [[UILabel alloc] init];
        statelb.textAlignment = NSTextAlignmentCenter;
        statelb.font = kFont(10);
        statelb.textColor = [UIColor whiteColor];
        statelb.layer.cornerRadius = 3;
        statelb.layer.masksToBounds = YES;
        statelb.textAlignment = NSTextAlignmentCenter;
        statelb.numberOfLines = 0;
        statelb.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        statelb.tag = 1000;
        [self.contentView addSubview:statelb];
        [statelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.coverPaperImgV).offset(-5);
            make.left.equalTo(self.coverPaperImgV).offset(14);
            make.right.equalTo(self.coverPaperImgV).offset(-14);
            make.height.equalTo(@(CellW-48));
        }];
        NSString *noteCountStr = @"";
        if (model.uploadArray.count >99) {
            noteCountStr = [NSString stringWithFormat:@"%@\n照片/视频\n(99+)",model.stateStr];
          
        }else {
           noteCountStr = [NSString stringWithFormat:@"%@\n照片/视频\n(%ld)",model.stateStr,model.uploadArray.count];
        }
        NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:noteCountStr];
        NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:model.stateStr].location, [[noteStr string] rangeOfString:model.stateStr].length);
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRangeTwo];
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [paragraphStyle  setLineSpacing:5];
        [noteStr  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, noteCountStr.length)];
         statelb.attributedText = noteStr;
       
    }else{
        for (UIView *v in self.contentView.subviews) {
            if (v.tag == 1000) {
                [v removeFromSuperview];
            }
        }
    }
    
}

- (void)setType:(WARPhotoCellType)type{
    _type = type;
    if (type == WARPhotoCellTypeNewCreat) {
     //   self.titlelb.hidden = YES;
        self.lockimgV.hidden = YES;
        self.countLb.hidden = YES;
        self.maskV.hidden = YES;
        self.newCreatlb.hidden = NO;
    }else{
        self.titlelb.hidden = NO;
        self.lockimgV.hidden = NO;
        self.countLb.hidden = NO;
        self.newCreatlb.hidden = YES;
        self.maskV.hidden = NO;
    }
}

- (UIImageView *)coverPaperImgV{
    if(!_coverPaperImgV){
        _coverPaperImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,CellW , CellW)];
//        _coverPaperImgV.image = [UIImage war_imageName:@"wo_xiangce_xinjian" curClass:self curBundle:@"WARProfile.bundle"];
        _coverPaperImgV.layer.cornerRadius = 5;
        _coverPaperImgV.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        _coverPaperImgV.layer.shadowOffset=CGSizeMake(0, 2);
        _coverPaperImgV.layer.shadowOpacity = 0.3f;
//        _coverPaperImgV.layer.shadowRadius = 5;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_coverPaperImgV.bounds];
        _coverPaperImgV.layer.shadowPath = shadowPath.CGPath;
    
    }
    return _coverPaperImgV;
}
//wo_xiangce_xinjian@2x  xiangce_suo@2x
- (UILabel *)newCreatlb{
    if (!_newCreatlb) {
        _newCreatlb = [[UILabel alloc] init];
        _newCreatlb.textAlignment = NSTextAlignmentCenter;
        _newCreatlb.textColor = [UIColor colorWithHexString:@"d2d2d2"];
        _newCreatlb.font = [UIFont systemFontOfSize:12];
            _newCreatlb.text = @"新建相册";
    }
    return _newCreatlb;
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] init];
        _maskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _maskV;
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithHex:0x00d8b7 opacity:0.5];
    }
    return _maskView;
}
- (UIImageView *)lockimgV{
    if (!_lockimgV) {
        _lockimgV = [[UIImageView alloc] init];
        _lockimgV.image = [UIImage war_imageName:@"xiangce_suo" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _lockimgV;
}
- (UILabel *)countLb{
    if (!_countLb) {
        _countLb = [[UILabel alloc] init];
        _countLb.textAlignment = NSTextAlignmentRight;
        _countLb.font = kFont(13);
        _countLb.textColor = [UIColor whiteColor];
        _countLb.text = @"Hellow Word";
    }
    return _countLb;
}

- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.textAlignment = NSTextAlignmentCenter;
        _titlelb.font = kFont(12);
        _titlelb.textColor = ThreeLevelTextColor;
            _titlelb.text = @"Hellow Word";
        _titlelb.numberOfLines = 2;
    }
    return _titlelb;
}
- (UILabel *)Statelb{
    if (!_Statelb) {
        _Statelb = [[UILabel alloc] init];
        _Statelb.textAlignment = NSTextAlignmentCenter;
        _Statelb.font = kFont(14);
        _Statelb.textColor = [UIColor redColor];
        _Statelb.text = @"正在上传";
        _Statelb.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _Statelb;
}
@end
