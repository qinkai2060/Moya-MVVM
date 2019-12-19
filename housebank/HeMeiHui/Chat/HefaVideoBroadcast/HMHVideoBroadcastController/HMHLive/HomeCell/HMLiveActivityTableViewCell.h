//
//  HMLiveActivityTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMLiveBaseCell.h"
#import "HFModuleTwoView.h"
#import "HMHLiveModules_4Model.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HMLiveActivityTableViewCellClick)(HMHLiveModules_4ItemsModel *model);

@interface HMLiveActivityTableViewCell : HMLiveBaseCell
@property (nonatomic, strong) HMHLiveModules_4Model *model;
@property (nonatomic, strong) UIImageView *imgViewTop;
@property (nonatomic,strong) HFModuleTwoView *imageBannerView1;
@property (nonatomic,strong) HFModuleTwoView *imageBannerView2;
@property (nonatomic,strong) HFModuleTwoView *imageBannerView3;
@property (nonatomic,copy) HMLiveActivityTableViewCellClick cellClick;
@end

NS_ASSUME_NONNULL_END
