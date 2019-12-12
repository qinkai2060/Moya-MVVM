//
//  WARPhotoDownListCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/8.
//

#import "WARPhotoDownListCell.h"
#import "Masonry.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARGroupModel.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
@implementation WARPhotoDownListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setModel:(WARDownPictureModel *)model {
    _model = model;
    if ([model.type isEqualToString:@"VIDEO"]) {
            [self.imageV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(40  , 40),model.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(40 , 40))];
    }else {
        [self.imageV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(40  , 40),model.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(40 , 40))];
    }

 
    self.datelb.text = model.creatDate;
    WS(weakSelf);
    model.downblock = ^(float progress, NSString *speedStr, NSInteger length) {
        weakSelf.progressV.hidden = NO;
        weakSelf.progresslb.hidden = NO;
        weakSelf.progressV.progress = progress;
        weakSelf.statelb.text = speedStr;
        NSString *baifenbi =[NSString stringWithFormat:@"%.f", progress *100];
        
        weakSelf.progresslb.text = [NSString stringWithFormat:@"%@/%@(%@%%)",[weakSelf getBytesFromDataLength:length*progress],[weakSelf getBytesFromDataLength:length],baifenbi];
    };
    self.progressV.hidden = YES;
    self.progresslb.hidden = YES;
    if (model.isUploadFinsh) {
        self.statelb.text = model.totalSize;
    }else{
        self.statelb.text = model.stateStr;
    }
}
- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}
- (void)setUI {
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.imageNamelb];
    [self.contentView addSubview:self.datelb];
    [self.contentView addSubview:self.statelb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.progresslb];
    [self.contentView addSubview:self.progressV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.top.equalTo(self.contentView).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.imageNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.height.equalTo(@14);
        make.width.equalTo(@98);
    }];
    [self.datelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageNamelb.mas_bottom).offset(8);
        make.height.equalTo(@10);
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.width.equalTo(@60);
    }];
    [self.statelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@16);
        make.width.equalTo(@70);
    }];
    [self.progressV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageNamelb.mas_bottom).offset(12);
        make.height.equalTo(@4);
        make.left.equalTo(self.imageNamelb.mas_right);
        make.right.equalTo(self.statelb.mas_left).offset(-18);
    }];
    [self.progresslb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.imageNamelb.mas_right);
        make.height.equalTo(@14);
        make.width.equalTo(@120);
    }];
    self.progressV.progress = 0;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.layer.cornerRadius = 3;
        _imageV.layer.masksToBounds = YES;
    }
    return _imageV;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _lineView;
}
- (UILabel *)imageNamelb {
    if (!_imageNamelb) {
        _imageNamelb = [[UILabel alloc] init];
        _imageNamelb.textColor = [UIColor blackColor];
        _imageNamelb.font = [UIFont systemFontOfSize:13];
        
        
    }
    return _imageNamelb;
}
- (UILabel *)datelb {
    if (!_datelb) {
        _datelb = [[UILabel alloc] init];
        _datelb.textColor = [UIColor colorWithHexString:@"ADB1BE"];
        _datelb.font = [UIFont systemFontOfSize:10];
    }
    return _datelb;
}
- (UILabel *)statelb {
    if (!_statelb) {
        _statelb = [[UILabel alloc] init];
        _statelb.textColor = [UIColor blackColor];
        _statelb.font = [UIFont systemFontOfSize:16];
        _statelb.textAlignment = NSTextAlignmentRight;
    }
    return _statelb;
}
- (UILabel *)progresslb {
    if (!_progresslb) {
        _progresslb = [[UILabel alloc] init];
        _progresslb.textColor = [UIColor colorWithHexString:@"575C68"];
        _progresslb.font = [UIFont systemFontOfSize:12];
        _progresslb.textAlignment = NSTextAlignmentCenter;
        
    }
    return _progresslb;
}
- (UIProgressView *)progressV {
    if (!_progressV) {
        _progressV = [[UIProgressView alloc] init];
        _progressV.progressTintColor = [UIColor colorWithHexString:@"2CBE61" opacity:0.49];
        _progressV.hidden = YES;
        _progresslb.layer.cornerRadius = 1.5;
        _progresslb.layer.masksToBounds = YES;
    }
    return _progressV;
}

@end
