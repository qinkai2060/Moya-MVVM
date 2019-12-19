//
//  HFModuleFourCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFZuberOneView.h"
#import "HFModuleTwoView.h"
#import "HFModuleFourModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleFourCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFModuleFourModel *fourModuleModel;
@property(nonatomic,strong)HFZuberOneView *imageBannerView;
@property(nonatomic,strong)HFModuleTwoView *imageBannerView1;
@property(nonatomic,strong)HFModuleTwoView *imageBannerView2;
@property(nonatomic,strong)HFModuleTwoView *imageBannerView3;
@end

NS_ASSUME_NONNULL_END
