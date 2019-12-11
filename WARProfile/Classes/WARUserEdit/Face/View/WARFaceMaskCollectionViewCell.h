//
//  WARFaceMaskCollectionViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/21.
//

#import <UIKit/UIKit.h>


typedef void(^WARFaceMaskCollectionViewCellDidLongPreBlock)();

@interface WARFaceMaskCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)WARFaceMaskCollectionViewCellDidLongPreBlock didLongPreBlock;
@property (nonatomic, strong) UIImageView *faceImgV;
@property (nonatomic, strong) UILabel *faceLab;

@end
