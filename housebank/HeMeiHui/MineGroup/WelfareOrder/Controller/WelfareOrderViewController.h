//
//  WelfareOrderViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "VTMagic.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelfareOrderViewController : BaseSettingViewController<JXCategoryListContentViewDelegate>
@property (nonatomic,weak) UINavigationController *nvController;

@end

NS_ASSUME_NONNULL_END
