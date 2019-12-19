//
//  MyDeleteTitleCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteTitleCell.h"

@implementation MyDeleteTitleCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:2];
}
- (void)hh_setupSubviews {
    
    [self.contentView addSubview:self.titleStrLb];
    [self.contentView addSubview:self.lineView];
}
- (void)doMessageRendering {
    self.titleStrLb.text = self.model.title;
    self.titleStrLb.frame = CGRectMake(15, 15, ScreenW-30, 15);
    self.lineView.frame = CGRectMake(0, self.model.rowHeight-1, ScreenW, 1);
}
- (UILabel *)titleStrLb {
    if (!_titleStrLb) {
        _titleStrLb = [[UILabel alloc] init];
        _titleStrLb.textColor = [UIColor blackColor];
        _titleStrLb.font = [UIFont systemFontOfSize:14];
    }
    return _titleStrLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _lineView;
}
@end
