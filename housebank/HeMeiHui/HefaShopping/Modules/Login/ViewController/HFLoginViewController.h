//
//  HFLoginViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewController.h"
@class HFLoginViewController;
NS_ASSUME_NONNULL_BEGIN
@protocol HFLoginViewControllerDelegate <NSObject>
- (void)closeController;
- (void)loginViewController:(HFLoginViewController*)viewcontroller loginFinsh:(NSDictionary*)loginData;

@end
@interface HFLoginViewController : HFViewController
@property(nonatomic,weak)id <HFLoginViewControllerDelegate> delegate;
+ (void)showViewController:(UIViewController*)viewcontroller;
@end

NS_ASSUME_NONNULL_END
