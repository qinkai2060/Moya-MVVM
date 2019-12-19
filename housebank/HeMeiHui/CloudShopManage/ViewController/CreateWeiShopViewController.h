//
//  CreateWeiShopViewController.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "CloudManageModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, createType) {
    CreateNewShop,
    ChangeShop,
};

@interface CreateWeiShopViewController : SpBaseViewController
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * bottomString;
@property (nonatomic, strong) CloudManageItemModel *itemModel;
@property (nonatomic, assign) createType createType;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL showBottom;
@end

NS_ASSUME_NONNULL_END
