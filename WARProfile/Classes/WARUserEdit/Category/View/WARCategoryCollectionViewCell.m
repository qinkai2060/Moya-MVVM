//
//  WARCategoryCollectionViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARCategoryCollectionViewCell.h"

#import "Masonry.h"
#import "WARMacros.h"
#import "WARUIHelper.h"

#import "WARContactCategoryModel.h"

@interface WARCategoryCollectionViewCell()
@property (nonatomic, strong) UIView *bigContainerV;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIView *containerV;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *countLab;

@end


@implementation WARCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kColor(clearColor);
        [self initUI];
        
        UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPreAction:)];
        longPre.minimumPressDuration = 1;
        [self addGestureRecognizer:longPre];
        
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.bigContainerV];
    [self.bigContainerV addSubview:self.imgV];
    [self.imgV addSubview:self.containerV];
    [self.containerV addSubview:self.nameLab];
    [self.containerV addSubview:self.countLab];
    
    self.imgV.backgroundColor = kColor(redColor);
    
    [self.bigContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bigContainerV);
    }];
    
    [self.containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bigContainerV);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerV);
    }];
    
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(12);
        make.centerX.equalTo(self.nameLab);
    }];
    
}

- (void)configureCategoryModel:(WARContactCategoryModel *)categoryModel{
    self.nameLab.text = categoryModel.defaultCategoryShowName;
    self.countLab.text = [NSString stringWithFormat:@"%ld",categoryModel.categoryNum];
    self.imgV.image = [WARUIHelper war_placeholderBackground];
}

- (void)longPreAction:(UILongPressGestureRecognizer *)longPre{
    if (longPre.state == UIGestureRecognizerStateEnded) {
        if (self.didLongPreBlock) {
            self.didLongPreBlock();
        }
    }
}

#pragma mark - getter methods
- (UIView *)bigContainerV{
    if (!_bigContainerV) {
        _bigContainerV = [[UIView alloc]init];
        _bigContainerV.layer.masksToBounds = YES;
        _bigContainerV.layer.cornerRadius = 3;
    }
    return _bigContainerV;
}

- (UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
        _containerV.backgroundColor = RGBA(0, 0, 0, 0.4);
    }
    return _containerV;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
    }
    return _imgV;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
//        _nameLab.backgroundColor = RGBA(0, 0, 0, 0.3);
        _nameLab.textColor = kColor(whiteColor);
        _nameLab.font = kFont(20);
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

- (UILabel *)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc]init];
        _countLab.textColor = kColor(whiteColor);
        _countLab.font = kFont(15);
        _countLab.textAlignment = NSTextAlignmentCenter;
    }
    return _countLab;
}

@end
