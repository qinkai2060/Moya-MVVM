//
//  EmptyModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "EmptyModel.h"

@implementation EmptyModel

- (NSString *)identifier {
    return @"MyEmplyDataTableViewCell";
}

- (CGFloat)height {
    return (kHeight-STATUSBAR_NAVBAR_HEIGHT);
}
@end
