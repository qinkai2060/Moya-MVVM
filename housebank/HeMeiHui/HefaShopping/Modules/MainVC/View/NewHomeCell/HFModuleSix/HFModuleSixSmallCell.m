//
//  HFFashionSmallCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/4.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleSixSmallCell.h"

@implementation HFModuleSixSmallCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setsubView];
    }
    return self;
}
- (void)hh_setsubView {
    self.soneV.frame = CGRectMake(0, 0, (ScreenW-25)*0.5, 120);
    [self.contentView addSubview:self.soneV];
}
- (void)doMessgaSommthing {
    self.soneV.sixModel = self.model;
    [self.soneV doMessageRendering];
}
- (HFModuleSixView *)soneV {
    if (!_soneV) {
        _soneV = [[HFModuleSixView alloc] init];
    }
    return _soneV;
}
@end
