//
//  MyTipCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyTipCell.h"

@implementation MyTipCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:5];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.titleStrLb];
    [self.contentView addSubview:self.subTitleStrLb];
}
- (void)doMessageRendering {
    self.titleStrLb.text = self.model.title;
    self.subTitleStrLb.text = self.model.subtitle;
    self.titleStrLb.frame = CGRectMake(15, 15, ScreenW-30, 15);
    self.subTitleStrLb.frame =CGRectMake(15, self.titleStrLb.bottom+10,  ScreenW-30, 40);
}
- (UILabel *)titleStrLb {
    if (!_titleStrLb) {
        _titleStrLb = [[UILabel alloc] init];
        _titleStrLb.textColor =[UIColor blackColor ];
        _titleStrLb.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleStrLb;
}
- (UILabel *)subTitleStrLb {
    if (!_subTitleStrLb) {
        _subTitleStrLb = [[UILabel alloc] init];
        _subTitleStrLb.textColor =[UIColor blackColor ];
        _subTitleStrLb.font = [UIFont systemFontOfSize:14];
        _subTitleStrLb.numberOfLines = 2;
    }
    return _subTitleStrLb;
}
@end
