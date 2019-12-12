//
//  WARGameShareItemCell.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import "WARGameShareItemCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"

#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"

@interface WARGameShareItemCell()
/** icon */
@property (nonatomic,strong) UIImageView *iconImagev; 
/** 标题 */
@property (nonatomic,strong) UILabel *titlelb;
@end

@implementation WARGameShareItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImagev];
        [self.contentView addSubview:self.titlelb];
        
        [self.iconImagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.width.equalTo(@(59));
            make.top.equalTo(self.contentView).offset(0);
        }];
        
        [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImagev.mas_bottom).offset(9);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@(30));
        }];
    }
    return self;
}

- (void)setItem:(WARGameShareItemModel *)item {
    _item = item;
    
    if (item.localHeadId && item.localHeadId.length > 0) {
        self.iconImagev.image = [UIImage war_imageName:item.localHeadId curClass:[self class] curBundle:@"WARProfile.bundle"];
    } else {
        [self.iconImagev sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(59, 59),item.headId) placeholderImage:[WARUIHelper war_defaultGroupIcon]];
    }
    
    /// 富文本拼接
    if (item.name.length > 0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 15.0f;
        paragraphStyle.maximumLineHeight = 15.0f;
        paragraphStyle.minimumLineHeight = 15.0f;
        paragraphStyle.lineSpacing = 0.0f;// 行间距
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSString *string = item.name;
        NSDictionary *ats = @{
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        NSAttributedString *attri = [[NSAttributedString alloc] initWithString:string attributes:ats];
        self.titlelb.attributedText = attri;
        
        if ((item.localHeadId && item.localHeadId.length > 0)) {
            CGFloat height = [attri boundingRectWithSize:CGSizeMake(65, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  context:nil].size.height;
            [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        } else {
            [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(11));
            }];
        } 
    }
}

- (UIImageView *)iconImagev {
    if (!_iconImagev) {
        _iconImagev = [[UIImageView alloc] init];
        _iconImagev.layer.cornerRadius = 4;
        _iconImagev.layer.masksToBounds = YES;
    }
    return _iconImagev;
}

- (UILabel *)titlelb {
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _titlelb.textColor = HEXCOLOR(0x575C68);
        _titlelb.textAlignment = NSTextAlignmentCenter;
        _titlelb.numberOfLines = 2;
    }
    return _titlelb;
}

@end
