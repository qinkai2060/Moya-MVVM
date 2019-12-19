//
//  HFHomeNewBaseCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"

@implementation HFHomeNewBaseCell
static NSMutableDictionary* registeredRenderCellMap = NULL;

+ (NSMutableDictionary*)getRegisteredRenderCellMap {
    
    return registeredRenderCellMap;
}
+ (void)registerRenderCell:(Class)cellClass messageType:(HHFHomeBaseModelType)mtype {
    
    if (!registeredRenderCellMap) {
        registeredRenderCellMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredRenderCellMap setObject:className forKey:[NSNumber numberWithInteger:mtype]];
}
+ (Class)getRenderClassByMessageType:(HHFHomeBaseModelType)msgType {
    
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [HFHomeNewBaseCell getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInteger:msgType]];
    if (!className) {
        className = @"CCMessageCellUnknown";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
               [self hh_setupSubviews];
    }
    return self;
}
- (void)hh_setupSubviews {
    
}
- (void)doMessageRendering {
    
}

@end
