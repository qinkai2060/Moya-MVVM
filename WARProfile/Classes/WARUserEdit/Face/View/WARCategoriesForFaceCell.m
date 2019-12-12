//
//  WARCategoriesForFaceCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/22.
//

#import "WARCategoriesForFaceCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARUIHelper.h"

#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "UIImageView+WebCache.h"

#import "WARContactCategoryModel.h"

@interface WARCategoriesForFaceCell()<TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UIImageView *rightImgV;

@end
@implementation WARCategoriesForFaceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.rightImgV];

    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.left.equalTo(self.tagView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(8, 15));
        make.centerY.equalTo(self.tagView);
    }];
    
    [self.tagView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setCellType:(WARCategoriesForFaceCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case WARCategoriesForFaceCellTypeOfRightImg:{
            self.tagView.hidden = NO;
            self.rightImgV.hidden = NO;
            
            [self.rightImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-14);
                make.left.equalTo(self.tagView.mas_right).offset(20);
                make.size.mas_equalTo(CGSizeMake(8, 15));
                make.centerY.equalTo(self.tagView);
            }];
            
            TTGTextTagConfig *config = [[TTGTextTagConfig alloc] init];
            config.tagTextFont =  kFont(14);
            config.tagShadowOffset = CGSizeZero;
            config.tagShadowRadius = 0.0f;
            config.tagShadowOpacity = 0.0f;
            config.tagTextColor = RGB(153, 153, 153);
            config.tagBorderWidth = 0.5;
            config.tagBorderColor = RGB(217, 217, 217);
            config.tagBackgroundColor = [UIColor whiteColor];
            config.tagCornerRadius = 3;
            
            _tagView.defaultConfig = config;
            _tagView.userInteractionEnabled = NO;
            
            
        }
            break;
        case WARCategoriesForFaceCellTypeOfDifferentState:{
            self.tagView.hidden = NO;
            
            self.rightImgV.hidden = YES;
            
            [self.rightImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.left.equalTo(self.tagView.mas_right).offset(-13);
            }];
            

            TTGTextTagConfig *config = [[TTGTextTagConfig alloc] init];
            config.tagTextFont =  kFont(14);
            config.tagShadowOffset = CGSizeZero;
            config.tagShadowRadius = 0.0f;
            config.tagShadowOpacity = 0.0f;
            config.tagTextColor = HEXCOLOR(0x01d8b7);
            config.tagBorderWidth = 0.5;
            config.tagBorderColor = HEXCOLOR(0x01d8b7);
            config.tagBackgroundColor = [UIColor whiteColor];
            config.tagCornerRadius = 3;
            config.tagSelectedTextColor =RGB(153, 153, 153);
            config.tagSelectedBorderColor =RGB(217, 217, 217);
            config.tagSelectedBackgroundColor =[UIColor whiteColor];
            
            _tagView.defaultConfig = config;
            _tagView.userInteractionEnabled = YES;
            _tagView.delegate = self;
            
        }
            
            break;
        
        default:{
            self.tagView.hidden = NO;
            self.rightImgV.hidden = YES;
            
            
            [self.rightImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.left.equalTo(self.tagView.mas_right).offset(-13);
            }];
            
            TTGTextTagConfig *config = [[TTGTextTagConfig alloc] init];
            config.tagTextFont =  kFont(14);
            config.tagShadowOffset = CGSizeZero;
            config.tagShadowRadius = 0.0f;
            config.tagShadowOpacity = 0.0f;
            config.tagTextColor = HEXCOLOR(0x01d8b7);
            config.tagBorderWidth = 0.5;
            config.tagBorderColor = HEXCOLOR(0x01d8b7);
            config.tagBackgroundColor = [UIColor whiteColor];
            config.tagCornerRadius = 3;
            config.tagSelectedTextColor =HEXCOLOR(0x01d8b7);
            config.tagSelectedBorderColor =HEXCOLOR(0x01d8b7);
            config.tagSelectedBackgroundColor =[UIColor whiteColor];
            
            _tagView.defaultConfig = config;
            _tagView.userInteractionEnabled = YES;
            _tagView.delegate = self;

        }
            break;
    }
    
}


- (void)configureCategories:(NSArray *)categories{
    
    if (self.tagView.allTags.count) {
        [self.tagView removeAllTags];
    }

    
    for (int i = 0; i < categories.count; i++) {
        WARContactCategoryModel *item = categories[i];
        NSString *string = [NSString stringWithFormat:@"%@(%ld)",item.defaultCategoryShowName,item.categoryNum];
        [self.tagView addTag:string];
        if (self.cellType == WARCategoriesForFaceCellTypeOfDifferentState) {
            if (item.isSelected) {
                [self.tagView setTagAtIndex:i selected:YES];
            }
        }
    }
    

}


