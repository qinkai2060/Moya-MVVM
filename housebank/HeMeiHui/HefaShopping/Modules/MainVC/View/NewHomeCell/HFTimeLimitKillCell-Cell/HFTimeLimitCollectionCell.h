//
//  HFTimeLimitCollectionCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HFCollectionBaseCell.h"
#import "HFTimeLimitModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFTimeLimitCollectionCell : UICollectionViewCell
@property(nonatomic,strong)HFTimeLimitSmallModel *smallModel;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *priceLb;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END
