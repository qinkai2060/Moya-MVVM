//
//  WARUserDiaryActivityCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import "WARUserDiaryActivityCell.h"


#import "WARMacros.h"
#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "WARUserDiaryTweetCell.h"

#import "WARUserDiaryModel.h"



#define kWARUserDiaryActivityPhotoCollectionCellId @"kWARUserDiaryActivityPhotoCollectionCellId"

@interface WARUserDiaryActivityCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *containerV;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIImageView *actImgV;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *activityV;
@property (nonatomic, strong) UILabel *actTimeLab;
@property (nonatomic, strong) UILabel *actPlaceLab;
@property (nonatomic, strong) UIImageView *actJoinerImgV;
@property (nonatomic, strong) UILabel *actJoinerCountLab;

@property (nonatomic, strong) UIView *bottomContainerV;
@property (nonatomic, strong) UIImageView *locationImgV;
@property (nonatomic, strong) UILabel *locationLab;
@property (nonatomic, strong) UIImageView *thumbUpImgV;
@property (nonatomic, strong) UILabel *thumbUpLab;
@property (nonatomic, strong) UIImageView *commentsImgV;
@property (nonatomic, strong) UILabel *commentsLab;

@property (nonatomic, strong) UIBezierPath* maskPath;
@property (nonatomic, strong) CAShapeLayer* maskLayer;
@end
@implementation WARUserDiaryActivityCell