#pragma mark - TTGTextTagCollectionViewDelegate
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView canTapTag:(NSString *)tagText atIndex:(NSUInteger)index currentSelected:(BOOL)currentSelected{
    return !currentSelected;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{
    if (self.cellType == WARCategoriesForFaceCellTypeOfDifferentState) {
        if (self.differentStateDidSelectBlock) {
            self.differentStateDidSelectBlock(index);
        }
    }else if (self.cellType == WARCategoriesForFaceCellTypeOfNormal){
        if (self.normalDidSelectBlock) {
            self.normalDidSelectBlock(index);
        }
    }
}





-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    [_tagView layoutIfNeeded];
    [_tagView invalidateIntrinsicContentSize];
    return [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
}

#pragma mark - getter methods
- (TTGTextTagCollectionView *)tagView {
    if (!_tagView) {
        _tagView = [TTGTextTagCollectionView new];
        
        TTGTextTagConfig *config = [[TTGTextTagConfig alloc] init];
        config.tagTextFont =  kFont(14);
        config.tagShadowOffset = CGSizeZero;
        config.tagShadowRadius = 0.0f;
        config.tagShadowOpacity = 0.0f;
        config.tagTextColor = RGB(153, 153, 153);
        config.tagBorderWidth = 0.5;
        config.tagBorderColor = RGB(217, 217, 217);
        config.tagBackgroundColor = [UIColor whiteColor];
        config.tagCornerRadius = 3;
        
        _tagView.defaultConfig = config;
        _tagView.userInteractionEnabled = NO;
        _tagView.horizontalSpacing = 10.0;
        _tagView.verticalSpacing = 10.0;

    }
    
    return _tagView;
}

- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage war_imageName:@"list_more" curClass:self curBundle:@"WARProfile.bundle"];
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


@interface WARUserBgImgForFaceCell()
@property (nonatomic, strong) UIImageView *bgImgV;
@end
@implementation WARUserBgImgForFaceCell{
    CGFloat bgImgHeight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
    bgImgHeight = kScreenWidth*350/750;

    [self.contentView addSubview:self.bgImgV];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(bgImgHeight);
    }];
    
}

- (void)configureBgImgWithBgImgId:(NSString *)bgImgId{
    CGSize size = CGSizeMake(kScreenWidth, bgImgHeight);
    [self.bgImgV sd_setImageWithURL:kPhotoUrlWithImageSize(size, bgImgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
    
}

- (void)longPreImgAction:(UILongPressGestureRecognizer *)longPre{
    if (self.didLongPreImgBlock) {
        self.didLongPreImgBlock();
    }
}

#pragma mark - getter methods
- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc]init];
        _bgImgV.contentMode = UIViewContentModeScaleAspectFill;
        UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPreImgAction:)];
        [_bgImgV addGestureRecognizer:longPre];
    }
    return _bgImgV;
}
@end




@interface WARNoCategoriesForFaceCell()
@property (nonatomic, strong) UIImageView *rightImgV;

@property (nonatomic, strong) UILabel *aLab;
@property (nonatomic, strong) UILabel *bLab;

@end
@implementation WARNoCategoriesForFaceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI{

    [self.contentView addSubview:self.aLab];
    [self.contentView addSubview:self.bLab];
    [self.contentView addSubview:self.rightImgV];

    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(8, 15));
        make.centerY.equalTo(self.aLab);
    }];
    
    [self.aLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.bLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImgV.mas_left).offset(-20);
        make.left.equalTo(self.aLab.mas_right);
        make.top.bottom.equalTo(self.aLab);
    }];
    

    
}

#pragma mark - getter methods
- (UILabel *)aLab{
    if (!_aLab) {
        _aLab = [[UILabel alloc]init];
        _aLab.font = kFont(14);
        _aLab.textColor =RGB(153, 153, 153);
        _aLab.text = WARLocalizedString(@"分组");
    }
    return _aLab;
}

- (UILabel *)bLab{
    if (!_bLab) {
        _bLab = [[UILabel alloc]init];
        _bLab.font = kFont(14);
        _bLab.textColor =RGB(153, 153, 153);
        _bLab.text = WARLocalizedString(@"请选择面具对应分组");
    }
    return _bLab;
}

- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage war_imageName:@"list_more" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _rightImgV;
}

@end
