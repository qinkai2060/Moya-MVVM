//
//  ShopManagementCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/6/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckShopsModel.h"
#import "UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShopManagementCell : UITableViewCell
@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) UIImageView *btnImage;
@property(nonatomic, strong) UILabel *lineLable;
@end

NS_ASSUME_NONNULL_END
