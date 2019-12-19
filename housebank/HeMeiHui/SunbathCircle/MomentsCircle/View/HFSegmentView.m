//
//  HFSegmentView.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSegmentView.h"

@implementation HFSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        NSArray *title = @[@"关注",@"发现"];
        CGFloat x = 0;
        for (int i = 0; i < title.count; i++) {
            HFBageSegmentView *segmentV = [[HFBageSegmentView alloc] initWithFrame:CGRectMake(x, 0, 50, 33)];
            segmentV.tag = 1000+i;
            if (i == 0) {
                segmentV.isSelected = YES;
            }
            segmentV.title = title[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
            [segmentV addGestureRecognizer:tap];
            [self addSubview:segmentV];
            x = CGRectGetMaxX(segmentV.frame);
        }
    }
    return self;
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    HFBageSegmentView *segmentV  = [self viewWithTag:1000+selectIndex];
    for (UIView *bageV in self.subviews) {
        if ([bageV isKindOfClass:[HFBageSegmentView class]]) {
            HFBageSegmentView *segmentVSub = (HFBageSegmentView*)bageV;
            segmentVSub.isSelected =NO;
        }
    }
    segmentV.isSelected = YES;
}
- (void)didSelect:(UITapGestureRecognizer*)tap {
    HFBageSegmentView *segmentV  = (HFBageSegmentView*)tap.view;
    for (UIView *bageV in self.subviews) {
        if ([bageV isKindOfClass:[HFBageSegmentView class]]) {
            HFBageSegmentView *segmentVSub = (HFBageSegmentView*)bageV;
            segmentVSub.isSelected =NO;
        }
    }
    segmentV.isSelected = YES;
    if (self.didSelect) {
        self.didSelect(segmentV.tag-1000);
    }
}
@end
@implementation HFBageSegmentView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.btn];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    self.btn.frame = CGRectMake(0, 0, 50, 20);
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.btn.frame)+5, 29, 2);
    self.lineView.centerX = self.btn.centerX;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.btn setTitle:title forState:UIControlStateNormal];
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.lineView.hidden = NO;
    }else {
        self.lineView.hidden = YES;
        self.btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
}
- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitle:@"" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:16];
        _btn.userInteractionEnabled = NO;
    }
    return _btn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"FF1111"];
        _lineView.layer.cornerRadius = 2;
        _lineView.layer.masksToBounds = YES;
        _lineView.hidden = YES;
    }
    return _lineView;
}
@end
