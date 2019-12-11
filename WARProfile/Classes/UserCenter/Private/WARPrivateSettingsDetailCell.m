//
//  WARPrivateSettingsDetailCell.m
//  WARProfile
//
//  Created by Hao on 2018/6/29.
//

#import "WARPrivateSettingsDetailCell.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "Masonry.h"

@implementation WARPrivateSettingsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellTitleLabel = [[UILabel alloc] init];
        self.cellTitleLabel.font = [UIFont systemFontOfSize:16];
        self.cellTitleLabel.textColor = TextColor;
        [self.contentView addSubview:self.cellTitleLabel];
        
        self.cellDetailLabel = [[UILabel alloc] init];
        self.cellDetailLabel.font = [UIFont systemFontOfSize:14];
        self.cellDetailLabel.textColor = ThreeLevelTextColor;
        [self.contentView addSubview:self.cellDetailLabel];
        
        [self.cellTitleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10.5);
        }];
        
        [self.cellDetailLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(34);
        }];
        
        UIImage *image = [UIImage war_imageName:@"accessory" curClass:[self class] curBundle:@"WARControl.bundle"];
        self.accessoryImageView = [[UIImageView alloc] initWithImage:image];
        [self.contentView addSubview:self.accessoryImageView];
        
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView).with.offset(-15);
            make.height.width.mas_equalTo(image.size.height);
            make.width.mas_equalTo(image.size.width);
        }];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = SeparatorColor;
        [self.contentView addSubview:lineV];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
@end
