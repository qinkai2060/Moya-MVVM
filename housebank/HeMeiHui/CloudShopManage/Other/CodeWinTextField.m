//
//  CodeWinTextField.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CodeWinTextField.h"

@implementation CodeWinTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor colorWithHexString:@"#333333"];
        self.font = kFONT(14);
        self.textAlignment = NSTextAlignmentLeft;
        self.borderStyle = UITextBorderStyleNone;
    }
    return self;
}

- (void)changePlaceHolderColor {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName:kFONT(14),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"]}];
}
@end
