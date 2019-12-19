//
//  YunDianRefuseRefundViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "YunDianNewRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^YunDianRefuseRefundViewControllerRerenshBlock)(void);

@interface YunDianRefuseRefundViewController : BaseSettingViewController
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundModel;
@property (nonatomic, copy) YunDianRefuseRefundViewControllerRerenshBlock block;
@end

NS_ASSUME_NONNULL_END
