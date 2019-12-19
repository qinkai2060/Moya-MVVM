//
//  HFGlobalInterfaceModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobalInterfaceModel.h"

@implementation HFGlobalInterfaceModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModeGlobalInterfaceType];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModeGlobalInterfaceType;
    self.rowheight = 170;
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger i = 0;
    
    NSString *onoff = [[NSUserDefaults standardUserDefaults] objectForKey:nativeSwitch];
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSArray *array = [data valueForKey:@"items"];
        for (NSDictionary *dict in array) {
    
            if ([dict isKindOfClass:[NSDictionary class]]) {
                HFGlobalInterfaceModel *model = [[HFGlobalInterfaceModel alloc] init];
                model.titleImageUrl =  [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"img"]] description] .length == 0 ?@"": [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"img"]] description] ;
                if ([[[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"isNeedLogin"]] description] isEqualToString:@"true"]) {
                    model.isNeedLogin = YES;
                }else {
                    model.isNeedLogin = NO;
                }
                if (![dict.allKeys containsObject:@"isNeedLogin"]) {
                    model.isNeedLogin = NO;
                }
                model.title =  [[HFUntilTool EmptyCheckobjnil:[[dict valueForKey:@"title"]  description]] stringByReplacingOccurrencesOfString:@" " withString:@""];
                model.linkMappingModel = [HFLinkMappModel linkMappingWithDict:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"linkMapping"]]];
                model.linkMappingModel.isNeedLogin = model.isNeedLogin;
//                
                if([onoff isEqualToString:@"0"]&&[model.title isEqualToString:@"直播"]) {
//                if([onoff isEqualToString:@"0"]&&([model.title isEqualToString:@"全球家"]||[model.title isEqualToString:@"新零售"])) {
                   
                }else {
                     [tempArray addObject:model];
                }
                
            }

        }
     
    }
    self.dataArray = [tempArray copy];
    
}
@end
@implementation HFGlobalInterfaceSmallModel

@end
