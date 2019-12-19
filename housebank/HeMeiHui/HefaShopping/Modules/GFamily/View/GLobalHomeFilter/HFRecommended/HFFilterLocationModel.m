//
//  HFFilterLocationModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFilterLocationModel.h"

@implementation HFFilterLocationModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeLocation];
}
+ (HFFilterLocationModel*)locationData {
    HFFilterLocationModel *bedTypeModel = [[HFFilterLocationModel alloc] init];
    bedTypeModel.type = HFShowFilterModelTypeLocation;
    HFFilterLocationModel *chuangModel = [[HFFilterLocationModel alloc] init];
    chuangModel.title = @"距离";
    chuangModel.isSelected = YES;
    HFFilterLocationModel *subchuangModel = [[HFFilterLocationModel alloc] init];
    subchuangModel.title = @"不限";
    subchuangModel.codeTile = @"";
    subchuangModel.isSelected = YES;
    HFFilterLocationModel *subchuangModel1 = [[HFFilterLocationModel alloc] init];
    subchuangModel1.title = @"500米";
    subchuangModel1.codeTile = @"500";
    subchuangModel1.isSelected = NO;
    HFFilterLocationModel *subchuangModel2 = [[HFFilterLocationModel alloc] init];
    subchuangModel2.title = @"1公里";
    subchuangModel2.codeTile = @"1000";
    subchuangModel2.isSelected = NO;
    HFFilterLocationModel *subchuangModel3 = [[HFFilterLocationModel alloc] init];
    subchuangModel3.title = @"2公里";
    subchuangModel3.codeTile = @"2000";
    subchuangModel3.isSelected = NO;
    HFFilterLocationModel *subchuangModel4 = [[HFFilterLocationModel alloc] init];
    subchuangModel4.title = @"3公里";
    subchuangModel4.codeTile = @"3000";
    subchuangModel4.isSelected = NO;
    
    HFFilterLocationModel *subchuangModel5 = [[HFFilterLocationModel alloc] init];
    subchuangModel5.title = @"5公里";
    subchuangModel5.codeTile = @"5000";
    subchuangModel5.isSelected = NO;
    HFFilterLocationModel *subchuangModel6 = [[HFFilterLocationModel alloc] init];
    subchuangModel6.title = @"7公里";
    subchuangModel6.codeTile = @"7000";
    subchuangModel6.isSelected = NO;
    HFFilterLocationModel *subchuangModel7 = [[HFFilterLocationModel alloc] init];
    subchuangModel7.title = @"10公里";
    subchuangModel7.codeTile = @"10000";
    subchuangModel7.isSelected = NO;
    chuangModel.dataSource = @[subchuangModel,subchuangModel1,subchuangModel2,subchuangModel3,subchuangModel4,subchuangModel5,subchuangModel6,subchuangModel7];
    
    HFFilterLocationModel *chuangModel2 = [[HFFilterLocationModel alloc] init];
    chuangModel2.title = @"行政区";
    chuangModel2.isSelected = NO;
    HFFilterLocationModel *suzbchuangModel = [[HFFilterLocationModel alloc] init];
    suzbchuangModel.title = @"不限";
    suzbchuangModel.isSelected = YES;
    HFFilterLocationModel *suzbchuangModel1 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel1.title = @"静安区";
    suzbchuangModel1.isSelected = NO;
    HFFilterLocationModel *suzbchuangModel2 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel2.title = @"徐汇区";
    suzbchuangModel2.isSelected = NO;
    HFFilterLocationModel *suzbchuangModel3 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel3.title = @"黄浦区";
    suzbchuangModel3.isSelected = NO;
    
    HFFilterLocationModel *suzbchuangModel4 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel4.title = @"宝山区";
    suzbchuangModel4.isSelected = NO;
    HFFilterLocationModel *suzbchuangModel5 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel5.title = @"浦东新区";
    suzbchuangModel5.isSelected = NO;
    HFFilterLocationModel *suzbchuangModel6 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel6.title = @"松江区";
    suzbchuangModel6.isSelected = NO;
    HFFilterLocationModel *suzbchuangModel7 = [[HFFilterLocationModel alloc] init];
    suzbchuangModel7.title = @"闵行区";
    suzbchuangModel7.isSelected = NO;
//    chuangModel2.dataSource = @[suzbchuangModel,suzbchuangModel1,suzbchuangModel2,suzbchuangModel3,suzbchuangModel4,suzbchuangModel5,suzbchuangModel6,suzbchuangModel7];
    chuangModel2.dataSource = @[];
    bedTypeModel.dataSource = @[chuangModel,chuangModel2];
    bedTypeModel.viewHight = bedTypeModel.dataSource.count *45+45+50;
    CGFloat maxHeight = 0;
    for (HFFilterLocationModel *model in bedTypeModel.dataSource ) {
        maxHeight = MAX(bedTypeModel.viewHight, (model.dataSource.count*45+45+50));
    }
    bedTypeModel.viewHight = maxHeight;
    return bedTypeModel;
}
- (void)getDataDict:(NSDictionary*)dict {
    if ([[dict valueForKey:@"id"] isKindOfClass:[NSNumber class]]) {
        self.regionId = [[dict valueForKey:@"id"] integerValue];
    }
    if ([[dict valueForKey:@"parentId"] isKindOfClass:[NSNumber class]]) {
        self.parentId = [[dict valueForKey:@"parentId"] integerValue];
    }
    self.lat = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"lat"]];
    self.lng = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"lng"]];
    self.title = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"name"]];
    
}
@end
