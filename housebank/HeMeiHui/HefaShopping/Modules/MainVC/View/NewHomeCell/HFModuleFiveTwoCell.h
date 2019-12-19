//
//  HFModuleFiveTwoCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFModuleFiveTwoView.h"
#import "HFModuleFiveOneView.h"
#import "HFMoudleFiveTwoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleFiveTwoCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFMoudleFiveTwoModel *fiveTwoModel;
@property(nonatomic,strong)HFModuleFiveOneView *foneV;
@property(nonatomic,strong)HFModuleFiveOneView *foneV1;
@property(nonatomic,strong)HFModuleFiveOneView *foneV2;
@property(nonatomic,strong)HFModuleFiveTwoView *ftwoV1;
@property(nonatomic,strong)HFModuleFiveTwoView *ftwoV2;
@end

NS_ASSUME_NONNULL_END
