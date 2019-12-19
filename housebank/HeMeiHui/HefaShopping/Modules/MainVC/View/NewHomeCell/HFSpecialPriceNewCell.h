//
//  HFSpecialPriceNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFSpecialPOneView.h"
#import "HFSpecialPTwoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFSpecialPriceNewCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFSpecialPOneView *spOneView;
@property(nonatomic,strong)HFSpecialPTwoView *spOneView1;
@property(nonatomic,strong)HFSpecialPTwoView *spOneView2;
@property(nonatomic,strong)HFSpecialPTwoView *spOneView3;
@property(nonatomic,strong)HFSpecialPTwoView *spOneView4;
@property(nonatomic,strong)CALayer *linelayer;

@end

NS_ASSUME_NONNULL_END
