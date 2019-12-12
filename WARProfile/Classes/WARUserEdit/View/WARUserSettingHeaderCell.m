//
//  WARUserSettingHeaderCell.m
//  WARProfile
//
//  Created by Hao on 2018/7/6.
//

#import "WARUserSettingHeaderCell.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"

@implementation WARUserSettingHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headerImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = SubTextColor;
        self.nameLabel.font = kFont(12);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage war_imageName:@"group_add" curClass:[self class] curBundle:@"WARContacts.bundle"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];

        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.5);
            make.top.mas_equalTo(19);
            make.width.height.mas_equalTo(50);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14.5);
            make.width.mas_equalTo(62);
            make.top.mas_equalTo(self.headerImageView.mas_bottom).offset(6.5);
        }];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((kScreenWidth - 20.5 * 2 - 50 * 5) / 4.0 + 20.5 + 50);
            make.top.mas_equalTo(19);
            make.width.height.mas_equalTo(50);
        }];
        
        UIView *leftTapView = [[UIView alloc] init];
        leftTapView.backgroundColor = UIColorClear;
        [self.contentView addSubview:leftTapView];
        
        [leftTapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(15+36+5);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [leftTapView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction {
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)addButtonClick {
    if (self.addBlock) {
        self.addBlock();
    }
}

- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 2;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

@end
