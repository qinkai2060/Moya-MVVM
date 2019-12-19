//
//  YunDianOrderViewController.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "UserOrderCell.h"
#import "YunDianShopListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderViewController : BaseSettingViewController

@property (nonatomic, strong) YunDianShopListModel *shopListModel;

@end

NS_ASSUME_NONNULL_END
