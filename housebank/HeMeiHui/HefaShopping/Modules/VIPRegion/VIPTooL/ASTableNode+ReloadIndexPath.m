//
//  ASTableNode+ReloadIndexPath.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ASTableNode+ReloadIndexPath.h"
#import <objc/runtime.h>

static void *strKey = &strKey;
@implementation ASTableNode (ReloadIndexPath)
- (void)setJs_reloadIndexPaths:(NSArray *)js_reloadIndexPaths{
    objc_setAssociatedObject(self, &strKey, js_reloadIndexPaths, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)js_reloadIndexPaths{
    return objc_getAssociatedObject(self, &strKey);
}

@end
