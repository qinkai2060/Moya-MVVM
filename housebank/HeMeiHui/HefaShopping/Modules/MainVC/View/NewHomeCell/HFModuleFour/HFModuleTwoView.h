//
//  HFModuleTwoView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFModuleFourModel.h"
#import "HMHLiveModules_4ItemsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleTwoView : HFView
@property(nonatomic,strong)HFModuleFourModel *fourModuleModel;


@property(nonatomic,strong)HMHLiveModules_4ItemsModel *fourLiveModuleModel;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *miaoshLb;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *bgView;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END
