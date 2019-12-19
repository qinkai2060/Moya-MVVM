//
//  HFPriceFixledRangCollectionCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterPriceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFPriceFixledRangCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)HFFilterPriceModel *model;
- (void)doSomething;
@end

NS_ASSUME_NONNULL_END
