//
//  MySectionCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MySectionCell.h"

@implementation MySectionCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:4];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.titleStrLb];
    [self.contentView addSubview:self.subTitleStrLb];
//    [self.contentView addSubview:self.subBoldTitleStrLb];
}
- (void)doMessageRendering {
    self.titleStrLb.text = self.model.title;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.model.subtitle attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
                                         
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.000000]} range:NSMakeRange(0, 180)];
                                         
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor blackColor]} range:NSMakeRange(180, 113)];
     self.subTitleStrLb.attributedText = string;
//    self.subTitleStrLb.text = self.model.subBoldtitle;
    self.titleStrLb.frame = CGRectMake(0, 15, ScreenW, 25);
    CGFloat subTitleH =  [self.subTitleStrLb sizeThatFits:CGSizeMake(ScreenW-40, MAXFLOAT)].height;
//    CGFloat subBoldTitleH =  [self.subBoldTitleStrLb sizeThatFits:CGSizeMake(ScreenW-40, MAXFLOAT)].height;
    self.subTitleStrLb.frame = CGRectMake(20, self.titleStrLb.bottom+15, ScreenW-40, subTitleH);
//    self.subBoldTitleStrLb.frame = CGRectMake(20, self.titleStrLb.bottom+15, ScreenW-40, subBoldTitleH);
}
- (UILabel *)titleStrLb {
    if (!_titleStrLb) {
        _titleStrLb = [[UILabel alloc] init];
        _titleStrLb.textAlignment = NSTextAlignmentCenter;
        _titleStrLb.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleStrLb;
}
- (UILabel *)subTitleStrLb {
    if (!_subTitleStrLb) {
        _subTitleStrLb = [[UILabel alloc] init];
        _subTitleStrLb.numberOfLines = 0;
    }
    return _subTitleStrLb;
}
@end
