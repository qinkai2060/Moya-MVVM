//
//  STShoppingAddressMainView.h
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAddressTopView.h"
#import "SpTypesSearchView.h"

// 发货地址的主view
NS_ASSUME_NONNULL_BEGIN

@interface STShoppingAddressMainView : UIView

@property (nonatomic, strong) SpTypesSearchView *searchView;
@property (nonatomic, strong) STAddressTopView *topView;

@end

NS_ASSUME_NONNULL_END
