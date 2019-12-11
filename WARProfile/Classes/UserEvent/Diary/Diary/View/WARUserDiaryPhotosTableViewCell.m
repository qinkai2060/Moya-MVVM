//
//  WARUserDiaryPhotosTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/25.
//

#import "WARUserDiaryPhotosTableViewCell.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

#import "WARUserDiaryModel.h"

#import "WARUserDiaryTweetCell.h"

#import <Photos/Photos.h>

#define kLeftMagrin 15
#define kPhotoItemMagrin 5
#define kPhotoImgHeight ((kPhotosMaxWidth- kPhotoItemMagrin *3)/4)
#define kCollectionCellSize CGSizeMake(kPhotoImgHeight, kPhotoImgHeight)
#define kPhotosMaxHeight (kPhotoImgHeight *2 + kPhotoItemMagrin)
#define kPhotosMaxWidth (kScreenWidth - kLeftMagrin*4)
#define kOneImgSize CGSizeMake(kPhotosMaxWidth, kPhotosMaxHeight)
#define kSmallIconSize CGSizeMake(15, 15)

#define kWARUserDiaryPhotosTableViewCellCollectionCellId @"kWARUserDiaryPhotosTableViewCellCollectionCellId"


@interface WARUserDiaryPhotosTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *containerV;
@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, copy)NSArray *photos;


@property (nonatomic, strong) UIBezierPath* maskPath;
@property (nonatomic, strong) CAShapeLayer* maskLayer;

@end
@implementation WARUserDiaryPhotosTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(clearColor);
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI{
    
    [self.contentView addSubview:self.containerV];
      self.containerV.layer.contents =  [UIImage imageNamed:@"WARProfile.bundle/personalinformation_ty"];
    [self.containerV addSubview:self.collectionView];
    
    [self.containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.height.mas_equalTo(kPhotosMaxHeight);
        make.bottom.mas_equalTo(-15);
    }];
    
    
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


- (CGFloat)updateCollectionViewHeight{
    NSInteger count = self.photos.count;
    if (count == 0){
        return 0.f;
    }else {
        NSInteger row = self.photos.count/4;
        NSInteger otherItem = self.photos.count%4;
        if (otherItem) {
            row++;
        }
        return (kPhotoImgHeight *row + (row-1)*kPhotoItemMagrin);
    }
}

- (void)configureModel:(WARUserDiaryEventModel *)model{
    
    self.photos = model.photos;
    CGFloat height = [self updateCollectionViewHeight];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(kLeftMagrin);
        make.right.mas_equalTo(-kLeftMagrin);
        make.height.mas_equalTo(height);
        make.bottom.mas_equalTo(-15);
    }];
    
    [self.collectionView reloadData];
    
}


#pragma mark - collection view delegate & data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARUserDiaryTweetPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARUserDiaryPhotosTableViewCellCollectionCellId forIndexPath:indexPath];
    
//    cell.photoImgV.image = self.photos[indexPath.row];
    
    PHAsset *asset = self.photos[indexPath.row];
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                       targetSize:PHImageManagerMaximumSize
                      contentMode:PHImageContentModeAspectFill
                          options:nil
                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        cell.photoImgV.image = result;
                    }];
    
    
//    NSString *imgId = self.photos[indexPath.row];
//    [cell.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(kCollectionCellSize, imgId) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        cell.photoImgV.image = image;
//    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - getter methods
- (UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
        _containerV.backgroundColor = kColor(whiteColor);
    }
    return _containerV;
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
        [_collectionView registerClass:[WARUserDiaryTweetPhotoCollectionCell class] forCellWithReuseIdentifier:kWARUserDiaryPhotosTableViewCellCollectionCellId];
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
