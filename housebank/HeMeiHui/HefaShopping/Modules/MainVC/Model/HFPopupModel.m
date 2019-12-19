//
//  HFPopupModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFPopupModel.h"

@implementation HFPopupModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypePopup];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypePopup;
    self.rowheight = 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *array = [data valueForKey:@"items"];
        for (NSDictionary *dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    HFPopupModel *model = [[HFPopupModel alloc] init];
                    model.imgUrl =  [NSString stringWithFormat:@"%@%@",[[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"img"]] description],IMGWH(CGSizeMake(275, 300))];
                    model.popUpid = [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"linkMapping"] valueForKey:@"id"]] description];
                    model.link = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"link"]] description];
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
