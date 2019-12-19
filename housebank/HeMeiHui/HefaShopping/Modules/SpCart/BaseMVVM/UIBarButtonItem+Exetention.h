//
//  UIBarButtonItem+Exetention.h
//  housebank
//
//  Created by usermac on 2019/1/8.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Exetention)
- (instancetype)initWithImage:(NSString*)imageStr target:(id)object action:(nullable SEL)action;
@end

NS_ASSUME_NONNULL_END
