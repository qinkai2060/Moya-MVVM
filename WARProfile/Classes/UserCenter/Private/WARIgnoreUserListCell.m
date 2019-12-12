//
//  WARIgnoreUserLiseCell.m
//  Pods
//
//  Created by huange on 2017/8/10.
//
//

#import "WARIgnoreUserListCell.h"

#import "Masonry.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "UIImageView+CornerRadius.h"
#import "WARLocalizedHelper.h"
#import "NSString+Size.h"

#define IconImageWidth 50.0
#define IconImageLeftMargin 15.0

#define deleteButtonWidth 20.0

@interface WARIgnoreUserListCell ()

@end

@implementation WARIgnoreUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIView *selectBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.selectedBackgroundView = selectBackView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIView *selectBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.selectedBackgroundView = selectBackView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    [self createButtomLine];
    [self createDeleteButton];
    [self createIconImageView];
    [self createSolarImageView];
    [self createNameLabel];
    [self createAgeLabel];
    [self createDescriptionLabel];
    [self createRightButton];
    
    [self updateConstraint];
}

- (void)createButtomLine {
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = HEXCOLOR(0xeeeeee);
    [self.contentView addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)createDeleteButton {
    self.deleteActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage war_imageName:@"cell_delete" curClass:[self class] curBundle:@"WARProfile.bundle"];
    [self.deleteActionButton setImage:image forState:UIControlStateNormal];
    [self.deleteActionButton addTarget:self action:@selector(leftDeleteAction) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.deleteActionButton];
}

- (void)createIconImageView {
    self.iconImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:IconImageWidth/2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.iconImageView];
}

- (void)createSolarImageView {
    self.solarImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:self.solarImageView];
}

- (void)createNameLabel {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = HEXCOLOR(0x333333);
    [self.contentView addSubview:self.nameLabel];

}

- (void)createAgeLabel {
    self.ageLabel = [[UILabel alloc] init];
    self.ageLabel.font = [UIFont systemFontOfSize:10];
    self.ageLabel.textColor = RGB(255, 255, 255);
    self.ageLabel.backgroundColor = HEXCOLOR(0xFFA6A6);
    self.ageLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.ageLabel];

}

- (void)createDescriptionLabel {
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13];
    self.descriptionLabel.textColor = HEXCOLOR(0x999999);
    [self.contentView addSubview:self.descriptionLabel];
}

- (void)createRightButton {
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:WARLocalizedString(@"移除") backgroundColor:[UIColor redColor]];
    button.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [self rightDeleteAction];
        
        return YES;
    };
    
    self.rightButtons= @[button];
}

- (void)updateConstraint {
    NSInteger deleteButtonSizeWidth = 0;
    NSInteger deleteButtonleftMargin = 0;

    if (self.isEditing) {
        deleteButtonSizeWidth = deleteButtonWidth;
        deleteButtonleftMargin = IconImageLeftMargin;
    }
    
    [self.deleteActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).with.offset(deleteButtonleftMargin);
        make.height.width.mas_equalTo(deleteButtonSizeWidth);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.deleteActionButton.mas_trailing).with.offset(IconImageLeftMargin);
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo(IconImageWidth);
    }];
    
    CGFloat nameWidth = 0;
    if (![self.nameLabel.text isKindOfClass:[NSNull class]]) {
        nameWidth = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToWidth:self.frame.size.width/2].width;
    }
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(IconImageLeftMargin);
        make.top.equalTo(self.contentView).with.offset(16);
        make.width.mas_equalTo(nameWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.solarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(12);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.ageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.solarImageView.mas_trailing).with.offset(1);
        make.top.equalTo(self.solarImageView);
        make.width.equalTo(self.solarImageView);
        make.height.equalTo(self.solarImageView);
    }];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(4);
        make.trailing.equalTo(self.contentView).with.offset(-IconImageLeftMargin);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
}


#pragma mark - setter method
- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    
    [self updateConstraint];
    [self layoutIfNeeded];
}

- (void)setEditingWidthAnimation:(BOOL)isEditing animation:(BOOL)animation  {
    _isEditing = isEditing;

    if (isEditing) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateConstraint];
            [self layoutIfNeeded];
        }];
    }else {
        [self updateConstraint];
        [self layoutIfNeeded];
    }
}

- (void)rightDeleteAction {
    if (self.ignoreListCellDelegate && [self.ignoreListCellDelegate respondsToSelector:@selector(rightDeleteButtonAction:)]) {
        
        [self.ignoreListCellDelegate rightDeleteButtonAction:[self getCurrentIndexPath]];
    }
}

- (void)leftDeleteAction {
    if (self.ignoreListCellDelegate && [self.ignoreListCellDelegate respondsToSelector:@selector(leftDeleteButtonAction:)]) {
        
        [self.ignoreListCellDelegate leftDeleteButtonAction:[self getCurrentIndexPath]];
    }
}

- (NSIndexPath *)getCurrentIndexPath {
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    UITableView *tableView = (UITableView *)view;
    NSIndexPath *indexPath = [tableView indexPathForCell: self];
    
    return indexPath;
}

@end
