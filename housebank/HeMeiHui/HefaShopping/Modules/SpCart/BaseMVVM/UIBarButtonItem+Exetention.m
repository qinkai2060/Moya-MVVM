//
//  UIBarButtonItem+Exetention.m
//  housebank
//
//  Created by usermac on 2019/1/8.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "UIBarButtonItem+Exetention.h"

@implementation UIBarButtonItem (Exetention)
- (instancetype)initWithImage:(NSString*)imageStr target:(id)object action:(nullable SEL)action {
    if (self = [self init]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
     //   [btn  sizeToFit];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [btn addTarget:object action:action forControlEvents:UIControlEventTouchUpInside];
        self.customView = btn;
    }
    return self;
}
@end
