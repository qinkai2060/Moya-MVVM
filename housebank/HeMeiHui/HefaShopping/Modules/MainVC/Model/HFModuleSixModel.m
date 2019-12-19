//
//  HFModuleSixModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleSixModel.h"

@implementation HFModuleSixModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeSixType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeSixType;

    self.rowheight = 120*2+20;
    
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSInteger count = items.count % 2;
        if (count == 0) {
            self.rowheight = (items.count/2)*(120+5)+10;
        }else {
            self.rowheight = (items.count/2)*(120+5)+(120+5)+10;
        }
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
                     if ([browserDic isKindOfClass:[NSDictionary class]]) {
                         HFModuleSixModel *model = [[HFModuleSixModel alloc] init];
                         model.imgUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                         model.linkUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                         model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                         model.title = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                         [tempArray addObject:model];
                     }

        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
