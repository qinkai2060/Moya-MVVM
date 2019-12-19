//
//  CloudVipAlertView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/8/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^cancelBlock)(void);
typedef void(^changeBlock)(void);
@interface CloudVipAlertView : UIView
@property (nonatomic, copy) cancelBlock cancelBlock;
@property (nonatomic, copy) changeBlock changeBlock;
- (void)showAlertString:(NSString *)alertString isSure:(BOOL)isSure 
            changeBlock:(changeBlock)changeBlock;
- (void)resetContext_styleWithSure:(NSString *)sure cancel:(NSString *)cancel;
@end

NS_ASSUME_NONNULL_END

