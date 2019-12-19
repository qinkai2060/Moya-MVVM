//
//  HFModuleFourModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFourModel.h"

@implementation HFModuleFourModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeModuleFourType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeModuleFourType;
    self.rowheight = 135+120+10+5;
    
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFModuleFourModel *model = [[HFModuleFourModel alloc] init];
                model.imgUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                model.linkUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                model.title = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                model.littleTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"subtitle"]] description];
                model.smallTags = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"smallTags"]] description];
                model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                [tempArray addObject:model];
            }
  
        }
        self.dataArray = [tempArray copy];
    }
    
}

@end
