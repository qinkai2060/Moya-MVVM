//
//  HFModuleFourCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFourCell.h"


@implementation HFModuleFourCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeModuleFourType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.imageBannerView];
    [self.contentView addSubview:self.imageBannerView1];
    [self.contentView addSubview:self.imageBannerView2];
    [self.contentView addSubview:self.imageBannerView3];
}
- (void)doMessageRendering {
    self.fourModuleModel = (HFModuleFourModel*)self.model;
    self.imageBannerView.frame = CGRectMake(10, 0, ScreenW-20, 135);
    self.imageBannerView1.frame = CGRectMake(10, self.imageBannerView.bottom+5, (ScreenW-20-10)/3, 120);
    self.imageBannerView2.frame = CGRectMake( self.imageBannerView1.right+5, self.imageBannerView.bottom+5, (ScreenW-20-10)/3, 120);
    self.imageBannerView3.frame = CGRectMake(self.imageBannerView2.right+5, self.imageBannerView.bottom+5, (ScreenW-20-10)/3, 120);
    if (self.fourModuleModel.dataArray.count == 4) {
        self.imageBannerView.fourModuleModel = self.fourModuleModel.dataArray[0];
        self.imageBannerView1.fourModuleModel = self.fourModuleModel.dataArray[1];
        self.imageBannerView2.fourModuleModel = self.fourModuleModel.dataArray[2];
        self.imageBannerView3.fourModuleModel = self.fourModuleModel.dataArray[3];
    }
    [self.imageBannerView doMessageRendering];
    [self.imageBannerView1 doMessageRendering];
    [self.imageBannerView2 doMessageRendering];
    [self.imageBannerView3 doMessageRendering];
}
- (void)tapOne:(UITapGestureRecognizer*)tap {
    HFZuberOneView *zuberView = (HFZuberOneView*)tap.view;
    if (self.didModuleFourBlock) {
        self.didModuleFourBlock(zuberView.fourModuleModel);
    }
}
- (void)tap:(UITapGestureRecognizer*)tap {
    HFModuleTwoView *zuberView = (HFModuleTwoView*)tap.view;
    if (self.didModuleFourBlock) {
        self.didModuleFourBlock(zuberView.fourModuleModel);
    }
}

- (HFZuberOneView *)imageBannerView {
    if (!_imageBannerView) {
        _imageBannerView = [[HFZuberOneView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_imageBannerView addGestureRecognizer:tapGesture];
    }
    return _imageBannerView;
}
- (HFModuleTwoView *)imageBannerView1 {
    if (!_imageBannerView1) {
        _imageBannerView1 = [[HFModuleTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageBannerView1 addGestureRecognizer:tapGesture];
    }
    return  _imageBannerView1;
}
- (HFModuleTwoView *)imageBannerView2 {
    if (!_imageBannerView2) {
        _imageBannerView2 = [[HFModuleTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageBannerView2 addGestureRecognizer:tapGesture];
    }
    return  _imageBannerView2;
}
- (HFModuleTwoView *)imageBannerView3 {
    if (!_imageBannerView3) {
        _imageBannerView3 = [[HFModuleTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageBannerView3 addGestureRecognizer:tapGesture];
    }
    return  _imageBannerView3;
}
@end
