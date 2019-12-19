//
//  CloudTypicalView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudTypicalView : UIView

- (void)showImageString:(NSURL *)imageString withWidth:(CGSize)size;

- (void)showLabelText:(NSString *)showString;

@end

NS_ASSUME_NONNULL_END
