//
//  VipCenterViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VipCenterViewController : BaseSettingViewController
@property (nonatomic, copy) NSString *imagePath;//头像
@property (nonatomic, strong) NSNumber *vipLevel;
@end

NS_ASSUME_NONNULL_END
