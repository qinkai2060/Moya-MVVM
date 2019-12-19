//
//  CollectMainController.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SelectIndex) {
    HFCollectProductType,
    HFCollectShopType,
    HFCollectGlobalHomeType,
};

@interface CollectMainController : SpBaseViewController
@property (nonatomic, assign) SelectIndex  selectIndex;
@end

NS_ASSUME_NONNULL_END
