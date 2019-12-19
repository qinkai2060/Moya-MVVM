//
//  SpTypesSearchListCollectionViewCell.h
//  housebank
//
//  Created by liqianhong on 2019/1/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetProductListByConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SpTypesSearchListOneCollectionViewCell;
// 进店
typedef void(^toShopBtnClick)(SpTypesSearchListOneCollectionViewCell *cell,NSInteger cellIndexRow);

@interface SpTypesSearchListOneCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) toShopBtnClick toShopBtnClickBlock;

- (void)refreshCellWithModel:(GetProductListByConditionModel *)model;

@end

NS_ASSUME_NONNULL_END
