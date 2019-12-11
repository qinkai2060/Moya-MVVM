//
//  WARUserDiaryBaseTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/24.
//

#import <UIKit/UIKit.h>


#define kLeftMagrin 15
#define kPhotoItemMagrin 5
#define kPhotoImgHeight ((kPhotosMaxWidth- kPhotoItemMagrin *3)/4)
#define kCollectionCellSize CGSizeMake(kPhotoImgHeight, kPhotoImgHeight)
#define kPhotosMaxHeight (kPhotoImgHeight *2 + kPhotoItemMagrin)
#define kPhotosMaxWidth (kScreenWidth - kLeftMagrin*4)
#define kOneImgSize CGSizeMake(kPhotosMaxWidth, kPhotosMaxHeight)
#define kSmallIconSize CGSizeMake(15, 15)
#define kCollectionViewMaxItemCount 8

#define kWARProfileBundle @"WARProfile.bundle"


@interface WARUserDiaryBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *dayOrNightImgV;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *tweetImgV;


@property (nonatomic, copy)NSArray *photos;





- (void)setUpUI;
- (CGFloat)updateCollectionViewHeight;

@end
