//
//  HFShowFilterModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFShowFilterModel.h"

@implementation HFShowFilterModel
static NSMutableDictionary* registeredDRChatMessageMap = NULL;


+ (NSMutableDictionary*)getRegisteredRenderCellMap {
    
    return registeredDRChatMessageMap;
}
+ (void)registerRenderCell:(Class)cellClass messageType:(HFShowFilterModelType)mtype {
    
    if (!registeredDRChatMessageMap) {
        registeredDRChatMessageMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredDRChatMessageMap setObject:className forKey:[NSNumber numberWithInteger:mtype]];
}
+ (Class)getRenderClassByMessageType:(HFShowFilterModelType)mtype {
    
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [HFShowFilterModel getRegisteredRenderCellMap];
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
