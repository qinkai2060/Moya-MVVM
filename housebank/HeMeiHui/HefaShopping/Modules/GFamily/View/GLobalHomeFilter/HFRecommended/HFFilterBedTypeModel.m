//
//  HFFilterBedTypeModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFilterBedTypeModel.h"

@implementation HFFilterBedTypeModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeBedFilter];
}
+ (HFFilterBedTypeModel*)bedData {
    HFFilterBedTypeModel *bedTypeModel = [[HFFilterBedTypeModel alloc] init];
    bedTypeModel.type = HFShowFilterModelTypeBedFilter;
    HFFilterBedTypeModel *chuangModel = [[HFFilterBedTypeModel alloc] init];
    chuangModel.title = @"床型";
    chuangModel.isSelected = YES;
    HFFilterBedTypeModel *subchuangModel = [[HFFilterBedTypeModel alloc] init];
    subchuangModel.title = @"不限";
    subchuangModel.codeTile = @"0";
    subchuangModel.isSelected = YES;
    HFFilterBedTypeModel *subchuangModel1 = [[HFFilterBedTypeModel alloc] init];
    subchuangModel1.title = @"大床";
    subchuangModel1.codeTile = @"1";
    subchuangModel1.isSelected = NO;
    HFFilterBedTypeModel *subchuangModel2 = [[HFFilterBedTypeModel alloc] init];
    subchuangModel2.title = @"双床";
    subchuangModel2.codeTile = @"2";
    subchuangModel2.isSelected = NO;
    HFFilterBedTypeModel *subchuangModel3 = [[HFFilterBedTypeModel alloc] init];
    subchuangModel3.title = @"单人床";
    subchuangModel3.codeTile = @"3";
    subchuangModel3.isSelected = NO;
    HFFilterBedTypeModel *subchuangModel4 = [[HFFilterBedTypeModel alloc] init];
    subchuangModel4.title = @"多张床";
    subchuangModel4.codeTile = @"4";
    subchuangModel4.isSelected = NO;
    chuangModel.dataSource = @[subchuangModel,subchuangModel1,subchuangModel2,subchuangModel3,subchuangModel4];
    
    HFFilterBedTypeModel *chuangModel2 = [[HFFilterBedTypeModel alloc] init];
    chuangModel2.title = @"早餐";
    chuangModel2.isSelected = NO;
    HFFilterBedTypeModel *suzbchuangModel = [[HFFilterBedTypeModel alloc] init];
    suzbchuangModel.title = @"不限";
    suzbchuangModel.codeTile = @"0";
    suzbchuangModel.isSelected = YES;
    HFFilterBedTypeModel *suzbchuangModel1 = [[HFFilterBedTypeModel alloc] init];
    suzbchuangModel1.title = @"含早";
    suzbchuangModel1.codeTile = @"1";
    suzbchuangModel1.isSelected = NO;
    HFFilterBedTypeModel *suzbchuangModel2 = [[HFFilterBedTypeModel alloc] init];
    suzbchuangModel2.title = @"单早";
    suzbchuangModel2.codeTile = @"2";
    suzbchuangModel2.isSelected = NO;
    HFFilterBedTypeModel *suzbchuangModel3 = [[HFFilterBedTypeModel alloc] init];
    suzbchuangModel3.title = @"双早";
    suzbchuangModel3.codeTile = @"3";
    suzbchuangModel3.isSelected = NO;
    chuangModel2.dataSource = @[suzbchuangModel,suzbchuangModel1,suzbchuangModel2,suzbchuangModel3];
    bedTypeModel.dataSource = @[chuangModel,chuangModel2];
    bedTypeModel.viewHight = bedTypeModel.dataSource.count *45+25+50;
    CGFloat maxHeight = 0;
    for (HFFilterBedTypeModel *model in bedTypeModel.dataSource ) {
        maxHeight = MAX(bedTypeModel.viewHight, (model.dataSource.count*45+25+50));
    }
    bedTypeModel.viewHight = maxHeight;
//    self.model = bedTypeModel;
    return bedTypeModel;
}
@end
