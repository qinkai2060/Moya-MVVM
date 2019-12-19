//
//  HFBannerNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFAdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFBannerNewCell : HFHomeNewBaseCell
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *adImageView;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)HFAdModel *admodel;
@end

NS_ASSUME_NONNULL_END
