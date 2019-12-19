//
//  HFSpecialPriceOneModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSpecialPriceOneModel.h"

@implementation HFSpecialPriceOneModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeSpecialPriceType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeSpecialPriceType;
    self.rowheight = 85*3;
    
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
               if ([browserDic isKindOfClass:[NSDictionary class]]) {
                   HFSpecialPriceOneModel *spModel = [[HFSpecialPriceOneModel alloc] init];
                   spModel.title = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                   spModel.littleTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"subtitle"]] description];
                   spModel.tagStr =  [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"smallTags"]] description];
                   spModel.colorStr = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"selectColor"]] description];
                   spModel.imgUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                   spModel.link = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                   spModel.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                   
                   [tempArray addObject:spModel];
               }
         
        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
