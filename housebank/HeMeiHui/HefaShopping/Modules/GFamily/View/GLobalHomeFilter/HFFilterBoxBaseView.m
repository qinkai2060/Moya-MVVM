//
//  HFFilterBoxBaseView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFilterBoxBaseView.h"

@implementation HFFilterBoxBaseView
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
    NSMutableDictionary* renderMap = [HFFilterBoxBaseView getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInt:mtype]];
    if (!className) {
        className = @"CCMessageCellUnknown";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}
- (instancetype)initWithFilter:(HFShowFilterModel*)model {
    if (self = [super init]) {
        self.selectedArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"dissmiss" object:nil];
    }
    return self;
}

- (void)dismiss {
    if (self.superview) {
            
            [self.coverView removeFromSuperview];
            [self removeFromSuperview];
//        }];
   
    }
}

- (void)dismissWithOutAnimation {
    if (self.superview) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^)(void))completion {
    //写这些方法是为了消除警告；
}
- (void)show {
    
}
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
        tap.numberOfTouchesRequired = 1; //手指数
        tap.numberOfTapsRequired = 1; //tap次数
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}
@end
