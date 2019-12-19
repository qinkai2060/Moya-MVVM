//
//  HFYDCarView.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFYDCarView : HFView
@property(nonatomic,assign)BOOL isShow;

- (void)showCar;
- (void)dissMissCar;
@end

NS_ASSUME_NONNULL_END
