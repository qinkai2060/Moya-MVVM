//
//  MyDeleteAccountCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteAccountCell.h"

@implementation MyDeleteAccountCell

static NSMutableDictionary* registeredRenderCellMap = NULL;

+ (NSMutableDictionary*)getRegisteredRenderCellMap {
    
    return registeredRenderCellMap;
}
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype {
    
    if (!registeredRenderCellMap) {
        registeredRenderCellMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredRenderCellMap setObject:className forKey:[NSNumber numberWithInteger:mtype]];
}
+ (Class)getRenderClassByMessageType:(NSInteger)msgType {
    
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [MyDeleteAccountCell getRegisteredRenderCellMap];
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
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)hh_setupSubviews {
    
}
- (void)doMessageRendering {
    
}



@end
