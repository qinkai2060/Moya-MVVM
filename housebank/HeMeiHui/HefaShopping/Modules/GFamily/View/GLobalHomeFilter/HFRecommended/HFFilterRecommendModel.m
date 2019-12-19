//
//  HFFilterRecommendModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFilterRecommendModel.h"

@implementation HFFilterRecommendModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeSort];
}
+ (HFFilterRecommendModel*)recommendData {
    HFFilterRecommendModel *totalmodel =  [[HFFilterRecommendModel alloc] init];
    totalmodel.type = HFShowFilterModelTypeSort;
    HFFilterRecommendModel *rModel  = [[HFFilterRecommendModel alloc] init];
    rModel.title = @"距离优先";
    rModel.codeTile = @"1";
    rModel.isSelected = YES;
    HFFilterRecommendModel *rModel1 = [[HFFilterRecommendModel alloc] init];
    rModel1.title = @"好评优先";
    rModel1.codeTile = @"2";
    rModel1.isSelected = NO;
    HFFilterRecommendModel *rModel2 = [[HFFilterRecommendModel alloc] init];
    rModel2.title = @"低价优先";
    rModel2.codeTile = @"3";
    rModel2.isSelected = NO;
    HFFilterRecommendModel *rModel3 = [[HFFilterRecommendModel alloc] init];
    rModel3.title = @"高价优先";
    rModel3.codeTile = @"4";
    rModel3.isSelected = NO;
    totalmodel.dataSource = @[rModel,rModel1,rModel2,rModel3];
    totalmodel.viewHight = 45* totalmodel.dataSource.count;
    return totalmodel;
}
@end
