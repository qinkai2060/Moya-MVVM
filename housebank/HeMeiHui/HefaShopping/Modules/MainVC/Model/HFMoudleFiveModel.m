//
//  HFMoudleFiveModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFMoudleFiveModel.h"

@implementation HFMoudleFiveModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeFiveOneType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeFiveOneType;
    self.rowheight = 150*2+15;
    
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFMoudleFiveModel *model = [[HFMoudleFiveModel alloc] init];
                model.title = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                model.littleTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"subtitle"]] description];
                model.imgUrlL = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                model.imgUrlR = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img_2"]] description];
                model.link = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                model.link_2 = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link_2"]] description];
                model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                model.linkMappingModel2 = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping_2"]]];
                
                [tempArray addObject:model];
            }

        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
