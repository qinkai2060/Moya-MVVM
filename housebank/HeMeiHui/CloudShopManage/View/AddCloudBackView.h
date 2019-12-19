//
//  AddCloudBackView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCloudShopView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^dissMissBlock)(void);
@interface AddCloudBackView : UIView
@property (nonatomic, strong) AddCloudShopView * addShopView;
@property (nonatomic, copy) dissMissBlock missBlock;
- (void)closeAnimation;
- (void)popViewAnimation;
@end

NS_ASSUME_NONNULL_END
