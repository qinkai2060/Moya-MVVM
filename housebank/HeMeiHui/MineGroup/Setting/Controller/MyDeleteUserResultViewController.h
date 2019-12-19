//
//  MyDeleteUserResultViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "BaseSettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDeleteUserResultViewController : BaseSettingViewController
@property(nonatomic,assign)BOOL hasPwdChange;//密码修改记录校验
@property(nonatomic,assign)BOOL hasTransaction;//交易记录校验
@property(nonatomic,assign)BOOL hasAsset;//账户余额校验
@property(nonatomic,assign)BOOL hasShop;//店铺校验
@end

NS_ASSUME_NONNULL_END
