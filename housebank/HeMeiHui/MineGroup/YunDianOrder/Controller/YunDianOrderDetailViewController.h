//
//  YunDianOrderDetailViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderDetailViewController : BaseSettingViewController

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSNumber *commented;

@end

NS_ASSUME_NONNULL_END
