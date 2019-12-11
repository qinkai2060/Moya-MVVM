//
//  WARPrivatePersonListCell.m
//  WARProfile
//
//  Created by Hao on 2018/6/29.
//

#import "WARPrivatePersonListCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "WARUIHelper.h"

@interface WARPrivatePersonListCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation WARPrivatePersonListCell

#pragma mark - System

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.nameLabel];
        
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(36);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(self);
        }];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = SeparatorColor;
        [self.contentView addSubview:lineV];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

#pragma mark - Event Response


#pragma mark - Delegate

#pragma mark - Private

- (void)setModel:(WARPrivatePersonModel *)model {
    _model = model;
    self.nameLabel.text = model.friendName;
    [self.headerImageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(36, 36), model.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
}

//- (void)configureCellWithSearchString:(NSString *)searchString {
//    self.nameLabel.attributedText = [self changeLabelColorOriginalString:self.nameLabel.text changeString:searchString];
//}
//
//- (NSMutableAttributedString *)changeLabelColorOriginalString:(NSString *)originalString changeString:(NSString *)changeString {
//    NSRange changeStringRange = [originalString rangeOfString:changeString];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:ThemeColor range:changeStringRange];
//    return attributedString;
//}

#pragma mark - Setter And Getter

- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = TextColor;
    }
    return _nameLabel;
}

@end
