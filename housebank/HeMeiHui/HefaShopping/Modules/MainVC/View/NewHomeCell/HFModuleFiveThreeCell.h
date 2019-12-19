//
//  HFModuleFiveThreeCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFModuleFiveTwoView.h"
#import "HFModuleFiveOneView.h"
#import "HFModuleFiveThreeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleFiveThreeCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFModuleFiveThreeModel *threeModel;
@property(nonatomic,strong)HFModuleFiveOneView *foneV;
@property(nonatomic,strong)HFModuleFiveOneView *foneV1;
@property(nonatomic,strong)HFModuleFiveTwoView *ftwoV1;
@property(nonatomic,strong)HFModuleFiveTwoView *ftwoV2;
@property(nonatomic,strong)HFModuleFiveTwoView *ftwoV3;
@property(nonatomic,strong)HFModuleFiveTwoView *ftwoV4;
@end

NS_ASSUME_NONNULL_END
