//
//  WARPhotosCollectionCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/27.
//

#import "WARPhotosCollectionCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "WARMacros.h"
#import "WARBaseMacros.h"
#import "WARUIHelper.h"
#import "TZImageManager.h"
@implementation WARPhotosCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.loacalPhotoImgV];
        [self.contentView addSubview:self.textlb];
        [self.loacalPhotoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setModel:(TZAssetModel *)model{
    _model = model;
    
    self.representedAssetIdentifier = [[TZImageManager manager] getAssetIdentifier:model.asset];
    
    int32_t imageRequestID = [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:(kScreenWidth-15)/4 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        
        if ([self.representedAssetIdentifier isEqualToString:[[TZImageManager manager] getAssetIdentifier:model.asset]]) {
          
            self.loacalPhotoImgV.image = photo;
            
     
        } else {
            // NSLog(@"this cell is showing other asset");
     
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
   
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        // NSLog(@"cancelImageRequest %d",self.imageRequestID);
    }
    self.imageRequestID = imageRequestID;
}
- (UIImageView *)loacalPhotoImgV{
    if (!_loacalPhotoImgV) {
        _loacalPhotoImgV = [[UIImageView alloc] init];
        _loacalPhotoImgV.contentMode = UIViewContentModeScaleAspectFill;
        _loacalPhotoImgV.clipsToBounds = YES;
    }
    return _loacalPhotoImgV;
}
- (UILabel *)textlb{
    if (!_textlb) {
        _textlb = [[UILabel alloc] init];
        _textlb.textColor  = [UIColor blackColor];
        _textlb.font = [UIFont boldSystemFontOfSize:18];
        _textlb.textAlignment = NSTextAlignmentCenter;
    }
    return _textlb;
}

@end
