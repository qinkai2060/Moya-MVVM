//
//  HFSpecialPriceNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSpecialPriceNewCell.h"

@implementation HFSpecialPriceNewCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeSpecialPriceType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.spOneView];
    [self.contentView addSubview:self.spOneView1];
    [self.contentView addSubview:self.spOneView2];
    [self.contentView addSubview:self.spOneView3];
    [self.contentView addSubview:self.spOneView4];
    [self.contentView.layer addSublayer:self.linelayer];
}

- (void)doMessageRendering {
    self.linelayer.frame = CGRectMake(0, 0, ScreenW, 0.5);
    self.spOneView.frame = CGRectMake(0, 0, ScreenW*0.5, 85*2);
    self.spOneView1.frame = CGRectMake(ScreenW*0.5, 0, ScreenW*0.5, 85);
    self.spOneView2.frame = CGRectMake(ScreenW*0.5, 85, ScreenW*0.5, 85);
    self.spOneView3.frame = CGRectMake(0, 170, ScreenW*0.5, 85);
    self.spOneView4.frame = CGRectMake(ScreenW*0.5, 170, ScreenW*0.5, 85);
    HFSpecialPriceOneModel *model = (HFSpecialPriceOneModel*)self.model;
    if (model.dataArray.count == 5) {
        self.spOneView.specialModel = model.dataArray[0];
        self.spOneView1.specialModel = model.dataArray[2];
        self.spOneView2.specialModel = model.dataArray[3];
        self.spOneView3.specialModel = model.dataArray[1];
        self.spOneView4.specialModel = model.dataArray[4];
    }
    [self.spOneView doMessageRendering];
    [self.spOneView1 doMessageRendering];
    [self.spOneView2 doMessageRendering];
    [self.spOneView3 doMessageRendering];
    [self.spOneView4 doMessageRendering];
}
- (void)tap:(UITapGestureRecognizer*)gesture{
    HFSpecialPTwoView *view = (HFSpecialPTwoView*)gesture.view;
    if (self.didSpecialPBlock) {
        self.didSpecialPBlock(view.specialModel);
    }
}
- (void)tapOne:(UITapGestureRecognizer*)gesture{
    HFSpecialPOneView *view = (HFSpecialPOneView*)gesture.view;
    if (self.didSpecialPBlock) {
        self.didSpecialPBlock(view.specialModel);
    }
}
- (HFSpecialPOneView *)spOneView {
    if (!_spOneView) {
        _spOneView = [[HFSpecialPOneView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_spOneView addGestureRecognizer:tapGesture];
    }
    return _spOneView;
}
- (HFSpecialPTwoView *)spOneView1 {
    if (!_spOneView1) {
        _spOneView1 = [[HFSpecialPTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_spOneView1 addGestureRecognizer:tapGesture];
    }
    return _spOneView1;
}
- (HFSpecialPTwoView *)spOneView2 {
    if (!_spOneView2) {
        _spOneView2 = [[HFSpecialPTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_spOneView2 addGestureRecognizer:tapGesture];
    }
    return _spOneView2;
}
- (HFSpecialPTwoView *)spOneView3 {
    if (!_spOneView3) {
        _spOneView3 = [[HFSpecialPTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_spOneView3 addGestureRecognizer:tapGesture];
    }
    return _spOneView3;
}
- (HFSpecialPTwoView *)spOneView4 {
    if (!_spOneView4) {
        _spOneView4 = [[HFSpecialPTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_spOneView4 addGestureRecognizer:tapGesture];
    }
    return _spOneView4;
}
- (CALayer *)linelayer {
    if(!_linelayer) {
        _linelayer = [CALayer layer];
        _linelayer.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"].CGColor;
    }
    return _linelayer;
}
@end
