//
//  cloudWeiLabel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "cloudWeiLabel.h"

@implementation cloudWeiLabel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.font = kFONT(14);
        self.textColor = [UIColor colorWithHexString:@"#333333"];
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

@end
