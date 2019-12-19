//
//  HFGoodsVideoModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGoodsVideoModel.h"

@implementation HFGoodsVideoModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeGoodsVideo];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeGoodsVideo;
    self.rowheight = 298.5;
     if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
         NSArray *items = [data valueForKey:@"items"];
         NSMutableArray *tempArray = [NSMutableArray array];
         for (NSDictionary *browserDic in items) {
             if ([browserDic isKindOfClass:[NSDictionary class]]) {
                 HFGoodsVideoModel *model = [[HFGoodsVideoModel alloc] init];
                 model.img = [HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]];
                 model.img = [NSString stringWithFormat:@"%@%@/roundrect/10",[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"img"]],IMGWH(CGSizeMake(ScreenW-30, 268.5))];
                 model.mainTitle = [HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]];
                 [tempArray addObject:model];
             }
         }
        self.dataArray = [tempArray copy];
     }
    
}
@end
