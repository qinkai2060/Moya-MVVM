//
//  MyCallTelPhoneCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyCallTelPhoneCell.h"

@implementation MyCallTelPhoneCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:6];
}
- (void)hh_setupSubviews {
//    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleStrLb];
}
- (void)doMessageRendering {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.model.title attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor blackColor]}];
    [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"4D88FF"]} range:NSMakeRange(22, 12)];
    
    self.titleStrLb.attributedText = string;
    self.titleStrLb.frame = CGRectMake(20, 20, ScreenW-40, 40);
}
- (UILabel *)titleStrLb {
    if (!_titleStrLb) {
        _titleStrLb = [[UILabel alloc] init];
        _titleStrLb.textColor =[UIColor blackColor ];
        _titleStrLb.font = [UIFont boldSystemFontOfSize:14];
        _titleStrLb.numberOfLines = 2;
    }
    return _titleStrLb;
}
@end
