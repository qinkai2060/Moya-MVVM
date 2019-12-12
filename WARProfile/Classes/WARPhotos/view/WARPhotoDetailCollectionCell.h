//
//  WARPhotoDetailCollectionCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import <UIKit/UIKit.h>
#import "WARPhotoDetailView.h"
@class WARPictureModel;
@class WARPhotoDetailCollectionCell;
typedef void (^WARPhotoDetailCollectionCellBlock)(UIButton *btn,WARPictureModel *model);
@interface WARPhotoDetailCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *photoImgV;
@property(nonatomic,strong)UIButton *selectimage;
@property(nonatomic,strong)UIView *maskV;
@property(nonatomic,strong)UIImageView *cameraimgV;
@property(nonatomic,strong)UILabel *durationlb;
@property(nonatomic,copy) NSString *idenfinerStr;
@property (nonatomic,strong) UIImageView *maskView;
@property (nonatomic,strong) UILabel *timeDurationlb;
@property(nonatomic,copy)WARPhotoDetailCollectionCellBlock block;
@property(nonatomic,strong)WARPictureModel *model;
- (void)setCSSStyle:(WARPhotoDetailViewType)type;
@end
