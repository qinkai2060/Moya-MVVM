//
//  HFFashionSmallCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/4.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFModuleSixView.h"
#import "HFModuleSixModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleSixSmallCell : UICollectionViewCell
@property(nonatomic,strong)HFModuleSixView *soneV;
@property(nonatomic,strong)HFModuleSixModel *model;
- (void)doMessgaSommthing;
@end

NS_ASSUME_NONNULL_END
