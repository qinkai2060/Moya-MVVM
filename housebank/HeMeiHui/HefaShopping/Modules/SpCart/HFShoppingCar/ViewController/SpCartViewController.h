//
//  SpCartViewController.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "SpBaseViewController.h"
typedef  NS_ENUM(NSInteger,SpCartViewControllerEnterType) {
    SpCartViewControllerEnterTypeNone = 1,
    SpCartViewControllerEnterTypeOther = 2
};
@interface SpCartViewController : SpBaseViewController
- (instancetype)initWithType:(SpCartViewControllerEnterType)contentMode;
@end
