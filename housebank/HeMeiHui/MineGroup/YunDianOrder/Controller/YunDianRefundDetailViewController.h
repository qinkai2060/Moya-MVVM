//
//  YunDianRefundDetailViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YunDianRefundDetailViewController : BaseSettingViewController
@property (nonatomic, copy) NSString *orderReturnId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSNumber *shopsType;
@property (nonatomic, strong) NSNumber *distribution;

@end

NS_ASSUME_NONNULL_END
