//
//  WARCategoryMemberCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARCategoryMemberCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WARBundleImage.h"
#import "WARUIHelper.h"
#import "UIImageView+CornerRadius.h"

#import "WARCategoryViewModel.h"

#define kIconSzie CGSizeMake(46, 46)
#define kButtonSize CGSizeMake(16, 16)

@interface WARCategoryMemberCell()
@property (nonatomic, strong) UIView *containerV;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *removeBtn;
@property (nonatomic, strong) UILabel *nameLab;
@end
@implementation WARCategoryMemberCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.containerV];
    [self.containerV addSubview:self.icon];
    [self.containerV addSubview:self.addBtn];
    [self.containerV addSubview:self.removeBtn];
    [self.containerV addSubview:self.nameLab];
    
    [self.containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-4);
        make.top.mas_equalTo(4);
        make.size.mas_equalTo(kIconSzie);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(kButtonSize);
    }];
    
    [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(kButtonSize);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(6);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    
}


- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        switch (self.type) {
            case WARCategoryMemberCellTypeOfMember:
            {                
                self.removeBtn.hidden = NO;
                self.addBtn.hidden = YES;
            }
                break;
            case WARCategoryMemberCellTypeOfOther:
            {
                self.removeBtn.hidden = YES;
                self.addBtn.hidden = NO;
            }
                break;
            default:
                break;
        }
    }else{
        self.removeBtn.hidden = YES;
        self.addBtn.hidden = YES;
    }
}

- (void)configureCategoryMember:(WARCategoryMemberModel *)categoryMember{
    [self.icon sd_setImageWithURL:kPhotoUrlWithImageSize(kIconSzie, categoryMember.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLab.text = categoryMember.nickName;
}

#pragma mark - getter method
-(UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
    }
    return _containerV;
}
- (UIImageView *)icon{
    if (!_icon) {
//        _icon = [[UIImageView alloc]init];
        _icon = [[UIImageView alloc] initWithCornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    }
    return _icon;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage war_imageName:@"list_jia" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UIButton *)removeBtn{
    if (!_removeBtn) {
        _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeBtn setImage:[UIImage war_imageName:@"list_jian" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }
    return _removeBtn;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.font = kFont(11);
        _nameLab.textColor= RGB(51, 51, 51);
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}
@end
