//
//  HFFashionModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFashionModel.h"

@implementation HFFashionModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeFashionType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeFashionType;
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [data valueForKey:@"items"];
        NSInteger count = items.count % 3;
        if (count == 0) {
            self.rowheight = (items.count/3)*160;
        }else {
           self.rowheight = (items.count/3)*160+160;
        }
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFFashionModel *spModel2 = [[HFFashionModel alloc] init];
                spModel2.title = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                spModel2.littleTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"subtitle"]] description];;
                spModel2.imgUrl = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]] description];
                spModel2.imgUrl_2 = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img_2"]] description];
                spModel2.link = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"link"]] description];
                spModel2.goodsId = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"goodsId"]] description];
                spModel2.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"linkMapping"]]];
                [tempArray addObject:spModel2];
            }
  
        }
        self.dataArray = [tempArray copy];
    }
    
}
@end
