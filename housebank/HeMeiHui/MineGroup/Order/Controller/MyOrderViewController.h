//
//  MyOrderViewController.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserOrderCell.h"
#import "BaseSettingViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyOrderViewController : BaseSettingViewController
@property (nonatomic, assign) UserOrderCellClickType type;

@property (nonatomic, strong) NSArray *titleArr;
@end

NS_ASSUME_NONNULL_END
