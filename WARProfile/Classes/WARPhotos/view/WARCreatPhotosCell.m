//
//  WARCreatPhotosCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARCreatPhotosCell.h"
#import "Masonry.h"
#import "WARMacros.h"
//#import "UIColor+WARCategory.h"
#import "WARConfigurationMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARAlertView.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
@implementation WARCreatPhotosCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        
    }
    return self;
}
- (void)setUI{
    [self.contentView addSubview:self.coverPaperImgV];
     [self.coverPaperImgV addSubview:self.newCreatlb];
    [self.coverPaperImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@(CellW));
    }];
    [self.newCreatlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.coverPaperImgV);
        make.bottom.equalTo(self.coverPaperImgV).offset(-15);
        make.height.equalTo(@15);
    }];
    
}
- (UIImageView *)coverPaperImgV{
    if(!_coverPaperImgV){
        _coverPaperImgV = [[UIImageView alloc] init];
        _coverPaperImgV.image = [UIImage war_imageName:@"wo_xiangce_xinjian" curClass:self curBundle:@"WARProfile.bundle"];
    
    }
    return _coverPaperImgV;
}
- (UILabel *)newCreatlb{
    if (!_newCreatlb) {
        _newCreatlb = [[UILabel alloc] init];
        _newCreatlb.textAlignment = NSTextAlignmentCenter;
        _newCreatlb.textColor = DisabledTextColor;
        _newCreatlb.font = [UIFont systemFontOfSize:12];
        _newCreatlb.text = @"新建相册";
    }
    return _newCreatlb;
}
@end
