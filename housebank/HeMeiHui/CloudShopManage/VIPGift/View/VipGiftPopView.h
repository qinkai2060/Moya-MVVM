//
//  VipGiftPopView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipGiftPopView : UIView
@property (nonatomic, strong)UILabel  * memberLabel;
- (void)closeAnimation;
- (void)popViewAnimation;
@end

NS_ASSUME_NONNULL_END
