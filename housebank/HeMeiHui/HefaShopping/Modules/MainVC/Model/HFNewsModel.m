//
//  HFNewsModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNewsModel.h"

@implementation HFNewsModel
+ (void)load {
    
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeNewsType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeNewsType;
    self.rowheight = 40;
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFNewsModel *model = [[HFNewsModel alloc] init];
                model.title =  [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"title"]] description];
                model.url =  [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                [tempArray addObject:model];
            }
         
        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
