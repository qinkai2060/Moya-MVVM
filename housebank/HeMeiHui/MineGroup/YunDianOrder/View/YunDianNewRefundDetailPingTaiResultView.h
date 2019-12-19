//
//  YunDianNewRefundDetailPingTaiResultView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianNewRefundDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundDetailPingTaiResultView : UIView
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel * pingTaiResultLable;
@property (nonatomic, strong) UILabel * timeLable;
@property (nonatomic, strong) UILabel * pingTaiDetailLable;
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundDetailModel;
+(CGFloat)yunDianNewRefundDetailPingTaiResultViewReturnHeight:(YunDianNewRefundDetailModel *)refundDetailModel;
@end

NS_ASSUME_NONNULL_END
