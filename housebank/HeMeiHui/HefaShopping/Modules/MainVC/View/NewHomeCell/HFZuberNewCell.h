//
//  HFZuberNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFZuberTwoView.h"
#import "HFZuberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFZuberNewCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFZuberModel *zuberModel;
@property(nonatomic,strong)HFZuberTwoView *zuberTwoView;
@property(nonatomic,strong)HFZuberTwoView *zuberTwoView1;
@property(nonatomic,strong)HFZuberTwoView *zuberTwoView2;
@end

NS_ASSUME_NONNULL_END
