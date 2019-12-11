//
//  WARPhotosCollectionCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/27.
//

#import <UIKit/UIKit.h>
#import "TZAssetModel.h"
@interface WARPhotosCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *loacalPhotoImgV;
@property(nonatomic,strong)UILabel *textlb;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;
@property (nonatomic,strong) TZAssetModel *model;
@end
