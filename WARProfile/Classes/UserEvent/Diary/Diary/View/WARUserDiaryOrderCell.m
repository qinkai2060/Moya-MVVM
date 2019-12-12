//
//  WARUserDiaryOrderCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import "WARUserDiaryOrderCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "WARUserDiaryTweetCell.h"

#import "WARUserDiaryModel.h"


#define kWARUserDiaryOrderPhotoCollectionCellId @"kWARUserDiaryOrderPhotoCollectionCellId"

@interface WARUserDiaryOrderCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *containerV;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIImageView *oneImgV;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIBezierPath* maskPath;
@property (nonatomic, strong) CAShapeLayer* maskLayer;
@end

@implementation WARUserDiaryOrderCell

- (void)setUpUI{
    [super setUpUI];
    
    
    [self.contentView addSubview:self.dayOrNightImgV];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.tweetImgV];
    
    [self.contentView addSubview:self.containerV];


    [self.containerV addSubview:self.textLab];
    [self.containerV addSubview:self.collectionView];
    [self.containerV addSubview:self.oneImgV];
    
    
    [self.dayOrNightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kSmallIconSize);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(23);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayOrNightImgV.mas_right).offset(26);
        make.centerY.equalTo(self.dayOrNightImgV);
    }];
    
    [self.tweetImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.left.equalTo(self.timeLab.mas_right).offset(10);
        make.centerY.equalTo(self.dayOrNightImgV);
    }];
    
    [self.containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayOrNightImgV.mas_bottom).offset(14);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.bottom.mas_equalTo(-20);
    }];
//    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.containerV);
//    }];
//    bg.image = [UIImage imageNamed:@"WARProfile.bundle/personalinformation_ty"];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kLeftMagrin);
        make.right.mas_lessThanOrEqualTo(-kLeftMagrin);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLab.mas_bottom).offset(10);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.height.mas_equalTo(kPhotosMaxHeight);
        make.bottom.mas_equalTo(-kLeftMagrin);
    }];
    
    [self.oneImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLab.mas_bottom).offset(10);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.height.mas_equalTo(kPhotosMaxHeight);
        make.bottom.mas_equalTo(-kLeftMagrin);
    }];
    
  //  [self containerVWithCorner];
    
}

- (void)containerVWithCorner{
    CGFloat width = kScreenWidth-kLeftMagrin*2;
    CGFloat height = [self.containerV systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:5];
    self.maskLayer = [CAShapeLayer new];
    self.maskLayer.frame = CGRectMake(0, 0, width, height);
    self.maskLayer.path = self.maskPath.CGPath;
    self.containerV.layer.mask = self.maskLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.maskPath removeAllPoints];
    [self.maskLayer removeAllAnimations];
    [self.maskLayer removeFromSuperlayer];
    self.maskLayer = nil;
    self.maskPath = nil;
    [self containerVWithCorner];
}

- (void)configureModel:(WARUserDiaryEventModel *)model{
    
    self.dayOrNightImgV.image = model.diaryTimeImg;
    self.tweetImgV.image = model.diaryTypeImg;
    self.timeLab.text = model.showTimeStr;
    
    double price = [model.orderPrice doubleValue];
    self.textLab.text = [NSString stringWithFormat:WARLocalizedString(@"购买了%@ ¥%.2f"),model.orderTitle,price];
    
    
    
    self.photos = model.photos;
    if(self.photos.count > 0){
        if (self.photos.count == 1) {
            self.collectionView.hidden = YES;
            self.oneImgV.hidden = NO;
            NSString *imgId = self.photos.firstObject;
            [self.oneImgV sd_setImageWithURL:kPhotoUrlWithImageSize(kOneImgSize, imgId)];
            
        }else{
            self.collectionView.hidden = NO;
            self.oneImgV.hidden = YES;
            
            CGFloat height = [self updateCollectionViewHeight];
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.textLab.mas_bottom).offset(10);
                make.left.mas_equalTo(kLeftMagrin);
                make.right.mas_equalTo(-kLeftMagrin);
                make.height.mas_equalTo(height);
                make.bottom.mas_equalTo(-kLeftMagrin);
            }];
            
            self.photos = model.photos;
            [self.collectionView reloadData];
            
        }
        
    }else{
        
        self.oneImgV.hidden = YES;
        self.collectionView.hidden = YES;
    }
}


#pragma mark - collection view delegate & data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.photos.count > kCollectionViewMaxItemCount) {
        return kCollectionViewMaxItemCount;
    }
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARUserDiaryTweetPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARUserDiaryOrderPhotoCollectionCellId forIndexPath:indexPath];
    NSString *imgId = self.photos[indexPath.row];
    
    [cell.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(kCollectionCellSize, imgId) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.photoImgV.image = image;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - getter methods
- (UIImageView *)oneImgV{
    if (!_oneImgV) {
        _oneImgV = [[UIImageView alloc]init];
    }
    return _oneImgV;
}


- (UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
        _containerV.backgroundColor = kColor(clearColor);
    }
    return _containerV;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(14);
        _textLab.textColor = RGB(51, 51, 51);
    }
    return _textLab;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize =kCollectionCellSize;
        layout.minimumLineSpacing = kPhotoItemMagrin;
        layout.minimumInteritemSpacing = kPhotoItemMagrin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WARUserDiaryTweetPhotoCollectionCell class] forCellWithReuseIdentifier:kWARUserDiaryOrderPhotoCollectionCellId];
        _collectionView.backgroundColor = kColor(clearColor);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;

    }
    return _collectionView;
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
