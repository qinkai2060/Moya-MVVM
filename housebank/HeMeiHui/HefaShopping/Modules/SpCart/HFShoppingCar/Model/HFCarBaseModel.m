//
//  HFCarBaseModel.m
//  housebank
//
//  Created by usermac on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarBaseModel.h"

@implementation HFCarBaseModel
static NSMutableDictionary* registeredDRChatMessageMap = NULL;


+ (NSMutableDictionary*)getRegisteredRenderCellMap {

    return registeredDRChatMessageMap;
}
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype {

    if (!registeredDRChatMessageMap) {
        registeredDRChatMessageMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredDRChatMessageMap setObject:className forKey:[NSNumber numberWithInt:mtype]];
}
+ (Class)getRenderClassByMessageType:(int)mtype {

    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [HFCarBaseModel getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInt:mtype]];
    if (!className) {
        className = @"CCMessageCellUnknown";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}
-(void)getData:(NSDictionary *)data  {

}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end
