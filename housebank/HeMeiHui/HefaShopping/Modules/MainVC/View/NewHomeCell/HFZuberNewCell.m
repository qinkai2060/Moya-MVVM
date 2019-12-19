//
//  HFZuberNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFZuberNewCell.h"


@implementation HFZuberNewCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeZuberType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.zuberTwoView];
    [self.contentView addSubview:self.zuberTwoView1];
    [self.contentView addSubview:self.zuberTwoView2];
}
- (void)doMessageRendering {
    self.zuberModel = (HFZuberModel*)self.model;
     self.zuberTwoView.frame = CGRectMake(20, 0, (ScreenW-40-10)*0.5, 75*2+10);
     self.zuberTwoView1.frame = CGRectMake(self.zuberTwoView.right+10, 0, (ScreenW-40-10)*0.5, 75);
     self.zuberTwoView2.frame = CGRectMake(self.zuberTwoView.right+10, self.zuberTwoView1.bottom+10, (ScreenW-40-10)*0.5, 75);
    if (self.zuberModel.dataArray.count == 3) {
        self.zuberTwoView.zuberModel = self.zuberModel.dataArray[0];
        self.zuberTwoView1.zuberModel = self.zuberModel.dataArray[1];;
        self.zuberTwoView2.zuberModel = self.zuberModel.dataArray[2];;
    }

    [self.zuberTwoView doMessageRendering];
    [self.zuberTwoView1 doMessageRendering];
    [self.zuberTwoView2 doMessageRendering];
}
- (void)tapOne:(UITapGestureRecognizer*)tap {
    HFZuberTwoView *view = tap.view;
    if (self.didZuberBlock) {
        self.didZuberBlock(view.zuberModel);
    }
}
- (HFZuberTwoView *)zuberTwoView1 {
    if (!_zuberTwoView1) {
        _zuberTwoView1 = [[HFZuberTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_zuberTwoView1 addGestureRecognizer:tapGesture];
    }
    return _zuberTwoView1;
}
- (HFZuberTwoView *)zuberTwoView {
    if (!_zuberTwoView) {
        _zuberTwoView = [[HFZuberTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_zuberTwoView addGestureRecognizer:tapGesture];
    }
    return _zuberTwoView;
}
- (HFZuberTwoView *)zuberTwoView2 {
    if (!_zuberTwoView2) {
        _zuberTwoView2 = [[HFZuberTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_zuberTwoView2 addGestureRecognizer:tapGesture];
    }
    return _zuberTwoView2;
}
@end
