//
//  HFTimeLimitModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFTimeLimitModel.h"

@implementation HFTimeLimitModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeTimeLimitKillType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeTimeLimitKillType;
    self.rowheight = (ScreenW-45)/3-20+5+10+15+8+15+12+45+10;
    self.nextActivityTime = [[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"nextActivityTime"]] description] integerValue];
    NSDate *newdate =   [NSDate dateWithTimeIntervalSince1970:self.nextActivityTime/1000];
    NSTimeInterval timeIntervar =  [newdate timeIntervalSinceDate:[NSDate date]];
    self.timersmp = timeIntervar;
    if ([[data valueForKey:@"spikes"] isKindOfClass:[NSArray class]]) {
        
        if (self.timersmp >0) {
               self.isOpentimer = YES;
        }
        NSArray *spikesArray = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"spikes"]];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in spikesArray) {
     if ([dict isKindOfClass:[NSDictionary class]]) {
         HFTimeLimitSmallModel *timeSmallModel = [[HFTimeLimitSmallModel alloc] init];
         timeSmallModel.killID = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"id"] description]] integerValue];
         timeSmallModel.productId =  [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"productId"] description]] integerValue];
         timeSmallModel.productName =  [HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"productName"] description]];
         timeSmallModel.productImage =  [HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"productImage"] description]];
         timeSmallModel.productSubtitle =  [HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"productSubtitle"] description]];
         timeSmallModel.classifications =  [HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"classifications"] description]];
         timeSmallModel.specificationsId =  [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"specificationsId"] description]] integerValue];
         timeSmallModel.cashPrice =  [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"cashPrice"] description]] floatValue];
         timeSmallModel.promotionPrice =  [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"promotionPrice"] description]] floatValue];
         timeSmallModel.productLevel =  [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"productLevel"] description]] integerValue];
         timeSmallModel.promotionTag =  [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"promotionTag"]] ;
         [tempArray addObject:timeSmallModel];

     }
        }
        self.dataArray = [tempArray copy];

    }else {
        self.isOpentimer = NO;
    }
}
+ (NSString*)dataStr:(NSString*)number {
    
    NSDate *newdate =   [NSDate dateWithTimeIntervalSince1970:[number longLongValue]/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear fromDate:newdate];
    return    [NSString stringWithFormat:@"%zd-%02zd-%02zd",[components year],[components month],[components day]];
}
@end
@implementation HFTimeLimitSmallModel
@end
