//
//  HFBrowserModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFBrowserModel.h"

@implementation HFBrowserModel
+ (void)load {
      [super registerRenderCell:[self class] messageType:HHFHomeBaseModeBrowserBannerType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModeBrowserBannerType;
    if (self.isVipP) {
        self.rowheight = 150;
    }else {
        self.rowheight = 235;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *array = [data valueForKey:@"items"];
        for (NSDictionary *dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    HFBrowserModel *model = [[HFBrowserModel alloc] init];
                    model.imgUrl =  [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"img"]] description];
                    model.linkUrl = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"linkMapping"] valueForKey:@"id"]] description];
                    model.goodsId = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"goodsId"]] description];
                    model.type = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"linkMapping"] valueForKey:@"type"]] description];
                    model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"linkMapping"]]];
                    [tempArray addObject:model];
                }
         
            }
    
        }
    }
    self.dataArray = [tempArray copy];
    
}
@end
@implementation HFBrowserSmallModel



@end
