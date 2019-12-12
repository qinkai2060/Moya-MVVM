//
//  WARPhotoCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import <UIKit/UIKit.h>
#import "WARGroupModel.h"
#define CellW    ([UIScreen mainScreen].bounds.size.width - 60)/3

typedef NS_ENUM(NSInteger,WARPhotoCellType) {
    WARPhotoCellTypeNewCreat,
    WARPhotoCellTypePhotoGroup,
};

@interface WARPhotoCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *coverPaperImgV;
@property(nonatomic,strong)UIImageView *lockimgV;
@property(nonatomic,strong)UIView *maskV;
@property(nonatomic,strong)UILabel *countLb;
@property(nonatomic,strong)UILabel *titlelb;
@property(nonatomic,strong)UILabel *newCreatlb;
@property(nonatomic,strong)UILabel *Statelb;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,assign)WARPhotoCellType type;
@property(nonatomic,strong)WARGroupModel *model;
@end
