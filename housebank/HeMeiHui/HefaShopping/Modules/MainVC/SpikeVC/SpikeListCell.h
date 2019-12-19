//
//  SpikeListCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/20.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpikeDataList.h"
#import "SptimeKillProgressView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpikeListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *HMH_iconImage;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_subLab;
@property (nonatomic, strong) UILabel *HMH_subscribeNumLab;
@property (nonatomic, strong) UILabel *HMH_contentNumLab;
@property (nonatomic, strong) UIButton *HMH_subscribeBtn;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) SptimeKillProgressView *progressView;
@property (nonatomic, strong) ListItemmodel*itemmodel;
- (void)refreshCellWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
