//
//  HFAsyncCircleCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAsyncCircleCell.h"
#import "HFAsyncLable.h"
@interface HFAsyncCircleCell ()
@property(nonatomic,strong)CALayer *bglayer;
@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)HFAsyncLable *detailLabel;
@end
@implementation HFAsyncCircleCell

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
    NSMutableDictionary* renderMap = [HFAsyncCircleCell getRegisteredRenderCellMap];
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
