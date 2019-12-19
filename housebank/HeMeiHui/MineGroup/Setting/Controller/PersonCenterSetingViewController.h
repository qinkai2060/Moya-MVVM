//
//  PersonCenterSetingViewController.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonCenterSetingViewController : BaseSettingViewController
@property (nonatomic, assign) NSInteger RMGrade;// == 1 没名片
@property (nonatomic, copy) NSString *imagePath;//头像
@end

NS_ASSUME_NONNULL_END
