//
//  HFHeaderCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFYDDetialDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFHeaderCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;//HFYDImagModel
@property(nonatomic,strong)HFYDImagModel *model;
- (void)domessageData;
@end

NS_ASSUME_NONNULL_END
