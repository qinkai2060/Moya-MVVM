//
//  YunDianNewRefundDetailStateView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianNewRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundDetailStateView : UIView
@property (nonatomic, strong) UILabel *refundStateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) YunDianNewRefundDetailModel *refundDetailModel;
@end

NS_ASSUME_NONNULL_END
