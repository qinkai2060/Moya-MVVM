//
//  SpTypesSearchListTwoCollectionViewCell.h
//  housebank
//
//  Created by liqianhong on 2019/1/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetProductListByConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SpTypesSearchListTwoCollectionViewCell;
// 进店
typedef void(^toShopTwoBtnClick)(SpTypesSearchListTwoCollectionViewCell *cell,NSInteger cellIndexRow);

@interface SpTypesSearchListTwoCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) toShopTwoBtnClick toShopBtnClickBlock;

- (void)refreshCellWithModel:(GetProductListByConditionModel *)model;

@end

NS_ASSUME_NONNULL_END
