//
//  WARPhotoUpDownListCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/27.
//

#import "WARPhotoUpDownListCell.h"
#import "Masonry.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARConfigurationMacros.h"
#import "TZImageManager.h"
#import "WARPhotosUploadManger.h"
@implementation WARPhotoUpDownListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setModel:(WARupPictureModel *)model {
    _model = model;
     PHAsset *imageAset     =  [[PHAsset fetchAssetsWithLocalIdentifiers:@[model.localIdentifier] options:nil] firstObject];
    self.representedAssetIdentifier = [[TZImageManager manager] getAssetIdentifier:imageAset];
    
    int32_t imageRequestID = [[TZImageManager manager] getPhotoWithAsset:imageAset photoWidth:MAXFLOAT completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        
        if ([self.representedAssetIdentifier isEqualToString:[[TZImageManager manager] getAssetIdentifier:imageAset]]) {
            
                self.imageV.image = photo;
            
            
        } else {
        
            
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
    self.imageNamelb.text = model.filePath;
    self.datelb.text = model.creatDate;
    WS(weakSelf);
//    WARGroupModel *uploadModel =  [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
//    WARupPictureModel*pmodel =    [[uploadModel uploadArray] firstObject];
//    if ([pmodel.localIdentifier isEqualToString:model.localIdentifier]) {
//
//    }

    model.block = ^(NSString  *progress,float progressBaifen, NSString *speedStr, NSString *toalSize) {
        weakSelf.progressV.hidden = NO;
        weakSelf.progresslb.hidden = NO;
        weakSelf.progressV.progress = progressBaifen;
        weakSelf.statelb.text = speedStr;
        NSString *baifenbi =[NSString stringWithFormat:@"%.f", progressBaifen *100];
        
        weakSelf.progresslb.text = [NSString stringWithFormat:@"%@/%@(%@%%)",progress,toalSize,baifenbi];
    };
    self.progressV.hidden = YES;
    self.progresslb.hidden = YES;
    self.statelb.text = model.stateStr;
   
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
        make.width.equalTo(@110);
    }];
    [self.datelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageNamelb.mas_bottom).offset(8);
        make.height.equalTo(@10);
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.width.equalTo(@80);
    }];
    [self.statelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@16);
        make.width.equalTo(@70);
    }];

    [self.progresslb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.imageNamelb.mas_right).offset(8);
        make.height.equalTo(@14);
        make.width.equalTo(@120);
    }];
    [self.progressV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progresslb.mas_bottom).offset(8);
        make.height.equalTo(@4);
        make.left.equalTo(self.datelb.mas_right).offset(18);
        make.right.equalTo(self.statelb.mas_left).offset(-18);
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
        _lineView.backgroundColor = SeparatorColor;
    }
    return _lineView;
}
- (UILabel *)imageNamelb {
    if (!_imageNamelb) {
        _imageNamelb = [[UILabel alloc] init];
        _imageNamelb.textColor = TextColor;
        _imageNamelb.font = [UIFont systemFontOfSize:13];
  
        
    }
    return _imageNamelb;
}
- (UILabel *)datelb {
    if (!_datelb) {
        _datelb = [[UILabel alloc] init];
        _datelb.textColor = ThreeLevelTextColor;
        _datelb.font = [UIFont systemFontOfSize:11];
    }
    return _datelb;
}
- (UILabel *)statelb {
    if (!_statelb) {
        _statelb = [[UILabel alloc] init];
        _statelb.textColor = TextColor;
        _statelb.font = [UIFont systemFontOfSize:16];
        _statelb.textAlignment = NSTextAlignmentRight;
    }
    return _statelb;
}
- (UILabel *)progresslb {
    if (!_progresslb) {
        _progresslb = [[UILabel alloc] init];
        _progresslb.textColor = SubTextColor;
        _progresslb.font = [UIFont systemFontOfSize:12];
        _progresslb.textAlignment = NSTextAlignmentCenter;
        _progresslb.hidden = YES;
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
