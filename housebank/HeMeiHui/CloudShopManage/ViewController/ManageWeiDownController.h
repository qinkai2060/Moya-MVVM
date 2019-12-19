//
//  ManageWeiDownController.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "CloudManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageWeiDownController : SpBaseViewController
@property (nonatomic, copy) NSString * shopID;
@property (nonatomic, strong) CloudManageItemModel * itemModel;
@end

NS_ASSUME_NONNULL_END
