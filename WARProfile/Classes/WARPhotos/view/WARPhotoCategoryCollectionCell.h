//
//  WARPhotoCategoryCollectionCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import <UIKit/UIKit.h>
#import "WARPhotoListModel.h"
#import "WARPhotoVideoListModel.h"
#import "WARGroupModel.h"
@interface WARPhotoCategoryCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *photoImgV;
@property (nonatomic,strong) UIImageView *maskView;
@property (nonatomic,strong) UILabel *timeDurationlb;
@property (nonatomic,strong) UIImageView *videoimage;
@property (nonatomic,strong) WARPictureModel *albumModel;
@property (nonatomic,strong) WARPictureModel *videoModel;
@end
