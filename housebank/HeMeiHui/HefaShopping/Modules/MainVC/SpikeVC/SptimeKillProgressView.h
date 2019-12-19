//
//  SptimeKillProgressView.h
//  HeMeiHui
//
//  Created by usermac on 2019/5/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SptimeKillProgressView : UIView
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) UILabel *stateLb;
@property (nonatomic,strong) UILabel *percentageLb;// 百分比
@property (nonatomic,assign) CGFloat progress;
@end

NS_ASSUME_NONNULL_END
