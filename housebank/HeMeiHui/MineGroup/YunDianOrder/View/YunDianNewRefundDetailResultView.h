//
//  YunDianNewRefundDetailResultView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianNewRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundDetailResultView : UIView
@property (nonatomic, strong) UILabel *result1Label;
@property (nonatomic, strong) UILabel *result2Label;
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundDetailModel;

@end

NS_ASSUME_NONNULL_END
