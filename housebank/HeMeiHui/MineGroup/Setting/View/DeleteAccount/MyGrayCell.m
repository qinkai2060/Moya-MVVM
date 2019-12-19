//
//  MyGrayCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyGrayCell.h"

@implementation MyGrayCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:3];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.titleStrLb];
}
- (void)doMessageRendering {
    self.titleStrLb.text = self.model.title;
    self.titleStrLb.frame = CGRectMake(25, 10, ScreenW-50, 40);
}
- (UILabel *)titleStrLb {
    if (!_titleStrLb) {
        _titleStrLb = [[UILabel alloc] init];
        _titleStrLb.textColor = [UIColor colorWithHexString:@"999999"];
        _titleStrLb.font = [UIFont systemFontOfSize:14];
        _titleStrLb.numberOfLines = 2;
    }
    return _titleStrLb;
}
@end
