//
//  HFTableViewCarBaseCell.m
//  housebank
//
//  Created by usermac on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFTableViewCarBaseCell.h"

@implementation HFTableViewCarBaseCell

static NSMutableDictionary* registeredRenderCellMap = NULL;

+ (NSMutableDictionary*)getRegisteredRenderCellMap {

    return registeredRenderCellMap;
}
+ (void)registerRenderCell:(Class)cellClass messageType:(int)mtype {

    if (!registeredRenderCellMap) {
        registeredRenderCellMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredRenderCellMap setObject:className forKey:[NSNumber numberWithInt:mtype]];
}
+ (Class)getRenderClassByMessageType:(NSInteger)msgType {

    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [HFTableViewCarBaseCell getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInt:msgType]];
    if (!className) {
        className = @"CCMessageCellUnknown";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}
- (void)doMessageRendering {

    
}

@end
