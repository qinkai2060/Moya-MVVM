//
//  SpTypesSearchListTableViewCell.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetProductListByConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpTypesSearchListTableViewCell : UITableViewCell

- (void)refreshCellWithModel:(GetProductListByConditionModel *)model;

@end

NS_ASSUME_NONNULL_END
