//
//  HMLiveBaseCell.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHLivereCommendModel.h"
#import "HMHLiveModel.h"
#import "HMHLiveMoreModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface HMLiveBaseCell : UITableViewCell

@property (nonatomic,assign)HMHomeLiveMoreType currentMoreType;

@property (nonatomic,strong)NSArray<HMHLivereCommendModel *> *modelArray;

@property (nonatomic,strong)HMHLiveMoreModel *moreModel;

- (void)setSubviews;

@end

NS_ASSUME_NONNULL_END
