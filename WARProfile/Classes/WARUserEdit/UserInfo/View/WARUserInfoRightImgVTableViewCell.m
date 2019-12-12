//
//  WARUserInfoRightImgVTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import "WARUserInfoRightImgVTableViewCell.h"


#import "WARMacros.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"

@interface WARUserInfoRightImgVTableViewCell()
@property (nonatomic, strong) UILabel *textLab;

@end


@implementation WARUserInfoRightImgVTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        [self.contentView addSubview:self.textLab];
        [self.contentView addSubview:self.rightMoreImgV];
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.rightMoreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(8, 13));
        }];
    }
    return self;
}

- (void)configureContentStr:(NSString *)contentStr{
    self.textLab.text = contentStr;

}

#pragma mark - getter methods
- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(16);
        _textLab.textColor = TextColor;
    }
    return _textLab;
}
- (UIImageView *)rightMoreImgV{
    if (!_rightMoreImgV) {
        _rightMoreImgV = [[UIImageView alloc]init];
        _rightMoreImgV.image = [UIImage war_imageName:@"more" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _rightMoreImgV;
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
