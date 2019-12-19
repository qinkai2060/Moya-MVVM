//
//  CategoryRightCollectionViewCell.h
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypeFirstLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpTypesRightCollectionViewCell : UICollectionViewCell

- (void)refreshCellWithModel:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
