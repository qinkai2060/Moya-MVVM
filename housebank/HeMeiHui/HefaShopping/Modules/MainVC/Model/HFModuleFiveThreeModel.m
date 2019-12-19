//
//  HFModuleFiveThreeModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFiveThreeModel.h"
#import "HFMoudleFiveModel.h"
@implementation HFModuleFiveThreeModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeThreeType];
}

- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeThreeType;
    self.rowheight = 150*2+15;
    
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFMoudleFiveModel *model = [[HFMoudleFiveModel alloc] init];
                model.title = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                model.imgUrlL = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                model.imgUrlR = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img_2"]] description];
                model.link = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                model.link_2 = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link_2"]] description];
                model.littleTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"subtitle"]] description];
                model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                [tempArray addObject:model];
            }

        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
