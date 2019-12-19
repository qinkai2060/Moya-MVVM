//
//  HFConfitionIndexPath.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFConfitionIndexPath : NSObject
@property (nonatomic, assign) NSInteger firstPath;
@property (nonatomic, assign) NSInteger secondPath;         //default is -1.
@property (nonatomic, assign) NSInteger thirdPath;          //default is -1.
@property (nonatomic, assign) NSInteger fourdPath;   
@property (nonatomic, assign) BOOL isKindOfAlternative;     // YES when is MMAlternativeItem,default is NO
@property (nonatomic, assign) BOOL isOn;                    //when is Switch,it is useful;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
                        thirdPath:(NSInteger)thirdPath fourPath:(NSInteger)fourPath;
@end

NS_ASSUME_NONNULL_END
