//
//  HFModuleFiveOneCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFiveOneCell.h"

@implementation HFModuleFiveOneCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeFiveOneType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.foneV];
    [self.contentView addSubview:self.foneV1];
    [self.contentView addSubview:self.foneV2];
    [self.contentView addSubview:self.foneV3];
}
- (void)doMessageRendering {
    self.fiveModel = (HFMoudleFiveModel*)self.model;
    self.foneV.frame = CGRectMake(10, 0, (ScreenW-25)*0.5, 150);
    self.foneV1.frame = CGRectMake(self.foneV.right+5, 0, (ScreenW-25)*0.5, 150);
    self.foneV2.frame = CGRectMake(10, self.foneV.bottom+5, (ScreenW-25)*0.5, 150);
    self.foneV3.frame = CGRectMake(self.foneV.right+5, self.foneV.bottom+5, (ScreenW-25)*0.5, 150);
    if (self.fiveModel.dataArray.count == 4) {
        self.foneV.fiveModel = self.fiveModel.dataArray[0];
        self.foneV1.fiveModel = self.fiveModel.dataArray[1];
        self.foneV2.fiveModel = self.fiveModel.dataArray[2];
        self.foneV3.fiveModel = self.fiveModel.dataArray[3];
    }
    [self.foneV doMessageRendering];
    [self.foneV1 doMessageRendering];
    [self.foneV2 doMessageRendering];
    [self.foneV3 doMessageRendering];
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
- (HFModuleFiveOneView *)foneV3 {
    if (!_foneV3) {
        _foneV3 = [[HFModuleFiveOneView alloc] init];
        @weakify(self)
        _foneV3.didModuleFiveBlock = ^(HFHomeBaseModel *model) {
            @strongify(self)
            if (self.didModuleFiveBlock) {
                self.didModuleFiveBlock(model);
            }
        };
    }
    return _foneV3;
}
@end
