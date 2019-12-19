//
//  MyDeletAcountModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeletAcountModel.h"

@implementation MyDeletAcountModel
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
+ (Class)getRenderClassByMessageType:(NSInteger)mtype {
    
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [MyDeletAcountModel getRegisteredRenderCellMap];
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