- (void)setUpUI{
    [super setUpUI];
    
    
    [self.contentView addSubview:self.dayOrNightImgV];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.tweetImgV];

    [self.contentView addSubview:self.containerV];
    [self.containerV addSubview:self.textLab];
    [self.containerV addSubview:self.activityV];
    [self.containerV addSubview:self.bottomContainerV];
    
    [self.activityV addSubview:self.actTimeLab];
    [self.activityV addSubview:self.actPlaceLab];
    [self.activityV addSubview:self.actJoinerImgV];
    [self.activityV addSubview:self.actJoinerCountLab];
    
    [self.containerV addSubview:self.actImgV];
    [self.containerV addSubview:self.collectionView];
    
    [self.bottomContainerV addSubview:self.locationImgV];
    [self.bottomContainerV addSubview:self.locationLab];
    [self.bottomContainerV addSubview:self.thumbUpImgV];
    [self.bottomContainerV addSubview:self.thumbUpLab];
    [self.bottomContainerV addSubview:self.commentsImgV];
    [self.bottomContainerV addSubview:self.commentsLab];
    
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
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kLeftMagrin);
        make.right.mas_lessThanOrEqualTo(-kLeftMagrin);
    }];
    
    
    [self.activityV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLab.mas_bottom).offset(10);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
    }];
    
    [self.actTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    
    [self.actPlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actTimeLab.mas_right).offset(30);
        make.top.bottom.equalTo(self.actTimeLab);
    }];
    
    [self.actJoinerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actTimeLab);
        make.right.equalTo(self.actJoinerCountLab.mas_left).offset(-7);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [self.actJoinerCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(self.actTimeLab);
    }];
    
    
    [self.actImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kPhotosMaxHeight);
        make.top.equalTo(self.activityV.mas_bottom).offset(10);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.height.mas_equalTo(kPhotosMaxHeight);
    }];
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activityV.mas_bottom).offset(10);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.height.mas_equalTo(kPhotosMaxHeight);
    }];
    
    
    [self.bottomContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(9);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.bottom.mas_equalTo(-kLeftMagrin);
    }];
    
    
    [self.locationImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kSmallIconSize);
        make.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImgV.mas_right).offset(8);
        make.centerY.equalTo(self.locationImgV);
    }];
    
    [self.thumbUpImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kSmallIconSize);
        make.centerY.equalTo(self.locationImgV);
        make.right.equalTo(self.thumbUpLab.mas_left).offset(-4);
    }];
    
    [self.thumbUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationImgV);
        make.right.equalTo(self.commentsImgV.mas_left).offset(-30);
    }];
    
    [self.commentsImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kSmallIconSize);
        make.centerY.equalTo(self.locationImgV);
        make.right.equalTo(self.commentsLab.mas_left).offset(-6);
    }];
    
    [self.commentsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(self.locationImgV);
    }];
    
    
    [self containerVWithCorner];
    
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
    
    
    self.textLab.text = model.diaryText;
    
    self.actTimeLab.text = [NSString stringWithFormat:WARLocalizedString(@"%@开始"),model.showActivityTime];
    self.actPlaceLab.text = model.activityPlace;
    self.actJoinerCountLab.text = model.joinerCount;
    
    self.locationImgV.image = model.diaryLocationImg;
    self.locationLab.text = model.diaryLocationStr;
    

    self.thumbUpLab.text = [NSString stringWithFormat:@"%ld",model.thumpUpCount];
    self.commentsLab.text = [NSString stringWithFormat:@"%ld",model.commentsCount];
    
    self.photos = model.photos;
    if(self.photos.count > 0){
        if (self.photos.count == 1) {
            self.collectionView.hidden = YES;
            self.actImgV.hidden = NO;
            NSString *imgId = self.photos.firstObject;
            [self.actImgV sd_setImageWithURL:kPhotoUrlWithImageSize(kOneImgSize, imgId)];
            
        }else{
            self.collectionView.hidden = NO;
            self.actImgV.hidden = YES;
            
            CGFloat height = [self updateCollectionViewHeight];
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.textLab.mas_bottom).offset(10);
                make.left.mas_equalTo(kLeftMagrin);
                make.right.mas_equalTo(-kLeftMagrin);
                make.height.mas_equalTo(height);
            }];
            
            self.photos = model.photos;
            [self.collectionView reloadData];
        }
        
    }else{
        
        self.actImgV.hidden = YES;
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
    WARUserDiaryTweetPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARUserDiaryActivityPhotoCollectionCellId forIndexPath:indexPath];
    NSString *imgId = self.photos[indexPath.row];
    [cell.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(kCollectionCellSize, imgId)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - getter methods
- (UIView *)activityV{
    if (!_activityV) {
        _activityV = [[UIView alloc]init];
    }
    return _activityV;
}

- (UILabel *)actTimeLab{
    if (!_actTimeLab) {
        _actTimeLab = [[UILabel alloc]init];
        _actTimeLab.font = kFont(11);
        _actTimeLab.textColor = RGB(153, 153, 153);
    }
    return _actTimeLab;
}

- (UILabel *)actPlaceLab{
    if (!_actPlaceLab) {
        _actPlaceLab = [[UILabel alloc]init];
        _actPlaceLab.font = kFont(11);
        _actPlaceLab.textColor = RGB(153, 153, 153);
    }
    return _actPlaceLab;
}

- (UIImageView *)actImgV{
    if (!_actImgV) {
        _actImgV = [[UIImageView alloc]init];
    }
    return _actImgV;
}

- (UIImageView *)actJoinerImgV{
    if (!_actJoinerImgV) {
        _actJoinerImgV = [[UIImageView alloc]init];
        _actJoinerImgV.image = [UIImage war_imageName:@"personal_people" curClass:self curBundle:kWARProfileBundle];
    }
    return _actJoinerImgV;
}

- (UILabel *)actJoinerCountLab{
    if (!_actJoinerCountLab) {
        _actJoinerCountLab = [[UILabel alloc]init];
        _actJoinerCountLab.font = kFont(11);
        _actJoinerCountLab.textColor = RGB(153, 153, 153);
    }
    return _actJoinerCountLab;
}

- (UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
        _containerV.backgroundColor = kColor(whiteColor);
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

- (UIView *)bottomContainerV{
    if (!_bottomContainerV) {
        _bottomContainerV = [[UIView alloc]init];
    }
    return _bottomContainerV;
}

- (UIImageView *)thumbUpImgV{
    if (!_thumbUpImgV) {
        _thumbUpImgV = [[UIImageView alloc]init];
        _thumbUpImgV.image = [UIImage war_imageName:@"personal_zan" curClass:self curBundle:kWARProfileBundle];
    }
    return _thumbUpImgV;
}

- (UILabel *)thumbUpLab{
    if (!_thumbUpLab) {
        _thumbUpLab = [[UILabel alloc]init];
        _thumbUpLab.font = kFont(12);
        _thumbUpLab.textColor = RGB(153, 153, 153);
    }
    return _thumbUpLab;
}

- (UILabel *)commentsLab{
    if (!_commentsLab) {
        _commentsLab = [[UILabel alloc]init];
        _commentsLab.font = kFont(12);
        _commentsLab.textColor = RGB(153, 153, 153);
    }
    return _commentsLab;
}

- (UIImageView *)commentsImgV{
    if (!_commentsImgV) {
        _commentsImgV = [[UIImageView alloc]init];
        _commentsImgV.image = [UIImage war_imageName:@"personal_comment" curClass:self curBundle:kWARProfileBundle];
    }
    return _commentsImgV;
}

- (UIImageView *)locationImgV{
    if (!_locationImgV) {
        _locationImgV = [[UIImageView alloc]init];
    }
    return _locationImgV;
}

- (UILabel *)locationLab{
    if (!_locationLab) {
        _locationLab = [[UILabel alloc]init];
        _locationLab.font = kFont(12);
        _locationLab.textColor = RGB(153, 153, 153);
    }
    return _locationLab;
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
        [_collectionView registerClass:[WARUserDiaryTweetPhotoCollectionCell class] forCellWithReuseIdentifier:kWARUserDiaryActivityPhotoCollectionCellId];
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
