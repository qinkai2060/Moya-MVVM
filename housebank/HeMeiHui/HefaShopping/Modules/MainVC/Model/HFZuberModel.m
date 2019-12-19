//
//  HFZuberModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFZuberModel.h"

@implementation HFZuberModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeZuberType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeZuberType;
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
 
        self.rowheight = 160+10;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFZuberModel *spModel2 = [[HFZuberModel alloc] init];
                spModel2.imgUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                spModel2.linkUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                spModel2.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                [tempArray addObject:spModel2];
            }
         
        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
