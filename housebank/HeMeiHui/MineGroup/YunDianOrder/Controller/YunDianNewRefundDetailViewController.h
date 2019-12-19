//
//  YunDianNewRefundDetailViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "YunDianNewRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundDetailViewController : BaseSettingViewController
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *refundNo;

@end

NS_ASSUME_NONNULL_END
