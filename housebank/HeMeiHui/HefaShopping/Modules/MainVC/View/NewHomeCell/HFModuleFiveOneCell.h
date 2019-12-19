//
//  HFModuleFiveOneCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFModuleFiveTwoView.h"
#import "HFModuleFiveOneView.h"
#import "HFMoudleFiveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleFiveOneCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFMoudleFiveModel *fiveModel;
@property(nonatomic,strong)HFModuleFiveOneView *foneV;
@property(nonatomic,strong)HFModuleFiveOneView *foneV1;
@property(nonatomic,strong)HFModuleFiveOneView *foneV2;
@property(nonatomic,strong)HFModuleFiveOneView *foneV3;
@end

NS_ASSUME_NONNULL_END
