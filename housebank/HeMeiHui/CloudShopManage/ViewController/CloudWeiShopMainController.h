//
//  CloudWeiShopMainController.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "CloudManageModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, CloudSelectInex) {
    WeiShopSelect,
    WeiShopOwn,
    WeiShopOrderList,
};
@interface CloudWeiShopMainController : SpBaseViewController
@property (nonatomic, assign) CloudSelectInex cloudSelectIndex;
@property (nonatomic, strong) CloudManageItemModel * itemModel;
@property (nonatomic, copy) NSString * shopID;
@end

NS_ASSUME_NONNULL_END
