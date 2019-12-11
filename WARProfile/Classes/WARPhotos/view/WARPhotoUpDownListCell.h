//
//  WARPhotoUpDownListCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/27.
//

#import <UIKit/UIKit.h>
#import "WARGroupModel.h"
@interface WARPhotoUpDownListCell : UITableViewCell
/**图片*/
@property (nonatomic,strong) UIImageView  *imageV;
/**图片名字*/
@property (nonatomic,strong) UILabel *imageNamelb;
/**图片日期*/
@property (nonatomic,strong) UILabel *datelb;
/**图片日期*/
@property (nonatomic,strong) UILabel *statelb;
/**进度占比*/
@property (nonatomic,strong) UILabel *progresslb;
/**图片日期*/
@property (nonatomic,strong) UIView *lineView;
/**图片日期*/
@property (nonatomic,strong) UIProgressView *progressV;
/**model*/
@property (nonatomic,strong) WARupPictureModel *model;

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;
@end
