//
//  WARCategoryCollectionViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import <UIKit/UIKit.h>

@class WARContactCategoryModel;

typedef void(^WARCategoryCollectionViewCellDidLongPreBlock)();
@interface WARCategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy)WARCategoryCollectionViewCellDidLongPreBlock didLongPreBlock;

- (void)configureCategoryModel:(WARContactCategoryModel *)categoryModel;
@end
