//
//  HFNewGoodVideoCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
@class HFGoodsVideoModel;
NS_ASSUME_NONNULL_BEGIN

@interface HFNewGoodVideoCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFGoodsVideoModel *admodel;
@property(nonatomic,strong)UIImageView *playBtn;
@property(nonatomic,strong)UIImageView *videoImageV;
@property(nonatomic,strong)CALayer *lineLayer;
@end

NS_ASSUME_NONNULL_END
