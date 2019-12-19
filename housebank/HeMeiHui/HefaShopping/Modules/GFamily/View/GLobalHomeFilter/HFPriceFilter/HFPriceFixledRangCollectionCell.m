//
//  HFPriceFixledRangCollectionCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFPriceFixledRangCollectionCell.h"

@implementation HFPriceFixledRangCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setupView];
    }
    return self;
}
- (void)hh_setupView {
    [self.contentView addSubview:self.btn];
}
- (void)doSomething {
    self.btn.frame = CGRectMake(0, 0, self.width, self.height);
    [self.btn setTitle:self.model.title forState:UIControlStateNormal];
    self.btn.selected = self.model.isSelected;
    if (self.model.isSelected) {
        self.btn.layer.borderColor = [UIColor colorWithHexString:@"FF6600"].CGColor;
    }else {
       self.btn.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    }
}
- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor colorWithHexString:@"FF6600"] forState:UIControlStateSelected];
        _btn.layer.borderWidth = 0.5;
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn.enabled  = NO;
        _btn.userInteractionEnabled = NO;
    }
    return _btn;
}
@end
