//
//  HFBedTypeFilterBoxView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFilterBoxBaseView.h"
@class HFConfitionIndexPath;
NS_ASSUME_NONNULL_BEGIN

@interface HFBedTypeFilterBoxView : HFFilterBoxBaseView
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UITableView *tableviewLeft;
@property(nonatomic,strong)UITableView *tableviewRight;
@property(nonatomic,strong)UIButton *resetBtn;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)NSMutableArray<HFConfitionIndexPath*> *secondSelectArray;
@end

NS_ASSUME_NONNULL_END
