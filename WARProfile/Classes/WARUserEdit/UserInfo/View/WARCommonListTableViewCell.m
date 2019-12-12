//
//  WARCommonListTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import "WARCommonListTableViewCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARTagCollectionView.h"
#import "WARTextTagCollectionView.h"
#import "WARCornerButtonView.h"


#import "WARUserProvinceModel.h"

@interface WARCommonListTableViewCell()
@property (nonatomic, strong) UIImageView *addImgV;

@property (nonatomic, strong) UILabel *textLab;

@end
@implementation WARCommonListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        
        [self.contentView addSubview:self.addImgV];
        [self.contentView addSubview:self.createLab];
        
        [self.contentView addSubview:self.textLab];
        [self.contentView addSubview:self.rightImgV];
        
        
        [self.addImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 13));
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.createLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addImgV.mas_right).offset(6);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        
    }
    return self;
}

- (void)setType:(WARCommonListTableViewCellType)type{
    switch (type) {
        case WARCommonListTableViewCellTypeOfCreate:
            {
                self.createLab.hidden = NO;
                self.addImgV.hidden = NO;
                self.textLab.hidden = YES;
                self.rightImgV.hidden = YES;
            }
            break;
        case WARCommonListTableViewCellTypeOfNormal:
            {
                self.createLab.hidden = YES;
                self.addImgV.hidden = YES;
                self.textLab.hidden = NO;
                self.rightImgV.hidden = YES;
            }
            break;
        default:
            break;
    }
}


- (void)configureText:(NSString *)text{
    self.textLab.text = text;
}

- (void)configureSelectStateWithArray:(NSArray *)array isMulti:(BOOL)isMulti {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:self.textLab.text]) {
            self.rightImgV.hidden = NO;
        }
    }];
    if (isMulti) {
        self.rightImgV.image = [UIImage war_imageName:@"friendset_select" curClass:self curBundle:@"WARContacts.bundle"];
        
        [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
    }else {
        self.rightImgV.image = [[UIImage war_imageName:@"person_hom" curClass:self curBundle:@"WARProfile.bundle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
    }
}

#pragma mark - getter methods
- (UIImageView *)addImgV{
    if (!_addImgV) {
        _addImgV = [[UIImageView alloc]init];
        _addImgV.image = [[UIImage war_imageName:@"userinfo_add" curClass:self curBundle:@"WARProfile.bundle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _addImgV.tintColor = ThemeColor;
    }
    return _addImgV;
}

- (UILabel *)createLab{
    if (!_createLab) {
        _createLab = [[UILabel alloc]init];
        _createLab.font = kFont(16);
        _createLab.textColor = ThemeColor;
        _createLab.text = WARLocalizedString(@"创建自己的标签");
    }
    return _createLab;
}


- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(16);
        _textLab.textColor = TextColor;
    }
    return _textLab;
}
- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.tintColor = ThemeColor;
    }
    return _rightImgV;
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








@interface WAREditTagsTableCell()<WARTextTagCollectionViewDelegate,WARCornerButtonViewDelegate>
@property (nonatomic, strong) WARTextTagCollectionView *tagView;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) WARCornerButtonView *cornerBtn;
//@property (nonatomic, assign) BOOL  isEdit;

@end

@implementation WAREditTagsTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    
//    _cornerBtn = [[WARCornerButtonView alloc] initWithButtonType:WARCornerButtonViewTypeOfBorder bounds:CGRectMake(0, 0, 50, 18) cornerRadius:5];
//    [_cornerBtn titleText:WARLocalizedString(@"编辑")];
//    [_cornerBtn titleFont:kFont(11)];
//    _cornerBtn.delegate = self;
//
//    [self.contentView addSubview:self.textLab];
//    [self.contentView addSubview:self.cornerBtn];
    [self.contentView addSubview:self.tagView];
 
//    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(15);
//        make.left.mas_equalTo(12);
//        make.right.mas_equalTo(-12);
//    }];
//
//    [self.cornerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(50, 18));
//        make.right.mas_equalTo(-12);
//        make.centerY.equalTo(self.textLab);
//    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = SeparatorColor;
    [self.contentView addSubview:lineV];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
    
    
    [self.tagView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

}


- (void)configureDataArr:(NSArray *)dataArr{
    if (self.tagView.allTags) {
        [self.tagView removeAllTags];
    }
    
    for (NSString *item in dataArr) {
        [self.tagView addTag:item];
    }
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    self.tagView.enableCloseButton = isEdit;
    if (!isEdit) {
        if (self.didFinishEditBlock) {
            self.didFinishEditBlock();
        }
    }
}

#pragma mark - WARTextTagCollectionViewDelegate
- (BOOL)textTagCollectionView:(WARTextTagCollectionView *)textTagCollectionView canTapTag:(NSString *)tagText atIndex:(NSUInteger)index currentSelected:(BOOL)currentSelected{
    return YES;
}

- (void)textTagCollectionView:(WARTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{
    if (self.isEdit) {
        if (selected) {
            [self.tagView removeTagAtIndex:index];
            if (self.didSelectTagBlock) {
                self.didSelectTagBlock(index);
            }
        }
    }
}


-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    [_tagView layoutIfNeeded];
    [_tagView invalidateIntrinsicContentSize];
    return [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
}


#pragma mark - WARCornerButtonViewDelegate
- (void)cornerButtonDidClickWithButtonActionString:(NSString *)string{
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        [self.cornerBtn titleText:WARLocalizedString(@"完成")];
    }else{
        if (self.didFinishEditBlock) {
            self.didFinishEditBlock();
        }
        [self.cornerBtn titleText:WARLocalizedString(@"编辑")];
    }

}


#pragma mark - getter methods
- (WARTextTagCollectionView *)tagView {
    if (!_tagView) {
        _tagView = [WARTextTagCollectionView new];
        
        WARTextTagConfig *config = [[WARTextTagConfig alloc] init];
        config.tagTextFont =  kFont(14);
        config.tagShadowOffset = CGSizeZero;
        config.tagShadowRadius = 0.0f;
        config.tagShadowOpacity = 0.0f;
        config.tagTextColor = ThreeLevelTextColor;
//        config.tagBorderWidth = 0.5;
//        config.tagBorderColor = DisabledTextColor;
        config.tagBackgroundColor = BackgroundDefaultColor;
        config.tagCornerRadius = 4;
        
        _tagView.defaultConfig = config;
        _tagView.userInteractionEnabled = YES;
        _tagView.horizontalSpacing = 5.0;
        _tagView.verticalSpacing = 5.0;
        _tagView.delegate = self;
        _tagView.enableTagSelection = NO;
        _tagView.enableCloseButton = NO;
    }
    
    return _tagView;
}

-(UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(14);
        _textLab.textColor = COLOR_WORD_GRAY_9;
        _textLab.text = WARLocalizedString(@"点击\"编辑\"可对标签进行删除");
    }
    return _textLab;
}

@end





@interface WARInputTableCell()

@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIImageView *rightImgV;

@end
@implementation WARInputTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.textLab];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = COLOR_WORD_GRAY_E;
    [self.contentView addSubview:lineV];
    
    [self.contentView addSubview:self.rightImgV];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.top.equalTo(self.textLab.mas_bottom).offset(9);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(0.5);
    }];

    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(8, 13));
    }];
}


-(UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(14);
        _textLab.textColor = COLOR_WORD_GRAY_9;
        _textLab.text = WARLocalizedString(@"请输入标签");
    }
    return _textLab;
}

- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage war_imageName:@"more" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _rightImgV;
}

@end
