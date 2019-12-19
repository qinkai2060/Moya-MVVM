//
//  CloudAlertView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^cancelBlock)(void);
typedef void(^changeBlock)(void);
@interface CloudAlertView : UIView
@property (nonatomic, copy) cancelBlock cancelBlock;
@property (nonatomic, copy) changeBlock changeBlock;
- (void)showAlertString:(NSString *)alertString
            changeBlock:(changeBlock)changeBlock;
@end

NS_ASSUME_NONNULL_END
