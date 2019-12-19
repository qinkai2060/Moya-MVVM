//
//  CloudManageShopViewController.h
//  HeMeiHui
//
//  Created by Tracy on 2019/8/7.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "CloudManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CloudManageShopViewController : SpBaseViewController
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, strong) CloudManageItemModel *itemModel;
@end

NS_ASSUME_NONNULL_END
