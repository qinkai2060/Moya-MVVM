//
//  PersonInformationSelectView.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectViewCancelBlock)();
typedef void(^SelectViewSureBlock)(NSString *title);

@interface PersonInformationSelectView : UIView

+ (instancetype)share;

- (void)showView:(NSArray<NSString *> *)titleArray cancel:(SelectViewCancelBlock)cancelBlock sure:(SelectViewSureBlock)sureBlock;

@end

NS_ASSUME_NONNULL_END
