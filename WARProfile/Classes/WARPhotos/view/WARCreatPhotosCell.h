//
//  WARCreatPhotosCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import <UIKit/UIKit.h>
#define CellW    ([UIScreen mainScreen].bounds.size.width - 60)/3
@interface WARCreatPhotosCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *coverPaperImgV;
@property(nonatomic,strong)UILabel *newCreatlb;
@end
