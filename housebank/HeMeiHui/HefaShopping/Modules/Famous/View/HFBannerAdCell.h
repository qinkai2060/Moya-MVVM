//
//  HFBannerAdCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFamousGoodsBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFBannerAdCell : UICollectionViewCell
@property(nonatomic,strong)HFFamousGoodsBannerModel *model;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *textlb;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END
