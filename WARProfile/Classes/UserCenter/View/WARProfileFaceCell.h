//
//  WARProfileFaceCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/16.
//

#import <UIKit/UIKit.h>
#import "WARProfileUserModel.h"

typedef void (^WARProfileFaceCellLongPressBlock) (void);

@interface WARProfileFaceCell : UICollectionViewCell
@property (nonatomic, strong)  UIImageView *imageView;
@property (nonatomic, strong)  UIView *defaultView;
@property (nonatomic, strong)  UILabel *defaultLabel;
@property (nonatomic, strong)  WARProfileMasksModel *maskModel;

@property (nonatomic, copy) WARProfileFaceCellLongPressBlock longPressBlock;

@end
