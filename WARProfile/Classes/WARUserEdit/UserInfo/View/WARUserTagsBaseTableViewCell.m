//
//  WARUserTagsTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import "WARUserTagsBaseTableViewCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"

#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface WARUserTagsBaseTableViewCell()
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIImageView *rightImgV;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation WARUserTagsBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.typeLab];
    [self.contentView addSubview:self.rightImgV];
    [self.contentView addSubview:self.bottomLine];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(19.5);
    }];
    
    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(8, 15));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - getter methods
- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage war_imageName:@"list_more" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _rightImgV;
}


- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc]init];
        _typeLab.font = kFont(16);
        _typeLab.textColor = TextColor;
    }
    return _typeLab;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = SeparatorColor;
    }
    return _bottomLine;
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




@interface WARUserTagsTableViewCell()<TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@end
@implementation WARUserTagsTableViewCell

- (void)initUI{
    [super initUI];
    
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLab.mas_right).offset(12);
        make.top.mas_equalTo(13.5);
        make.right.equalTo(self.rightImgV.mas_left).offset(-22);
        make.bottom.mas_equalTo(-13.5);
    }];
    
    
    [self.typeLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.tagView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

}


- (void)configureDataArr:(NSArray *)dataArr title:(NSString *)title{
    self.typeLab.text = title;
    
    if (self.tagView.allTags) {
        [self.tagView removeAllTags];
    }
    
    for (NSString *item in dataArr) {
        [self.tagView addTag:item];
    }
    
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView canTapTag:(NSString *)tagText atIndex:(NSUInteger)index currentSelected:(BOOL)currentSelected{
    return YES;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{

    
    
    
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
        config.tagTextColor = DisabledTextColor;
        config.tagBorderWidth = 0.5;
        config.tagBorderColor = DisabledTextColor;
        config.tagBackgroundColor = [UIColor whiteColor];
        config.tagCornerRadius = 4;
        
        _tagView.defaultConfig = config;
        _tagView.userInteractionEnabled = NO;
        _tagView.horizontalSpacing = 10.0;
        _tagView.verticalSpacing = 10.0;
        
    }
    
    return _tagView;
}
@end




@interface WARUserNoTagsTableViewCell()
@property (nonatomic, strong) UILabel *describeLab;
@end
@implementation WARUserNoTagsTableViewCell

- (void)initUI{
    [super initUI];
    
    [self.contentView addSubview:self.describeLab];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImgV.mas_left).offset(-10);
        make.centerY.equalTo(self.rightImgV);
        make.bottom.mas_equalTo(-15);
    }];
    
}

- (void)configureTitle:(NSString *)title describeText:(NSString *)describeText{
    self.typeLab.text = title;
    self.describeLab.text = describeText;
}

#pragma mark - getter methods
-(UILabel *)describeLab{
    if (!_describeLab) {
        _describeLab = [[UILabel alloc]init];
        _describeLab.font = kFont(16);
        _describeLab.textColor = COLOR_WORD_GRAY_9;
    }
    return _describeLab;
}
@end
