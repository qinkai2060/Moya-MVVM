//
//  HFModuleFiveTwoCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFiveTwoCell.h"


@implementation HFModuleFiveTwoCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeFiveTwoType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.foneV];
    [self.contentView addSubview:self.foneV1];
    [self.contentView addSubview:self.foneV2];
    [self.contentView addSubview:self.ftwoV1];
    [self.contentView addSubview:self.ftwoV2];
}
- (void)doMessageRendering {
    self.fiveTwoModel = (HFMoudleFiveTwoModel*)self.model;
    self.foneV.frame = CGRectMake(10, 0, (ScreenW-25)*0.5, 150);
    self.foneV1.frame = CGRectMake(self.foneV.right+5, 0, (ScreenW-25)*0.5, 150);
    self.foneV2.frame = CGRectMake(10, self.foneV.bottom+5, (ScreenW-25)*0.5, 150);
    self.ftwoV1.frame = CGRectMake(self.foneV2.right+5, self.foneV.bottom+5, ((ScreenW-25)*0.5-5)*0.5, 150);
    self.ftwoV2.frame = CGRectMake(self.ftwoV1.right+5, self.foneV.bottom+5, ((ScreenW-25)*0.5-5)*0.5, 150);
     if (self.fiveTwoModel.dataArray.count == 5) {
         self.foneV.fiveModel = self.fiveTwoModel.dataArray[0];
         self.foneV1.fiveModel = self.fiveTwoModel.dataArray[1];
         self.foneV2.fiveModel = self.fiveTwoModel.dataArray[2];
         self.ftwoV1.fiveModel = self.fiveTwoModel.dataArray[3];
         self.ftwoV2.fiveModel = self.fiveTwoModel.dataArray[4];
     }

    [self.foneV doMessageRendering];
    [self.foneV1 doMessageRendering];
    [self.foneV2 doMessageRendering];
    [self.ftwoV1 doMessageRendering];
    [self.ftwoV2 doMessageRendering];


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
- (HFModuleFiveOneView *)foneV2 {
    if (!_foneV2) {
        _foneV2 = [[HFModuleFiveOneView alloc] init];
        @weakify(self)
        _foneV2.didModuleFiveBlock = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _foneV2;
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
@end
