//
//  HFAdModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAdModel.h"

@implementation HFAdModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeAdType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeAdType;
    self.rowheight = 130;
   
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFAdModel *model = [[HFAdModel alloc] init];
                model.imgUrl =  [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                model.url = [HFUntilTool EmptyCheckobjnil:[[browserDic valueForKey:@"link"]  description]];
                model.title = [HFUntilTool EmptyCheckobjnil:[[browserDic valueForKey:@"title"]  description]];
                model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                [tempArray addObject:model];
            }

        }
        self.dataArray = [tempArray copy];
    }
    
}

@end
