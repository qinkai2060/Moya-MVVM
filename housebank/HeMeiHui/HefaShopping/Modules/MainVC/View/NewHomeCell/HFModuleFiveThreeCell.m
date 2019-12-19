//
//  HFModuleFiveThreeCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFiveThreeCell.h"

@implementation HFModuleFiveThreeCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeThreeType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.foneV];
    [self.contentView addSubview:self.foneV1];
    [self.contentView addSubview:self.ftwoV1];
    [self.contentView addSubview:self.ftwoV2];
    [self.contentView addSubview:self.ftwoV3];
    [self.contentView addSubview:self.ftwoV4];
}
- (void)doMessageRendering {
    self.threeModel = (HFModuleFiveThreeModel*)self.model;
    self.foneV.frame = CGRectMake(10, 0, (ScreenW-25)*0.5, 150);
    self.foneV1.frame = CGRectMake(self.foneV.right+5, 0, (ScreenW-25)*0.5, 150);
    self.ftwoV1.frame = CGRectMake(13, self.foneV.bottom+5, ((ScreenW-25)*0.5-5)*0.5, 150);
    self.ftwoV2.frame = CGRectMake(self.ftwoV1.right+5, self.foneV.bottom+5, ((ScreenW-25)*0.5-5)*0.5, 150);
    self.ftwoV3.frame = CGRectMake(self.ftwoV2.right+2, self.foneV.bottom+5,((ScreenW-25)*0.5-5)*0.5, 150);
    self.ftwoV4.frame = CGRectMake(self.ftwoV3.right+5, self.foneV.bottom+5, ((ScreenW-25)*0.5-5)*0.5, 150);
     if (self.threeModel.dataArray.count == 6) {
         self.foneV.fiveModel = self.threeModel.dataArray[0];
         self.foneV1.fiveModel = self.threeModel.dataArray[1];
         self.ftwoV1.fiveModel = self.threeModel.dataArray[2];
         self.ftwoV2.fiveModel = self.threeModel.dataArray[3];
         self.ftwoV3.fiveModel = self.threeModel.dataArray[4];
         self.ftwoV4.fiveModel = self.threeModel.dataArray[5];

     }
    [self.foneV doMessageRendering];
    [self.foneV1 doMessageRendering];
    [self.ftwoV1 doMessageRendering];
    [self.ftwoV2 doMessageRendering];
    [self.ftwoV3 doMessageRendering];
    [self.ftwoV4 doMessageRendering];
}
- (HFModuleFiveOneView *)foneV {
    if (!_foneV) {
        _foneV = [[HFModuleFiveOneView alloc] init];
        @weakify(self)
        _foneV.didModuleFiveBlock = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _foneV;
}
- (HFModuleFiveOneView *)foneV1 {
    if (!_foneV1) {
        _foneV1 = [[HFModuleFiveOneView alloc] init];
        @weakify(self)
        _foneV1.didModuleFiveBlock = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _foneV1;
}

- (HFModuleFiveTwoView *)ftwoV1 {
    if(!_ftwoV1) {
        _ftwoV1 = [[HFModuleFiveTwoView alloc] init];
        @weakify(self)
        _ftwoV1.didModuleFiveTwoBlock  = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _ftwoV1;
}
- (HFModuleFiveTwoView *)ftwoV2 {
    if(!_ftwoV2) {
        _ftwoV2 = [[HFModuleFiveTwoView alloc] init];
        @weakify(self)
        _ftwoV2.didModuleFiveTwoBlock  = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _ftwoV2;
}
- (HFModuleFiveTwoView *)ftwoV3 {
    if(!_ftwoV3) {
        _ftwoV3 = [[HFModuleFiveTwoView alloc] init];
        @weakify(self)
        _ftwoV3.didModuleFiveTwoBlock  = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _ftwoV3;
}
- (HFModuleFiveTwoView *)ftwoV4 {
    if(!_ftwoV4) {
        _ftwoV4 = [[HFModuleFiveTwoView alloc] init];
        @weakify(self)
        _ftwoV4.didModuleFiveTwoBlock  = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _ftwoV4;
}
@end
