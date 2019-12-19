//
//  CustomInputMoneyView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^CustomInputMoneyViewSureBlock)(float money);
typedef void(^CustomInputMoneyViewCloseBlock)();
@interface CustomInputMoneyView : UIView
@property (nonatomic, copy) CustomInputMoneyViewSureBlock sureblock;
@property (nonatomic, copy) CustomInputMoneyViewCloseBlock closeblock;
+(instancetype)CustomInputMoneyViewIn:(UIView *)view sureblock:(void(^)(float money))sureblock closeblock:(void(^)())closeblock;
@end

NS_ASSUME_NONNULL_END
