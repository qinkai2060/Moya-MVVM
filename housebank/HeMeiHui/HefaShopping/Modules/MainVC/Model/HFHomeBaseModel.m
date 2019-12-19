//
//  HFHomeBaseModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

@implementation HFHomeBaseModel
static NSMutableDictionary* registeredDRChatMessageMap = NULL;


+ (NSMutableDictionary*)getRegisteredRenderCellMap {
    
    return registeredDRChatMessageMap;
}
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype {
    
    if (!registeredDRChatMessageMap) {
        registeredDRChatMessageMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredDRChatMessageMap setObject:className forKey:[NSNumber numberWithInteger:mtype]];
}
+ (Class)getRenderClassByMessageType:(HHFHomeBaseModelType)mtype {
    
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [HFHomeBaseModel getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInt:mtype]];
    if (!className) {
        className = @"CCMessageCellUnknown";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}
- (void)getData:(NSDictionary *)data {
    
}
@end
@implementation HFLinkMappModel
- (instancetype)initWithDict:(NSDictionary*)dict {
    if (self = [super init]) {
        [self getData:dict];
    }
    return self;
}
+ (instancetype)linkMappingWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}
- (void)getData:(NSDictionary *)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        self.level_3 = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"level_3"]];
        self.level_2 = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"level_2"]];
        self.level_1 = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"level_1"]];
        self.linkId = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"id"]];
//        if ([[[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"isNeedLogin"]] description] isEqualToString:@"true"]) {
//             self.isNeedLogin = YES;
//        }else {
//             self.isNeedLogin = NO;
//        }
//        if ([data.allKeys containsObject:@"isNeedLogin"]) {
//            self.isNeedLogin = NO;
//        }
       
        self.link = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"link"]] description];
        self.type = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"type"]] description];
    }
  
}

@end
