//
//  HFConfitionIndexPath.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFConfitionIndexPath.h"

@implementation HFConfitionIndexPath
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath {
    
    return [self pathWithFirstPath:firstPath
                        secondPath:-1
               isKindOfAlternative:NO
                              isOn:NO];
}
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath {
    return [self pathWithFirstPath:firstPath
                        secondPath:secondPath
                         thirdPath:-1
               isKindOfAlternative:NO
                              isOn:NO];
}
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
              isKindOfAlternative:(BOOL)isKindOfAlternative
                             isOn:(BOOL)isOn {
    
    return [self pathWithFirstPath:firstPath
                        secondPath:-1
                         thirdPath:-1
               isKindOfAlternative:YES
                              isOn:isOn];
}
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
                        thirdPath:(NSInteger)thirdPath
              isKindOfAlternative:(BOOL)isKindOfAlternative
                             isOn:(BOOL)isOn {
    HFConfitionIndexPath *path = [[[self class] alloc] init];
    path.firstPath = firstPath;
    path.secondPath = secondPath;
    path.thirdPath = thirdPath;
    path.isKindOfAlternative = isKindOfAlternative;
    path.isOn = isOn;
    return path;
}
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
                        thirdPath:(NSInteger)thirdPath fourPath:(NSInteger)fourPath
{
    HFConfitionIndexPath *path = [[[self class] alloc] init];
    path.firstPath = firstPath;
    path.secondPath = secondPath;
    path.thirdPath = thirdPath;
    path.fourdPath = fourPath;
    return path;
}
@end
